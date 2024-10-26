# Use a base Ubuntu image
FROM ubuntu:20.04

# Set environment variables to prevent timezone prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update package list and install software-properties-common
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe

# Update packages and install necessary dependencies without man pages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libmicrohttpd-dev \
    libjansson-dev \
    libssl-dev \
    libsrtp2-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libglib2.0-0 \
    libgmodule-2.0-dev \
    libgthread-2.0-dev \
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
    wget \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone Janus GitHub repository
RUN git clone https://github.com/meetecho/janus-gateway.git /janus

# Change working directory to /janus
WORKDIR /janus

# Make autogen.sh executable and run the build commands
RUN chmod +x autogen.sh && \
    sh autogen.sh && \
    ./configure --disable-websockets --disable-data-channels --disable-docs && \
    make && \
    make install && \
    make configs

# Expose necessary ports for Janus
EXPOSE 8088 8188 7088 7089 10000-10200/udp

# Start Janus server
CMD ["janus", "-F", "/usr/local/etc/janus"]
