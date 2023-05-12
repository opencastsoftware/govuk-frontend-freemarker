# govuk-frontend-freemarker

[![CI](https://github.com/opencastsoftware/govuk-frontend-freemarker/actions/workflows/ci.yml/badge.svg)](https://github.com/opencastsoftware/govuk-frontend-freemarker/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://spdx.org/licenses/MIT.html)

This repository contains [Apache FreeMarker](https://freemarker.apache.org/) templates for the [GOV.UK Design System](https://design-system.service.gov.uk/) components.

These templates have been translated from the original [Nunjucks](https://mozilla.github.io/nunjucks/) using the [govuk-frontend-transformer](https://github.com/opencastsoftware/govuk-frontend-transformer) project.

## Installation

*govuk-frontend-freemarker* is published for Java 8 and above.

Gradle (build.gradle / build.gradle.kts):

```kotlin
implementation("com.opencastsoftware:govuk-frontend-freemarker:0.1.0:govukFrontend460")
```

Maven (pom.xml):

```
<dependency>
    <groupId>com.opencastsoftware</groupId>
    <artifactId>govuk-frontend-freemarker</artifactId>
    <version>0.1.0</version>
    <classifier>govukFrontend460</classifier>
</dependency>
```

## Usage

Templates can be found as resources in the `com.opencastsoftware.govuk.freemarker.components` package.

Data model classes have been generated representing each design system component's parameters.

For example, to render the `accordion` component, we can use the `com.opencastsoftware.govuk.freemarker.Accordion` class.

To render a template we must follow a few steps:

### Set up FreeMarker

For this example we will follow [the instructions](https://freemarker.apache.org/docs/pgui_quickstart_createconfiguration.html) in the FreeMarker documentation.

```java
var config = new Configuration(Configuration.VERSION_2_3_32);
config.setClassForTemplateLoading(Params.class, "components");
config.setDefaultEncoding(StandardCharsets.UTF_8.name());
config.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
config.setLogTemplateExceptions(false);
config.setWrapUncheckedExceptions(false);
config.setFallbackOnNullLoopVariable(false);
```

Please note the invocation of `setClassForTemplateLoading`. The templates will be resolved relative to the class and package prefix used in this call.

### Get a Template instance

Template names reflect the structure used in [govuk-frontend](), so each component possesses:

* a `macro.ftlh` file - containing the interface for rendering the component within other templates
* a `template.ftlh` file - containing the template content

```java
var template = config.getTemplate("accordion/template.ftlh");
```

### Populate the data model

Each data model class has a `Builder` class which enables you to build up the parameters of the template incrementally.

For example, the simplest invocation of the `accordion` component is as follows:

```java
var accordion = Accordion.builder()
  .withId("example-id")
  .withItems(List.of())
  .build()
```

### Render the template

Every template accepts a top-level `Params` object containing the data model.

This reflects the structure of the original Nunjucks templates.

In order to render the template, we use the `process` method of our `Template` instance:

```java
var writer = new StringWriter();
template.process(Params.of(accordion), writer);
```

## Acknowlegements

This project wouldn't exist without the work of the GOV.UK Design System and GOV.UK Frontend contributors.

## License

All code in this repository is licensed under the MIT License. See [LICENSE](./LICENSE).
