# docker-sia

[![Build Status](https://travis-ci.org/nebulouslabs/docker-sia.svg?branch=master)](https://travis-ci.org/nebulouslabs/docker-sia) 
[![Docker Pulls](https://img.shields.io/docker/pulls/nebulouslabs/sia.svg?maxAge=604800)](https://hub.docker.com/r/nebulouslabs/sia/) 
[![License](http://img.shields.io/:license-mit-blue.svg)](LICENSE)

## Supported Tags

### Latest
* **latest**: The latest official binary release.
* **alpine-latest**: The latest official binary release based on Alpine Linux.
* **pi-latest**: The latest official binary release for Raspberry Pi or any other 
machine with an ARMv8 CPU.
* **dev**: The latest version of the `master` branch that passed CI. Typically 
unsuitable for production use, this image is aimed at people who want to tinker 
and stay up to the date with the latest development.
* **debug**: This is a special image that has a full development environment in 
it. This image is not meant to be run in production, it's meant to be a 
debugging and experimentation image.

### v1.5.0
* **1.5.0**
* **alpine-1.5.0**
* **pi-1.5.0**

### v1.4.11
* **1.4.11**
* **alpine-1.4.11**
* **pi-1.4.11**

### v1.4.10
* **1.4.10**
* **alpine-1.4.10**
* **pi-1.4.10**

### v1.4.8
* **1.4.8**
* **alpine-1.4.8**
* **pi-1.4.8**

### v1.4.7
* **1.4.7**
* **alpine-1.4.7**
* **pi-1.4.7**

## Usage

```bash
mkdir sia-data
docker run \
  --detach \
  --volume $(pwd)/sia-data:/sia-data \
  --publish 127.0.0.1:9980:9980 \
  --publish 9981:9981 \
  --publish 9982:9982 \
  --name sia-container \
   nebulouslabs/sia
```

**Important**: Never publish port 9980 to all interfaces. This is a 
security-sensitive API, so only expose it beyond 127.0.0.1 if you know what 
you're doing.

By default, the container uses the following defaults:  
- `SIA_DIR` is `/sia`
- `SIA_DATA_DIR` is `/sia-data`
- `SIAD_DATA_DIR` is `/sia-data`

You can change the values of `SIA_DATA_DIR` and `SIAD_DATA_DIR` by supplying new
environment variables for the container using the `-e` option:  
`-e SIA_DATA_DIR=/new-sia-data-dir`  
`-e SIAD_DATA_DIR=/new-siad-data-dir`

Once the container is running, you can execute `siac` from within the container:

```bash
$ docker exec -it sia-container siac consensus
Synced: No
Height: 3800
Progress (estimated): 2.4%
```

You can also call `siad` from outside the container:

```bash
$ curl -A "Sia-Agent" "http://localhost:9980/consensus"
{"synced":false,"height":4690,"currentblock":"0000000000007d656e3bb0099737892b9073259cb05883b04c6f518fbf0faffb","target":[0,0,0,0,0,2,200,179,126,85,220,153,25,190,195,228,72,53,129,181,62,124,175,60,255,90,105,68,179,16,6,71],"difficulty":"101104922300609"}
```

## Logs

If you are interested in `siad`'s logs you can start the container with the 
following option `--log-driver local` and docker will keep the logs on disk.
More info [here](https://docs.docker.com/config/containers/logging/local).  

If you want to follow the logs while still being detached from the container,
you can use `docker logs -f <container>`

## Which image to use?

If you are unsure which image to use, use the default `latest` image.  
If using an Alpine-based image makes more sense in your environment - use the 
`alpine` image.  
In case you want to play around with the latest development build and see what 
we are working on, use the `dev` image. Keep in mind that the `dev` image might 
not be suitable for regular production use! 

## Build it yourself

Building the container is very simple. The only thing you need to keep in mind 
is to run the build from the project's root folder, so your build context will 
have access to the various scripts we're using:
```
docker build -t sia:1.4.7-dev-custom -f dev/Dockerfile
```

## More examples

For more usage examples, see the blog post, ["Fun with Sia and Docker."](https://blog.spaceduck.io/sia-docker/)

## Publishing a new version

If you are looking for a howto on publishing a new version of this image, you
can find one [here](https://github.com/NebulousLabs/docker-sia/blob/master/HOWTO.md).
