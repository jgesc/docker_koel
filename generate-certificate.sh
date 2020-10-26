#!/bin/bash

if [ ! -d ./persist ]; then
	mkdir ./persist;
	mkdir ./persist/ssl;
	mkdir ./persist/ssl/private;
	mkdir ./persist/ssl/certs;
fi;

cd persist
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ssl/private/koel.key -out ssl/certs/koel.crt
