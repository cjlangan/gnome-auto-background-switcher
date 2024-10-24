# Program to cycle through background photos in GNOME

# Retrieving type of images wanted
read -p "What Background type to cycle through? " user_input
search=$(echo "$user_input" | sed 's/ /%20/g')

# Retrieving time in seconds between background changes
read -p "How often should your background cycle (in seconds)? " user_input
cycle_time="$user_input"

file="background"

# Setting up directories for files.
dir="/home/$USER/.auto-bg-switcher/"
mkdir -p "$dir"
echo "Created Proper folders. See at ${dir}"

# Retrieve HTML data from Yandex Search
curl -s "https://yandex.com/images/search?text=${search}&isize=wallpaper&wp=wh16x9_1920x1080" -o "${dir}site.html"

# Check if we successfully retrieved the HTML data
if [ -z "$(sed -n '2p' ${dir}site.html)" ]; then
    echo "Failed to download site HTML. Exiting."
    exit 1
else
    echo "Downloaded site HTML."
fi

# Extract all image URL's to a single text file
grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*\.(jpg|jpeg|png)" ${dir}site.html | sort -u > ${dir}urls.txt

# Remove yastatic image, it is the last one, it is irrelevant
sed -i '$d' "${dir}urls.txt"
echo "Extracted image URL's from HTML package."
    
bg_set=false

# Loop to change background photo intermittently
while true
do
    # Loop to ensure we retrieve a valid image
    while true
    do
        # Randomise which URL to choose from
        bg_url=$(shuf -n 1 "$dir"urls.txt)

        # Attempt to download the URL
        if wget -L -q -O "$dir"temp $bg_url; then
            echo "Downloaded random image, from $bg_url"
            cp ${dir}temp ${dir}$file
            break
        else
            # if fail, remove that URL from the list and try again
            echo "Failed to download image from $bg_url. Trying another URL and removing failed one."
            line_number=$(grep -nF "$bg_url" "${dir}urls.txt" | cut -d: -f1)
            sed -i "${line_number}d" "${dir}urls.txt"
        fi
    done

    # Use swaybg to set the background image
    swaybg -i "${dir}${file}" -m fill &

    # Wait time until next change
    sleep $cycle_time
done
