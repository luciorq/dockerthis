# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Set the shell to bash
SHELL ["/bin/bash", "-c"]

# Install necessary dependencies
RUN apt-get update -y && apt-get install -y \
    wget \
    bzip2 \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*;

# Install Micromamba
RUN wget https://micromamba.snakepit.net/api/micromamba/linux-64/latest \
    && tar -xvjf ./latest bin/micromamba --strip-components=1 \
    && ln -sf /app/micromamba /usr/local/bin/micromamba;
    # && rm latest;

# Configure Micromamba
# RUN micromamba shell init -s bash -p /opt/micromamba;
# && echo 'source /opt/micromamba/etc/profile.d/micromamba.sh' >> ~/.bashrc

# Set the default working directory
WORKDIR /app

# Set the entrypoint or default command if needed
ENTRYPOINT ["/usr/local/bin/micromamba"]
