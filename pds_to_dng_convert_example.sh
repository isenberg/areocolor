#!/bin/sh
#
# Examples for converting NASA/ESA PDS raw images into DNG format
# based on the actual production scripts used on https://areo.info/mars20
# Holger Isenberg https://areo.info https://twitter.com/areoinfo 2023
#
# Dependencies:
# * https://gdal.org
# * https://exiftool.org
# * https://rawtherapee.com for reading DNG
#
# Dependencies Installation:
# * macOS Homebrew https://brew.sh: brew install gdal exiftool
# * Debian/Ubuntu Linux: sudo apt install gdal-bin libimage-exiftool-perl
#
# Examples for useful output formats:
# * Byte: 8 PDS bit data
# * UInt16: 11 to 16 bit data
# * Float32: floating point data
#
# Notes:
# * This example does not claim to produce standard conform DNG files.
#   To produce standard conform DNG files please refer to the public DNG specification
#   about the required and recommended tags.
# * For a complete PDS to image conversation, applying of the camera-specific
#   inverted LUT and the transformation from camera to viewer color space is needed.
#   Refer to PDFs on https://researchgate.net/profile/Holger-Isenberg for concepts and results.

# convert 3 band RGB PDS to TIFF
gdal_translate -colorinterp red,green,blue -ot UInt16 -of GTiff pdsfile_rgb.img tmpfile_rgb.tif

# convert CFA "bayered" PDS to TIFF
gdal_translate -ot UInt16 -of GTiff pdsfile_cfa.img tmpfile_cfa.tif

# convert monochrome PDS to TIFF
gdal_translate -ot UInt16 -of GTiff pdsfile_gray.img tmpfile_gray.tif

# convert TIFF to DNG
exiftool \
 -DNGVersion="1.4.0.0" \
 -DNGBackwardVersion="1.4.0.0" \
 -ColorSpace="Uncalibrated" \
 -Gamma="1.0" \
 -IFD0:WhiteLevel=65535 \
 -IFD0:SamplesPerPixel=3 \
 -IFD0:BitsPerSample=16 \
 -IFD0:PhotometricInterpretation="RGB" \
 -ComponentsConfiguration="R,G,B,0" \
 tmpfile_rgb.tif \
 && mv tmpfile_rgb.tif tmpfile_rgb.dng

exiftool \
 -DNGVersion="1.4.0.0" \
 -DNGBackwardVersion="1.4.0.0" \
 -ColorSpace="Uncalibrated" \
 -Gamma="1.0" \
 -IFD0:WhiteLevel=65535 \
 -IFD0:SamplesPerPixel=1 \
 -IFD0:BitsPerSample=16 \
 -IFD0:PhotometricInterpretation="Color Filter Array" \
 -IFD0:CFAPattern2="0 1 1 2" \
 -IFD0:CFARepeatPatternDim="2 2" \
 -ComponentsConfiguration="R,G,B,0" \
 tmpfile_cfa.tif \
 && mv tmpfile_cfa.tif tmpfile_cfa.dng

exiftool \
 -DNGVersion="1.4.0.0" \
 -DNGBackwardVersion="1.4.0.0" \
 -ColorSpace="Uncalibrated" \
 -Gamma="1.0" \
 -IFD0:WhiteLevel=65535 \
 -IFD0:SamplesPerPixel=1 \
 -IFD0:BitsPerSample=16 \
 -IFD0:PhotometricInterpretation="Linear Raw" \
 tmpfile_mono.tif \
 && mv tmpfile_mono.tif tmpfile_mono.dng

