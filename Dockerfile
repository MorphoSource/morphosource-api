# Builds the static API docs site and packages it as a small image whose only
# job is to carry the files at /site, for copying onto the nginx-public volume.
# The site has no build-time settings, so one image serves dev and production.
#
#   docker build -t morphosource-api-docs .

FROM alpine:3 AS builder
WORKDIR /src
COPY . .
RUN sh scripts/build-docs.sh /site

# coreutils provides `mv -T`, needed to swap the `current` symlink atomically.
FROM alpine:3
RUN apk add --no-cache coreutils
COPY --from=builder /site /site
COPY deploy/publish-site.sh /usr/local/bin/publish-site
RUN chmod +x /usr/local/bin/publish-site
