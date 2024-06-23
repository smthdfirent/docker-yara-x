ARG yarax_version="v0.4.0"
ARG install_dir="/opt/tools"
ARG username="user"

FROM rust:1.79-slim
ARG yarax_version
ARG install_dir
ARG username

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    libssl-dev \
    vim \
    python3 \
    python3-pip \
    python3-venv \
    pipx

# Add a user and switch to user
RUN useradd --create-home ${username}

# Create the installation directory and switch to ${username}
RUN mkdir ${install_dir}
RUN chown ${username}:${username} ${install_dir}
USER ${username}
WORKDIR ${install_dir}

# Clone the YARA-X repository
RUN git clone --recursive https://github.com/VirusTotal/yara-x.git
WORKDIR ${install_dir}/yara-x
RUN git checkout tags/${yarax_version}

# Build and install YARA-X
RUN cargo build --release
ENV PATH="${PATH}:/${install_dir}/yara-x/target/release/"

# Build Python YARA-X bindings
RUN pipx install maturin
ENV PATH="${PATH}:/home/${username}/.local/bin"
RUN maturin build --manifest-path py/Cargo.toml

# Create a virtualenv and install the yara_x package
WORKDIR /home/${username}/
RUN python3 -m venv venv
RUN . venv/bin/activate && pip install ${install_dir}/yara-x/target/wheels/yara_x*

# Copy the YARA rules that may be in the rules directory
USER root
COPY rules/ /home/${username}/rules/
RUN chown -R ${username}:${username} /home/${username}/rules/

# Cleanup
USER root
RUN apt-get -y remove git libssl-dev
RUN apt-get -y autoremove
RUN rm -rf /var/cache/apt/*

# Switch to ${username}
USER ${username}
WORKDIR /home/${username}/

