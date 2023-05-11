package com.opencastsoftware.gradle;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Collections;
import java.util.List;

public class ParameterSchema {
    private String name;
    private String type;
    private Boolean required;
    private String description;
    private List<ParameterSchema> params = Collections.emptyList();

    public ParameterSchema() {

    }

    public ParameterSchema(String name, String type, Boolean required, String description) {
        this.name = name;
        this.type = type;
        this.required = required;
        this.description = description;
    }

    public ParameterSchema(String name, String type, Boolean required, String description, List<ParameterSchema> params) {
        this.name = name;
        this.type = type;
        this.required = required;
        this.description = description;
        this.params = params;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean isRequired() {
        return required;
    }

    public void setRequired(Boolean required) {
        this.required = required;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
                .append(name)
                .append(type)
                .append(required)
                .append(description)
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
        var other = (ParameterSchema) obj;
        return new EqualsBuilder()
                .append(name, other.name)
                .append(type, other.type)
                .append(required, other.required)
                .append(description, other.description)
                .append(params, other.params)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("name", name)
                .append("type", type)
                .append("required", required)
                .append("description", description)
                .append("params", params)
                .toString();
    }
}
