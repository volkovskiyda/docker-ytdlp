#!/bin/bash
args="$@"

/ytdlp_update.sh

/ytdlp.sh video $args
/ytdlp.sh audio --extract-audio $args
