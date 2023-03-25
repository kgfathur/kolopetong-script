#!/bin/bash

host_target="$1"
endpoint="http://${host_target}"
while true
do
  echo -n "$(date +'%F %T.%3N') | ${endpoint} | "
  curl -s ${host_target} -w ", con_t: %{time_connect}, total_t: %{time_total}, RC: %{http_code}" | tr -d '\n'
  echo ""
#  if [[ "${stat}" == 0 ]]; then
#    echo ""
#  else
#    echo "DOWN"
#  fi
  sleep 1
done