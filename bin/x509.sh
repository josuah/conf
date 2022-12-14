#!/bin/sh -eu
# simple openssl(1) based certificate authority

conf="

[req]
default_bits			= 4096
default_md			= sha256
distinguished_name		= distinguished_name

[distinguished_name]
commonName			= CN, CommonName

[ca]
default_ca			= ca_default

[ca_default]
default_md			= sha256
default_days			= 65535
default_crl_days		= 1
new_certs_dir			= /etc/ssl/ca/${2:-}/issued
database			= /etc/ssl/ca/${2:-}/index.txt
crl_dir				= /etc/ssl/ca/${2:-}/crl
serial				= /etc/ssl/ca/${2:-}/serial
private_key			= /etc/ssl/ca/${2:-}/private/ca.key
certificate			= /etc/ssl/ca/${2:-}/ca.crt
crlnumber			= /etc/ssl/ca/${2:-}/crlnumber
crl				= /etc/ssl/ca/${2:-}/ca.crl
policy				= ca_policy

[ca_policy]
countryName			= optional
stateOrProvinceName		= optional
localityName			= optional
organizationName		= optional
organizationalUnitName		= optional
commonName			= supplied
emailAddress			= optional

[ext_ca]
basicConstraints		= critical,CA:true,pathlen:1
keyUsage			= digitalSignature,keyCertSign,cRLSign

[ext_fqdn]
keyUsage			= digitalSignature,keyCertSign,cRLSign
nsCertType			= server,client
extendedKeyUsage		= serverAuth,clientAuth

" # end

case " $* " in
(" ca "*" create ") ca=$2
	mkdir -p "/etc/ssl/ca/$ca/issued"
	cd "/etc/ssl/ca/$ca"
	mkdir -m 700 private 
	touch index.txt
	echo 0000 >serial
	echo 0000 >crlnumber
	echo "$conf" | openssl req -config /dev/stdin -extensions ext_ca -x509 \
	 -newkey rsa:4096 -nodes -keyout private/ca.key -subj "/CN=$ca" >ca.crt
	;;
(" ca "*" delete ") ca=$2
	rm -r "/etc/ssl/ca/$ca/"
	;;
(" ca "*" sign "*" ") ca=$2 file=$4
	[ -f "$file" ] || file=/etc/ssl/$file.csr
	echo "$conf" | openssl ca -config /dev/stdin -extensions ext_fqdn -batch \
	 -in "$file" >${file%csr}crt
	cat "/etc/ssl/ca/$ca/ca.crt" >>"${file%csr}crt"
	echo "${file%csr}crt"
	;;
(" ca "*" revoke "*" ") ca=$2 file=$4
	[ -f "$file" ] || file=/etc/ssl/$file.crt
	mkdir -p "/etc/ssl/ca/$ca/crl"
	hash=$(openssl x509 -noout -fingerprint <$file | sed 's/.*=//; s/://g')
	echo "$conf" | openssl ca -config /dev/stdin -gencrl -batch \
	 -in "${file%crt}csr" -out "/etc/ssl/ca/$ca/crl/$hash.crl"
	echo "/etc/ssl/ca/$ca/crl/$hash.crl"
	echo "$conf" | openssl ca -config /dev/stdin -batch -revoke "$file"
	echo "certificate $file revoked"
	;;
(" csr "*" ") cn=$2
	mkdir -p /etc/ssl/private
	cd /etc/ssl
	chmod 500 private
	echo "$conf" | openssl req -config /dev/stdin -extensions ext_fqdn \
	 -newkey rsa:4096 -nodes \
	 -keyout "private/$cn.key" -out "$cn.csr" -subj "/CN=$cn"
	;;
(" dhparam ")
	if [ ! -f "dhparam.pem" ]; then
		openssl dhparam -out /etc/ssl/dhparam.pem 2048
	fi
	;;
(*)
	echo>&2	"usage:	${0##*/} ca <name> create"
	echo>&2	"	${0##*/} ca <name> delete"
	echo>&2	"	${0##*/} ca <name> sign <csr>"
	echo>&2	"	${0##*/} ca <name> revoke <crt>"
	echo>&2	"	${0##*/} csr <name>"
	echo>&2	"	${0##*/} dhparam"
	;;
esac
