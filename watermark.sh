b=$(basename "$PWD")
[ $# -eq 0 ] && pics="../*.*" || pics=
for a in "$@" $pics; do
  echo $a
  convert "$a" -background 'rgb(66, 139, 202)' -resize 3840x2160 -gravity center -extent 3840x2160 -font Arial -pointsize 48 -draw "gravity southwest fill black text 12,7 '$b' fill white text 11,6 '$b' " "$b"_"$(basename "$a")"
  [ $? -gt 0 ] && exit $?
done
