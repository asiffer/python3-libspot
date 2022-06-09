# Dockerfile to build the debian package
FROM debian:11

RUN apt update -y && apt install -y build-essential debhelper 