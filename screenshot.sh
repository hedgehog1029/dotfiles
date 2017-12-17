#!/bin/zsh

# === Sparkler options ===
# Screenshot file type extension (png, jpg)
ext="png"

# URL for uploading
upload_url="https://mixtape.moe/upload.php"

# Folder to save screenshots to by default
save_folder="/home/henry/pictures/screenshots/"

# Name of multipart key to POST file as
file_key="files[]"

# Path of JSON response's URL / ID / whatever.
json_path=".files[0].url"

# Any prefix or suffix to append to the result extracted from JSON. You can leave these blank if your service responds with a full URL.
prelude=""
url_suffix=""

# === End of options ===

function notify {
    notify-send -t 4000 -a sparkler "$1" "$2"
}

function upload {
    local curl_response=$(curl -s -F "$file_key=@/tmp/shot.$ext" "$1")

    if [[ $curl_response = '' ]]; then
        notify "Image upload failed."
        return 1
    fi

    local image_id=$(echo "$curl_response" | jq -r "$json_path")
    echo -n "$prelude$image_id$url_suffix" | xsel -b
    notify "Image uploaded" "$image_id"
}

function save {
    local timestamp=$(date +%d%m%y-%H%M%S)
    local filename="$save_folder/shot-$timestamp.$ext"

    local result=$(zenity --file-selection --save --filename=$filename)

    if [[ $result = '' ]]; then
        notify "Image save cancelled."
        return 1
    fi

    cp "/tmp/shot.$ext" "$result"
    notify "Image saved" $(basename "$result")
}

maim -us "/tmp/shot.$ext"

if [[ $? = '1' ]]; then
    notify "Image capture cancelled."
    exit 1
fi

local choice=$(echo -e "upload\nsave" | dmenu -l 2 -p "action")

if [[ $choice = 'save' ]]; then
    save
elif [[ $choice = 'upload' ]]; then
    upload $upload_url
fi

rm "/tmp/shot.$ext"
