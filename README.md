# docker_koel
Docker image for [koel](https://github.com/phanan/koel)
 
# Introduction
Koel is a web-based open source personal audio streaming service.
This repository provides the tools to deploy a koel server with HTTPS support inside Docker containers.
Requires docker-compose.

# Installation
1. Run `build-all.sh` to build the images.
2. Run `create-certificate.sh` to generate a self-signed certificate. Alternatively, you can use your own certificate.
3. Run `run.sh` and wait for MySQL to initialize.
4. Run `init.sh` to initialize koel. Use the default value (/music) when asked for the music repository.

# Notes
* Music is stored in `./persist/music`.

# TO-DO
* Clean up
