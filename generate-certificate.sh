cd persist
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ssl/private/koel.key -out ssl/certs/koel.crt
