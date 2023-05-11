import com.opencastsoftware.gradle.GenerateComponentParams
import org.gradle.configurationcache.extensions.capitalized

plugins {
    `java-library`
    alias(libs.plugins.gradleJavaConventions)
}

group = "com.opencastsoftware"

description = "Freemarker templates for GOV.UK Design System components"

val govukFrontendVersions = mapOf("govukFrontend460" to "v4.6.0", "govukFrontend450" to "v4.5.0")

spotless { java { targetExclude("**/build/generated/**") } }

sourceSets {
    govukFrontendVersions.forEach { (version, tagName) ->
        val generatedSrcDir = "${buildDir}/generated/${version}/java"
        val generateParamsTaskName = "generate${version.capitalized()}Params"
        val generateParamsTask =
            tasks.register<GenerateComponentParams>(generateParamsTaskName) {
                govukFrontendTagName.set(tagName)
                generatedSourcesDir.set(file(generatedSrcDir))
            }

        sourceSets.create(version) {
            tasks[compileJavaTaskName].dependsOn(generateParamsTask.get())
            java { srcDirs(generatedSrcDir) }
            dependencies {
                "${version}Implementation"(sourceSets["main"].output)
                "${version}Implementation"(libs.jsr305)
            }
        }
    }
}

java {
    toolchain.languageVersion.set(JavaLanguageVersion.of(11))
    govukFrontendVersions.forEach { (version, _) ->
        registerFeature(version) { usingSourceSet(sourceSets[version]) }
    }
}

mavenPublishing {
    coordinates("com.opencastsoftware", "govuk-frontend-freemarker", project.version.toString())

    pom {
        name.set("govuk-frontend-freemarker")
        description.set(project.description)
        url.set("https://github.com/opencastsoftware/govuk-frontend-freemarker")
        inceptionYear.set("2023")
        licenses {
            // TODO: Change this to MIT
            license {
                name.set("The Apache License, Version 2.0")
                url.set("http://www.apache.org/licenses/LICENSE-2.0.txt")
                distribution.set("repo")
            }
        }
        organization {
            name.set("Opencast Software Europe Ltd")
            url.set("https://opencastsoftware.com")
        }
        developers {
            developer {
                id.set("DavidGregory084")
                name.set("David Gregory")
                organization.set("Opencast Software Europe Ltd")
                organizationUrl.set("https://opencastsoftware.com/")
                timezone.set("Europe/London")
                url.set("https://github.com/DavidGregory084")
            }
        }
        ciManagement {
            system.set("Github Actions")
            url.set("https://github.com/opencastsoftware/govuk-frontend-freemarker/actions")
        }
        issueManagement {
            system.set("GitHub")
            url.set("https://github.com/opencastsoftware/govuk-frontend-freemarker/issues")
        }
        scm {
            connection.set(
                "scm:git:https://github.com/opencastsoftware/govuk-frontend-freemarker.git"
            )
            developerConnection.set(
                "scm:git:git@github.com:opencastsoftware/govuk-frontend-freemarker.git"
            )
            url.set("https://github.com/opencastsoftware/govuk-frontend-freemarker")
        }
    }
}

testing {
    suites {
        govukFrontendVersions.forEach { (version, tagName) ->
            register<JvmTestSuite>("test${version.capitalized()}") {
                sources { java { srcDir("${projectDir}/src/integrationTest/java") } }
                dependencies {
                    implementation(libs.freemarker)
                    implementation(libs.junitJupiter)
                    implementation(libs.hamcrest)
                    implementation(libs.json)
                    implementation(libs.jsoup)
                    implementation(sourceSets["main"].output)
                    implementation(sourceSets[version].output)
                }
                targets {
                    all {
                        testTask.configure { systemProperty("govuk.version", tagName.substring(1)) }
                    }
                }
            }
        }
    }
}

tasks.check {
    govukFrontendVersions.forEach { (version, _) ->
        dependsOn(testing.suites.named("test${version.capitalized()}"))
    }
}
