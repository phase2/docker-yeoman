FROM node:6-alpine

# @see http://label-schema.org/rc1/
LABEL maintainer "Phase2 <outrigger@phase2technology.com>" \
  # Replacement for the old MAINTAINER directive has fragmented.
  # "vendor" prevents CentOS from leaking through, the other is for tools integrations.
  vendor="Phase2 <outrigger@phase2technology.com>" \
  org.label-schema.vendor="Phase2 <outrigger@phase2technology.com>" \
  # CentOS adds a name label but it is misleading in our instance.
  name="Outrigger Yeoman" \
  org.label-schema.name="Outrigger Yeoman" \
  org.label-schema.description="An Alpine & Node 6 base Yeoman support image. Add your code and generate!" \
  org.label-schema.url="http://docs.outrigger.sh" \
  org.label-schema.vcs-url="https://github.com/phase2/docker-yeoman" \
  org.label-schema.docker.cmd="docker run -it --rm outrigger/yeoman bash" \
  org.label-schema.docker.debug="docker exec -it $CONTAINER bash" \
  org.label-schema.schema-version="1.0"

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh curl

RUN echo -n "Node: " && node -v && echo -n "npm: " && npm -v
RUN echo "Yeoman Doctor will warn about our npm version being outdated. It is expected and OK."
RUN npm install --global --silent yo

# Add a yeoman user because Yeoman freaks out and runs setuid(501).
# This was because less technical people would run Yeoman as root and cause problems.
# Setting uid to 501 here since it's already a random number being thrown around.
# @see https://github.com/yeoman/yeoman.github.io/issues/282
# @see https://github.com/cthulhu666/docker-yeoman/blob/master/Dockerfile
RUN adduser -D -u 501 yeoman && \
  echo "yeoman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Yeoman needs the use of a home directory for caching and certain config storage.
ENV HOME /home/yeoman

RUN mkdir /generated && chown yeoman:yeoman /generated
WORKDIR /generated

# Always run as the yeoman user
USER yeoman

COPY root /

ENTRYPOINT ["/opt/bin/entrypoint.sh"]

# Run a Yeoman generator with a command such as:
# docker build -t GENERATOR .
# docker run -it -v "/Users/username/Projects/newproject:/generated" --rm GENERATOR
