/*
 * SPDX-FileCopyrightText:  © 2023 Opencast Software Europe Ltd <https://opencastsoftware.com>
 * SPDX-License-Identifier: MIT
 */
package com.opencastsoftware.govuk.freemarker;

import freemarker.template.TemplateException;
import net.jqwik.api.ForAll;
import net.jqwik.api.Property;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class AccordionTest extends ComponentTest<Accordion> {

    public AccordionTest() throws IOException {
        super("accordion");
    }

    @Property
    void shouldRender(@ForAll Accordion accordion) throws IOException, TemplateException, InterruptedException {
        var nunjucksDoc = renderNunjucks(accordion);
        var freeMarkerDoc = renderFreeMarker(accordion);
        assertTrue(freeMarkerDoc.hasSameValue(nunjucksDoc));
    }
}
