FROM rust:latest

ARG TARGET

RUN rustup target add $TARGET

COPY . /usr/src/hashtree
WORKDIR /usr/src/hashtree

RUN cargo build --release --target $TARGET

RUN cargo test --target $TARGET