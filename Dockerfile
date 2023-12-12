FROM alpine

ADD ytdlp_update.sh /ytdlp_update.sh
ADD ytdlp_video_audio.sh /ytdlp_video_audio.sh
ADD ytdlp.sh /ytdlp.sh

RUN apk add curl
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp
RUN apk del curl

RUN apk add bash ffmpeg python3
RUN /ytdlp_update.sh

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["/ytdlp_video_audio.sh"]
