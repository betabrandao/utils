#!/usr/bin/env python3

import base64
import json
import sys


def read_tokens(filename):
    data = json.load(open(filename))
    
    for token in data["tokens"]:    
        token_secret = base64.b32encode(
            bytes(x & 0xff for x in token["secret"])
        ).decode("utf8")

        name = token.get("issuerAlt") or \
                token.get("issuerExt") or \
                token.get("issuerInt")

        issuer = token.get("label") or token.get("labelAlt")
        obj = {
            "name": name,
            "issuer": issuer,
            "algorithm": token["algo"],
            "secret": token_secret,
            "digits": token["digits"],
            "type": token["type"],
            "period": None,
            "counter": None
        }

        if token["type"] == "TOTP":
            obj.update({
                "period": token["period"],
                "type": "totp"
            })
        elif token["type"] == "HOTP":
            obj.update({
                "counter": token["counter"],
                "type": "hotp"
            })
        yield obj



def main():
    if sys.version_info.major < 3:
        print("This script requires Python 3.", file=sys.stderr)
        sys.exit(1)

    if len(sys.argv) != 2:
        print("Usage: ",sys.argv[0]," <filename>", file=sys.stderr)
        sys.exit(1)

    # Dump the tokens
    data = { "accounts": list(read_tokens(sys.argv[1]))}
    
    output = json.dumps(
        data,
        indent=2,
        separators=(',', ': ')
    )

    print(output)


if __name__ == "__main__":
    main()

