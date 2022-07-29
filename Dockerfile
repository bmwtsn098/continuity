FROM golang:1.18 as builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl
    
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.46.2

ADD . /continuity
WORKDIR /continuity

RUN make

# Package Stage
FROM debian:bookworm-slim
COPY --from=builder /continuity/bin/continuity /