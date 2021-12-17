# Container image that runs our code.
# base-notebook is a ubuntu image with a light-weight Jupyter installation
FROM jupyter/base-notebook:2021-12-16

# Run the action script when starting the docker container
ENTRYPOINT ["/bin/bash"]
