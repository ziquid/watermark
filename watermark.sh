#!/bin/bash
# set up a series of watermarked images.

# Set up sane defaults.
DISPLAY=1
XRES=1920
YRES=1080

function showhelp {
echo $(basename $0): watermark images for use as Mac OS X backgrounds.
echo Usage: $(basename $0) '[<options>] [<file> ...]'
  cat <<EOF

If <file> is omitted, source images are all "../???*.*" files
  (all files at least three characters long, with an extension)

Destination images are placed inside a directory named
  "<current directory>_<desired resolution>", which will be created if it doesn't exist

Options:
-h|--help:        this help
-v|--verbose:     be verbose
--debug:          be even more verbose
-d|--display <x>: which display (first/default: 1) to check
--dry-run:        do all except make the new images
--list-displays:  show the resolutions for each display in use
-x|--xres <x>:    set the X resolution to <x>
-y|--yres <x>:    set the Y resolution to <x>
EOF
}

# Check options.
# FIXME: allow options in any order.
[ "$1" = '-h' -o "$1" = '--help' ] && showhelp && exit
[ "$1" = '-v' -o "$1" = '--verbose' ] && VERBOSE=1 && shift
[ "$1" = '--debug' ] && VERBOSE=1 && DEBUG=1 && shift

[ "$1" = '-d' -o "$1" = '--display' ] && DISPLAY="$2" && shift 2 && \
  [ $VERBOSE ] && echo Checking display $DISPLAY

[ "$1" = '--dry-run' ] && DRY_RUN=1 && shift

[ "$1" = '--list-displays' ] && system_profiler SPDisplaysDataType | grep Resolution | \
  cat -n && exit

# Get resolution.
resline=$(system_profiler SPDisplaysDataType | grep Resolution | tr -s ' ' |\
  head -n $DISPLAY | tail -n 1)
XRES=$(echo $resline | sed -e 's/Resolution://g' | tr -s ' ' | cut -d ' ' -f 2)
YRES=$(echo $resline | sed -e 's/Resolution://g' | tr -s ' ' | cut -d ' ' -f 4)
[ $VERBOSE ] && echo MacOS says your resolution is $resline \($XRES x $YRES\)

[ "$1" = '-x' -o "$1" = '--xres' ] && XRES="$2" && shift 2 && \
  [ $VERBOSE ] && echo Setting X Resolution to $XRES

[ "$1" = '-y' -o "$1" = '--yres' ] && YRES="$2" && shift 2 && \
  [ $VERBOSE ] && echo Setting Y Resolution to $YRES

b=$(basename "$PWD")
NEWDIR="${b}_${XRES}x${YRES}"
mkdir -p $NEWDIR

# Set point size based on Y resolution
POINTSIZE=$(expr \( $XRES + $YRES \) / 125)

[ $# -eq 0 ] && pics="../???*.*" || pics=
[ -r .watermark-annotation ] && \
  annotate="-gravity northwest -fill black -annotate +12+27 @.watermark-annotation -fill white -annotate +11+26 @.watermark-annotation" || annotate=
for PIC in "$@" $pics; do
  NEWPIC=$NEWDIR/"$(basename "$PIC")"
  echo $PIC '-->' "$NEWPIC"
  [ $DEBUG ] && set -x

  [ $DRY_RUN ] || convert "$PIC" -background 'rgb(26, 29, 39)' \
  -sample ${XRES}x${YRES}^ -gravity center -extent ${XRES}x${YRES} \
  -font Arial -pointsize $POINTSIZE \
  -draw "gravity southwest fill black text 12,7 '$b' fill white text 11,6 '$b' " \
  $annotate "$NEWPIC"
  [ $? -gt 0 ] && exit $?
  set +x
done
