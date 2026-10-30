FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git build-essential bc bison flex libssl-dev libelf-dev \
    libncurses-dev dwarves cpio kmod rsync \
    qemu-system-x86 qemu-utils \
    debootstrap sudo \
    vim less curl ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /work
# test commit 2 


# copy config cần thiết (kernel config fragment + scripts)
COPY release.config ./
COPY build_all_docker.sh ./
RUN chmod +x build_all_docker.sh

CMD ["/bin/bash"]
# test commit 1
# 
# 
# 
# test commit after merge 