#!/bin/bash

cat /etc/hosts | while read -r ip name; do
    [[ -z "$ip" || "$ip" =~ ^# || "$ip" =~ : ]] && continue
    [[ "$name" == "localhost" || "$ip" == "127.0.0.1" ]] && continue

    if [ -n "$name" ]; then
        real_ip=$(nslookup "$name" 8.8.8.8 2>/dev/null | awk '/^Address: / { print $2 }' | tail -n1)

        if [ -n "$real_ip" ] && [ "$real_ip" != "$ip" ]; then
            echo "Bogus IP for $name in /etc/hosts!"
        fi
    fi
done

