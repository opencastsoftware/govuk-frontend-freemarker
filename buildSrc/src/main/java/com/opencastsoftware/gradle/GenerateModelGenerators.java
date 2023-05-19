package com.opencastsoftware.gradle;

import com.squareup.javapoet.*;
import org.apache.commons.lang3.stream.Streams;
import org.apache.commons.text.WordUtils;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.tasks.InputDirectory;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.TaskAction;

import javax.lang.model.element.Modifier;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.Collections;
import java.util.List;
import java.util.Set;

public abstract class GenerateModelGenerators extends GovukComponentTask {
    @InputDirectory
    abstract public DirectoryProperty getRepositoryDir();

    @OutputDirectory
    abstract public DirectoryProperty getGeneratedSourcesDir();

    @OutputDirectory
    abstract public DirectoryProperty getGeneratedResourcesDir();

    private final String MODEL_PACKAGE = "com.opencastsoftware.govuk.freemarker";
    private final String OUT_PACKAGE = "com.opencastsoftware.govuk.freemarker.generators";

    private void generateCanProvideFor(TypeSpec.Builder typeBuilder, String componentDir) {
        var typeUsageTypeName = ClassName.get("net.jqwik.api.providers", "TypeUsage");

        var componentName = kebabCaseToCamelCase(componentDir, true);
        var modelClassName = ClassName.get(MODEL_PACKAGE, componentName);

        var methodBuilder = MethodSpec.methodBuilder("canProvideFor")
                .returns(TypeName.BOOLEAN)
                .addAnnotation(Override.class)
                .addModifiers(Modifier.PUBLIC)
                .addParameter(typeUsageTypeName, "targetType")
                .addStatement("return targetType.isOfType($T.class)", modelClassName);

        typeBuilder.addMethod(methodBuilder.build());
    }

    private void generateProvideFor(TypeSpec.Builder typeBuilder, String componentDir) {
        var methodBuilder = MethodSpec.methodBuilder("provideFor")
                .addAnnotation(Override.class)
                .addModifiers(Modifier.PUBLIC);

        var setTypeName = ClassName.get(Set.class);
        var arbitraryTypeName = ClassName.get("net.jqwik.api", "Arbitrary");
        var wildcardArbitraryTypeName = ParameterizedTypeName.get(arbitraryTypeName, WildcardTypeName.subtypeOf(ClassName.get(Object.class)));
        var setArbitraryTypeName = ParameterizedTypeName.get(setTypeName, wildcardArbitraryTypeName);
        methodBuilder.returns(setArbitraryTypeName);

        var typeUsageTypeName = ClassName.get("net.jqwik.api.providers", "TypeUsage");
        methodBuilder.addParameter(typeUsageTypeName, "targetType");

        var subtypeProviderTypeName = ClassName.get("net.jqwik.api.providers", "ArbitraryProvider", "SubtypeProvider");
        methodBuilder.addParameter(subtypeProviderTypeName, "subtypeProvider");

        var collectionsTypeName = ClassName.get(Collections.class);
        var modelGenTypeName = ClassName.get(OUT_PACKAGE, "ModelGenerators");
        var arbitraryMethodName = kebabCaseToCamelCase(componentDir, false);
        methodBuilder.addStatement("return $T.singleton($T.$N())", collectionsTypeName, modelGenTypeName, arbitraryMethodName);

        typeBuilder.addMethod(methodBuilder.build());
    }

    private void generateArbitraryProvider(List<ParameterSchema> params, String componentDir) throws IOException {
        var srcDir = getGeneratedSourcesDir().get().getAsFile();
        var resourcesDir = getGeneratedResourcesDir().get().getAsFile();

        var componentName = kebabCaseToCamelCase(componentDir, true);
        var className = ClassName.get(OUT_PACKAGE, componentName + "ArbitraryProvider");
        var arbitraryProviderClassName = ClassName.get("net.jqwik.api.providers", "ArbitraryProvider");

        var typeBuilder = TypeSpec.classBuilder(className)
                .addSuperinterface(arbitraryProviderClassName)
                .addModifiers(Modifier.PUBLIC, Modifier.FINAL);

        generateCanProvideFor(typeBuilder, componentDir);
        generateProvideFor(typeBuilder, componentDir);

        var typeSpec = typeBuilder.build();

        var paramsFile = JavaFile.builder(OUT_PACKAGE, typeSpec).build();

        paramsFile.writeTo(srcDir);

        var providersPath = resourcesDir.toPath().resolve("META-INF").resolve("services").resolve("net.jqwik.api.providers.ArbitraryProvider");

        Files.createDirectories(providersPath.getParent());

        Files.writeString(
                providersPath,
                className.canonicalName() + System.lineSeparator(),
                StandardOpenOption.CREATE, StandardOpenOption.APPEND);
    }

    private void generateParamGenerator(TypeSpec.Builder modelGenBuilder, CodeBlock.Builder codeBuilder, String componentName, ParameterSchema param) throws IOException {
        var paramName = param.getName();
        var paramType = param.getType();
        var newline = System.lineSeparator();
        var genClassName = ClassName.get(OUT_PACKAGE, "ModelGenerators");
        var builderClassName = ClassName.get(MODEL_PACKAGE, WordUtils.capitalize(componentName), "Builder");
        var arbitrariesClassName = ClassName.get("net.jqwik.api", "Arbitraries");
        var escapeClassName = ClassName.get("org.apache.commons.text", "StringEscapeUtils");

        var isComplexType = "object".equals(paramType) || "array".equals(paramType);
        var hasParameters = !param.getParams().isEmpty();

        if (isComplexType && hasParameters) {
            var methodName = getDeclarationName(componentName, param.getName());
            var useCode = "object".equals(paramType) ? ".use($T.$N())" : ".use($T.$N().list())";
            codeBuilder.add(useCode, genClassName, methodName);
            generateModelGenerator(modelGenBuilder, param.getParams(), methodName);
        } else if (isComplexType) {
            if ("object".equals(paramType)) {
                codeBuilder.add(".use($T.maps($T.strings().alpha().ofMaxLength(10), $T.strings().ascii().ofMaxLength(20)))", arbitrariesClassName, arbitrariesClassName, arbitrariesClassName);
            } else {
                codeBuilder.add(".use($T.strings().ascii().ofMaxLength(20).list())", arbitrariesClassName);
            }
        } else if ("integer".equals(paramType)) {
            codeBuilder.add(".use($T.integers())", arbitrariesClassName);
        } else if ("nunjucks-block".equals(paramType) || "html".equals(paramType) || ("string".equals(paramType) && "html".equals(paramName))) {
            codeBuilder.add(".use($T.strings().ascii().ofMaxLength(20).map($T::escapeHtml4))", arbitrariesClassName, escapeClassName);
        } else if ("string".equals(paramType)) {
            codeBuilder.add(".use($T.strings().ascii().ofMaxLength(20))", arbitrariesClassName);
        } else if ("boolean".equals(paramType)) {
            codeBuilder.add(".use($T.of(true, false))", arbitrariesClassName);
        }

        if (param.isRequired()) {
            codeBuilder.add(".withProbability($L)", 1.0);
        }

        codeBuilder.add(".in($T::with$N)" + newline, builderClassName, WordUtils.capitalize(paramName));
    }

    private void generateModelGenerator(TypeSpec.Builder modelGenBuilder, List<ParameterSchema> params, String componentName) throws IOException {
        var methodBuilder = MethodSpec.methodBuilder(componentName)
                .addModifiers(Modifier.PUBLIC, Modifier.STATIC);

        var arbitraryTypeName = ClassName.get("net.jqwik.api", "Arbitrary");
        var modelClassName = ClassName.get(MODEL_PACKAGE, WordUtils.capitalize(componentName));
        var arbitraryModelClassName = ParameterizedTypeName.get(arbitraryTypeName, modelClassName);
        methodBuilder.returns(arbitraryModelClassName);

        var codeBuilder = CodeBlock.builder();

        var newline = System.lineSeparator();
        var buildersClassName = ClassName.get("net.jqwik.api", "Builders");
        codeBuilder.add("return $T.withBuilder($T::builder)" + newline, buildersClassName, modelClassName);

        for (var param : params) {
            generateParamGenerator(modelGenBuilder, codeBuilder, componentName, param);
        }

        var builderClassName = ClassName.get(MODEL_PACKAGE, WordUtils.capitalize(componentName), "Builder");
        codeBuilder.add(".build($T::build)", builderClassName);

        methodBuilder.addStatement(codeBuilder.build());

        modelGenBuilder.addMethod(methodBuilder.build());
    }

    private void generateModelGenerator(TypeSpec.Builder modelGenBuilder, Path schemaPath) throws IOException {
        try (var input = new FileInputStream(schemaPath.toFile())) {
            var componentDir = schemaPath.getParent().getFileName().toString();
            var componentSchema = yaml.<ComponentSchema>load(input);
            preProcessSchema(componentSchema);
            var methodName = kebabCaseToCamelCase(componentDir, false);
            generateArbitraryProvider(componentSchema.getParams(), componentDir);
            generateModelGenerator(modelGenBuilder, componentSchema.getParams(), methodName);
        }
    }

    @TaskAction
    public void generate() throws IOException {
        var srcDir = getGeneratedSourcesDir().get().getAsFile();

        var componentsPath = getRepositoryDir().get().getAsFile().toPath()
                .resolve("src").resolve("govuk").resolve("components");

        var className = ClassName.get(OUT_PACKAGE, "ModelGenerators");

        var typeBuilder = TypeSpec.classBuilder(className)
                .addModifiers(Modifier.PUBLIC, Modifier.FINAL);

        try (var files = Files.find(componentsPath, Integer.MAX_VALUE, this::isParameterSchema)) {
            Streams.stream(files).forEach(component -> generateModelGenerator(typeBuilder, component));
        }

        var typeSpec = typeBuilder.build();
        var paramsFile = JavaFile.builder(OUT_PACKAGE, typeSpec).build();
        paramsFile.writeTo(srcDir);
    }
}
