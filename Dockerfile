FROM alpine

ARG YTDLP_VERSION=latest
ARG TARGETARCH

ADD yt-dlp.conf /root

RUN apk -U --no-cache add bash ffmpeg ca-certificates curl deno \
    && if [ "$YTDLP_VERSION" = "latest" ]; then \
         base_url="https://github.com/yt-dlp/yt-dlp/releases/latest/download"; \
       else \
         base_url="https://github.com/yt-dlp/yt-dlp/releases/download/${YTDLP_VERSION}"; \
       fi \
    && case "$TARGETARCH" in \
         arm64) binary="yt-dlp_musllinux_aarch64" ;; \
         *) binary="yt-dlp_musllinux" ;; \
       esac \
    && curl -Lo /usr/local/bin/yt-dlp "${base_url}/${binary}" \
    && curl -Lo /tmp/SHA2-256SUMS "${base_url}/SHA2-256SUMS" \
    && grep " ${binary}$" /tmp/SHA2-256SUMS | sed "s#${binary}#/usr/local/bin/yt-dlp#" | sha256sum -c - \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && rm /tmp/SHA2-256SUMS \
    && apk del curl

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["yt-dlp"]
