exec openssl s_client \
  -connect "$var_ip:$var_port" \
  -verify_return_error -verify_dept 3 \
  </dev/null
