# Changelog

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
