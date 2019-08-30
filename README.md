# Guide to Install UT2003 on Ubuntu

This guide assumes that you wish to install the game to `~/Games/ut2003`. Modify your commands appropriately if you are installing it elsewhere.

## Copy the Files from the Installation CDs
```
mkdir ~/Games/ut2003

sudo mount -o loop CDx.iso /mount/cdrom
sudo cp -R /mount/cdrom/* ~/Games/ut2003/
```
Repeat this for all the CDs, then fix the permissions:
```
sudo chown --recursive $USER:$USER ~/Games/ut2003
find ~/Games/ut2003 -type d -print0 | xargs -0 chmod 0775
find ~/Games/ut2003 -type f -print0 | xargs -0 chmod 0664
```

## Run Update Script

You will need the UT2003 Patch 2225.3 for Linux (`ut2003_2225beta3-multilanguage.update.run`) for this.

This update script will update UT2003 and install the launcher and the `ucc` tool required for decompressing the installation CD's acrhives.
```
chmod +x ut2003_2225beta3-multilanguage.update.run
linux32 ./ut2003_2225beta3-multilanguage.update.run --target /home/yourUsername/Games/ut2003/
```
Make sure you use an absolute path!

## Put in Your CD Key

Put your CD key in a file
```
echo XXXXX-XXXXX-XXXXX-XXXX >> ~/Games/ut2003/System/cdkey
```

## Decompress .uz2 files

You need to decompress .uz2 files using `ucc`
```
cd ~/Games/ut2003/System; for i in ../**/*.uz2 ; do ./ucc-bin decompress $i ; done
```

## Attempt to Run the Game

```
cd ~/Games/ut2003/System && ./ut2003-bin
```
# Fixing Errors
## libstdc++.so.5

If you get errors like
```
./ut2003-bin: error while loading shared libraries: libstdc++.so.5: cannot open shared object file: No such file or directory
```
you need to install the 32-bit version of package `libstdc++5`

If you use a 32-bit system (not tested):
```
sudo apt-get install libstdc++5
```

or for a 64-bit system:
```
sudo apt-get install libstdc++5:i386
```

## Configure Render Device

If you get errors like
```
Can't find file for package 'WinDrv'
```
In `~/.ut2003/System/UT2003.ini` and `~/.ut2003/System/User.ini` replace
```
RenderDevice=D3DDrv.D3DRenderDevice
;RenderDevice=Engine.NullRenderDevice
;RenderDevice=OpenGLDrv.OpenGLRenderDevice
```
with
```
;RenderDevice=D3DDrv.D3DRenderDevice
;RenderDevice=Engine.NullRenderDevice
RenderDevice=OpenGLDrv.OpenGLRenderDevice
```
and
```
ViewportManager=WinDrv.WindowsClient
;ViewportManager=SDLDrv.SDLClient
```
with
```
;ViewportManager=WinDrv.WindowsClient
ViewportManager=SDLDrv.SDLClient
```

## Bad/No Sound

If you get errors like
```
open /dev/[sound/]dsp: No such file or directory
```
Run the game with `padsp`:
```
padsp ./ut2003-bin
```

## ERROR: ld.so: when using padsp

If you are using 64-bit system, you might still get no sound. The startup may show the following error when using padsp:
```
ERROR: ld.so: object '/usr/lib/x86_64-linux-gnu/pulseaudio/libpulsedsp.so' from LD_PRELOAD cannot be preloaded (wrong ELF class: ELFCLASS64): ignored.
```
To solve this, install the 32-bit version if not already installed:
```
sudo apt-get install libpulsedsp:i386
```
Then, copy the `padsp` script (you can find it using `which padsp`) to a local (or global) file on your PATH called `padsp32`, and edit the lines that set the LD_PRELOAD variable to point to the 32-bit version of the library. These should be near the bottom of the file. You should replace:
```
if [ x"$LD_PRELOAD" = x ] ; then
   LD_PRELOAD="/usr/lib/x86_64-linux-gnu/pulseaudio/libpulsedsp.so"
else
   LD_PRELOAD="$LD_PRELOAD /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsedsp.so"
fi
```
with
```
if [ x"$LD_PRELOAD" eq x ] ; then
  LD_PRELOAD="/usr/lib/i386-linux-gnu/pulseaudio/libpulsedsp.so"
else
  LD_PRELOAD="$LD_PRELOAD /usr/lib/i386-linux-gnu/pulseaudio/libpulsedsp.so"
fi
```

Now run the game with `padsp32`:
```
padsp32 ./ut2003-bin
```

# Configuration

UT2003 creates `~/.ut2003` directory to store your per-user config.
