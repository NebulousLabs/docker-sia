# Changelog

## 1.5.3 (Sia 1.5.3) - 10th November 2020

## 1.5.1 (Sia 1.5.1) - 4th November 2020

## 1.5.0.4 (Sia 1.5.0) - 16th October 2020
* Add a `dev-debian` image. This image will become the main dev image in the
future while the current `dev` image will be renamed to `dev-alpine`. This will
probably happen on the next major version of Sia (1.6).
* Fix `cron` and `logrotate` configurations.

## 1.5.0.3 (Sia 1.5.0) - 14th September 2020
* Start rebuilding the `dev` image on each successful push to Sia's `master` branch.
* Add a new `debug` image which has a full development environment in it. This image is not meant to be run in production, it's meant to be a debugging and experimentation image, as well as a CI image.
* Add `logrotate` to all images.

## 1.5.0.2 (Sia 1.5.0) - 26th August 2020
* Add OS-level mime support

## 1.5.0.1 (Sia 1.5.0) - 25th August 2020
* Allow building `dev` with specific git tag or sha
* Stop using `socat` and directly expose `siad` api on port 9980 instead
* Remove health checks
* Add HOWTO

## 1.5.0 (Sia 1.5.0) - 6th August 2020
* Add logging instructions to README
* Add support for SIAD_DATA_DIR
* Move Sia binaries from `/sia` to `/usr/bin`

## 1.4.11 (Sia 1.4.11) - 8th July 2020
* Add a Makefile

## 1.4.10 (Sia 1.4.10) - 4th June 2020

## 1.4.8 (Sia 1.4.8) - 14th May 2020
* Add a Raspberry Pi image
* Limit the `dev` image to the latest `master` that passed CI
* [Junipei Kawamoto](mailto:kawamoto.junpei@gmail.com)
    * Allow all flags passed to the container to be passed to `siad`


## 1.4.7 (Sia 1.4.7) - 22nd April 2020
* [Junipei Kawamoto](mailto:kawamoto.junpei@gmail.com)
    * Add Alpine Linux image
* Move to an `ENTRYPOINT` script
* Add `HEALTHCHECK` functionality, allowing the image to be monitored and maintained by Will Farrel's [autoheal](https://hub.docker.com/r/willfarrell/autoheal/) container
