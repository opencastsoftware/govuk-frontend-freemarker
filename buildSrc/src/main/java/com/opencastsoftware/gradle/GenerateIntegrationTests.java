package com.opencastsoftware.gradle;

import com.squareup.javapoet.*;
import org.apache.commons.lang3.stream.Streams;
import org.apache.commons.text.WordUtils;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.tasks.InputDirectory;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.TaskAction;
import org.xml.sax.SAXException;

import javax.lang.model.element.Modifier;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public abstract class GenerateIntegrationTests extends GovukComponentTask {
    @InputDirectory
    abstract public DirectoryProperty getRepositoryDir();

    @OutputDirectory
    abstract public DirectoryProperty getGeneratedTestsDir();

    private void generateIntegrationTest(String componentDir) throws IOException {
        var srcDir = getGeneratedTestsDir().get().getAsFile();

        var componentName = kebabCaseToCamelCase(componentDir);
        var modelClassName = ClassName.get(MODEL_PACKAGE, componentName);
        var testClassName = ClassName.get(MODEL_PACKAGE, modelClassName.simpleName() + "Test");
        var superClassName = ClassName.get(MODEL_PACKAGE, "ComponentTest");
        var propertyClassName = ClassName.get("net.jqwik.api", "Property");
        var forAllClassName = ClassName.get("net.jqwik.api", "ForAll");
        var templateExceptionClassName = ClassName.get("freemarker.template", "TemplateException");
        var parameterizedClassName = ParameterizedTypeName.get(superClassName, modelClassName);
        var matcherAssertClassName = ClassName.get("org.hamcrest", "MatcherAssert");
        var compareMatcherClassName = ClassName.get("org.xmlunit.matchers", "CompareMatcher");

        var typeBuilder = TypeSpec.classBuilder(testClassName)
                .superclass(parameterizedClassName)
                .addModifiers(Modifier.PUBLIC, Modifier.FINAL);

        typeBuilder.addMethod(MethodSpec.constructorBuilder()
                .addException(ClassName.get(IOException.class))
                .addException(ClassName.get(ParserConfigurationException.class))
                .addStatement("super($S)", componentDir)
                .build());

        var propertyParamName = WordUtils.uncapitalize(componentName);

        typeBuilder.addMethod(MethodSpec.methodBuilder("shouldRender")
                .addAnnotation(propertyClassName)
                .addException(IOException.class)
                .addException(InterruptedException.class)
                .addException(SAXException.class)
                .addException(templateExceptionClassName)
                .addParameter(ParameterSpec.builder(modelClassName, propertyParamName)
                        .addAnnotation(forAllClassName)
                        .build())
                .addStatement("var nunjucksDoc = renderNunjucks($N)", propertyParamName)
                .addStatement("var freeMarkerDoc = renderFreeMarker($N)", propertyParamName)
                .addStatement(
                        "$T.assertThat($N, $T.isIdenticalTo($N))",
                        matcherAssertClassName,
                        "freeMarkerDoc",
                        compareMatcherClassName,
                        "nunjucksDoc")
                .build());

        var typeSpec = typeBuilder.build();

        var testFile = JavaFile.builder(MODEL_PACKAGE, typeSpec)
                .addStaticImport(matcherAssertClassName, "assertThat")
                .addStaticImport(compareMatcherClassName, "isIdenticalTo")
                .build();

        testFile.writeTo(srcDir);
    }

    private void generateIntegrationTest(Path schemaPath) throws IOException {
        var componentDir = schemaPath.getParent().getFileName().toString();
        generateIntegrationTest(componentDir);
    }

    @TaskAction
    public void generate() throws IOException {
        var componentsPath = getRepositoryDir().getAsFile().get().toPath()
                .resolve("src").resolve("govuk").resolve("components");

        try (var files = Files.find(componentsPath, Integer.MAX_VALUE, this::isParameterSchema)) {
            Streams.stream(files).forEach(this::generateIntegrationTest);
        }
    }
}
