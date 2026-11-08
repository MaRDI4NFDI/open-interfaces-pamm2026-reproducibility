FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libffi-dev \
    python3 \
    python3-pip \
    python3-venv

# Set up Python (version 3.12).
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    python3 -m pip install numpy==2.2 scipy==1.15 msgpack==1.2 jax matplotlib

# Set up Julia for the target platform.
ARG TARGETARCH
RUN case "$TARGETARCH" in \
      amd64) julia_arch=x86_64; julia_platform=x64 ;; \
      arm64) julia_arch=aarch64; julia_platform=aarch64 ;; \
      *) echo "Unsupported target architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac && \
    julia_tarball="julia-1.11.9-linux-${julia_arch}.tar.gz" && \
    curl -fLO "https://julialang-s3.julialang.org/bin/linux/${julia_platform}/1.11/${julia_tarball}" && \
    tar xzf "$julia_tarball" -C /opt && \
    ln -sv /opt/julia-1.11.9/bin/julia /usr/local/bin/

# Get Open Interfaces
RUN curl -LO https://github.com/MaRDI4NFDI/open-interfaces/archive/refs/tags/v0.7.1.tar.gz && \
    tar xzf v0.7.1.tar.gz

WORKDIR /open-interfaces-0.7.1

RUN julia --project=. -e 'using Pkg; Pkg.instantiate()'

RUN . /venv/bin/activate && make release

WORKDIR /app

# Set up environment
RUN echo "source /venv/bin/activate" >> /etc/bash.bashrc \
 && echo "source /open-interfaces-0.7.1/env.sh" >> /etc/bash.bashrc \
 && echo 'export PYTHONPATH=/app/src/mlpexample:$PYTHONPATH' >> /etc/bash.bashrc \
