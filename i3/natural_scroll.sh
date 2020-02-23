# Get id of touchpad device
touchpad_id=`xinput list | grep TouchPad | awk '{print $6}' | cut -d "=" -f 2`

# Get id of properties from device $touchpad_id
natural_scrolling_id=`xinput --list-props $touchpad_id | grep "Natural Scrolling" | awk '{print $5}'| cut -d "(" -f 2 | cut -d ")" -f 1 | head -1`
tapping_enabled_id=`xinput --list-props $touchpad_id | grep "Tapping Enabled" | awk '{print $4}'| cut -d "(" -f 2 | cut -d ")" -f 1 | head -1`

# Enable desired properties
xinput set-prop $touchpad_id $natural_scrolling_id 1
xinput set-prop $touchpad_id $tapping_enabled_id 1
