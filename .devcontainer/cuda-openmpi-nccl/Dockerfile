ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ARG OPENMPI_URL
# Compile and install openmpi from source, with CUDA support
RUN mkdir mpi && curl -fsSL "${OPENMPI_URL}" | tar -xzf - -C mpi --strip-components=1 \
    && cd mpi \
    && ./configure --with-cuda=/usr/local/cuda --prefix=/usr/local/mpi \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpi
