#!/bin/bash
#rbin.sh

help=0
list=0
empty=0

#check if ".recycle" exists in home directory, else create it.
if [[ ! ( -d $HOME/".recycle" ) ]]; then
    mkdir $HOME/".recycle"
    chmod -R 555 $HOME/".recycle"
fi

readonly recycleDir=$HOME/".recycle"

#parses flag options in executable call
while getopts ":hlp" options; do
    case "${options}" in
        h)
            help=1
            ;;

        l)
            list=1
            ;;

        p)
            empty=1
            ;;

        *)
            cat << EOF
Usage: rbin.sh [-hlp] [list of files]
   -h: Display this help;
   -l: List files in the recycle bin;
   -p: Empty all files in the recycle bin;
   [list of files] with no other flags,
        these files will be moved to the
        recycle bin.
EOF
            echo "Error: Unknown option '-${OPTARG}'." >&2
            exit 1
    esac
done

if [[ $(( $help + $list + $empty )) -gt 1 ]]; then
    cat << EOF
Usage: rbin.sh [-hlp] [list of files]
   -h: Display this help;
   -l: List files in the recycle bin;
   -p: Empty all files in the recycle bin;
   [list of files] with no other flags,
        these files will be moved to the
        recycle bin.
EOF
    echo Error: Too many options enabled. >&2
    exit 1

elif [[ $(( $help + $list + $empty )) -eq 0 ]]; then
    if [[ $# -gt 0 ]]; then
        for file in $@; do
            if [[ -e $file ]]; then
                mv $file $recycleDir/
            else
                echo "Warning: '$file' not found." >&2 

            fi
        done
    else
        cat << EOF
Usage: rbin.sh [-hlp] [list of files]
   -h: Display this help;
   -l: List files in the recycle bin;
   -p: Empty all files in the recycle bin;
   [list of files] with no other flags,
        these files will be moved to the
        recycle bin.
EOF
    exit 1

    fi

else
    if [[ $# -gt 1 ]]; then
        cat << EOF
Usage: rbin.sh [-hlp] [list of files]
   -h: Display this help;
   -l: List files in the recycle bin;
   -p: Empty all files in the recycle bin;
   [list of files] with no other flags,
        these files will be moved to the
        recycle bin.
EOF
    echo Error: Too many options enabled. >&2
    exit 1

    fi

fi

#checks which input was given
if [[ $help = 1 ]]; then
    cat << EOF
Usage: rbin.sh [-hlp] [list of files]
   -h: Display this help;
   -l: List files in the recycle bin;
   -p: Empty all files in the recycle bin;
   [list of files] with no other flags,
        these files will be moved to the
        recycle bin.
EOF

elif [[ $list = 1 ]]; then
    ls -AFl1 $recycleDir

elif [[ $empty = 1 ]]; then
    for file in $(ls -a $recycleDir); do
        rm -rf $recycleDir/$file 2> /dev/null
    done

fi


