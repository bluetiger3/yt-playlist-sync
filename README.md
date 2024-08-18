# yt-playlist-sync
Sync a YouTube playlist to a local directory with yt-dlp.

## Getting started
### Dependencies
Install `yt-dlp`
#### Arch Linux
```
pacman -S yt-dlp
```
### Common usage
Run this command to sync once.
```
./yt-sync-playlist.sh $HOME/Videos/playlist1 https://www.youtube.com/playlist?list=JF34jfJKS2opp_ANzG
```
Or run the command as a cronjob every hour.
```
(crontab -l && echo "0 * * * * ./yt-sync-playlist.sh $HOME/Videos/playlist1 https://www.youtube.com/playlist?list=JF34jfJKS2opp_ANzG") | crontab -
```
## Authors
* **Spit** - [spitmirror](https://github.com/spitmirror)

## Acknowledgments
This project has been inspired by
* n/a
