#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# Get current directory name
dir_name=$(basename "$cwd")

# Get git branch if in a git repo (skip optional locks for performance)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$git_branch" ]; then
    # Check if there are uncommitted changes
    if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
      ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
      git_status="*"
    else
      git_status=""
    fi
    git_info=" on $(printf '\033[35m')${git_branch}${git_status}$(printf '\033[0m')"
  fi
fi

# Build status line with colors (dimmed in terminal)
printf "$(printf '\033[36m')%s$(printf '\033[0m') | $(printf '\033[32m')%s$(printf '\033[0m')%s" \
  "$model" \
  "$dir_name" \
  "$git_info"

# Add output style if not default
if [ "$output_style" != "default" ] && [ "$output_style" != "null" ]; then
  printf " [$(printf '\033[33m')%s$(printf '\033[0m')]" "$output_style"
fi
