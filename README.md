# docker-sia

[![Build Status](https://travis-ci.org/nebulouslabs/docker-sia.svg?branch=master)](https://travis-ci.org/nebulouslabs/docker-sia) [![Docker Pulls](https://img.shields.io/docker/pulls/nebulouslabs/sia.svg?maxAge=604800)](https://hub.docker.com/r/nebulouslabs/sia/) [![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](LICENSE)

## Supported Tags

* latest: The latest official binary release.
* 1.4.7

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

**Important**: Never publish port 9980 to all interfaces. This is a security-sensitive API, so only expose it beyond 127.0.0.1 if you know what you're doing.

Once the container is running, you can execute `siac` from within the container:

```bash
$ docker exec -it sia-container ./siac consensus
Synced: No
Height: 3800
Progress (estimated): 2.4%
```

You can also call `siad` from outside the container:

```bash
$ curl -A "Sia-Agent" "http://localhost:9980/consensus"
{"synced":false,"height":4690,"currentblock":"0000000000007d656e3bb0099737892b9073259cb05883b04c6f518fbf0faffb","target":[0,0,0,0,0,2,200,179,126,85,220,153,25,190,195,228,72,53,129,181,62,124,175,60,255,90,105,68,179,16,6,71],"difficulty":"101104922300609"}
```

## Health monitoring

The `sia` container is equipped with a [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck) 
and is labelled as `autoheal=true`. This allows us to use Will Farrel's [autoheal](https://hub.docker.com/r/willfarrell/autoheal/) 
container in order to restart the `sia` container if it becomes unhealthy.

All you need to do is start the `autoheal` container alongside `sia`:
```
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal
```

## Which image to use?

If you are unsure which image to use, use the default `latest` image.  
If using an Alpine-based image makes more sense in your environment - use the 
`alpine` image.  
If you want to play around with the latest development build and see what we are 
working on, use the `dev` image. Keep in mind that the `dev` image might not be 
suitable for regular production use! 

## Build it yourself

Building the container is very simple. The only thing you need to keep in mind 
is to run the build from the project's root folder, so your build context will 
have access to the various scripts we're using:
```
docker build -t sia:1.4.7-dev-custom -f dev/Dockerfile
```

## More examples

For more usage examples, see the blog post, ["Fun with Sia and Docker."](https://blog.spaceduck.io/sia-docker/)
