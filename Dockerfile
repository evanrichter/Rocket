# Build Stage
FROM rustlang/rust:nightly as builder

## Install build dependencies.
RUN cargo install -f cargo-fuzz

## Add source code to the build stage.
ADD . /src
WORKDIR /src
RUN cargo build
RUN cd core/lib/fuzz && cargo fuzz build

# Package Stage
FROM rustlang/rust:nightly

COPY --from=builder src/core/lib/fuzz/target/x86_64-unknown-linux-gnu/release/uri-parsing /
COPY --from=builder src/core/lib/fuzz/target/x86_64-unknown-linux-gnu/release/uri-roundtrip /
COPY --from=builder src/core/lib/fuzz/corpus/uri-parsing/ /corpus
