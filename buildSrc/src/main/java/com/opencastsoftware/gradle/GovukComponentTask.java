package com.opencastsoftware.gradle;

import com.squareup.javapoet.ClassName;
import com.squareup.javapoet.ParameterizedTypeName;
import com.squareup.javapoet.TypeName;
import org.apache.commons.lang3.stream.Streams;
import org.apache.commons.text.CaseUtils;
import org.apache.commons.text.WordUtils;
import org.gradle.api.DefaultTask;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.tasks.InputDirectory;
import org.gradle.api.tasks.TaskAction;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.representer.Representer;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
import java.util.stream.Collectors;

public abstract class GovukComponentTask extends DefaultTask {
    @InputDirectory
    abstract public DirectoryProperty getRepositoryDir();

    protected final Yaml yaml;

    protected final String MODEL_PACKAGE = "com.opencastsoftware.govuk.freemarker";

    protected final Map<String, ComponentSchema> componentSchemas = new HashMap<>();

    public GovukComponentTask() {
        var representer = new Representer(new DumperOptions());
        representer.getPropertyUtils().setSkipMissingProperties(true);
        this.yaml = new Yaml(new Constructor(ComponentSchema.class, new LoaderOptions()), representer);
    }

    protected String kebabCaseToCamelCase(String kebab) {
        return kebabCaseToCamelCase(kebab, true);
    }

    protected String kebabCaseToCamelCase(String kebab, boolean upperCase) {
        return CaseUtils.toCamelCase(kebab, upperCase, '-');
    }

    protected String getDeclarationName(String componentName, String paramName) {
        var suffixName = WordUtils.capitalize(paramName);

        if (suffixName.endsWith("Items") || suffixName.endsWith("List") || suffixName.endsWith("Values") || suffixName.endsWith("Rows")) {
            // Remove pluralisation in certain cases
            suffixName = suffixName.replaceAll("(s|List)$", "");
        }

        return componentName + suffixName;
    }

    protected ClassName getClassName(String componentName, String paramName) {
        return ClassName.get(MODEL_PACKAGE, getDeclarationName(componentName, paramName));
    }

    protected TypeName getTypeName(String componentName, ParameterSchema param) {
        var paramType = param.getType();

        if ("array".equals(paramType)) {
            var listName = ClassName.get(List.class);
            var elemTypeName = param.getParams().isEmpty() ? ClassName.get(String.class) : getClassName(componentName, param.getName());
            return ParameterizedTypeName.get(listName, elemTypeName);
        } else if ("object".equals(paramType) && Optional.ofNullable(param.isComponent()).orElse(false)) {
            return ClassName.get(MODEL_PACKAGE, WordUtils.capitalize(param.getName()));
        } else if ("object".equals(paramType)) {
            var mapName = ClassName.get(Map.class);
            var mapTypeName = ParameterizedTypeName.get(mapName, ClassName.get(String.class), ClassName.get(String.class));
            return param.getParams().isEmpty() ? mapTypeName : getClassName(componentName, param.getName());
        } else if ("boolean".equals(paramType)) {
            return TypeName.BOOLEAN.box();
        } else if ("integer".equals(paramType)) {
            return TypeName.INT.box();
        } else if ("string".equals(paramType) || "nunjucks-block".equals(paramType) || "html".equals(paramType)) {
            return ClassName.get(String.class);
        } else {
            throw new IllegalArgumentException("Unknown parameter paramType: " + paramType);
        }
    }

    protected boolean isParameterSchema(Path path, BasicFileAttributes attrs) {
        var filename = path.getFileName().toString();
        return filename.endsWith(".yaml") && attrs.isRegularFile();
    }

    protected List<ParameterSchema> preProcessParamSchemas(List<ParameterSchema> params) {
        if (params.isEmpty()) {
            return params;
        }

        var groupedParams = params.stream()
                .filter(param -> !"caller".equals(param.getName()))
                .collect(Collectors.groupingBy(
                        // Some parameter entries are not nested appropriately, so they
                        // may have names like `conditional.html`.
                        // We need to group by the first part of these names.
                        param -> param.getName().split("\\.")[0],
                        LinkedHashMap::new,
                        Collectors.toList()
                ));

        return groupedParams.entrySet().stream()
                .map(entry -> {
                    entry.getValue().forEach(innerParam -> {
                        // If we have a dotted name, use the second part
                        var innerParamSegments = innerParam.getName().split("\\.");
                        if (innerParamSegments.length > 1) {
                            innerParam.setName(innerParamSegments[1]);
                        }
                        // Process the params of this parameter recursively
                        innerParam.setParams(preProcessParamSchemas(innerParam.getParams()));
                    });

                    // Some entries do not have dotted fields, so we can use them as-is
                    if (entry.getValue().size() == 1) {
                        return entry.getValue().get(0);
                    } else {
                        // Those which do can have a collision between the top-level object definition
                        // and the synthetic object we're introducing here - see the `conditional` and `conditional.html`
                        // fields of the checkboxes and radios components.
                        // These definitions in the YAML make absolutely no sense - there's no way that a parameter can be both
                        // a `string` or a `boolean` and an object with its own fields.
                        var innerParams = entry.getValue().stream()
                                .filter(innerParam -> !innerParam.getName().equals(entry.getKey()))
                                .collect(Collectors.toList());

                        return new ParameterSchema(
                                entry.getKey(),
                                "object",
                                true,
                                null,
                                false,
                                innerParams);
                    }

                }).collect(Collectors.toList());
    }

    protected void preProcessSchema(ComponentSchema schema) {
        schema.setParams(preProcessParamSchemas(schema.getParams()));
    }

    private void readComponentSchema(Path schemaPath) throws IOException {
        try (var input = new FileInputStream(schemaPath.toFile())) {
            var componentDir = schemaPath.getParent().getFileName().toString();
            var componentSchema = yaml.<ComponentSchema>load(input);
            componentSchema.setKebabCaseName(componentDir);
            preProcessSchema(componentSchema);
            componentSchemas.put(kebabCaseToCamelCase(componentDir), componentSchema);
        }
    }

    protected void generate(Map.Entry<String, ComponentSchema> component) throws IOException {

    }

    @TaskAction
    public void generate() throws IOException {
        var componentsPath = getRepositoryDir().getAsFile().get().toPath()
                .resolve("src").resolve("govuk").resolve("components");

        // We need to read all schemas so that they can be cross-referenced later
        try (var files = Files.find(componentsPath, Integer.MAX_VALUE, this::isParameterSchema)) {
            Streams.stream(files).forEach(this::readComponentSchema);
        }

        for (var component : componentSchemas.entrySet()) {
            generate(component);
        }
    }
}
