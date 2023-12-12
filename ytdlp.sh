#!/bin/bash
chapter_folder=$1
shift 1
args="$@"

out_path="%(channel)s/%(playlist|)s/%(upload_date)s. %(title).64s [%(id)s]"
ext=".%(ext)s"
yt-dlp -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4 \
 -o "$out_path$ext" \
 -o "chapter:$chapter_folder/$out_path/%(section_number).3d. %(section_title).32s$ext" \
 --add-chapters --keep-video --split-chapters \
 --match-filter "!is_live & !live" \
 --min-sleep-interval 5 --max-sleep-interval 30 \
 --exec "rm %(requested_formats.:.filepath)#q" \
 $args
