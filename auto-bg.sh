read -p "What Background type to cycle through (no spaces)? " user_input
search=$user_input

dir="/home/$USER/Pictures/auto-backgrounds/"
mkdir -p "$dir" && mkdir -p "$dir".config
rm -f "$dir"*
echo "Created Proper folders. See at ${dir}"

curl https://yandex.com/images/search?text=${search}%20wallpaper -s -o ${dir}site.html

if [ -z "$(sed -n '5p' ${dir}site.html)" ]; then
    echo "Failed to download site HTML. Exiting."
    exit 1
fi

grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*\.(jpg|jpeg|png)" ${dir}site.html | sort -u > ${dir}.config/urls.txt
echo "Extracted image URL's from HTML package."

while true
do
    rm -f "$dir"*

    while true
    do
        bg_url=$(shuf -n 1 "$dir".config/urls.txt)

        if wget -L -q -P "$dir" $bg_url; then
            echo "Download random image using $bg_url"
            break
        else
            echo "Failed to download image from $bg_url. Trying another URL."
        fi
    done

    img=$(ls "$dir")

    gsettings set org.gnome.desktop.background picture-uri-dark "file://${dir}${img}"
    echo "Set background image to ${dir}${img}"

    sleep 5
done
