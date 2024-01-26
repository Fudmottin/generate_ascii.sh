# Generate ASCII Animated Video Clip: `generate_ascii.sh`

This script extracts a video clip and converts it into an ASCII animated video clip.

## Usage

Call the script like so:

```
./generate_ascii.sh movie.mov HH:MM:SS SS
```

Where:
- `movie.mov` is the file to extract a clip from and convert to ASCII.
- `HH:MM:SS` is the time offset into the file from the beginning.
- `SS` is the duration in seconds.

## Dependencies

This script requires these dependencies:

- jp2a
- ImageMagick
- ffmpeg

### Installing Dependencies

**On MacOS**, you can install these using HomeBrew package manager with these commands:
```bash
brew install jp2a imagemagick ffmpeg
```

**On Linux**, Apt or RPM packages should be available. For example, on Ubuntu you can use:

```bash
sudo apt-get update && sudo apt-get install jp2a imagemagick ffmpeg
```
