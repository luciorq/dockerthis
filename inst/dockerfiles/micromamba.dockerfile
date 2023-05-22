# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Set the shell to bash
SHELL ["/bin/bash", "-c"]

# Set noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update -y \
  && apt-get install -y \
    wget \
    bzip2 \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*;

# Install Micromamba
RUN wget https://micromamba.snakepit.net/api/micromamba/linux-64/latest -O /tmp/micromamba \
    && mkdir -p /opt/micromamba \
    && tar -xjf /tmp/micromamba -C /opt/micromamba \
    && ln -sf /opt/micromamba/bin/micromamba /usr/local/bin/micromamba \
    && rm /tmp/micromamba;

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

# Configure Micromamba
RUN micromamba shell init -s bash -p /app/micromamba;

# Set the entrypoint or default command if needed
# ENTRYPOINT ["/usr/local/bin/micromamba"]
