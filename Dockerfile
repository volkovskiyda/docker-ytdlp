FROM alpine

ADD yt-dlp.conf /root

RUN apk -U add bash yt-dlp

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["yt-dlp"]
