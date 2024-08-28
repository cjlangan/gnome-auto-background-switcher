# GNOME Auto Background Switcher

## A script to automically cycle your desktop background to different images all centered around a specified theme

### Dependencies
- curl
- wget
- shuf
- gsettings, should have if you are using gnome.

## DISCLAIMER
- if the script fails, it is likely because you have ran it too much in a short period of time

**Solution:** Either wait, or connect to a VPN then run the script

## Use
Simply download the `auto-bg.sh` file and run:
```bash
sudo chmod +x auto-bg.sh
./auto-bg.sh
```

You will be prompted for the type of photos you want.
Then you will be asked how often you want your background to switch.
That's it!

### How it Works
- Retrieves HTML data from a Yandex image search
- Creates a directory at ~/.auto-bg-switcher/
- Extracts image URL's from the acquired HTML data
- Randomly download an image from the URL list, clearing any previous image if they exist
- Sets the downloaded image to the GNOME background
