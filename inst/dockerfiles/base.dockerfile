# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Create a non-root user and change permissions on app directory
RUN useradd -m dockerthis \
  && mkdir -p /app \
  && chown -R dockerthis:dockerthis /app;

# Set the working directory and grant permissions to the non-root user
WORKDIR /app

# Switch to non-root user
USER dockerthis
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
