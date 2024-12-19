import com.opencastsoftware.gradle.CloneGovukFrontend
import com.opencastsoftware.gradle.GenerateIntegrationTests
import com.opencastsoftware.gradle.GenerateModelClasses
import com.opencastsoftware.gradle.GenerateModelGenerators
import org.gradle.configurationcache.extensions.capitalized

plugins {
    `java-library`
    `jacoco-report-aggregation`
    alias(libs.plugins.gradleJavaConventions)
}

group = "com.opencastsoftware"

description = "Freemarker templates for GOV.UK Design System components"

spotless {
    java {
        clearSteps()
        targetExclude("**/build/generated/**")
        licenseHeader(
            """
            /*
             * SPDX-FileCopyrightText:  © ${"$"}YEAR Opencast Software Europe Ltd <https://opencastsoftware.com>
             * SPDX-License-Identifier: MIT
             */
            """
                .trimIndent()
        )
        removeUnusedImports()
        importOrder("", "javax", "java", "\\#")
        indentWithSpaces()
        trimTrailingWhitespace()
        endWithNewline()
    }
}

java { toolchain.languageVersion.set(JavaLanguageVersion.of(11)) }

tasks.withType<JavaCompile> {
    // Target Java 11
    options.release.set(11)
}

testing {
    suites {
        val test by
            getting(JvmTestSuite::class) {
                dependencies {
                    implementation(libs.junitJupiter)
                    implementation(libs.hamcrest)
                    implementation(libs.jqwik)
                    implementation(libs.freemarker)
                    implementation(libs.jacksonDataBind)
                    implementation(libs.xmlUnitLegacy)
                    implementation(libs.xmlUnitMatchers)
                    implementation(libs.apacheCommonsText)
                }
            }

    }
}

val govukFrontendVersions = mapOf("govukFrontend4x" to "v4.9.0", "govukFrontend5x" to "v5.7.1")
val isCI = !System.getenv("CI").isNullOrEmpty()

govukFrontendVersions.forEach { (version, tagName) ->
    val cloneRepoDir = "${buildDir}/generated/${version}/gitRepo"
    val cloneRepoTaskName = "clone${version.capitalized()}"
    val cloneRepoTask =
        tasks.register<CloneGovukFrontend>(cloneRepoTaskName) {
            govukFrontendTagName.set(tagName)
            repositoryDir.set(file(cloneRepoDir))
        }

    sourceSets {
        val generatedSrcDir = "${buildDir}/generated/${version}/java"
        val generateModelClassesTaskName = "generate${version.capitalized()}Models"
        val generateModelClassesTask =
            tasks.register<GenerateModelClasses>(generateModelClassesTaskName) {
                govukFrontendVersion.set(tagName)
                repositoryDir.set(cloneRepoTask.map { it.repositoryDir.get() })
                generatedSourcesDir.set(file(generatedSrcDir))
            }

        sourceSets.create(version) {
            tasks[compileJavaTaskName].dependsOn(generateModelClassesTask.get())
            java { srcDirs(generatedSrcDir) }
            dependencies {
                "${version}Implementation"(libs.jsr305)
                "${version}Implementation"(sourceSets["main"].output)
            }
        }
    }

    java { registerFeature(version) { usingSourceSet(sourceSets[version]) } }

    val suiteName = "test${version.capitalized()}"

    testing {
        suites {
            register<JvmTestSuite>(suiteName) {
                val generatedTestSrcDir = "${buildDir}/generated/${suiteName}/java"

                val generateModelGeneratorsTaskName = "generate${version.capitalized()}Generators"
                val generatedTestResourceDir = "${buildDir}/generated/${suiteName}/resources"
                val generateModelGeneratorsTask =
                    tasks.register<GenerateModelGenerators>(generateModelGeneratorsTaskName) {
                        govukFrontendVersion.set(tagName)
                        repositoryDir.set(cloneRepoTask.map { it.repositoryDir.get() })
                        generatedSourcesDir.set(file(generatedTestSrcDir))
                        generatedResourcesDir.set(file(generatedTestResourceDir))
                    }

                val generateIntegrationTestsTaskName = "generate${version.capitalized()}Tests"
                val generateIntegrationTestsTask =
                    tasks.register<GenerateIntegrationTests>(generateIntegrationTestsTaskName) {
                        govukFrontendVersion.set(tagName)
                        repositoryDir.set(cloneRepoTask.map { it.repositoryDir.get() })
                        generatedTestsDir.set(file(generatedTestSrcDir))
                    }

                sources {
                    java {
                        tasks[compileJavaTaskName].dependsOn(generateModelGeneratorsTask.get())
                        tasks[compileJavaTaskName].dependsOn(generateIntegrationTestsTask.get())
                        tasks[processResourcesTaskName].dependsOn(generateModelGeneratorsTask.get())
                        setSrcDirs(listOf(generatedTestSrcDir))
                    }

                    resources { srcDir(generatedTestResourceDir) }
                }

                dependencies {
                    implementation(sourceSets["main"].output)
                    implementation(sourceSets["test"].output)
                    implementation(sourceSets[version].output)
                    implementation(libs.junitJupiter)
                    implementation(libs.hamcrest)
                    implementation(libs.jqwik)
                    implementation(libs.freemarker)
                    implementation(libs.jacksonDataBind)
                    implementation(libs.xmlUnitLegacy)
                    implementation(libs.xmlUnitMatchers)
                    implementation(libs.jsr305)
                    implementation(libs.apacheCommonsText)
                    // Can be used to enable Freemarker logging in the tests
                    // runtimeOnly(libs.log4jOverSlf4j)
                    // runtimeOnly(libs.logbackClassic)
                }

                targets {
                    all {
                        testTask.configure { systemProperty("govuk.version", tagName.substring(1)) }
                    }
                }
            }
        }
    }

    // Only run version 4.x in CI while 5.x is still WIP
    if (version == "govukFrontend4x" || !isCI) {
        tasks.check {
            dependsOn(testing.suites.named(suiteName))
            finalizedBy(tasks["${suiteName}CodeCoverageReport"])
        }
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
            license {
                name.set("The MIT License")
                url.set("https://opensource.org/license/mit/")
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
