#!/bin/bash

echo " ▌ ▐·▄▄▌   ▄▄·  ▄· ▄▌▄▄▄▄▄";
echo "▪█·█▌██•  ▐█ ▌▪▐█▪██▌•██  ";
echo "▐█▐█•██▪  ██ ▄▄▐█▌▐█▪ ▐█.▪";
echo " ███ ▐█▌▐▌▐███▌ ▐█▀·. ▐█▌·";
echo ". ▀  .▀▀▀ ·▀▀▀   ▀ •  ▀▀▀ ";
echo "              By: @spawnmc";

#=== Variables =============================
ward=true

interactive_mode(){
  while $ward ; do
    echo "Welcome to Vlcyt :)"
    echo -e "1 -> Play (no video)"
    echo -e "2 -> Play"
    echo -e "3 -> Update playlist"
    echo -e "4 -> Exit"
    echo -e "Enter an option> "
    read 
    ward=false
  done
}



__ScriptVersion="0.1"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
usage ()
{
  echo "Usage :  $0 [options] [--]

    Options:
    -h|help         Display this message
    -v|version      Display script version
    -i|interactive  Interactive version
    "
}    # ----------  end of function usage  ----------


while getopts ":hvi" opt
do
  case $opt in
    h|help)
      usage; exit 0
      ;;
    v|version)
      echo "$0 -- Version $__ScriptVersion"; exit 0
      ;;
    i|interactive)
      interactive_mode
      ;;
    *)
      echo -e "\n  Option does not exist : $OPTARG\n"
      usage; exit 1
      ;;
  esac    # --- end of case ---
done
shift $(($OPTIND-1))
