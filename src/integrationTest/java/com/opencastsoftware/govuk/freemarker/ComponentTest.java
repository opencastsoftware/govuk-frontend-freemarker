/*
 * SPDX-FileCopyrightText:  © 2023 Opencast Software Europe Ltd <https://opencastsoftware.com>
 * SPDX-License-Identifier: MIT
 */
package com.opencastsoftware.govuk.freemarker;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

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

    public ComponentTest(String componentName) throws IOException {
        this.componentName = componentName;
        this.config = templateConfiguration();
        config.setClassForTemplateLoading(AccordionTest.class, "components");
        config.setDefaultEncoding(StandardCharsets.UTF_8.name());
        config.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        config.setLogTemplateExceptions(false);
        config.setWrapUncheckedExceptions(false);
        config.setFallbackOnNullLoopVariable(false);
        this.template = config.getTemplate(this.componentName + "/template.ftlh");
    }

    protected Document renderNunjucks(JSONObject input) throws IOException, InterruptedException {
        var params = new JSONObject();
        params.put("params", input);

        var postBody = HttpRequest.BodyPublishers.ofString(params.toString());

        var response = http.send(
                requestBuilder().POST(postBody).build(),
                HttpResponse.BodyHandlers.ofString()
        );

        if (response.statusCode() != 200) {
            fail("Failed to render Nunjucks template: " + response.body());
        }

        return Jsoup.parseBodyFragment(response.body());
    }

    protected Document renderFreeMarker(A dataModel) throws TemplateException, IOException {
        var stringWriter = new StringWriter();

        try (var bufWriter = new BufferedWriter(stringWriter)) {
            template.process(Params.of(dataModel), bufWriter);
        }

        return Jsoup.parseBodyFragment(stringWriter.toString());
    }
}
