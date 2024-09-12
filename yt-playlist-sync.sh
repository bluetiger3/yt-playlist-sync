#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <directory> <url>"
fi

# Playlist stuff
PLAYLIST_DIR=$1
PLAYLIST_URL=$2

# YouTube stuff
YT_URL="https://www.youtube.com"
WATCH_URL="$YT_URL/watch?v="

# Create an array of videos IDs from online playlist
printf  "Downloading watch IDs from YT playlist..."; sleep 1; echo " (this might take a while)"
readarray -t ONLINE < <(yt-dlp --flat-playlist --print id $PLAYLIST_URL 2> /dev/null)
declare -p ONLINE

if [ ${#ONLINE[@]} -eq 0 ]; then
  echo "No videos in YouTube playlist (or private)"
  echo "Terminating program early..."
  return 1
fi

# Create an array of video IDs from offline playlist
readarray -t OFFLINE < <(ls -1 $PLAYLIST_DIR/* | sed -E 's/.*\[([^]]+)\].*/\1/')
declare -p OFFLINE

# Remove any videos no longer in online playlist
for id in "${OFFLINE[@]}"; do
  echo "${ONLINE[@]}" | grep -q -- $id
  if [ "$?" -ne 0 ]; then
    tmp=$(find $PLAYLIST_DIR -name \*$id\*)
    echo "-$(basename "$tmp")..."
    rm "$tmp"
  fi
done
echo

# Download any new videos from online playlist
for id in "${ONLINE[@]}"; do
  echo ${OFFLINE[@]} | grep -q -- $id
  if [ "$?" -ne 0 ]; then
    echo "+${WATCH_URL}${id}"
    yt-dlp -q -f mp4 -P $PLAYLIST_DIR --playlist-random ${WATCH_URL}${id}
  fi
done
