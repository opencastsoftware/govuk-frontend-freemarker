package com.opencastsoftware.gradle;

import com.squareup.javapoet.*;
import org.apache.commons.lang3.stream.Streams;
import org.apache.commons.text.CaseUtils;
import org.apache.commons.text.WordUtils;
import org.gradle.api.DefaultTask;
import org.gradle.api.file.RegularFileProperty;
import org.gradle.api.provider.Property;
import org.gradle.api.tasks.Input;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.TaskAction;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.representer.Representer;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.lang.model.element.Modifier;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public abstract class GenerateComponentParams extends DefaultTask {
    @Input
    public abstract Property<String> getGovukFrontendTagName();

    @OutputDirectory
    abstract public RegularFileProperty getGeneratedSourcesDir();

    private final Yaml yaml;
    private final String OUT_PACKAGE = "com.opencastsoftware.govuk.freemarker";
    private final char[] CASE_DELIMITERS = new char[]{'-'};
    private final Pattern IS_PATTERN = Pattern.compile("^is[A-Z]");

    public GenerateComponentParams() {
        var representer = new Representer(new DumperOptions());
        representer.getPropertyUtils().setSkipMissingProperties(true);
        this.yaml = new Yaml(new Constructor(ComponentSchema.class, new LoaderOptions()), representer);
    }

    private boolean isParameterSchema(Path path, BasicFileAttributes attrs) {
        var filename = path.getFileName().toString();
        return filename.endsWith(".yaml") && attrs.isRegularFile();
    }

    private void cloneRepo(File tmpDir) {
        var gitDir = tmpDir.toPath().resolve(".git");
        var tagName = getGovukFrontendTagName().get();
        var githubToken = System.getenv("GITHUB_TOKEN");
        var repoUrl = githubToken != null && !githubToken.isBlank() ? "https://oauth2:" + githubToken + "@github.com/alphagov/govuk-frontend" : "https://github.com/alphagov/govuk-frontend";

        if (!Files.exists(gitDir)) {
            getProject().exec(cmd -> {
                cmd.setExecutable("git");
                cmd.setArgs(Arrays.asList("clone", "--depth", "1", "-b", tagName, repoUrl, "."));
                cmd.setWorkingDir(tmpDir);
            });
        }
    }

    private void generateGetter(TypeSpec.Builder typeSpec, ParameterSchema param, FieldSpec fieldSpec) {
        generateGetter(typeSpec, param, fieldSpec, true);
    }

    private void generateGetter(TypeSpec.Builder typeSpec, ParameterSchema param, FieldSpec fieldSpec, boolean withAnnotations) {
        var methodName = IS_PATTERN.matcher(param.getName()).find()
                ? param.getName()
                : "get" + WordUtils.capitalize(param.getName());
        var method = MethodSpec.methodBuilder(methodName)
                .addModifiers(Modifier.PUBLIC)
                .returns(fieldSpec.type)
                .addStatement("return this.$N", fieldSpec.name);

        if (withAnnotations) {
            if (param.isRequired()) {
                method.addAnnotation(Nonnull.class);
            } else {
                method.addAnnotation(Nullable.class);
            }
        }

        typeSpec.addMethod(method.build());
    }

    private void generateSetter(TypeSpec.Builder typeSpec, ParameterSchema param, FieldSpec fieldSpec) {
        var methodName = "set" + WordUtils.capitalize(param.getName().replaceFirst("^is", ""));

        var methodParam = ParameterSpec.builder(fieldSpec.type, fieldSpec.name);

        if (param.isRequired()) {
            methodParam.addAnnotation(Nonnull.class);
        } else {
            methodParam.addAnnotation(Nullable.class);
        }

        var method = MethodSpec.methodBuilder(methodName)
                .addModifiers(Modifier.PUBLIC)
                .returns(TypeName.VOID)
                .addParameter(methodParam.build())
                .addStatement("this.$N = $N", fieldSpec.name, fieldSpec.name);

        typeSpec.addMethod(method.build());
    }

    private void generateWither(TypeSpec.Builder typeSpec, ParameterSchema param, FieldSpec fieldSpec, ClassName builderName) {
        var methodName = "with" + WordUtils.capitalize(param.getName().replaceFirst("^is", ""));

        var methodParam = ParameterSpec.builder(fieldSpec.type, fieldSpec.name);

        var method = MethodSpec.methodBuilder(methodName)
                .addModifiers(Modifier.PUBLIC)
                .returns(builderName)
                .addParameter(methodParam.build())
                .addStatement("this.$N = $N", fieldSpec.name, fieldSpec.name)
                .addStatement("return this");

        typeSpec.addMethod(method.build());
    }

    private String sanitizeParamName(String name) {
        return "for".equals(name) ? "htmlFor" : name;
    }

    private ClassName getClassName(String componentName, String paramName) {
        var className = WordUtils.capitalize(paramName);
        if (className.endsWith("Items") || className.endsWith("List") || className.endsWith("Values") || className.endsWith("Rows")) {
            // Remove pluralisation in certain cases
            className = className.replaceAll("(s|List)$", "");
        }
        return ClassName.get(OUT_PACKAGE, componentName + className);
    }

    private FieldSpec generateField(TypeSpec.Builder typeSpec, String componentName, ParameterSchema param) {
       return generateField(typeSpec, componentName, param, true);
    }

    private FieldSpec generateField(TypeSpec.Builder typeSpec, String componentName, ParameterSchema param, boolean withAnnotations) {
        var fieldName = sanitizeParamName(param.getName());
        var fieldBuilder = FieldSpec.builder(getTypeName(componentName, param), fieldName, Modifier.PRIVATE);
        if (withAnnotations) {
            if (param.isRequired()) {
                fieldBuilder.addAnnotation(Nonnull.class);
            } else {
                fieldBuilder.addAnnotation(Nullable.class);
            }
        }
        var fieldSpec = fieldBuilder.build();
        typeSpec.addField(fieldSpec);
        return fieldSpec;
    }

    private void generateParam(TypeSpec.Builder typeSpec, String componentName, ParameterSchema param) throws IOException {
        var fieldSpec = generateField(typeSpec, componentName, param);
        generateGetter(typeSpec, param, fieldSpec);
        generateSetter(typeSpec, param, fieldSpec);

        var isComplexType = "object".equals(param.getType()) || "array".equals(param.getType());
        var hasParameters = !param.getParams().isEmpty();

        if (isComplexType && hasParameters) {
            generateModelClass(param.getParams(), componentName, getClassName(componentName, param.getName()));
        }
    }

    private TypeName getTypeName(String componentName, ParameterSchema param) {
        var paramType = param.getType();

        if ("array".equals(paramType)) {
            var listName = ClassName.get(List.class);
            var elemTypeName = param.getParams().isEmpty() ? ClassName.get(Object.class) : getClassName(componentName, param.getName());
            return ParameterizedTypeName.get(listName, elemTypeName);
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

    private void generateConstructor(TypeSpec.Builder typeSpec, List<ParameterSchema> params, String componentName) {
        var constructor = MethodSpec.constructorBuilder()
                .addModifiers(Modifier.PUBLIC);

        for (var param : params) {
            var paramName = sanitizeParamName(param.getName());
            var paramSpec = ParameterSpec.builder(getTypeName(componentName, param), paramName);

            if (param.isRequired()) {
                paramSpec.addAnnotation(Nonnull.class);
            } else {
                paramSpec.addAnnotation(Nullable.class);
            }

            constructor.addParameter(paramSpec.build());

            if (param.isRequired()) {
                constructor.addStatement("this.$N = $T.requireNonNull($N)", paramName, Objects.class, paramName);
            } else {
                constructor.addStatement("this.$N = $N", paramName, paramName);
            }
        }

        typeSpec.addMethod(constructor.build());
    }

    private void generateBuilder(TypeSpec.Builder typeSpec, String componentName, ClassName className, List<ParameterSchema> params) throws IOException {
        var builderName = ClassName.get(className.packageName(), className.simpleName(), "Builder");
        var builder = TypeSpec.classBuilder(builderName)
                .addModifiers(Modifier.PUBLIC, Modifier.STATIC);

        var buildArgs = new Object[params.size() + 1];
        buildArgs[0] = className;

        for (var i = 0 ; i < params.size() ; i++) {
            var param = params.get(i);
            var fieldSpec = generateField(builder, componentName, param, false);
            generateGetter(builder, param, fieldSpec, false);
            generateWither(builder, param, fieldSpec, builderName);
            buildArgs[i + 1] = fieldSpec;
        }

        var argStrings = new String[params.size()];
        Arrays.fill(argStrings, "$N");

        var argFormatString = String.join(", ", argStrings);

        builder.addMethod(MethodSpec.methodBuilder("build")
                .addModifiers(Modifier.PUBLIC)
                .returns(className)
                .addStatement("return new $T(" + argFormatString + ")", buildArgs)
                .build());

        var builderSpec = builder.build();

        typeSpec.addType(builderSpec);

        typeSpec.addMethod(MethodSpec.methodBuilder("builder")
                .addModifiers(Modifier.PUBLIC, Modifier.STATIC)
                .returns(builderName)
                .addStatement("return new $T()", builderName)
                .build());
    }

    private void generateModelClass(List<ParameterSchema> params, String componentName, ClassName className) throws IOException {
        var outDir = getGeneratedSourcesDir().get().getAsFile();

        var typeBuilder = TypeSpec.classBuilder(className).addModifiers(Modifier.PUBLIC, Modifier.FINAL);

        generateConstructor(typeBuilder, params, componentName);

        for (var param : params) {
            generateParam(typeBuilder, componentName, param);
        }

        generateBuilder(typeBuilder, componentName, className, params);

        var typeSpec = typeBuilder.build();

        var paramsFile = JavaFile.builder(OUT_PACKAGE, typeSpec).build();

        paramsFile.writeTo(outDir);
    }

    private List<ParameterSchema> preProcessParamSchemas(List<ParameterSchema> params) {
        if (params.isEmpty()) {
            return params;
        }

        var groupedParams = params.stream().collect(Collectors.groupingBy(
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
                                innerParams);
                    }

                }).collect(Collectors.toList());
    }

    private ComponentSchema preProcessSchema(ComponentSchema schema) {
        return new ComponentSchema(preProcessParamSchemas(schema.getParams()));
    }

    private void generateModelClass(Path schemaPath) throws IOException {
        try (var input = new FileInputStream(schemaPath.toFile())) {
            var componentDir = schemaPath.getParent().getFileName().toString();
            var componentName = CaseUtils.toCamelCase(componentDir, true, CASE_DELIMITERS);
            var rawSchema = yaml.<ComponentSchema>load(input);
            var preparedSchema = preProcessSchema(rawSchema);
            var className = ClassName.get(OUT_PACKAGE, componentName);
            generateModelClass(preparedSchema.getParams(), componentName, className);
        }
    }

    @TaskAction
    public void generate() throws IOException {
        var tmpDir = getTemporaryDir();

        cloneRepo(tmpDir);

        var componentsPath = tmpDir.toPath().resolve("src").resolve("govuk").resolve("components");

        try (var files = Files.find(componentsPath, Integer.MAX_VALUE, this::isParameterSchema)) {
            Streams.stream(files).forEach(this::generateModelClass);
        }
    }
}
