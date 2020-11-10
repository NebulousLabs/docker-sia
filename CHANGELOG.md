# Changelog

## 0.6.5 - 9th November 2020

* Add version 1.5.2.

## 0.6.4 - 4th November 2020

* Fix `cron` and `logrotate` configurations.
* Add version 1.5.1.
* Fix the `build` script.

## 0.6.3 - 2nd October 2020

* Add a `dev-debian` image. This image will become the main dev image in the
future while the current `dev` image will be renamed to `dev-alpine`. This will
probably happen on the next major version of Sia (1.6).

## 0.6.2 - 18th September

* Add `analyze` to the CI image

## 0.6.1 - 14th September 2020

* Add `logrotate` to all images.

## 0.6.0 - 1st September 2020

* Start rebuilding the `dev` image on each successful push to Sia's `master` branch.
* Add a new `debug` image which has a full development environment in it. This image is not meant to be run in production, it's meant to be a debugging and experimentation image, as well as a CI image.

## 0.5.0 - 25th August 2020

* Stop using `socat` and directly expose `siad` api on port 9980 instead
* Remove the health checks as they are no longer needed

## 0.4.0 - 27th July 2020

* Move Sia binaries from `/sia` to `/usr/bin`


## 0.3.1 - 8th July 2020

* Add logging instructions to README
* Add support for SIAD_DATA_DIR
* Add a Makefile


## 0.3.0 - 14th May 2020

* Add a Raspberry Pi image
* Limit the `dev` image to the latest `master` that passed CI
* [Junipei Kawamoto](kawamoto.junpei@gmail.com)
    * Allow all flags passed to the container to be passed to `siad`


## 0.2.0 - 30th April 2020

* [Junipei Kawamoto](kawamoto.junpei@gmail.com)
    * Add Alpine Linux image
* Move to an `ENTRYPOINT` script
* Add `HEALTHCHECK` functionality, allowing the image to be monitored and maintained by Will Farrel's [autoheal](https://hub.docker.com/r/willfarrell/autoheal/) container


## 0.1.0 - 3rd April 2020

* Repository migrated to Nebulous's GitHub account
