# base
FROM node:18-bullseye

# set the github runner version
ARG RUNNER_VERSION="2.298.2"

ENV DEBIAN_FRONTEND=noninteractive

# add a non-sudo user
RUN useradd -m docker

# update then install dependencies, then clean cache
RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends curl jq zstd build-essential \
	&& rm -rf /var/lib/apt/lists/*

RUN corepack enable
RUN pnpm

# create a working directory, that docker user owns, we cant use /home/docker as will be mounted
RUN mkdir -p /runner/home/actions-runner && \
	chown -R docker:docker /runner

# cd into the user directory, download and unzip the github actions runner
RUN cd /runner/home/actions-runner \
	&& curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
	&& tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
# RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/home/docker/.cargo/bin:${PATH}"

# Get wasm dependencies
RUN rustup target add wasm32-unknown-unknown
RUN cargo install wasm-pack

# set the entrypoint to the start.sh script
ENTRYPOINT ["/bin/bash", "./start.sh"]
