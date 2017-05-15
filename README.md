# Generator Base image

This Docker image is intended as the base for other yeoman generator images to be used by Outrigger

## Creating a Generator image

To create a new generator for Outrigger, create a Dockerfile like this:

```
FROM phase2/outrigger-generatorbase
  
USER root
  
# For public generators know by npm:
RUN npm install --global --silent GENERATOR-NAME
  
# For private generators:
RUN npm install --global --silent git+ssh://bitbucket.org/ORG-NAME/GENERATOR-NAME.git
  
USER yeoman
ENV GENERATOR="GENERATOR-NAME"

```

Then build the docker image:

```
docker build -t GENERATOR-NAME .

```

To run the generator manually to create a new project, use:

```
mkdir ~/PROJECT-NAME
cd ~/PROJECT-NAME
docker run -it -v "$(pwd):/generated" --rm GENERATOR-NAME

```
This will run ``yo GENERATOR-NAME`` within the Docker container and will build the project in the current directory.
