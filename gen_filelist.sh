images=($(ls -v *_3s.mp4))
segments=($(ls -v longer_videos/*_part*.mp4))
popo=($(ls -v longer_videos/*_popo*.mp4))
count=0
popo_count=0
> filelist.txt

for img in "${images[@]}"; do
  echo "file '$img'" >> filelist.txt
  ((count++))

  # Insert a 10-second video segment after every 7 images
  if ((count % 2 == 0 && ${#segments[@]} > 0)); then
    echo "file '${segments[0]}'" >> filelist.txt
    segments=("${segments[@]:1}") # Remove the used segment
  fi

  # Insert a popo video after every 15 items (images + segments)
  if ((count % 5 == 0 && popo_count < ${#popo[@]})); then
    echo "file '${popo[popo_count]}'" >> filelist.txt
    ((popo_count++))
  fi
done

# Add any remaining 10-second segments
for seg in "${segments[@]}"; do
  echo "file '$seg'" >> filelist.txt
done

# Add any remaining popo videos
for p in "${popo[@]:$popo_count}"; do
  echo "file '$p'" >> filelist.txt
done
