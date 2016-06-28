# watermark
Script to generate watermarked images for Mac Desktops.

# requisites
Requires [Imagemagick](http://www.imagemagick.org/).  ```$ brew install imagemagick``` first, if you don't already have Imagemagick.
# installation
    $ cp watermark.sh /usr/local/bin
    $ chmod a+x /usr/local/bin/watermark.sh
    
or you can symlink from /usr/local/bin to this repo if you auto-want the latest and greatest.

# usage
    $ watermark.sh

Creates 3840x2160 images of all pics in ```..``` (parent dir), watermarked with the name of this folder.

    $ watermark.sh <file> [...]
    
Creates 3840x2160 images of all pics specified on command line, watermarked with the name of this folder.  Hopefully your shell expands wildcards (do any not?).

# use case
Watermark background images on my Mac so that I can remember which desktop (space) I am on.  See [Superuser.com](http://superuser.com/questions/313387/changing-name-of-space-in-mac-os-x-lion/1094016#1094016).