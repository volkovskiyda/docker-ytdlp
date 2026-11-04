# yt-dlp Docker image

[yt-dlp](https://github.com/yt-dlp/yt-dlp) on Alpine Linux, with [ffmpeg](https://ffmpeg.org) for merging formats and
embedding metadata, and [Deno](https://deno.com) as the JavaScript runtime yt-dlp needs for YouTube.

- Images: `ghcr.io/volkovskiyda/ytdlp` and, on Docker Hub, `volkovskiyda/ytdlp`
- Platforms: `linux/amd64`, `linux/arm64`
- Tags: `latest`, and the build date, such as `2026-10-27` (a second build on the same day is `2026-10-27.1`).
  The [release](https://github.com/volkovskiyda/docker-ytdlp/releases) for each tag names the yt-dlp version inside.
- Rebuilt automatically when yt-dlp publishes a release (checked daily).

## Pull the image

```bash
docker pull ghcr.io/volkovskiyda/ytdlp
```

## Download

The entrypoint is `yt-dlp`, so everything after the image name is passed to yt-dlp.
Mount the directory to save files to at `/downloads`:

```bash
docker run --rm -v /path/to/download/dir:/downloads ghcr.io/volkovskiyda/ytdlp 'URL'
```

To the current directory, in the background:

```bash
docker run --rm -d --name ytdlp -v "${PWD}:/downloads" ghcr.io/volkovskiyda/ytdlp 'URL'
docker logs -f ytdlp
```

`"${PWD}"` and `"${HOME}"` work in bash, zsh and PowerShell. In the Windows Command Prompt (cmd), use `"%cd%"`
instead. On Windows with PowerShell:

```powershell
docker run --rm -v "${HOME}/Downloads/YouTube:/downloads" ghcr.io/volkovskiyda/ytdlp 'URL'
```

A YouTube URL can also be given as just the video ID.

### File ownership on Linux

The container runs as root, so on Linux the downloaded files belong to root. To own them yourself, run as your user:

```bash
docker run --rm --user "$(id -u):$(id -g)" -v "${PWD}:/downloads" ghcr.io/volkovskiyda/ytdlp 'URL'
```

## Default configuration

The image ships [`yt-dlp.conf`](yt-dlp.conf) as `/etc/yt-dlp.conf`. With it, yt-dlp:

- saves to `<uploader>/<playlist>/<YYYYMMDD_HHMMSS> - <title> [<format>] [<id>].<ext>`
- prefers the highest resolution, then the video codec, then the container (`--format-sort res,vcodec,ext`)
- processes playlists in reverse order
- skips streams that are live at the moment
- embeds metadata, chapters and the thumbnail
- waits 5 to 30 seconds between downloads

To change the defaults:

- Add options to the command; they override the file.
- Put a `yt-dlp.conf` in the download directory. yt-dlp reads it from `/downloads` on top of the image's file.
- Replace the file: `-v /path/to/yt-dlp.conf:/etc/yt-dlp.conf:ro`.
- Pass `--ignore-config` to use none of these files.

## Shell in the container

```bash
docker run -it --rm --entrypoint bash -v "${PWD}:/downloads" ghcr.io/volkovskiyda/ytdlp
yt-dlp --print '%(id)s | %(upload_date>%Y.%m.%d)s %(title).80s (%(duration>%H:%M:%S)s)' 'URL'
yt-dlp --batch-file download.txt
```

Or run one command without a shell:

```bash
docker run --rm ghcr.io/volkovskiyda/ytdlp --version
docker run --rm -d -v "${PWD}:/downloads" ghcr.io/volkovskiyda/ytdlp --batch-file download.txt
```

## Build locally

```bash
docker build -t ytdlp .
docker build --build-arg YTDLP_VERSION=2026.10.26 -t ytdlp .
```

`YTDLP_VERSION` is a [yt-dlp release tag](https://github.com/yt-dlp/yt-dlp/releases) and defaults to `latest`.