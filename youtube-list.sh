#!/bin/bash

# @Autor: spawnmc (spawmc in GitHub)

#=== Variables ================================
input_file_name=""
output_file_name=""
declare -a links_playlist
__ScriptVersion="0.1"
#==============================================

#===  FUNCTION  ===============================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#==============================================
usage ()
{
  echo -e "\e[1;36mUsage:\e[21;39m $0 [options] [--]

    \e[33mOptions:\e[39m
    -h|help       Display this message
    -v|version    Display script version
    -i|input      Input file name
    -o|output     Output file name
    -f|file       Save in file            \e[35m| Syntax: -i -o -f\e[39m
    "
}

#===  FUNCTION  ===============================
#         NAME:  save_input
#  DESCRIPTION:  Save the links in the file
#==============================================
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
  echo -e "\e[5mDownloading playlist(s)...\e[25m"
  echo "" > $output_file_name
  for i in "${links_playlist[@]}" ; do
    youtube-dl -j --flat-playlist $i | jq -r '.id' | sed 's_^_https://youtu.be/_' >> $output_file_name
  done
  echo -e "Playlist(s) saved in \e[1;34m$output_file_name\e[21m" 
}

while getopts ":hvi:o:f" opt
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
