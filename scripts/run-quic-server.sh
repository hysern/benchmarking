#!/bin/sh

cd /home/osboxes/Desktop/Default
#quic_server --port=6121 --quic_in_memory_cache_dir=. &> /dev/null
./quic_server --certificate_file=/home/osboxes/Desktop/certs/out/leaf_cert.pem --key_file=/home/osboxes/Desktop/certs/out/leaf_cert.pkcs8 --quic_response_cache_dir=/var/www/html/test
