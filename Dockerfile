FROM alpine

ADD ytdlp_update.sh /ytdlp_update.sh
ADD ytdlp_video_audio.sh /ytdlp_video_audio.sh
ADD ytdlp.sh /ytdlp.sh

RUN apk -U add bash ffmpeg yt-dlp
RUN /ytdlp_update.sh

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["/ytdlp_video_audio.sh"]
