#!/bin/sh
while true; do
  workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
  if [ "$workspace" -eq "6" ]; then
    # Run the command here
	motion
  else
    #statements
	motion
  fi
  sleep 1
done
