# etcetera

This is custom software of gallery kiosk for browsing and playing multiple video files. It is content independent. To add your content please copy ```video.mp4``` into ```videos/``` directory along with ```video.txt``` file for text display alongside (optional).

## instalation

For full instalation please download full distribution [image](http://localhost) (dead link, not released yet) and copy onto disk / flash drive using ```dd``` command (MacOs / Linux).

```
dd if=etcetera.img of=/dev/targetdrive bs=1M
```
You should be able to boot directly from that drive / USB stick, if not, check BIOS / UEFI boot manager on the computer.

If target system is connected to internet it will download recent version upon system start. To edit location of repository please fork this repository and edit ```run.sh``` script with your modified mirror location.
