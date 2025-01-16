ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.4.0
# Target the CUDA runtime image
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}
FROM ${BASE_CUDA_DEV_CONTAINER} AS build
#ENTRYPOINT [ "bash", "-c" ]

FROM ${BASE_CUDA_RUN_CONTAINER} AS runtime
ENV CUDA_MAIN_VERSION=12.4
ENV LD_LIBRARY_PATH /usr/local/cuda-${CUDA_MAIN_VERSION}/compat:$LD_LIBRARY_PATH
WORKDIR /app

RUN apt-get update && \
  apt install -y --allow-change-held-packages curl ffmpeg cuda-libraries-12-4 libcublas-12-4 libnccl2 \
  && apt full-upgrade -y \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY --from=build /app /app

#ENTRYPOINT [ "./startserver.sh" ] \
ENTRYPOINT [ "bash", "-c" ]

CMD [ "./build/bin/whisper-server --model ./models/ggml-medium.en.bin --host '0.0.0.0' --convert" ]
