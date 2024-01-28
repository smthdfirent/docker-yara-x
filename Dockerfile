FROM rust:1.75-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    libssl-dev \
    vim

# Clone the YARA-X repository
WORKDIR /opt
RUN git clone --recursive https://github.com/VirusTotal/yara-x.git
WORKDIR /opt/yara-x

# Build and install YARA-X
RUN cargo build --release
ENV PATH="${PATH}:/opt/yara-x/target/release/"

# Clean up
RUN apt-get -y remove git libssl-dev
RUN apt-get -y autoremove
RUN rm -rf /var/cache/apt/*

# Set the working directory to /root
WORKDIR /root

# Copy the YARA rules that may be in the rules directory
COPY rules/ /root/rules/

