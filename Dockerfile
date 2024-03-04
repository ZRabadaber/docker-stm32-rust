FROM ubuntu:24.04

ENV TZ=Europe/Moscow

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -yq \
  git wget curl build-essential git cmake ninja-build meson openocd gdb-multiarch default-jre

ARG jlink=JLink_Linux_V794k_x86_64.deb
COPY ${jlink} /tmp/
RUN apt-get install -yq /tmp/${jlink}; exit 0
RUN rm /tmp/${jlink}

RUN apt-get clean \
  && rm -rf /var/cache/apk/*

ENV CARGO_HOME=/usr/local/cargo
ENV RUSTUP_HOME=/usr/local/rustup

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH=$CARGO_HOME/bin:$RUSTUP_HOME/bin:$PATH

RUN cargo install cargo-binutils \
  && rustup component add llvm-tools-preview \
  && rustup component add rust-analyzer \
  && rustup component add rust-src \
  && rustup target add thumbv6m-none-eabi \
  && rustup target add thumbv7m-none-eabi \
  && rustup target add thumbv7em-none-eabi \
  && rustup target add thumbv7em-none-eabihf \
  && rustup target add thumbv8m.base-none-eabi \
  && rustup target add thumbv8m.main-none-eabi \
  && rustup target add thumbv8m.main-none-eabihf \
  && cargo install svd2rust

RUN chmod -R a+rw $RUSTUP_HOME $CARGO_HOME;

USER ubuntu
WORKDIR /workspace

CMD [ "/bin/bash" ]
