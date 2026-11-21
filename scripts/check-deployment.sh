#!/bin/sh
set -eu

origin=https://haurvacoin.com
www=https://www.haurvacoin.com
guide=/how-hausd-works.html
query='?utm_source=deployment-check%20www'
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT

failures=0

check_response() {
    url=$1
    expected=$2
    if actual=$(curl -sS --max-time 15 -o "$scratch/body" -w '%{http_code} %{redirect_url}' "$url") &&
        [ "$actual" = "$expected" ]; then
        printf 'PASS %s\n' "$url"
        return 0
    fi
    printf 'FAIL %s (expected %s, got %s)\n' "$url" "$expected" "${actual:-no response}" >&2
    failures=1
    return 1
}

check_body() {
    if ! grep -Fq "$1" "$scratch/body"; then
        printf 'FAIL %s (expected content: %s)\n' "$2" "$1" >&2
        failures=1
    fi
}

check_response "$www/" "301 $origin/" || :
check_response "$www$guide$query" "301 $origin$guide$query" || :

if check_response "$origin/" '200 '; then
    check_body "<link rel=\"canonical\" href=\"$origin/\">" "$origin/"
fi
if check_response "$origin$guide" '200 '; then
    check_body "<link rel=\"canonical\" href=\"$origin$guide\">" "$origin$guide"
fi
if check_response "$origin/robots.txt" '200 '; then
    check_body "Sitemap: $origin/sitemap.xml" "$origin/robots.txt"
fi
if check_response "$origin/sitemap.xml" '200 '; then
    check_body "<loc>$origin/</loc>" "$origin/sitemap.xml"
    check_body "<loc>$origin$guide</loc>" "$origin/sitemap.xml"
fi

exit "$failures"
