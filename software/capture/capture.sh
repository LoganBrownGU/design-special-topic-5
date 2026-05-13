#!/usr/bin/env bash 

unmount_camera() {
	echo "unmounting..."
	fusermount -u /media/logan/canon/

}

mount_camera() {
	echo "mounting..."
	gphotofs /media/logan/canon/ 

}

capture_image() {
	path="$1"

	unmount_camera
	mount_camera
	echo "removing old images..."
	rm /media/logan/canon/store_00010001/DCIM/100EOSR5/*.JPG
	rm ./*.JPG
	unmount_camera

	echo "capturing..."
	gphoto2 --set-config output=Off --trigger-capture --wait-event=300ms

	sleep 0.5
	mount_camera
	echo "saving..."
	mv /media/logan/canon/store_00010001/DCIM/100EOSR5/*.JPG .
	img_path="$(ls *.JPG)"
	mv "$img_path" "$path"

	unmount_camera
}

if (( $# > 0 )) ; then 
	echo "saving original..."
	
	capture_image "original.jpg"

	exit 0 
fi 


capture_image "compare.jpg"

rm -f diff.png

echo "comparing images..."
compare -fuzz 20% original.jpg compare.jpg diff.png
shotwell diff.png
