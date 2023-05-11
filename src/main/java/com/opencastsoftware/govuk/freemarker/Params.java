/*
 * SPDX-FileCopyrightText:  © 2023 Opencast Software Europe Ltd <https://opencastsoftware.com>
 * SPDX-License-Identifier: Apache-2.0
 */
package com.opencastsoftware.govuk.freemarker;

public class Params<A> {
    private A params;

    public Params(A params) {
        this.params = params;
    }

    public A getParams() {
        return this.params;
    }

    public void setParams(A params) {
        this.params = params;
    }

    public static <A> Params<A> of(A params) {
        return new Params<>(params);
    }
}
