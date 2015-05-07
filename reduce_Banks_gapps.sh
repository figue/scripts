#!/bin/bash

## This script is intended to reduce BaNkS-dynamic-gapps zips, which are huge...
##
## This script is only tested for 05-2015 releases
##
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
##


# Architectures to delete
unwated_architectures="arm64 lib64 x86"

# Resolution of our ROM/device. Figure out with:    adb shell grep ro.sf.lcd_density /system/build.prop
wanted_lcd="320"   # Left blank if your lcd is NOT one of these: 160, 240, 320 or 480.

# New file reduced (you can modify the end part: -reduced.zip)
zip_file="${1%.zip}-reduced.zip"


## Starting
# We need 1 parameter (a BaNkS zip file)
if unzip -z "$1" | grep -qi BaNkS-dynamic-gapps ; then
    echo "BaNkS dynamic gapps detected!"
else
    echo "BaNkS zip not detected... Execute this script with BaNkS-dynamic-gapps-L-X-X-X.zip as the first parameter."
    exit 1
fi

# Backing up the zip, we will work with the copy...
cp -v "$1" "${zip_file}"

if [ "${wanted_lcd}" -eq "160" ]; then
    PrebuiltGmsCore=430
elif [ "${wanted_lcd}" -eq "240" ]; then
    PrebuiltGmsCore=434
elif [ "${wanted_lcd}" -eq "320" ]; then
    PrebuiltGmsCore=436
elif [ "${wanted_lcd}" -eq "480" ] || [ "${wanted_lcd}" -eq "560" ]; then
    PrebuiltGmsCore=438
elif [ "${wanted_lcd}" = "" ]; then
    PrebuiltGmsCore=470
fi

cat << EOF
==================================================================
This script will remove ${unwated_architectures} and other dpi differents of ${wanted_lcd} lcd density
==================================================================

Looking for unwanted arch files...

EOF

to_remove="$unwated_architectures $(echo 430 434 436 438 440 446 448 470 | sed -e "s/$PrebuiltGmsCore //g")"

for arch in $to_remove ; do
    echo "--> $arch <--"
    unzip -qql "${zip_file}" | grep $arch
done

echo
read -p "If all is OK, press 'y'  " q
echo

# All stuff is done here
if [ "$q" = "y" ]; then
    for f in $to_remove ; do
        for file in $(unzip -qql "${zip_file}" | awk '{print $4}' | grep $f) ; do
            zip -v -d $zip_file "$file"
        done
    done
fi

echo -e "\nAll Done."
