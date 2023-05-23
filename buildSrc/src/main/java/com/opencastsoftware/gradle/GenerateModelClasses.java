package com.opencastsoftware.gradle;

import com.squareup.javapoet.*;
import org.apache.commons.text.WordUtils;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.tasks.OutputDirectory;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.lang.model.element.Modifier;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public abstract class GenerateModelClasses extends GovukComponentTask {
    @OutputDirectory
    abstract public DirectoryProperty getGeneratedSourcesDir();

    private void generateGetter(TypeSpec.Builder typeSpec, ParameterSchema param, FieldSpec fieldSpec) {
        generateGetter(typeSpec, param, fieldSpec, true);
    }

    private void generateGetter(TypeSpec.Builder typeSpec, ParameterSchema param, FieldSpec fieldSpec, boolean withAnnotations) {
        var methodName = "get" + WordUtils.capitalize(param.getName());
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
        var methodName = "set" + WordUtils.capitalize(param.getName());

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
        var methodName = "with" + WordUtils.capitalize(param.getName());

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
            generateModelClass(param.getParams(), getDeclarationName(componentName, param.getName()));
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

    private void generateBuilder(TypeSpec.Builder typeSpec, ClassName className, List<ParameterSchema> params) {
        var builderName = ClassName.get(className.packageName(), className.simpleName(), "Builder");

        var builder = TypeSpec.classBuilder(builderName)
                .addModifiers(Modifier.PUBLIC, Modifier.STATIC);

        var buildArgs = new Object[params.size() + 1];
        buildArgs[0] = className;

        for (var i = 0; i < params.size(); i++) {
            var param = params.get(i);
            var fieldSpec = generateField(builder, className.simpleName(), param, false);
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

    private void generateToString(TypeSpec.Builder typeSpec, List<ParameterSchema> params, String componentName) {
        var className = ClassName.get(MODEL_PACKAGE, componentName);

        var method = MethodSpec.methodBuilder("toString")
                .returns(ClassName.get(String.class))
                .addAnnotation(Override.class)
                .addModifiers(Modifier.PUBLIC);

        var methodCode = CodeBlock.builder();

        var newline = System.lineSeparator();

        methodCode.add("return $S" + newline, className.simpleName() + "[");

        for (int i = 0; i < params.size(); i++) {
            var paramName = params.get(i).getName();
            var paramPrefix = i == 0 ? paramName + "=" : ", " + paramName + "=";
            methodCode.add(" + $S + $N" + newline, paramPrefix, sanitizeParamName(paramName));
        }

        methodCode.add(" + $S", "]");

        method.addStatement(methodCode.build());

        typeSpec.addMethod(method.build());
    }

    private void generateModelClass(List<ParameterSchema> params, String componentName) throws IOException {
        var className = ClassName.get(MODEL_PACKAGE, componentName);

        var srcDir = getGeneratedSourcesDir().get().getAsFile();

        var typeBuilder = TypeSpec.classBuilder(className).addModifiers(Modifier.PUBLIC, Modifier.FINAL);

        generateConstructor(typeBuilder, params, componentName);

        for (var param : params) {
            generateParam(typeBuilder, componentName, param);
        }

        generateToString(typeBuilder, params, componentName);

        generateBuilder(typeBuilder, className, params);

        var typeSpec = typeBuilder.build();

        var paramsFile = JavaFile.builder(MODEL_PACKAGE, typeSpec).build();

        paramsFile.writeTo(srcDir);
    }

    @Override
    protected void generate(Map.Entry<String, ComponentSchema> component) throws IOException {
        generateModelClass(component.getValue().getParams(), component.getKey());
    }
}
