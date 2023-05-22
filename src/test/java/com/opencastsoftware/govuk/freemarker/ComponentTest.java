/*
 * SPDX-FileCopyrightText:  © 2023 Opencast Software Europe Ltd <https://opencastsoftware.com>
 * SPDX-License-Identifier: MIT
 */
package com.opencastsoftware.govuk.freemarker;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.StringTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.apache.commons.text.CaseUtils;
import org.custommonkey.xmlunit.HTMLDocumentBuilder;
import org.custommonkey.xmlunit.TolerantSaxDocumentBuilder;
import org.custommonkey.xmlunit.XMLUnit;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.fail;

public abstract class ComponentTest<A> {
    private final String componentName;
    protected final Configuration config;
    protected final Template template;
    protected final HttpClient http = HttpClient.newHttpClient();
    protected final ObjectMapper objectMapper = new ObjectMapper();
    protected final DocumentBuilder docBuilder = XMLUnit.newControlParser();
    protected final TolerantSaxDocumentBuilder saxBuilder = new TolerantSaxDocumentBuilder(docBuilder);
    protected final HTMLDocumentBuilder htmlBuilder = new HTMLDocumentBuilder(saxBuilder);

    protected Configuration templateConfiguration() {
        return new Configuration(Configuration.VERSION_2_3_32);
    }

    ;

    protected HttpRequest.Builder requestBuilder() {
        return HttpRequest
                .newBuilder()
                .header("Accept", "text/html")
                .header("Content-Type", "application/json")
                .uri(URI.create("http://localhost:3000/govuk/" + System.getProperty("govuk.version") + "/components/" + this.componentName));
    }

    public ComponentTest(String componentName) throws IOException, ParserConfigurationException {
        this.componentName = componentName;
        this.config = templateConfiguration();
        this.objectMapper.setSerializationInclusion(Include.NON_NULL);
        var stringTemplateLoader = new StringTemplateLoader();
        var classTemplateLoader = new ClassTemplateLoader(Params.class, "");
        config.setTemplateLoader(new MultiTemplateLoader(new TemplateLoader[]{stringTemplateLoader, classTemplateLoader}));
        config.setDefaultEncoding(StandardCharsets.UTF_8.name());
        config.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        config.setLogTemplateExceptions(false);
        config.setWrapUncheckedExceptions(false);
        config.setFallbackOnNullLoopVariable(false);
        config.setNumberFormat("c");
        config.setBooleanFormat("c");
        var camelCaseName = CaseUtils.toCamelCase(componentName, true, '-');
        stringTemplateLoader.putTemplate(
                componentName,
                "<#import \"./components/" + componentName + ".ftlh\" as m>" + System.lineSeparator() +
                "<@m.govuk" + camelCaseName + "Macro params=params />");
        this.template = config.getTemplate(componentName);
    }

    protected Document renderNunjucks(A dataModel) throws IOException, InterruptedException, SAXException {
        var params = Params.of(dataModel);

        var paramsJson = objectMapper.writeValueAsString(params);

        var postBody = HttpRequest.BodyPublishers.ofString(paramsJson);

        var response = http.send(
                requestBuilder().POST(postBody).build(),
                HttpResponse.BodyHandlers.ofString()
        );

        if (response.statusCode() != 200) {
            fail("Failed to render Nunjucks template:\n\n" + response.body() + "\n\n" + "Using params:\n\n" + paramsJson);
        }

        return htmlBuilder.parse(response.body());
    }

    protected Document renderFreeMarker(A dataModel) throws TemplateException, IOException, SAXException {
        var stringWriter = new StringWriter();

        try (var bufWriter = new BufferedWriter(stringWriter)) {
            template.process(Params.of(dataModel), bufWriter);
        }

        return htmlBuilder.parse(stringWriter.toString());
    }
}
