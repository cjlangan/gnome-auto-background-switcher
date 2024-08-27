# Program to cycle through background photos in GNOME

# Retrieving type of images wanted
read -p "What Background type to cycle through? " user_input
search=$(echo "$user_input" | sed 's/ /%20/g')

# Retrieving time in seconds between background changes
read -p "How often should your background cycle (in seconds)? " user_input
cycle_time="$user_input"

# Setting up directories for files.
dir="/home/$USER/Pictures/auto-backgrounds/"
mkdir -p "$dir" && mkdir -p "$dir".config
rm -f "$dir"*
echo "Created Proper folders. See at ${dir}"

# Retrieve HTML data from Yandex Search
curl https://yandex.com/images/search?text=${search}%20wallpaper -s -o ${dir}site.html

# Check if we successfully retrieved the HTML data
if [ -z "$(sed -n '2p' ${dir}site.html)" ]; then
    echo "Failed to download site HTML. Exiting."
    exit 1
else
    echo "Downloaded site HTML."
fi

# Extract all image URL's to a single text file
grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*\.(jpg|jpeg|png)" ${dir}site.html | sort -u > ${dir}.config/urls.txt
echo "Extracted image URL's from HTML package."

# Loop to change background photo intermittently
while true
do
    # Clear the directory as to not build up a ton of images
    rm -f "$dir"*

    # Loop to ensure we retrieve a valid image
    while true
    do
        # Randomise which URL to choose from
        bg_url=$(shuf -n 1 "$dir".config/urls.txt)

        # Attempt to download the URL
        if wget -L -q -P "$dir" $bg_url; then
            echo "Downloaded random image, from $bg_url"
            break
        else
            # if fail, remove that URL from the list and try again
            echo "Failed to download image from $bg_url. Trying another URL."
            sed -i '1d' "$dir".config/urls.txt
        fi
    done

    img=$(ls "$dir")

    # Use GNOME settings to set the background image
    gsettings set org.gnome.desktop.background picture-uri-dark "file://${dir}${img}"
    echo "Set background image to ${dir}${img}"

    # Wait time until next change
    sleep $cycle_time
done
