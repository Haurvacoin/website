# Haurva Protocol website

This repository contains the static site for [haurvacoin.com](https://haurvacoin.com/).

## Preview locally

From the repository root, run `python3 -m http.server 8765 --bind 127.0.0.1` and open [localhost:8765](http://127.0.0.1:8765/). The Python preview serves the pages and assets. Production redirects are handled by Apache.

## Deploy and verify

1. Copy the site files from the repository root into the production document root, including the hidden `.htaccess`. If the host already has an `.htaccess`, merge the redirect into it before any catch-all rules. Keep the repository metadata and the `scripts` directory outside the public document root.
2. Configure both hostnames to use that document root and ensure the TLS certificate covers both. The redirect uses Apache's `mod_rewrite` and requires permission to use rewrite directives in `.htaccess`.
3. Run `./scripts/check-deployment.sh` from the repository to verify both permanent redirects, canonical tags, and the crawl files against production.
4. In the verified [Google Search Console](https://search.google.com/search-console) property, submit `https://haurvacoin.com/sitemap.xml` under **Sitemaps**. Use **URL Inspection** to test the homepage and HAUSD guide and request indexing if needed.
