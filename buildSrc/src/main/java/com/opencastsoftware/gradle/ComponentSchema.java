package com.opencastsoftware.gradle;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Collections;
import java.util.List;

public class ComponentSchema {
    public ComponentSchema() {

    }

    public ComponentSchema(List<ParameterSchema> params) {
        this.params = params;
    }

    private List<ParameterSchema> params = Collections.emptyList();

    public List<ParameterSchema> getParams() {
        return params;
    }

    public void setParams(List<ParameterSchema> params) {
        this.params = params;
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder()
                .append(params)
                .toHashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (obj == this) {
            return true;
        }
        if (obj.getClass() != getClass()) {
            return false;
        }
        var other = (ComponentSchema) obj;
        return new EqualsBuilder()
                .append(params, other.params)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("params", params)
                .toString();
    }
}
