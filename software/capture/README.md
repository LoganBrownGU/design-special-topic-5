# Requirements
- `gphoto2`
- `gphotofs`
- `ffmpeg`
- ImageMagick 

# Usage
```bash 
./capture.sh [options] 
```

## Options
- `-n <no. images>`: Number of images to capture. 
- `-o <output path>`: Directory to output to. When used with `--reprocess`, the directory to reprocess.
- `-s`: Show the difference between comparison and reference images. May take some time, depending on resolution and number of images. 
- `-c`: Remove all of today's data. 
- `-y`: With `-c`: Do not prompt for confirmation before deleting. 
- `-b`: Use camera's burst functionality. Default burst period of 1 second. 
- `-b=<burst period>`: Specify burst period. 
- `-m`: Produce videos using `ffmpeg` from images captured. May take some time, depending on resolution and number of images. 
- `-f <fuzz value>`: Fuzz value passed to ImageMagick as a percentage. A lower value make difference more sensitive. 
- `--reprocess`: Take a set of images already captured and perform the post-processing. Useful if you previously captured images with the `--no-compare` or without the `-m` options. 
- `--no-compare`: Do not perform image comparison. Useful if taking large numbers of high-resolutions images.


