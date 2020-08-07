# How To Publish a New Version

This is a step-by-step guide to creating a new version of the official Sia Docker image.

All examples will assume that we’re upgrading from version 1.4.11 to 1.5.0.

1. Checkout the https://github.com/NebulousLabs/docker-sia/ repo.
2. Update the version in all Dockerfiles except `dev`, as well as the `Makefile`.
3. Add a new section to the `README` describing the new version.
4. Push the update as a new commit to `master`, either directly or via a PR.
5. Tag the new commit with all the following tags `v1.5.0`,` v1.5.0pi`, 
`v1.5.0alpine` and push them as well.

In order to verify that everything is OK go to the
[Docker Hub build page](https://hub.docker.com/repository/docker/nebulouslabs/sia/builds) 
and make sure the builds for all the tags are either running or queued up. If 
they are not, you have either not pushed the tags, or you've messed up the tag 
format (you can see the exact regex for the tag format on the build page on 
Docker Hub). Don't worry about deleting tags are adding them again - this will
trigger the build process and the newly created images will replace the existing
ones, allowing you to correct mistakes like tagging the wrong commit, etc.

