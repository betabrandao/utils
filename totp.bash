#!/usr/bin/env bash
# pass otp - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2024 Roberta Brandao
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

local path="${1%/}"
local passfile="$PREFIX/$path.gpg"
local count="$(printf '%.16x' $(($(date +%s)/30)))"
check_sneaky_paths "$path"

local hexkey=$(gpg -d "${GPG_OPTS[@]}" "$passfile" | grep totp_secret | tr -d ' ' | cut -d':' -f2 | base32 -d | xxd -ps -c 128)

[[ -z "$hexkey" ]] && die "Failed to generate TOTP code: totp_secret not found. Example. totp_secret: YOURTOTPBASE32SECRET"

local hash="$(echo -n "$count" | xxd -r -p | openssl mac -digest sha1 -macopt hexkey:"$hexkey" HMAC)"
local offset="$((16#${hash:39}))"
local extracted="${hash:$((offset * 2)):8}"
local token="$(((16#$extracted & 16#7fffffff) % 1000000))"

#print otp
case "${2%/}" in
  -c|--clip) echo $token | xclip -selection c; echo 'Copied to clipboard.' ;;
  *) echo $token ;;
esac
  
