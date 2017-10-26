# Outrigger Yeoman Base

> Facilitates execution of Yeoman generators via a container.

[![GitHub tag](https://img.shields.io/github/tag/phase2/docker-yeoman.svg)](https://github.com/phase2/docker-yeoman) [![Docker Stars](https://img.shields.io/docker/stars/outrigger/yeoman.svg)](https://hub.docker.com/r/outrigger/yeoman) [![Docker Pulls](https://img.shields.io/docker/pulls/outrigger/yeoman.svg)](https://hub.docker.com/r/outrigger/yeoman) [![MicroBadger](https://images.microbadger.com/badges/image/outrigger/yeoman:latest.svg)](https://microbadger.com/images/outrigger/yeoman:latest "Get your own image badge on microbadger.com")

This image provides some special handling to ensure Yeoman generators can be
executed inside a container, and an entrypoint that facilitates execution of the
yo utility.

It does not contain any generators itself.

## Creating a Generator image

To create a new yeoman generator, create a Dockerfile like this:

```
FROM outrigger/yeoman

USER root

# For public generators know by npm:
RUN npm install --global --silent GENERATOR-NAME

USER yeoman
```

Then build the docker image:

```
docker build -t GENERATOR-NAME .
```

## Usage Example

To run the generator in your created generator image, run:

```
mkdir ~/PROJECT-NAME
cd ~/PROJECT-NAME
docker run --rm -it -v $PWD:/generated {GENERATOR-IMAGE} {GENERATOR-NAME}
```

This will run `yo GENERATOR-NAME` within the Docker container and will build the
project in the current directory.

## Use for Generator Development

You can directly use this generator and volume mount a working generator codebase
into place with bind volumes.

### Using docker-compose

```yaml
version: "2.1"

services:

  # Opens the container with a BASH session and sets the working directory to
  # the local of the volume-mounted generator code.
  cli:
    extends:
      service: yo
    working_dir: /usr/local/lib/node_modules/generator-outrigger-drupal
    entrypoint: ["/usr/bin/env"]
    command: "bash"

  # Run 'yo' inside the container.
  # Usage: docker-compose run --rm yo
  # docker-compose run --rm yo {GENERATOR-NAME}
  yo:
    image: outrigger/yeoman
    // Required by Outrigger DNS setup.
    network_mode: "bridge"
    volumes:
      - ${YO_PROJECT_DIRECTORY:-~/{PROJECT-NAME}}:/generated
      - .:/usr/local/lib/node_modules/generator-{GENERATOR_NAME}
```

Note that in the docker run example we generate the project in ~/{PROJECT-NAME},
in the docker-compose example this can be overridden by setting a YO_PROJECT_DIRECTORY
environment variable.

Now with that configuration, you have a pair of much simpler commands to install
and run your in-development generator.

```
docker-compose run --rm cli npm install
docker-compose run --rm cli yo {GENERATOR-NAME}
```

## Security Reports

Please email outrigger@phase2technology.com with security concerns.

## Maintainers

[![Phase2 Logo](https://www.phase2technology.com/wp-content/uploads/2015/06/logo-retina.png)](https://www.phase2technology.com)
