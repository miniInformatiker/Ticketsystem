# Stage 1: Build
FROM rust:1.72-alpine as builder

# Install necessary build dependencies
RUN apk add --no-cache musl-dev openssl-dev

# Add the musl target for ARM architecture
RUN rustup target add aarch64-unknown-linux-musl

# Set the working directory
WORKDIR /app

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml Cargo.lock ./

# This build step will cache the dependencies
RUN cargo fetch

# Copy the source code
COPY . .

# Build the project with musl target in release mode for ARM architecture
RUN cargo build --release --target aarch64-unknown-linux-musl

# Stage 2: Runtime
FROM alpine:latest

# Install necessary runtime dependencies
RUN apk add --no-cache ca-certificates

# Set the working directory
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/aarch64-unknown-linux-musl/release/my_actix_project .

# Expose the port the service runs on
EXPOSE 8080

# Command to run the binary
CMD ["./my_actix_project"]
