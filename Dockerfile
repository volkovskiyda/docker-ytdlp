FROM alpine

ARG YTDLP_VERSION=latest

ADD yt-dlp.conf /root

RUN apk -U --no-cache add bash ffmpeg ca-certificates curl deno \
    && if [ "$YTDLP_VERSION" = "latest" ]; then \
         base_url="https://github.com/yt-dlp/yt-dlp/releases/latest/download"; \
       else \
         base_url="https://github.com/yt-dlp/yt-dlp/releases/download/${YTDLP_VERSION}"; \
       fi \
    && curl -Lo /usr/local/bin/yt-dlp "${base_url}/yt-dlp_musllinux" \
    && curl -Lo /tmp/SHA2-256SUMS "${base_url}/SHA2-256SUMS" \
    && grep " yt-dlp_musllinux$" /tmp/SHA2-256SUMS | sed 's#yt-dlp_musllinux#/usr/local/bin/yt-dlp#' | sha256sum -c - \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && rm /tmp/SHA2-256SUMS \
    && apk del curl

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["yt-dlp"]
