package com.opencastsoftware.gradle;

import com.squareup.javapoet.*;
import org.apache.commons.text.WordUtils;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.tasks.OutputDirectory;
import org.xml.sax.SAXException;

import javax.lang.model.element.Modifier;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.util.Map;

public abstract class GenerateIntegrationTests extends GovukComponentTask {

    @OutputDirectory
    abstract public DirectoryProperty getGeneratedTestsDir();

    @Override
    protected void generate(Map.Entry<String, ComponentSchema> component) throws IOException {
        var srcDir = getGeneratedTestsDir().get().getAsFile();

        var componentName = component.getKey();
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
                .addStatement("super($S)", component.getValue().getKebabCaseName())
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
}
