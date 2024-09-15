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

## Installation

1. Download this repo, or clone it:

```bash
git clone https://github.com/cjlangan/gnome-auto-background-switcher.git
```

2. Navigate into the downloaded directory and run the installer script


```bash
cd gnome-auto-background-switcher
chmod +x install.sh
./install.sh
```

3. Run the program with `autobg`

You will be prompted for the type of photos you want.
Then you will be asked how often you want your background to switch.
That's it!

## Uninstallation

Navigate to the project directory and run:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Then feel free to remove the entire project directory

### How it Works
- Retrieves HTML data from a Yandex image search
- Creates a directory at ~/.auto-bg-switcher/
- Extracts image URL's from the acquired HTML data
- Randomly download an image from the URL list, clearing any previous image if they exist
- Sets the downloaded image to the GNOME background
