#!/usr/bin/env bash 

MOUNTPOINT="/media/$(whoami)/canon/"
CANON_PATH="$MOUNTPOINT/store_00010001/DCIM/101EOSR5/"
UNPROCESSED_VID="unprocessed.mkv"
DIFF_VID="diff.mkv"
MONTAGE_FILE="montage.jpg"

unmount_camera() {
	echo "unmounting..."

	if (( $# != 1 )) ; then 
		fusermount -u $MOUNTPOINT 
	else
		fusermount -u $MOUNTPOINT 2> /dev/null
	fi

}

mount_camera() {
	echo "mounting..."
	gphotofs $MOUNTPOINT

}

prepare_for_capture() {
	unmount_camera -
	mount_camera
	echo "removing old images..."
	rm -f $CANON_PATH/*.JPG
	rm -f ./*.JPG
	sleep 1
	unmount_camera

}

capture_image() {
	path="$1"
	
	prepare_for_capture
	echo "capturing..."
	gphoto2 --set-config output=Off --trigger-capture --wait-event=300ms > /dev/null

	sleep 0.5
	mount_camera
	echo "saving..."
	mv $CANON_PATH/*.JPG .
	img_path="$(ls *.JPG)"
	mv "$img_path" "$path"

	unmount_camera
}

capture_image_bulk() {

	prepare_for_capture
	echo "capturing..."
	for i in $@ ; do 
		echo $i
		gphoto2 --set-config output=Off --trigger-capture --wait-event=300ms > /dev/null
	done

	sleep 0.5
	mount_camera
	echo "saving..."
	mv $CANON_PATH/*.JPG .
	img_paths=(*.JPG)
	for i in ${!img_paths[*]} ; do 
		arg_index=$(( i + 1))
		echo "${img_paths[i]} -> ${!arg_index}"
		mv ${img_paths[i]} ${!arg_index}
	done

	unmount_camera
}

capture_image_burst() {

	prepare_for_capture
	echo "capturing..."
	gphoto2 --set-config eosremoterelease=4
	sleep "$1"
	gphoto2 --set-config eosremoterelease=7

	sleep $( echo "3.0 * $1 + 3.0" | bc )
	mount_camera
	echo "saving..."
	mv $CANON_PATH/*.JPG .
	img_paths=(*.JPG)
	for i in ${!img_paths[*]} ; do 
		mv "${img_paths[i]}" "compare$i.jpg"
	done
	
	unmount_camera
}

capture_images() {
    rm -rf $output_path/*
    
    echo "capturing reference image..."
    capture_image "$output_path/reference.jpg"
    
    read -n 1 -s -r -p "press any key to start capturing comparison images: "
    echo
    
    cd $output_path
    if [[ "$burst" == "true" ]] ; then
    	capture_image_burst "$burst_for"
    else
    	capture_image_bulk $(for i in $( seq 0 $(( $n_images - 1)) ) ; do echo -ne "compare$i.jpg " ; done)
    fi
    cd - > /dev/null
}

clean() {
    choice="Y"

	if [[ $1 != "true" ]] ; then 
		echo "remove all of today's runs? [Y/n]"
		read choice
		if [[ $choice == "Y" || $choice == "y" || $choice == "" ]] ; then
			echo "removing..."
		else
			echo "not removing"
			exit 0 
		fi
	fi
	rm -r ./$(date "+%F")* 
}

do_comparisons() {
	pids=()
	nproc=$(nproc)
	comparison_imgs=($output_path/compare*.jpg)
	echo $comparison_imgs
	n_comparisons="${#comparison_imgs[*]}"
	batch_no="1"
	n_batches=$(( n_comparisons / nproc ))
	for i in ${!comparison_imgs[*]} ; do
		compare -fuzz "$fuzz" $output_path/reference.jpg "$output_path/compare$i.jpg" "$output_path/diff$i.jpg" &
		pids+=($!)

		echo -ne "comparing $n_comparisons images ($(( (100 * batch_no) / n_batches ))%)\r"
		
		if (( ${#pids[*]} > $nproc )) ; then 
			(( batch_no++ ))
			for pid in $pids ; do 
				wait $pid
			done
			pids=()
		fi
	done
	echo -e "comparing $n_comparisons images ($(( (100 * batch_no) / n_batches ))%)"
	for pid in $pids ; do 
		wait $pid
	done

	if (( n_comparisons <= 36 )) ; then
		width=$(exiftool "$output_path/diff0.jpg" | grep -E "^Image Width" | tr -d "Image Width.*: ")
		tiling=$(echo "sqrt($n_comparisons) / 1" | bc)
		montage -tile "${tiling}x" -geometry "$width"x+20+20 -background "#000000" $output_path/diff*.jpg "$output_path/$MONTAGE_FILE"
	else
		echo "too many comparisons, not generating montage."
	fi
}

n_images="1"
output_path="./$(date "+%F__%H-%M-%S")"
show_diff="true"
clean="false"
yes="false"
burst="false"
burst_for="1"
produce_video="false"
fuzz="30%"
reprocess="false"
compare="true"

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
		-b) 
			burst="true"
			shift
			;;
		-b=*)
			burst="true"
			burst_for=$(echo "$1" | tr -d '\-b=')
			shift 
			;;
		-m) 
			produce_video="true" 
			shift 
			;;
		-f) 
			fuzz="$2%"
			shift ; shift
			;;
		--reprocess) 
			reprocess="true"
			shift
			;;
		--no-compare)
			compare="false"
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
    clean $yes
    exit 0
fi

if [[ ! -d $output_path && "$reprocess" == "true" ]] ; then 
    echo "Output directory ($output_path) must exist if reprocessing."
    exit -1 
fi


if [[ $output_path != *"/home/"* ]] ; then 
	echo "Trying to write outside home directory, exiting for safety."
	exit -1
fi

mkdir -p $output_path

if [[ "$reprocess" == "false" ]] ; then 
	capture_images 
fi

if [[ "$compare" == "true" ]] ; then 
	do_comparisons
fi

if [[ $produce_video == "true" ]] ; then 
	echo "producing videos..."
	rm -rf "$output_path/$UNPROCESSED_VID"
	rm -rf "$output_path/$DIFF_VID"   	
	ffmpeg -f image2 -i $output_path/compare%d.jpg $output_path/$UNPROCESSED_VID || exit -1 
	vlc "$output_path/$UNPROCESSED_VID"

	if [[ "$compare" == "true" ]] ; then  
		ffmpeg -f image2 -i $output_path/diff%d.jpg $output_path/$DIFF_VID || exit -1 
		vlc "$output_path/$DIFF_VID"
	fi
fi


if [[ $show_diff == "true" && -f "$output_path/$MONTAGE_FILE" ]] ; then 
	shotwell "$output_path/$MONTAGE_FILE"
fi

mv ../pico-rust/*.dat "$output_path"
