package com.opencastsoftware.gradle;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Collections;
import java.util.List;

public class ComponentSchema {
    private String kebabCaseName;
    private List<ParameterSchema> params = Collections.emptyList();

    public ComponentSchema() {

    }

    public ComponentSchema(List<ParameterSchema> params) {
        this.params = params;
    }

    public String getKebabCaseName() {
        return kebabCaseName;
    }

    public void setKebabCaseName(String kebabCaseName) {
        this.kebabCaseName = kebabCaseName;
    }


    public List<ParameterSchema> getParams() {
        return params;
    }

    public void setParams(List<ParameterSchema> params) {
        this.params = params;
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder()
                .append(kebabCaseName)
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
                .append(kebabCaseName, other.kebabCaseName)
                .append(params, other.params)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("kebabCaseName", kebabCaseName)
                .append("params", params)
                .toString();
    }
}
