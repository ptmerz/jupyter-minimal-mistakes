# Container image that runs our code.
# base-notebook is a ubuntu image with a light-weight Jupyter installation
FROM jupyter/base-notebook:2021-12-16
USER root

# The action needs the special notebook layout and the action script
# We'll just copy the entire folder there
COPY . /action

# Run the action script when starting the docker container
ENTRYPOINT ["/action/convert_notebooks.sh"]
