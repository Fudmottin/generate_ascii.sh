#!/bin/bash
# Extract arguments
video_file=$1
start_time=$2
duration=$3

# magic number used in two places
frame_rate=15

# Create temporary directory for frames 
mkdir -p tmp/ascii_frames

# Extract audio from original video file
echo "Extracting audio from video..."
ffmpeg -i "$video_file" -ss $start_time -t $duration -vn -acodec copy tmp/output.aac

# Get the video width using ffprobe.
width=$(ffprobe -v error -select_streams v:0 \
-show_entries stream=width \
-of default=noprint_wrappers=1:nokey=1 "$video_file")

# Calculate jp2a width (experiment with these numbers to get optimal results)
jp2a_width=$(( $width / 2 ))

# Calculate convert pointsize (experiment with these numbers to get optimal results)
pointsize=$(( $jp2a_width / 10 ))  

# Clamp minimum point size to 8
if (( $pointsize < 8 )); then
    pointsize=8
fi

echo "Extracting frames from video..."
ffmpeg -ss $start_time \
-i $video_file \
-t $duration \
-vf fps=$frame_rate tmp/ascii_frames/frame%04d.jpg

echo "Converting frames to ASCII..."
for file in tmp/ascii_frames/*.jpg; do 
  jp2a --width=$jp2a_width \
      --red=0.4 \
      --green=0.6 \
      --blue=0.4 \
      --background=light \
      "$file" --output="${file%.jpg}.txt"
done

echo "Converting ASCII frames back into images..."
frame_counter=1  
total_files=$(ls tmp/ascii_frames/*.txt | wc -l)
for file in tmp/ascii_frames/*.txt; do 
  echo -ne "\rProcessing frame $frame_counter/$total_files"
  frame_counter=$((frame_counter+1))
  convert -gravity Center -font Menlo-Regular \
    -pointsize $pointsize label:@$file "${file%.txt}.png"
done

echo "\nCompiling new image frames back into a video..."
ffmpeg -framerate $frame_rate \
-i tmp/ascii_frames/frame%04d.png output.mp4 

# Add audio to the ASCII video
echo "Adding audio to ASCII video..."
ffmpeg -i output.mp4 \
-i tmp/output.aac \
-map 0:v:0 -map 1:a:0 \
-c:v copy -c:a copy final_output.mp4

# Delete temporary directory & files when done 
echo "Cleaning up temporary files..."
rm -rf tmp/ascii_frames/
rm tmp/output.aac
rmdir tmp

echo "ASCII art video has been generated: final_output.mp4"

