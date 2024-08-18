#!/bin/bash

# Playlist stuff (CHANGE HERE)
PLAYLIST_DIR="" # (e.g. $HOME/playlist1)
PLAYLIST_URL="" # (e.g. https://www.youtube.com/playlist?list=f6f6432e9492e9127a4586e60c7681e99")

if [ $PLAYLIST_DIR = '' || $PLAYLIST_DIR = '' ]; then
  echo "Please edit the script to include your public YouTube playlist URL and/or local directory"
  return 1
fi

# YouTube stuff
YT_URL="https://www.youtube.com"
WATCH_URL="$YT_URL/watch?v="

# Create an array of videos IDs from online playlist
readarray -t ONLINE < <(yt-dlp --skip-download --print id $PLAYLIST_URL 2> /dev/null)
declare -p ONLINE 
# echo ONLINE IS ${ONLINE[@]}

# Create an array of video IDs from offline playlist
readarray -t OFFLINE < <(ls -1 $PLAYLIST_DIR/*.mp4 | sed -E 's/.*\[([^]]+)\].*/\1/')
declare -p OFFLINE 
# echo OFFLINE IS ${OFFLINE[@]}

# Remove any videos no longer in online playlist
for id in "${OFFLINE[@]}"; do
  echo ${ONLINE[@]} | grep -q $id
  if [ "$?" -ne 0 ]; then
    tmp=$(find $PLAYLIST_DIR -name \*$id\*)
    echo "Deleting $(basename "$tmp")..."
    rm "$tmp"
  fi
done
echo

# Download any new videos from online playlist
for id in "${ONLINE[@]}"; do
  echo ${OFFLINE[@]} | grep -q $id 
  if [ "$?" -ne 0 ]; then
    echo "Downloading ${WATCH_URL}${id}"
    yt-dlp -q -f mp4 -P $PLAYLIST_DIR --playlist-random ${WATCH_URL}${id}
  fi
done
