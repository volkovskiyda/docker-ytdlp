#!/bin/bash
args="$@"

/ytdlp_update.sh > /dev/null 2>&1

/ytdlp.sh video $args
/ytdlp.sh audio --extract-audio $args
