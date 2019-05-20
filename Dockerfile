FROM golang:1.12.5-alpine3.9 as builder

ENV GO111MODULE=on

RUN apk update --no-cache && \
  apk add git

WORKDIR /app

ADD ./ /app

RUN go build -o golang-test .

FROM alpine:3.9.4

WORKDIR /app

RUN addgroup -g 2000 golang && \
  adduser -D -u 2000 -G golang golang
USER golang

COPY --from=builder /app/golang-test .

CMD ["/app/golang-test"]

EXPOSE 8000
