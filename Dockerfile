FROM node:6-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN node -v
RUN npm -v
RUN echo "Yeoman Doctor will warn about our npm version being outdated. It is expected and OK."
RUN npm install --global --silent yo node-inspector

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
ENV GENERATOR="default"

COPY root /

ENTRYPOINT ["/opt/bin/entrypoint.sh"]
CMD ["$GENERATOR"]

# Run a Yeoman generator with a command such as:
# docker build -t yeoman .
# docker run -it -v "/Users/username/Projects/newproject:/generated" --rm yeoman yo gadget --no-insight --skip-install

# The --no-insight flag is recommended to avoid prompts for usage collection.
# @see https://github.com/yeoman/yo/issues/20

