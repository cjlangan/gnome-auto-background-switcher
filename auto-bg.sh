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
curl -s "https://yandex.com/images/search?text=${search}%20wallpaper&iorient=horizontal&isize=large" -o "${dir}site.html"

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
    
# Clear the directory as to not build up a ton of images
rm -f "$dir"*

# Set the download file name
file="background"
bg_set=false

# Loop to change background photo intermittently
while true
do
    # Loop to ensure we retrieve a valid image
    while true
    do
        # Randomise which URL to choose from
        bg_url=$(shuf -n 1 "$dir".config/urls.txt)

        # Attempt to download the URL
        if wget -L -q -O "$dir"temp $bg_url; then
            echo "Downloaded random image, from $bg_url"
            cp ${dir}temp ${dir}$file
            break
        else
            # if fail, remove that URL from the list and try again
            echo "Failed to download image from $bg_url. Trying another URL and removing failed one."
            line_number=$(grep -nF "$bg_url" "$dir.config/urls.txt" | cut -d: -f1)
            sed -i "${line_number}d" "$dir.config/urls.txt"
        fi
    done

    # Use GNOME settings to set the background image
    if [ "$bg_set" = false ]; then
        gsettings set org.gnome.desktop.background picture-uri "file://${dir}${file}"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://${dir}${file}"
        echo "Set background image to ${dir}${file}"
        bg_set=true
    fi

    # Wait time until next change
    sleep $cycle_time
done
