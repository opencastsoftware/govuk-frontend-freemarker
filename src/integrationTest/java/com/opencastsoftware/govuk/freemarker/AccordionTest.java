/*
 * SPDX-FileCopyrightText:  © 2023 Opencast Software Europe Ltd <https://opencastsoftware.com>
 * SPDX-License-Identifier: MIT
 */
package com.opencastsoftware.govuk.freemarker;

import freemarker.template.TemplateException;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class AccordionTest extends ComponentTest<Accordion> {

    public AccordionTest() throws IOException {
        super("accordion");
    }

    @Test
    void shouldRenderWithEmptyItems() throws IOException, TemplateException, InterruptedException {
        var input = new JSONObject();
        input.put("id", "bla");
        input.put("items", new JSONArray());

        var nunjucksDoc = renderNunjucks(input);

        var accordion = Accordion.builder()
                .withId("bla")
                .withItems(List.of())
                .build();

        var freeMarkerDoc = renderFreeMarker(accordion);

        assertTrue(freeMarkerDoc.hasSameValue(nunjucksDoc));
    }
}
