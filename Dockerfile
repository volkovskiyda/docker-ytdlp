FROM alpine

ARG YTDLP_VERSION=latest
ARG TARGETARCH

# System config, not ~/yt-dlp.conf: it is read for any user (also with
# `docker run --user`, where /root is unreadable), and it has the lowest
# precedence, so a yt-dlp.conf in /downloads or command-line options win.
COPY yt-dlp.conf /etc/yt-dlp.conf

RUN apk -U --no-cache add bash ffmpeg ca-certificates curl deno \
    && if [ "$YTDLP_VERSION" = "latest" ]; then \
         base_url="https://github.com/yt-dlp/yt-dlp/releases/latest/download"; \
       else \
         base_url="https://github.com/yt-dlp/yt-dlp/releases/download/${YTDLP_VERSION}"; \
       fi \
    && arch="${TARGETARCH:-$(uname -m)}" \
    && case "$arch" in \
         amd64|x86_64) binary="yt-dlp_musllinux" ;; \
         arm64|aarch64) binary="yt-dlp_musllinux_aarch64" ;; \
         *) echo "No yt-dlp musllinux binary for architecture: $arch" >&2; exit 1 ;; \
       esac \
    && curl -fsSLo /usr/local/bin/yt-dlp "${base_url}/${binary}" \
    && curl -fsSLo /tmp/SHA2-256SUMS "${base_url}/SHA2-256SUMS" \
    && grep " ${binary}$" /tmp/SHA2-256SUMS | sed "s#${binary}#/usr/local/bin/yt-dlp#" | sha256sum -c - \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && rm /tmp/SHA2-256SUMS \
    && apk del curl

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["yt-dlp"]
