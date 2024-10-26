# Set environment variable to prevent timezone prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Use a base Ubuntu image
FROM ubuntu:20.04

# Update packages and install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libmicrohttpd-dev \
    libjansson-dev \
    libssl-dev \
    libsrtp2-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libcurl4-openssl-dev \
    liblua5.3-dev \
    libconfig-dev \
    pkg-config \
    gengetopt \
    libtool \
    automake \
    uuid-dev \
    wget && \
    apt-get clean

# Clone Janus GitHub repository
RUN git clone https://github.com/meetecho/janus-gateway.git /janus

# Build and install Janus
WORKDIR /janus
RUN sh autogen.sh && \
    ./configure --disable-websockets --disable-data-channels --disable-docs && \
    make && \
    make install && \
    make configs

# Expose necessary ports for Janus
EXPOSE 8088 8188 7088 7089 10000-10200/udp

# Start Janus server
CMD ["janus", "-F", "/usr/local/etc/janus"]
