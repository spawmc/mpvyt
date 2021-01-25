#!/bin/bash

#=== Variables ===============================
input_file_name=""
output_file_name=""
declare -a links_playlist
#=============================================

__ScriptVersion="0.1"

#===  FUNCTION  ===============================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#==============================================
usage ()
{
  echo "Usage: $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version
    -i|input      Input file name
    -o|output     Output file name
    -f|file       Save in file
    "
}

save_input()
{
  count=0
  while read line ; do
    links_playlist[count]=$line
    count=$((count+1))
  done < $input_file_name
}

save_in_file()
{
  echo -e "Downloading playlist(s)"
  echo "" > $output_file_name
  for i in "${links_playlist[@]}" ; do
    youtube-dl -j --flat-playlist $i | jq -r '.id' | sed 's_^_https://youtu.be/_' >> $output_file_name
  done
  echo -e "Playlist(s) saved in $output_file_name"
}

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvi:o:pf" opt
do
  case $opt in

  h|help)
    usage; exit 0
  ;;

  v|version)
    echo "$0 -- Version $__ScriptVersion"; exit 0
  ;;

  i|input)
    input_file_name=$OPTARG 
    save_input
  ;;

  o|output)
    output_file_name=$OPTARG
  ;;
  
  p)
    for i in "${links_playlist[@]}"; do
      echo "$i"
    done
  ;;

  f)
    save_input
    save_in_file
  ;;

  *)
    echo -e "\n  Option does not exist : $OPTARG\n"
    usage; exit 1
  ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))
