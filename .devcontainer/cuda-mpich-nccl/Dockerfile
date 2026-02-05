FROM nvidia/cuda:12.9.0-devel-ubuntu24.04
LABEL authors="cedricchevalier19"
ENV DEBIAN_FRONTEND=noninteractive
ENV MPICH_URL=https://www.mpich.org/static/downloads/5.0.0/mpich-5.0.0.tar.gz
ENV KOKKOS_VERSION=5.0.2

# Install dependencies and kitware repository for latest cmake
RUN apt-get update && apt-get install -y --no-install-recommends \
            apt-transport-https \
            gnupg \
            software-properties-common \
            curl \
            && curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc  2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
            && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/kitware.list \
            && apt-get update && apt-get install -y --no-install-recommends kitware-archive-keyring \
            && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    ca-certificates \
    libnuma-dev \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Compile and install openmpi from source, with CUDA support
RUN mkdir openmpi && curl -fsSL ${MPICH_URL} | tar -xzf - -C mpich --strip-components=1 \
    && cd mpich \
    && ./configure --with-cuda=/usr/local/cuda --prefix=/usr/local/mpich \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpich

# Download and install Kokkos \
RUN URL="$(curl -s "https://api.github.com/repos/kokkos/kokkos/releases/tags/${KOKKOS_VERSION}" | jq -r '.tarball_url')" \
      && mkdir kokkos && curl -fsSL "$URL" | tar -xzf - -C kokkos --strip-components=1 \
      && cd kokkos \
    && cmake -B build -D CMAKE_BUILD_TYPE=Release -DKokkos_ENABLE_CUDA=ON -D Kokkos_ARCH_HOPPER90=ON -D CMAKE_INSTALL_PREFIX=/usr/local/kokkos \
    && cmake --build build -j$(nproc) \
    && cmake --install build \
    && cd .. \
    && rm -rf kokkos
