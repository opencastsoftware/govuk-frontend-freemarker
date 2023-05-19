package com.opencastsoftware.gradle;

import org.gradle.api.DefaultTask;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.provider.Property;
import org.gradle.api.tasks.Input;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.TaskAction;

import java.nio.file.Files;
import java.util.Arrays;

public abstract class CloneGovukFrontend extends DefaultTask {
    @Input
    public abstract Property<String> getGovukFrontendTagName();

    @OutputDirectory
    abstract public DirectoryProperty getRepositoryDir();


    {
        this.onlyIf("Git repository does not exist", task -> {
            var gitDir = getRepositoryDir().getAsFile()
                    .get().toPath()
                    .resolve(".git");
            return !Files.exists(gitDir);
        });
    }

    @TaskAction
    public void cloneRepo() {
        var tagName = getGovukFrontendTagName().get();

        var githubToken = System.getenv("GITHUB_TOKEN");

        var repoUrl = githubToken != null && !githubToken.isBlank()
                ? "https://oauth2:" + githubToken + "@github.com/alphagov/govuk-frontend"
                : "https://github.com/alphagov/govuk-frontend";

        getProject().exec(cmd -> {
            cmd.setExecutable("git");
            cmd.setArgs(Arrays.asList("clone", "--depth", "1", "-b", tagName, repoUrl, "."));
            cmd.setWorkingDir(getRepositoryDir().get().getAsFile());
        });
    }
}
