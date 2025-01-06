FROM alpine

ADD yt-dlp.conf /home

RUN apk -U add bash yt-dlp

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["yt-dlp"]
