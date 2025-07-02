#!/bin/bash

MOUNT_POINT="$HOME/Documents/Private"
MAPPER_NAME="secure_container"

mount_container() {
  echo -n "Enter container password: "
  read -s PASSWORD
  echo
  if [ -z "$PASSWORD" ]; then
    exit 1
  fi
  echo "$PASSWORD" | sudo cryptsetup open "$MOUNT_POINT/container.img" "$MAPPER_NAME" || {
    exit 1
  }
  sudo mount "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT"
  unset PASSWORD
}

unmount_container() {
  sudo umount "$MOUNT_POINT"
  sudo cryptsetup close "$MAPPER_NAME"
}

if mountpoint -q "$MOUNT_POINT"; then
  unmount_container
else
  mount_container
fi
