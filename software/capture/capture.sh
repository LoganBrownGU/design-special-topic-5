#!/usr/bin/env bash 

mountpoint="/media/$(whoami)/canon/"
canon_path="$mountpoint/store_00010001/DCIM/100EOSR5/"

unmount_camera() {
	echo "unmounting..."

	if (( $# != 1 )) ; then 
		fusermount -u /media/logan/canon/
	else
		fusermount -u /media/logan/canon/ 2> /dev/null
	fi

}

mount_camera() {
	echo "mounting..."
	gphotofs /media/logan/canon/ 

}

capture_image() {
	path="$1"


	unmount_camera -
	mount_camera
	echo "removing old images..."
	rm -f $canon_path/*.JPG
	rm -f ./*.JPG
	sleep 1
	unmount_camera

	echo "capturing..."
	gphoto2 --set-config output=Off --trigger-capture --wait-event=300ms

	sleep 0.5
	mount_camera
	echo "saving..."
	mv $canon_path/*.JPG .
	img_path="$(ls *.JPG)"
	mv "$img_path" "$path"

	unmount_camera
}

capture_image_bulk() {
	unmount_camera -
	mount_camera
	echo "removing old images..."
	rm -f $canon_path/*.JPG
	rm -f ./*.JPG
	sleep 1
	unmount_camera

	echo "capturing..."

	for i in $@ ; do 
		echo $i
		gphoto2 --set-config output=Off --trigger-capture --wait-event=300ms
	done

	sleep 0.5
	mount_camera
	echo "saving..."
	mv $canon_path/*.JPG .
	img_paths=(*.JPG)
	for i in ${!img_paths[*]} ; do 
		arg_index=$(( i + 1))
		echo "${img_paths[i]} -> ${!arg_index}"
		mv ${img_paths[i]} ${!arg_index}
	done

	unmount_camera
}

n_images="1"
output_path="./$(date --iso-8601=s)"
show_diff="true"
clean="false"
yes="false"

while (( $# > 0 )) ; do 
	case $1 in 
		-n)
			n_images="$2"
			shift ; shift
			;;
		-o) 
			output_path="$2"
			shift ; shift
			;;
		-s) 
			show_diff="$2"
			shift ; shift
			;;
		-c) 
			clean="true";
			shift 
			;; 
		-y) 
			yes="true"
			shift
			;;
		-*) 
			echo "unrecognised argument: $1" > /dev/stderr
			exit -1
			;;
	esac
done
output_path=$(realpath $output_path)


if [[ $clean == "true" ]] ; then 
	choice="Y"

	if [[ $yes != "true" ]] ; then 
		echo "remove all of today's runs? [Y/n]"
		read choice
		if [[ $choice == "Y" || $choice == "y" || $choice == "" ]] ; then
			echo "removing..."
		else
			echo "not removing"
			exit 0 
		fi
	fi
	rm -r ./$(date --iso-8601=date)* 
	exit 0 
fi



if [[ $output_path != *"/home/"* ]] ; then 
	echo "Trying to write outside home directory, exiting for safety."
	exit -1
fi

mkdir -p $output_path
rm -rf $output_path/*


capture_image "$output_path/reference.jpg"


cd $output_path
capture_image_bulk $(for i in $( seq 0 $(( $n_images - 1)) ) ; do echo -ne "compare$i.jpg " ; done)

echo "comparing images..."

for i in $(seq 0 $(( $n_images - 1)) ) ; do 
	compare -fuzz 20% reference.jpg "compare$i.jpg" "diff$i.png"
	if [[ $show_diff == "true" ]] ; then 
		shotwell "diff$i.png" 
	fi
done
