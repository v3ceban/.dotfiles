#!/bin/bash

# rclone mount "Dropbox:/" "$HOME/Cloud/Dropbox" --daemon --vfs-cache-mode full &
rclone mount "Proton:/" "$HOME/Cloud/Proton" --daemon --vfs-cache-mode full &
# rclone mount "Google Drive:/" "$HOME/Cloud/Google Drive" --daemon --vfs-cache-mode full &
