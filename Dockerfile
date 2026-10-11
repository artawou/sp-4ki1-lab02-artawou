FROM rust:1.79 AS build
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends musl-tools \
    && rm -rf /var/lib/apt/lists/*
RUN rustup target add x86_64-unknown-linux-musl

COPY Cargo.toml Cargo.lock ./
RUN mkdir src \
    && printf 'fn main() {}\n' > src/main.rs \
    && cargo build --release --target x86_64-unknown-linux-musl \
    && rm -rf src

COPY src ./src
RUN cargo build --locked --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=build /app/target/x86_64-unknown-linux-musl/release/vtfk-sid /vtfk-sid
ENTRYPOINT ["/vtfk-sid"]
