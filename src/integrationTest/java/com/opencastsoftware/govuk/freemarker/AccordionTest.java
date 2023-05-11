/*
 * SPDX-FileCopyrightText:  © 2023 Opencast Software Europe Ltd <https://opencastsoftware.com>
 * SPDX-License-Identifier: Apache-2.0
 */
package com.opencastsoftware.govuk.freemarker;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.json.JSONArray;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;

public class AccordionTest {
    static final Configuration config = new Configuration(Configuration.VERSION_2_3_32);
    static Template template;

    static HttpClient http = HttpClient.newHttpClient();

    static HttpRequest.Builder request = HttpRequest
            .newBuilder()
            .header("Accept", "text/html")
            .header("Content-Type", "application/json")
            .uri(URI.create("http://localhost:3000/govuk/" + System.getProperty("govuk.version") + "/components/accordion"));

    HttpResponse<String> renderNunjucks(JSONObject input) throws IOException, InterruptedException {
        var params = new JSONObject();
        params.put("params", input);

        var postBody = HttpRequest.BodyPublishers.ofString(params.toString());

        var response = http.send(
                request.POST(postBody).build(),
                HttpResponse.BodyHandlers.ofString()
        );

        if (response.statusCode() != 200) {
            fail("Failed to render Nunjucks template: " + response.body());
        }

        return response;
    }

    @BeforeAll
    static void setupFreemarker() throws IOException {
        config.setClassForTemplateLoading(AccordionTest.class, "components");
        config.setDefaultEncoding(StandardCharsets.UTF_8.name());
        config.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        config.setLogTemplateExceptions(false);
        config.setWrapUncheckedExceptions(false);
        config.setFallbackOnNullLoopVariable(false);
        template = config.getTemplate("accordion/template.ftlh");
    }

    @Test
    void shouldRenderWithEmptyItems() throws IOException, TemplateException, InterruptedException {
        var input = new JSONObject();
        input.put("id", "bla");
        input.put("items", new JSONArray());
        var nunjucksDoc = Jsoup.parseBodyFragment(renderNunjucks(input).body());

        var stringWriter = new StringWriter();
        try (var bufWriter = new BufferedWriter(stringWriter)) {
            template.process(Params.of(new Accordion("bla", null, null, null, null, null, null, null, null, null, null, Collections.emptyList())), bufWriter);
            var freemarkerDoc = Jsoup.parseBodyFragment(stringWriter.toString());
            assertTrue(nunjucksDoc.hasSameValue(freemarkerDoc));
        }
    }
}
