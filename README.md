# govuk-frontend-freemarker

[![CI](https://github.com/opencastsoftware/govuk-frontend-freemarker/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/opencastsoftware/govuk-frontend-freemarker/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://spdx.org/licenses/MIT.html)

This repository contains [Apache FreeMarker](https://freemarker.apache.org/) templates for the [GOV.UK Design System](https://design-system.service.gov.uk/) components.

At present this repository is tracking version 4.x of the GOV.UK Frontend library, but work is ongoing to translate version 5.x of GOV.UK Frontend.

## Installation

*govuk-frontend-freemarker* is published for Java 11 and above.

A [Maven classifier](https://maven.apache.org/pom.html#Dependencies) is used to select the GOV.UK Frontend major version.

At present only the `govuk-frontend4x` artifacts are recommended, as the translation of GOV.UK Frontend 5.x is still a work in progress.

Gradle (build.gradle / build.gradle.kts):

```kotlin
implementation("com.opencastsoftware:govuk-frontend-freemarker:0.1.0:govuk-frontend4x")
```

Maven (pom.xml):

```
<dependency>
    <groupId>com.opencastsoftware</groupId>
    <artifactId>govuk-frontend-freemarker</artifactId>
    <version>0.1.0</version>
    <classifier>govuk-frontend4x</classifier>
</dependency>
```

## Known Issues

There are no known functional issues with these translated templates. If you find some, please report them on the Issues tab!

The main issue with this translation at present is its readability:

* These templates were translated using Nunjucks' own parser. This means that [whitespace stripping](https://mozilla.github.io/nunjucks/templating.html#whitespace-control) that would normally be applied to the template output has been applied to the templates themselves, removing linebreaks and whitespace that were added for readability.
* Comments are missing from the translation, because the Nunjucks parser discards comments.
* No effort has been made as yet to print the translation with minimal parentheses. This means that parentheses are used in all cases where a compound expression could be used.

We plan to address these issues in later releases of the project. 

## Usage

Templates can be found as resources in the `com.opencastsoftware.govuk.freemarker.components` package.

Data model classes have been generated representing each design system component's parameters.

For example, to render the `accordion` component, we can use the `com.opencastsoftware.govuk.freemarker.Accordion` class.

To render a template we must follow a few steps:

### Set up FreeMarker

For this example we will follow [the instructions](https://freemarker.apache.org/docs/pgui_quickstart_createconfiguration.html) in the FreeMarker documentation.

```java
var config = new Configuration(Configuration.VERSION_2_3_32);
var stringTemplateLoader = new StringTemplateLoader();
var govukTemplateLoader = new ClassTemplateLoader(Params.class, "");
config.setTemplateLoader(new MultiTemplateLoader(new TemplateLoader[] { stringTemplateLoader, govukTemplateLoader }));
config.setDefaultEncoding(StandardCharsets.UTF_8.name());
config.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
config.setLogTemplateExceptions(false);
config.setWrapUncheckedExceptions(true);
config.setFallbackOnNullLoopVariable(false);
```

Please note the parameters of the `ClassTemplateLoader`. *govuk-frontend-freemarker* templates will be resolved relative to the class `com.opencastsoftware.govuk.freemarker.Params` and the package prefix used in this call.

In our examples, the `StringTemplateLoader` is used to load templates making use of the *govuk-frontend-freemarker* components.

This indirection is needed because FreeMarker templates instantiated via the `Template` constructor cannot import other templates. Only templates loaded via a `TemplateLoader` can do so.

In practice you will probably want to use another `ClassTemplateLoader` to load your custom templates from the classpath.

In addition to the setup above, we will set the FreeMarker `boolean_format` and `number_format` settings to `"c"`, the setting for computers.

```java
config.setBooleanFormat("c");
config.setNumberFormat("c");
```

This is because Nunjucks does not have any special formatting behaviour for numbers or booleans.

### Get a Template instance

Each component is represented by a Freemarker `*.ftlh` file named according to the component directory in [govuk-frontend](https://github.com/alphagov/govuk-frontend). The `*.ftlh` extension enables FreeMarker's HTML auto-escaping behaviour.

For example, to import the `accordion` component, we will import `"./components/accordion.ftlh"`.

Each component is defined as a FreeMarker macro with the prefix `govuk` and suffix `Macro`.

A FreeMarker function is also defined for each component which allows using that component in interpolations.

```java
stringTemplateLoader.putTemplate(
    "test",
    "<#import \"./components/accordion.ftlh\" as accordion>" +
    // Usage of the macro definition
    "<@accordion.govukAccordionMacro params=params />" +
    // Usage of the function definition
    "${accordion.govukAccordion(params)}"
);

var template = config.getTemplate("test");
```

### Populate the data model

Each data model class has a `Builder` class which enables you to build up the parameters of the component incrementally.

For example, the simplest invocation of the `accordion` component is as follows:

```java
var accordion = Accordion.builder()
  .withId("example-id")
  .withItems(List.of())
  .build();
```

### Render the template

Every component macro and wrapper function accepts a top-level `Params` object containing the data model.

This reflects the structure of the original Nunjucks templates.

In order to render the template, we use the `process` method of our `Template` instance:

```java
var writer = new StringWriter();
template.process(Params.of(accordion), writer);
```

## Contributing

This project is built with [Gradle](https://gradle.org/install/) 8.x and requires a [Java 11+ JDK](https://adoptium.net/temurin/releases/?version=11).

### Prerequisites

In order to run integration tests, this project makes use of a Node app, [govuk-nunjucks-renderer](https://github.com/opencastsoftware/govuk-nunjucks-renderer/).

It's a web app which renders Nunjucks templates via a HTTP API, in order to enable comparative testing with a diverse range of technology stacks.

To run it:

```bash
# Docker
docker run -d -p 3000:3000 ghcr.io/opencastsoftware/govuk-nunjucks-renderer:0.1.5
# Podman
podman run -d -p 3000:3000 ghcr.io/opencastsoftware/govuk-nunjucks-renderer:0.1.5
```

### Building

To build and run tests:

```bash
./gradlew build --info
```

## Acknowledgements

This project wouldn't exist without the work of the GOV.UK Design System and GOV.UK Frontend contributors.

## License

All code in this repository is licensed under the MIT License. See [LICENSE](./LICENSE).
