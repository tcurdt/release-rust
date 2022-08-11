FROM rust:1.63-alpine as builder
WORKDIR /app
RUN echo "nobody:x:65534:65534:Nobody:/:" > /passwd
RUN apk add --update --no-cache upx
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src
RUN cargo install --path .
RUN upx /usr/local/cargo/bin/release-rust

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/local/cargo/bin/release-rust /bin/
COPY --from=builder /passwd /etc/passwd
USER nobody
CMD ["/bin/release-rust"]
