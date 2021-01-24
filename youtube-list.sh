#!/bin/bash

link_playlist=$1
output_name=$2

echo -e "Downloading list..."

youtube-dl -j --flat-playlist $link_playlist | jq -r '.id' | sed 's_^_https://youtu.be/_' > $output_name

echo -e "List saved in $output_name"

__ScriptVersion="0.1"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
  echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version
    -i|input      Input file"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hv" opt
do
  case $opt in

  h|help)
    usage; exit 0
  ;;

  v|version)
    echo "$0 -- Version $__ScriptVersion"; exit 0
  ;;

  i|input)
  ;;

  *)
    echo -e "\n  Option does not exist : $OPTARG\n"
    usage; exit 1
  ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))
