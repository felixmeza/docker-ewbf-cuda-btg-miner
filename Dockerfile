FROM debian:stretch

MAINTAINER Adam Cecile <acecile@le-vert.net>

ENV TERM xterm
ENV HOSTNAME ewbf-cuda-btg-miner.local
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Upgrade base system
RUN apt update \
    && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends dist-upgrade \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt update \
    && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends install wget unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install binary
#
RUN mkdir /root/src \
    && wget "https://github.com/poolgold/ewbf-miner-btg-edition/releases/download/v0.3.4b-BTG/BTG-nVidia.miner.0.3.4b.Linux.Bin.zip" -O /root/src/miner.zip \
    && unzip /root/src/miner.zip -d /root/src/ \
    && find /root/src -name 'miner' -exec cp {} /root/ewbf-btg-miner \; \
    && chmod 0755 /root/ewbf-btg-miner \
    && rm -rf /root/src/

# nvidia-container-runtime @ https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/8.0/runtime/Dockerfile
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
