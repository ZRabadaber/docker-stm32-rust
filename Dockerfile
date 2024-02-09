FROM ubuntu:24.04
ENV TZ=Europe/Moscow

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
  apt install -yq \
  git curl ninja-build meson openocd gdb-multiarch default-jre \
  && rm -rf /var/cache/apk/*

#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
COPY rustup-init /tmp/
RUN /tmp/rustup-init -y

RUN $HOME/.cargo/bin/cargo install cargo-binutils
RUN $HOME/.cargo/bin/rustup component add llvm-tools-preview

RUN $HOME/.cargo/bin/rustup target add thumbv6m-none-eabi
RUN $HOME/.cargo/bin/rustup target add thumbv7m-none-eabi
RUN $HOME/.cargo/bin/rustup target add thumbv7em-none-eabi
RUN $HOME/.cargo/bin/rustup target add thumbv7em-none-eabihf
RUN $HOME/.cargo/bin/rustup target add thumbv8m.base-none-eabi
RUN $HOME/.cargo/bin/rustup target add thumbv8m.main-none-eabi
RUN $HOME/.cargo/bin/rustup target add thumbv8m.main-none-eabihf
RUN $HOME/.cargo/bin/cargo install svd2rust

WORKDIR /workspace
ENV PATH=$HOME/.cargo/bin:$PATH

CMD [ "/bin/sh" ]
