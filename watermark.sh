b=$(basename "$PWD")
pics="$*"
[ "$pics" = "" ] && pics="../*.*"
for a in $pics; do
  echo $a
  convert "$a" -background 'rgb(66, 139, 202)' -resize 3840x2160 -gravity center -extent 3840x2160 -font Arial -pointsize 40 -draw "gravity southwest fill black text 12,12 '$b' fill white text 11,11 '$b' " "$b"_"$(basename "$a")"
done
