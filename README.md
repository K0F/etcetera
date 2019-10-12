# etcetera

## context

This software was presented as a part of project called _Resteless Image_ in Etc. gallery Prague in May 2019. Software is an interactive gallery kiosk / video player. It was build with [Processing](http://processing.org) and utilizes [MPV](https://mpv.io/) video player. It gets curatorial informations about the content from Google Spreadsheet and links it together with delivered offline video files. The result is fullscreen study kiosk which can be operated with mouse only (no keyboard required).

## instalation

For full instalation (64-bit operation system) please download full distribution [image](http://localhost) (to be released) and copy image onto hard drive / flash drive using ```dd``` command (MacOs / Linux).

```
dd if=etcetera.img of=/dev/targetdrive bs=1M
```

You should be able to boot directly from live USB stick / HDD. If not, please check your BIOS / UEFI boot manager settings on target computer.

If target system is connected to the internet it will try to download recent master git branch on each system start (alongside with current version of Google Spreadsheet). To edit location of repository please fork this repository and edit ```run.sh``` script with your modified mirror location.

More documentation will be available after first OS/image release.
