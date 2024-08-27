# GNOME Auto Background Switcher

## A script to automically cycle your desktop background to different images all centered around a specified them

### Dependencies
- curl
- wget
- shuf
- gsettings, should have if you are using gnome.

## Use
```bash
./auto-bg.sh
```

You will be prompted for the type of photos you want.
Then you will be asked how often you want your background to switch.
That's it!

### How it Works
- Retrieves HTML data from a Yandex image search
- Creates the directory structure in ~/Pictures/auto-backgrounds
- Extracts image URL's from the acquired HTML data
- Randomly download an image from the URL list, clearing any previous image if they exist
- Sets the downloaded image to the GNOME background
