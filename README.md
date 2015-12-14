### Zoneminder

#### Install On unRaid:

On unRaid, install from the Community Repositories and enter the app folder location and the port for the webUI.


#### Install On Other Platforms (like Ubuntu or Synology 5.2 DSM, etc.):

On other platforms, you can run this docker with the following command:

```
docker run -d --name="Zoneminder" --privileged=true -v /path/to/config:/config:rw -v /etc/localtime:/etc/localtime:ro -p 80:80 aptalca/docker-zoneminder
```

#### Tips and Setup Instructions:
- This container includes mysql, no need for a separate mysql/mariadb container
- All settings and library files are stored outside of the container and they are preserved when this docker is updated or re-installed (change the variable "/path/to/config" in the run command to a location of your choice)
- This container includes avconv (ffmpeg variant) and cambozola but they need to be enabled in the settings. In the WebUI, click on Options in the top right corner and go to the Images tab
- Click on the box next to OPT_Cambozola to enable
- Click on the box next OPT_FFMPEG to enable ffmpeg
- Enter the following for ffmpeg path: /usr/bin/avconv
- Enter the following for ffmpeg "output" options: -r 30 -vcodec libx264 -threads 2 -b 2000k -minrate 800k -maxrate 5000k (you can change these options to your liking)
- Next to ffmpeg_formats, add mp4 (you can also add a star after mp4 and remove the star after avi to make mp4 the default format)
- Hit save
- Now you should be able to add your cams and record in mp4 x264 format
- PS. In options under display, change the skin to "flat" it looks 100 times nicer

#### Changelog:  
- 2015-10-27 - perl5/ZoneMinder folder is now persistent and available in the config folder to allow easy access for custom perl scripts - usbutils included in the package for usb camera support (needs to be further tested)  

