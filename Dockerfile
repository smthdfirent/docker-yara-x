ARG yarax_version="v0.6.0"
ARG install_dir="/opt/tools"
ARG username="user"
ARG run_jupyter="true"

FROM rust:1.80-slim
ARG yarax_version
ARG install_dir
ARG username
ARG run_jupyter

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    libssl-dev \
    vim \
    python3 \
    python3-pip \
    python3-venv \
    pipx

# Add a user
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
ENV VIRTUAL_ENV=/home/${username}/venv
RUN python3 -m venv venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
RUN . venv/bin/activate && pip install ${install_dir}/yara-x/target/wheels/yara_x* && pip install jupyter

# Copy the YARA rules and the notebooks
USER root
COPY --chown=${username} rules/ /home/${username}/rules/
COPY --chown=${username} notebooks/ /home/${username}/notebooks/

# Clean up
USER root
RUN apt-get -y remove git libssl-dev
RUN apt-get -y autoremove
RUN rm -rf /var/cache/apt/*

# Switch to ${username} and create startup scripts
USER ${username}
WORKDIR /home/${username}/
RUN mkdir scripts/
ENV PATH="$PATH:/home/${username}/scripts"
RUN echo "#!/bin/bash\nexec jupyter notebook --ip=0.0.0.0 --port=8080 --no-browser" > scripts/start-notebook.sh
RUN chmod +x scripts/start-notebook.sh
RUN if test "${run_jupyter}" = "true"; then echo "#!/bin/bash\nstart-notebook.sh" > scripts/start.sh; else echo "#!/bin/bash\n/bin/bash" > scripts/start.sh; fi
RUN chmod +x scripts/start.sh
CMD [ "start.sh" ]

