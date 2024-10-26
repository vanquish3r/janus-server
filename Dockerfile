# Use a base Ubuntu image
FROM ubuntu:20.04

# Set environment variables to prevent timezone prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update packages and install necessary dependencies without man pages
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    libgmodule-2.0-0 \
    libgthread-2.0-0 \
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

# Check if packages were installed successfully
RUN echo "Packages installed successfully"

# Clone Janus GitHub repository
RUN git clone https://github.com/meetecho/janus-gateway.git /janus || { echo "Cloning failed"; exit 1; }

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
