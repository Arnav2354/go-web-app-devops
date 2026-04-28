#Stage 1 - build the application
FROM golang:1.22.5 AS build-stage

WORKDIR /app

COPY  go.mod .

RUN go mod download

COPY . .

RUN  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Stage 2 - deploy the application

FROM gcr.io/distroless/base AS slim-stage

WORKDIR /app

COPY --from=build-stage /app/main .

COPY --from=build-stage  /app/static ./static

EXPOSE 8080

ENTRYPOINT ["./main"]