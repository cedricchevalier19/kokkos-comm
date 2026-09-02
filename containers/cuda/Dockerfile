ARG CUDA_VERSION=12.9.0
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu24.04 AS base
LABEL authors="cedricchevalier19"
ENV DEBIAN_FRONTEND=noninteractive
ARG KOKKOS_VERSION=5.2.0

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

ENV CUDA_ROOT=/usr/local/cuda
ENV PATH=${CUDA_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_ROOT}/lib64:${PATH}

FROM base AS kokkos
ENV Kokkos_ROOT=/usr/local/kokkos
# Download and install Kokkos \
RUN URL="$(curl -s "https://api.github.com/repos/kokkos/kokkos/releases/tags/${KOKKOS_VERSION}" | jq -r '.tarball_url')" \
      && mkdir kokkos && curl -fsSL "$URL" | tar -xzf - -C kokkos --strip-components=1 \
      && cd kokkos \
    && cmake -B build -D CMAKE_BUILD_TYPE=Release -DKokkos_ENABLE_CUDA=ON -D Kokkos_ARCH_HOPPER90=ON -DKokkos_ENABLE_OPENMP=ON -DKokkos_ENABLE_SERIAL=ON -D CMAKE_INSTALL_PREFIX=${Kokkos_ROOT} \
    && cmake --build build -j$(nproc) \
    && cmake --install build \
    && cd .. \
    && rm -rf kokkos

FROM kokkos AS mpi
ENV MPI_ROOT=/usr/local/mpi
ENV PATH=${MPI_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${MPI_ROOT}/lib64:${PATH}

FROM mpi as openmpi 
ARG OPENMPI_URL=https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.8.tar.gz
# Compile and install openmpi from source, with CUDA support
RUN mkdir mpi && curl -fsSL "${OPENMPI_URL}" | tar -xzf - -C mpi --strip-components=1 \
    && cd mpi \
    && ./configure --with-cuda=${CUDA_ROOT} --prefix=${MPI_ROOT} \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpi

FROM mpi AS mpich
ARG MPICH_URL=https://www.mpich.org/static/downloads/5.0.0/mpich-5.0.0.tar.gz
# Compile and install openmpi from source, with CUDA support
RUN mkdir mpi && curl -fsSL "${MPICH_URL}" | tar -xzf - -C mpi --strip-components=1 \
    && cd mpi \
    && ./configure --with-cuda=${CUDA_ROOT} --prefix=${MPI_ROOT} --disable-fortran \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpi
