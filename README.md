Protocol Benchmarking
============

I disabled the Google Docs reporting as it requires OAuth and no longer supports id/pwd 

These scripts provide an easy way to benchmark different protocols, over different network conditions, while reporting the results to a folder in Google Drive.

The current focus in these scripts is to compare Google's QUIC (http://en.wikipedia.org/wiki/QUIC) with regular HTTP and HTTPS.


Getting Started
=============
You'll need two Linux machines for these tests, and the Google QUIC demo client and server binaries (quic_client and quic_server).  One machine will run the tests, and  will act as the client, while the other machine will act as the server.  For testing different network conditions, you will also need a router running OpenWrt and the WAN emulation packages available here: https://github.com/Connectify/openwrt-netem

Compiling the QUIC Demo Client and Server
=============
Excellent instructions are available here: https://www.chromium.org/quic and 
https://github.com/google/proto-quic 


Setting up the Server
=============

Generate the certs using generate-certs.sh from the certs folder. This generates certs for www.example.org 
Install the cert in both client and server machine using

```
certutil -d sql:/home/osboxes/.pki/nssdb -A -t "C,," -n test -i 2048-sha256-root.pem

certutil -d sql:/home/osboxes/.pki/nssdb -A -t "P,," -n test -i 2048-sha256-root.pem
```

It is assumed that the server will run nginx on port 80 (and 443, if you care to test HTTPS).  Any web server will do, but the file scripts/mk-quic-data.sh will generate some random files, and will download files referenced in the benchmarking in the Chromium source, and currently places them where nginx ought to be looking for them by default.

Add www.example.org and example.org to point to the server in /etc/hosts 

Start the quic server like so,
```
./quic_server --certificate_file=/home/osboxes/Desktop/certs/out/leaf_cert.pem --key_file=/home/osboxes/Desktop/certs/out/leaf_cert.pkcs8 --quic_response_cache_dir=/tmp/quic-data
```
You can check everything works: 
```
./quic_client --host='server' --port=6121 https://www.example.org/test/file-10M.dat
```
Running the tests
==============
A few system environment variables are used by the test.

- GDOCS_USER is a valid Google Docs user
- GDOCS_PW is that user's password
- NETEM_USER is the user for the OpenWrt router (typically root)
- NETEM_PW is the OpenWrt user's password
- NETEM_IP is the IP address of the OpenWrt router
- QUIC_SERVER_IP is the IP address of the QUIC server

Once those environment variables are set, the tests can be run with the following command:
```
python quic_tests.py Test.test_QUIC_vs_HTTP
```
