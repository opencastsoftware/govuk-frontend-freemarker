package com.opencastsoftware.gradle;

import com.squareup.javapoet.*;
import org.apache.commons.text.WordUtils;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.TaskAction;

import javax.lang.model.element.Modifier;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardOpenOption;
import java.util.*;
import java.util.regex.Pattern;

public abstract class GenerateModelGenerators extends GovukComponentTask {
    @OutputDirectory
    abstract public DirectoryProperty getGeneratedSourcesDir();

    @OutputDirectory
    abstract public DirectoryProperty getGeneratedResourcesDir();

    private final String MODEL_PACKAGE = "com.opencastsoftware.govuk.freemarker";
    private final String OUT_PACKAGE = "com.opencastsoftware.govuk.freemarker.generators";

    private final TypeSpec.Builder modelGenBuilder = TypeSpec
            .classBuilder(ClassName.get(OUT_PACKAGE, "ModelGenerators"))
            .addModifiers(Modifier.PUBLIC, Modifier.FINAL);

    private void generateCanProvideFor(TypeSpec.Builder typeBuilder, String componentName) {
        var typeUsageTypeName = ClassName.get("net.jqwik.api.providers", "TypeUsage");

        var modelClassName = ClassName.get(MODEL_PACKAGE, componentName);

        var methodBuilder = MethodSpec.methodBuilder("canProvideFor")
                .returns(TypeName.BOOLEAN)
                .addAnnotation(Override.class)
                .addModifiers(Modifier.PUBLIC)
                .addParameter(typeUsageTypeName, "targetType")
                .addStatement("return targetType.isOfType($T.class)", modelClassName);

        typeBuilder.addMethod(methodBuilder.build());
    }

    private void generateProvideFor(TypeSpec.Builder typeBuilder, String componentName) {
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
        var arbitraryMethodName = WordUtils.uncapitalize(componentName);
        methodBuilder.addStatement("return $T.singleton($T.$N())", collectionsTypeName, modelGenTypeName, arbitraryMethodName);

        typeBuilder.addMethod(methodBuilder.build());
    }

    private void generateArbitraryProvider(List<ParameterSchema> params, String componentName) throws IOException {
        var srcDir = getGeneratedSourcesDir().get().getAsFile();
        var resourcesDir = getGeneratedResourcesDir().get().getAsFile();

        var className = ClassName.get(OUT_PACKAGE, componentName + "ArbitraryProvider");
        var arbitraryProviderClassName = ClassName.get("net.jqwik.api.providers", "ArbitraryProvider");

        var typeBuilder = TypeSpec.classBuilder(className)
                .addSuperinterface(arbitraryProviderClassName)
                .addModifiers(Modifier.PUBLIC, Modifier.FINAL);

        generateCanProvideFor(typeBuilder, componentName);
        generateProvideFor(typeBuilder, componentName);

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
        var builderClassName = ClassName.get(MODEL_PACKAGE, componentName, "Builder");
        var arbitrariesClassName = ClassName.get("net.jqwik.api", "Arbitraries");
        var escapeClassName = ClassName.get("org.apache.commons.text", "StringEscapeUtils");

        var isComplexType = "object".equals(paramType) || "array".equals(paramType);
        var hasParameters = !param.getParams().isEmpty();

        if (isComplexType && Optional.ofNullable(param.isComponent()).orElse(false)) {
            var useCode = "object".equals(paramType) ? ".use($T.$N())" : ".use($T.$N().list().ofMaxSize(5))";
            codeBuilder.add(useCode, genClassName, param.getName());
        } else if (isComplexType && hasParameters) {
            var nestedModelName = getDeclarationName(componentName, param.getName());
            var nestedModelMethodName = WordUtils.uncapitalize(nestedModelName);
            var useCode = "object".equals(paramType) ? ".use($T.$N())" : ".use($T.$N().list().ofMaxSize(5))";
            // Work around the undeclared nested array in the table component
            if ("Table".equals(componentName) && "rows".equals(param.getName())) {
                useCode = ".use($T.$N().list().ofSize(5).list().ofMaxSize(5))";
            } else if ("Table".equals(componentName) && "head".equals(param.getName())) {
                useCode = ".use($T.$N().list().ofSize(5))";
            }
            codeBuilder.add(useCode, genClassName, nestedModelMethodName);
            generateModelGenerator(modelGenBuilder, param.getParams(), nestedModelName);
        } else if (isComplexType) {
            if ("object".equals(paramType)) {
                codeBuilder.add(".use($T.maps($T.attributeNames, $T.strings).ofMaxSize(5))", arbitrariesClassName, genClassName, genClassName);
            } else {
                codeBuilder.add(".use($T.strings.list().ofMaxSize(5))", genClassName);
            }
        } else if ("integer".equals(paramType)) {
            codeBuilder.add(".use($T.integers())", arbitrariesClassName);
        } else if ("nunjucks-block".equals(paramType) || "html".equals(paramType) || ("string".equals(paramType) && HTML_PROP.matcher(paramName).find())) {
            codeBuilder.add(".use($T.strings.map($T::escapeHtml4))", genClassName, escapeClassName);
        } else if ("string".equals(paramType) && "classes".equals(paramName)) {
            codeBuilder.add(".use($T.strings)", genClassName);
        } else if ("string".equals(paramType) && "element".equals(paramName)) {
            // Special case for govuk-button element parameter
            codeBuilder.add(".use($T.of($S, $S, $S))", arbitrariesClassName, "a", "button", "input");
        } else if ("string".equals(paramType)) {
            codeBuilder.add(".use($T.strings)", genClassName);
        } else if ("boolean".equals(paramType)) {
            codeBuilder.add(".use($T.booleans)", genClassName);
        }

        if (param.isRequired()) {
            codeBuilder.add(".withProbability($L)", 1.0);
        } else if (HTML_PROP.matcher(paramName).find()) {
            codeBuilder.add(".withProbability($L)", 0.5);
        } else if (TEXT_PROP.matcher(paramName).find()) {
            codeBuilder.add(".withProbability($L)", 0.5);
        }

        codeBuilder.add(".in($T::with$N)" + newline, builderClassName, WordUtils.capitalize(paramName));
    }

    private void generateBaseGenerators(TypeSpec.Builder modelGenBuilder) {
        var arbitraryTypeName = ClassName.get("net.jqwik.api", "Arbitrary");
        var arbitrariesClassName = ClassName.get("net.jqwik.api", "Arbitraries");
        var stringArbitraryTypeName = ClassName.get("net.jqwik.api.arbitraries", "StringArbitrary");
        var arbitraryBooleanClassName = ParameterizedTypeName.get(arbitraryTypeName, ClassName.get(Boolean.class));

        // Arbitrary Strings
        var stringsGenBuilder = FieldSpec.builder(stringArbitraryTypeName, "strings", Modifier.PRIVATE, Modifier.STATIC, Modifier.FINAL)
                .initializer("$T.strings().withCharRange('!', '~').excludeChars('\"', '\\'', '>', '/', '=', '\\n').ofMaxLength($L)", arbitrariesClassName, 10);
        modelGenBuilder.addField(stringsGenBuilder.build());
        // Arbitrary HTML attributes
        var attrsNameGenBuilder = FieldSpec.builder(stringArbitraryTypeName, "attributeNames", Modifier.PRIVATE, Modifier.STATIC, Modifier.FINAL)
                // I would like to test this more exhaustively but XMLUnit cannot handle anything unusual in HTML attribute names
                .initializer("$T.strings().alpha().ofMinLength($L).ofMaxLength($L)", arbitrariesClassName, 1, 10);
        modelGenBuilder.addField(attrsNameGenBuilder.build());
        // Arbitrary booleans
        var boolGenBuilder = FieldSpec.builder(arbitraryBooleanClassName, "booleans", Modifier.PRIVATE, Modifier.STATIC, Modifier.FINAL)
                .initializer("$T.of($L, $L)", arbitrariesClassName, true, false);
        modelGenBuilder.addField(boolGenBuilder.build());
    }

    private void generateModelGenerator(TypeSpec.Builder modelGenBuilder, List<ParameterSchema> params, String componentName) throws IOException {
        var methodName = WordUtils.uncapitalize(componentName);

        var methodBuilder = MethodSpec.methodBuilder(methodName)
                .addModifiers(Modifier.PUBLIC, Modifier.STATIC);

        var arbitraryTypeName = ClassName.get("net.jqwik.api", "Arbitrary");
        var modelClassName = ClassName.get(MODEL_PACKAGE, WordUtils.capitalize(methodName));
        var arbitraryModelClassName = ParameterizedTypeName.get(arbitraryTypeName, modelClassName);
        methodBuilder.returns(arbitraryModelClassName);

        var codeBuilder = CodeBlock.builder();

        var newline = System.lineSeparator();
        var buildersClassName = ClassName.get("net.jqwik.api", "Builders");
        codeBuilder.add("return $T.withBuilder($T::builder)" + newline, buildersClassName, modelClassName);

        for (var param : params) {
            generateParamGenerator(modelGenBuilder, codeBuilder, componentName, param);
        }

        var builderClassName = ClassName.get(MODEL_PACKAGE, componentName, "Builder");
        codeBuilder.add(".build($T::build)", builderClassName);

        methodBuilder.addStatement(codeBuilder.build());

        modelGenBuilder.addMethod(methodBuilder.build());
    }

    @Override
    protected void generate(Map.Entry<String, ComponentSchema> component) throws IOException {
        var componentName = component.getKey();
        var params = component.getValue().getParams();
        generateArbitraryProvider(params, componentName);
        generateModelGenerator(modelGenBuilder, params, componentName);
    }


    @TaskAction
    @Override
    public void generate() throws IOException {
        super.generate();
        generateBaseGenerators(modelGenBuilder);
        var srcDir = getGeneratedSourcesDir().get().getAsFile();
        var typeSpec = modelGenBuilder.build();
        var paramsFile = JavaFile.builder(OUT_PACKAGE, typeSpec).build();
        paramsFile.writeTo(srcDir);
    }
}
