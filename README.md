## yt-dlp docker image

### Based on [yt-dlp](https://github.com/yt-dlp/yt-dlp)

### **Pull image:**
```bash
docker pull ghcr.io/volkovskiyda/ytdlp
```

### **Run container:**
```bash
docker run --rm -v /path/to/download/dir:/downloads ghcr.io/volkovskiyda/ytdlp 'video-id'
```

**Mount a volume on Windows**
```bash
docker run --rm -v $pwd:/downloads ghcr.io/volkovskiyda/ytdlp 'video-id'
```
```bash
docker run --rm -v /c/Users/user:/downloads ghcr.io/volkovskiyda/ytdlp 'video-id'
```

### **Run container with bash entrypoint:**
```bash
docker run -it --rm --entrypoint bash -v /downloads:/downloads ghcr.io/volkovskiyda/ytdlp
> yt-dlp --print '%(id)s | %(upload_date>%Y.%m.%d)s %(title).80s (%(duration>%H:%M:%S)s)' 'video-id'
# or
> /ytdlp_update.sh ; /ytdlp.sh video '--batch-file download.txt'
```

### **Run container with no entrypoint:**
```bash
docker run --rm --entrypoint '' ghcr.io/volkovskiyda/ytdlp yt-dlp --version
# or
docker run --rm -d --entrypoint '' -v /downloads:/downloads ghcr.io/volkovskiyda/ytdlp /ytdlp_video_audio.sh '--batch-file download.txt'
```
