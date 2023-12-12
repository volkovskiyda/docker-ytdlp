FROM python:3

ADD ytdlp_update.sh /ytdlp_update.sh
ADD ytdlp_video_audio.sh /ytdlp_video_audio.sh
ADD ytdlp.sh /ytdlp.sh

RUN apt -y update && \
    apt install -y ffmpeg bash python3 python3-pip && \
    apt clean all
RUN /ytdlp_update.sh

RUN mkdir /downloads
WORKDIR /downloads
VOLUME /downloads

ENTRYPOINT ["/ytdlp_video_audio.sh"]
