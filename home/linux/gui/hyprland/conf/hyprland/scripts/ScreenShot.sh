# #!/bin/bash
# # /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# # Screenshots scripts
#
# iDIR="$HOME/.config/swaync/icons"
# sDIR="$HOME/.config/hypr/scripts"
# notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"
#
# time=$(date "+%d-%b_%H-%M-%S")
# dir="$(xdg-user-dir)/Pictures/Screenshots"
# file="Screenshot_${time}_${RANDOM}.png"
#
# active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
# active_window_file="Screenshot_${time}_${active_window_class}.png"
# active_window_path="${dir}/${active_window_file}"
#
# # notify and view screenshot
# notify_view() {
#     if [[ "$1" == "active" ]]; then
#         if [[ -e "${active_window_path}" ]]; then
#             ${notify_cmd_shot} "Screenshot of '${active_window_class}' Saved."
#             "${sDIR}/Sounds.sh" --screenshot
#         else
#             ${notify_cmd_shot} "Screenshot of '${active_window_class}' not Saved"
#             "${sDIR}/Sounds.sh" --error
#         fi
#     elif [[ "$1" == "swappy" ]]; then
# 		${notify_cmd_shot} "Screenshot Captured."
#     else
#         local check_file="$dir/$file"
#         if [[ -e "$check_file" ]]; then
#             ${notify_cmd_shot} "Screenshot Saved."
#             "${sDIR}/Sounds.sh" --screenshot
#         else
#             ${notify_cmd_shot} "Screenshot NOT Saved."
#             "${sDIR}/Sounds.sh" --error
#         fi
#     fi
# }
#
#
#
# # countdown
# countdown() {
# 	for sec in $(seq $1 -1 1); do
# 		notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR"/timer.png "Taking shot in : $sec"
# 		sleep 1
# 	done
# }
#
# # take shots
# shotnow() {
# 	cd ${dir} && grim - | tee "$file" | wl-copy
# 	sleep 2
# 	notify_view
# }
#
# shot5() {
# 	countdown '5'
# 	sleep 1 && cd ${dir} && grim - | tee "$file" | wl-copy
# 	sleep 1
# 	notify_view
#
# }
#
# shot10() {
# 	countdown '10'
# 	sleep 1 && cd ${dir} && grim - | tee "$file" | wl-copy
# 	notify_view
# }
#
# shotwin() {
# 	w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
# 	w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
# 	cd ${dir} && grim -g "$w_pos $w_size" - | tee "$file" | wl-copy
# 	notify_view
# }
#
# shotarea() {
# 	tmpfile=$(mktemp)
# 	grim -g "$(slurp)" - >"$tmpfile"
# 	if [[ -s "$tmpfile" ]]; then
# 		wl-copy <"$tmpfile"
# 		mv "$tmpfile" "$dir/$file"
# 	fi
# 	notify_view
# }
#
# shotactive() {
#     active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
#     active_window_file="Screenshot_${time}_${active_window_class}.png"
#     active_window_path="${dir}/${active_window_file}"
#
#     hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${active_window_path}"
# 	sleep 1
#     notify_view "active"
# }
#
# shotswappy() {
# 	tmpfile=$(mktemp)
# 	grim -g "$(slurp)" - >"$tmpfile" && "${sDIR}/Sounds.sh" --screenshot && notify_view "swappy"
# 	swappy -f - <"$tmpfile"
# 	rm "$tmpfile"
# }
#
#
# if [[ ! -d "$dir" ]]; then
# 	mkdir -p "$dir"
# fi
#
# if [[ "$1" == "--now" ]]; then
# 	shotnow
# elif [[ "$1" == "--in5" ]]; then
# 	shot5
# elif [[ "$1" == "--in10" ]]; then
# 	shot10
# elif [[ "$1" == "--win" ]]; then
# 	shotwin
# elif [[ "$1" == "--area" ]]; then
# 	shotarea
# elif [[ "$1" == "--active" ]]; then
# 	shotactive
# elif [[ "$1" == "--swappy" ]]; then
# 	shotswappy
# else
# 	echo -e "Available Options : --now --in5 --in10 --win --area --active --swappy"
# fi
#
# exit 0

#!/bin/bash
# Screenshot script for Hyprland using grim and slurp
# Maintained by 💫 https://github.com/JaKooLit 💫

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir)/Pictures/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"
full_path="${dir}/${file}"

# Ensure screenshot directory exists
mkdir -p "$dir"

# Function: Notify and handle sound
notify_view() {
    local msg=$1
    local success=$2
    if [[ "$success" -eq 1 ]]; then
        ${notify_cmd_shot} "$msg"
        "${sDIR}/Sounds.sh" --screenshot
    else
        ${notify_cmd_shot} "Screenshot NOT saved: $msg"
        "${sDIR}/Sounds.sh" --error
    fi
}

# Function: Take screenshot with grim
take_shot() {
    local geometry=$1
    local output_path=$2
    grim -g "$geometry" - | tee "$output_path" | wl-copy
    if [[ -e "$output_path" ]]; then
        notify_view "Screenshot saved: $(basename "$output_path")" 1
    else
        notify_view "Failed to save screenshot" 0
    fi
}

# Function: Countdown timer
countdown() {
    local seconds=$1
    for sec in $(seq "$seconds" -1 1); do
        notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR/timer.png" "Taking shot in: $sec"
        sleep 1
    done
}

# Function: Capture active window
capture_active_window() {
    local geometry
    geometry=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    take_shot "$geometry" "$full_path"
}

# Function: Capture selected area
capture_area() {
    local geometry
    geometry=$(slurp)
    if [[ -n "$geometry" ]]; then
        take_shot "$geometry" "$full_path"
    else
        notify_view "No area selected" 0
    fi
}

# Function: Capture with swappy
capture_with_swappy() {
    local tmpfile
    tmpfile=$(mktemp)
    grim -g "$(slurp)" - >"$tmpfile" && wl-copy <"$tmpfile"
    if [[ -s "$tmpfile" ]]; then
        swappy -f "$tmpfile"
        mv "$tmpfile" "$full_path"
        notify_view "Screenshot edited and saved" 1
    else
        notify_view "Failed to capture screenshot" 0
    fi
    rm -f "$tmpfile"
}

# Screenshot options
case "$1" in
--now)
    take_shot "" "$full_path"
    ;;
--in5)
    countdown 5
    take_shot "" "$full_path"
    ;;
--in10)
    countdown 10
    take_shot "" "$full_path"
    ;;
--win)
    capture_active_window
    ;;
--area)
    capture_area
    ;;
--active)
    capture_active_window
    ;;
--swappy)
    capture_with_swappy
    ;;
*)
    echo -e "Available Options: --now --in5 --in10 --win --area --active --swappy"
    ;;
esac

exit 0
