# docker-sia

[![Build Status](https://travis-ci.org/nebulouslabs/docker-sia.svg?branch=master)](https://travis-ci.org/nebulouslabs/docker-sia) 
[![Docker Pulls](https://img.shields.io/docker/pulls/nebulouslabs/sia.svg?maxAge=604800)](https://hub.docker.com/r/nebulouslabs/sia/) 
[![License](http://img.shields.io/:license-mit-blue.svg)](LICENSE)

### Deprecation Notice
This image has been replaced by `ghcr.io/siafoundation/siad` and is no longer maintained. The Dockerfile is now part of the siad repo at https://github.com/siafoundation/siad.

## Supported tags

+ latest - the latest stable Sia release
+ versions - builds of exact Sia releases such as: `1.5.7`
+ master - an unstable build of Sia's current master branch.

**Get latest official release:**
```
docker pull ghcr.io/siafoundation/siad:latest
```

**Get Sia v1.5.7**
```
docker pull ghcr.io/siafoundation/siad:1.5.7
```

**Get current development version (not recommended)**
```
docker pull ghcr.io/siafoundation/siad:master
```

## Usage

It is important to never publish port `9980` to anything but 
`127.0.0.1:9980`. Doing so could give anyone full access to the Sia API and your
wallet.

Containers should never share volumes. If multiple sia containers are 
needed one unique volume should be created per container.

### Basic Container
```
docker volume create sia-data
docker run \
	--detach \
	--restart unless-stopped \
	--mount type=volume,src=sia-data,target=/sia-data \
	--publish 127.0.0.1:9980:9980 \
	--publish 9981:9981 \
	--publish 9982:9982 \
	--publish 9983:9983 \
	--name sia \
	ghcr.io/siafoundation/siad
```

### Command Line Flags

Additional siad command line flags can be passed in by appending them to docker
run.

#### Change API port from 9980 to 8880
```
docker run \
	--detach
	--restart unless-stopped \
	--publish 127.0.0.1:8880:8880 \
	--publish 9981:9981 \
	--publish 9982:9982 \
	--publish 9983:9983 \
	ghcr.io/siafoundation/siad --api-addr ":8880"
 ```


#### Change SiaMux port from 9983 to 8883
```
docker run \
	--detach
	--restart unless-stopped \
	--publish 127.0.0.1:9980:9980 \
	--publish 9981:9981 \
	--publish 9982:9982 \
	--publish 8883:8883 \
	ghcr.io/siafoundation/siad --siamux-addr ":8883"
 ```

#### Only run the minimum required modules
 ```
docker run \
	--detach
	--restart unless-stopped \
	--publish 127.0.0.1:9980:9980 \
	--publish 9981:9981 \
	--publish 9982:9982 \
	ghcr.io/siafoundation/siad -M gct
 ```

### Docker Compose

```yml
services:
  sia:
    container_name: sia
    image: ghcr.io/siafoundation/siad:latest
    ports:
      - 127.0.0.1:9980:9980
      - 9981:9981
      - 9982:9982
      - 9983:9983
      - 9984:9984
    volumes:
      - sia-data:/sia-data
    restart: unless-stopped

volumes:
  sia-data:
```

#### Change API port from 9980 to 8880
```yml
services:
  sia:
    container_name: sia
    command: --api-addr :8880
    image: ghcr.io/siafoundation/siad:latest
    ports:
      - 127.0.0.1:8880:8880
      - 9981:9981
      - 9982:9982
      - 9983:9983
      - 9984:9984
    volumes:
      - sia-data:/sia-data
    restart: unless-stopped

volumes:
  sia-data:
```


#### Change SiaMux port from 9983 to 8883
```yml
services:
  sia:
    container_name: sia
    command: --siamux-addr :8883
    image: ghcr.io/siafoundation/siad:latest
    ports:
      - 127.0.0.1:9980:9980
      - 9981:9981
      - 9982:9982
      - 8883:8883
      - 9984:9984
    volumes:
      - sia-data:/sia-data
    restart: unless-stopped

volumes:
  sia-data:
```

#### Only run the minimum required modules
```yml
services:
  sia:
    container_name: sia
    command: -M gct
    image: ghcr.io/siafoundation/siad:latest
    ports:
      - 127.0.0.1:9980:9980
      - 9981:9981
      - 9982:9982
      - 9983:9983
      - 9984:9984
    volumes:
      - sia-data:/sia-data
    restart: unless-stopped

volumes:
  sia-data:
```

## Interacting with Sia
You can interact with Sia by using the bundled `siac` through `docker exec` or downloading `siac` separately.

#### Print help text
```
docker exec -it sia /siac --help
```

#### Get current sync status
```
docker exec -it sia /siac consensus
```

#### Get wallet balance
```
docker exec -it sia /siac wallet
```

### Sia API Password

When you create or update the Sia container a random API password will be
generated. You may need to copy the new API password when connecting outside of
the container. To force the same API password to be used you can add
`-e SIA_API_PASSWORD=yourpasswordhere` to the `docker run` command. This will
ensure that the API password stays the same between updates and restarts.

### Using Specific Modules

You can pass in different combinations of Sia modules to run by modifying the 
command used to create the container. For example: `-M gct` tells Sia to only
run the gateway, consensus, and transactionpool modules. `-M gctwh` is the minimum
required modules to run a Sia host. `-m gctwr` is the minimum required modules to
run a Sia renter.

### Hosts

Hosting may require additional volumes passed into the container to map
local drives into the container. These can be added by specifying
docker's `-v` or `--mount` flag.

## Build it yourself

The Dockerfile is part of the `siad` repo (https://github.com/siafoundation/siad). To build the image:

1. Clone the siad repo `git clone https://github.com/siafoundation/siad`
2. Enter to the repo directory `cd siad`
3. Checkout the version of Sia you want to build with `git checkout`
4. Build the image `docker build -t siad .`
