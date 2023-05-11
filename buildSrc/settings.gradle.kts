// Workaround for https://github.com/gradle/gradle/issues/15383
dependencyResolutionManagement {
    repositories {
        mavenCentral()
        gradlePluginPortal()
    }

    versionCatalogs { create("libs") { from(files("../gradle/libs.versions.toml")) } }
}
