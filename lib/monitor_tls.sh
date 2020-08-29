exec openssl s_client \
  -connect "$var_ip:$var_port" \
  -verify_return_error -verify_depth 3 \
  </dev/null
