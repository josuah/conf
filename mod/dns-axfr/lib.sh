export tsig="$(adm-db "$db/dns-var" get pass | tr -d '\n' | openssl base64 -e)"
