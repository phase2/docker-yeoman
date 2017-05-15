# Generator Base image

This Docker image is intended as the base for other yeoman generator images.

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

To run the generator manually to create a new project, use:

```
mkdir ~/PROJECT-NAME
cd ~/PROJECT-NAME
docker run -it -v "$(pwd):/generated" --rm GENERATOR-NAME

```
This will run ``yo GENERATOR-NAME`` within the Docker container and will build the project in the current directory.
