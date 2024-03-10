#!/bin/bash
count="$(printf '%.16x' $(($(date +%s)/30)))"
hexkey="$(echo -n "$1" | base32 -d | xxd -p)"
hash="$(echo -n "$count" | xxd -r -p | openssl mac -digest sha1 -macopt hexkey:"$hexkey" HMAC)"
offset="$((16#${hash:39}))"
extracted="${hash:$((offset * 2)):8}"
echo "$(((16#$extracted & 16#7fffffff) % 1000000))"
