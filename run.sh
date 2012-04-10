#!/bin/bash

# Put here url to osm.pbf file
map_url='http://data.gis-lab.info/osm_dump/dump/latest/local.osm.pbf'

# Name of map how it will appear in Mapsource/Garmin
NAME=Russia

# ID of map, must be unique for your installed maps
ID=480

# Codepage to use for names on map
CODEPAGE=1251

# Location of ValentinAK configs and supplement tools
maptourist='../mkgmap-maptourist-style'

cwd=`pwd`
out=./output
logs=./logs
map=`basename $map_url`

mkdir -p $out
mkdir -p $logs

IDHEX=`printf "%0.4X" $ID`
IDHEXLE=`echo -ne $IDHEX | sed 's/\(..\)\(..\)/\2\1/'`
IDHEXSTR=`echo -ne $IDHEX | sed 's/\(..\)\(..\)/\\\\x\2\\\\x\1/'`
TYP='M000'$IDHEX'.TYP'
INPUT=$cwd/$map

cp $maptourist/../M0000000.TYP ./$TYP
echo -ne $IDHEXSTR | dd conv=notrunc bs=1 count=2 seek=47 of=$TYP

remote_size=`wget --spider --server-response $map_url -O - 2>&1 | sed -ne '/Content-Length/{s/.*: //;p}'`
local_size=`ls -l $map | awk '{ print $5 }'`
if [ ${remote_size}x != ${local_size}x ]; then
    rm -f $map
    wget -c $map_url
fi

cp $TYP $maptourist/config

cp $maptourist/Makefile $maptourist/Makefile.bak
sed -i "s/MapTourist/$NAME/" $maptourist/Makefile

cp $maptourist/optionsfile.args $maptourist/optionsfile.args.bak
sed -i "s/code-page:1251/code-page:$CODEPAGE/" $maptourist/optionsfile.args

cp $maptourist/config/options $maptourist/config/options.bak
sed -i 's/name-tag-list = name:ru,name,name:en,int_name/name-tag-list = name:en,int_name,name/' $maptourist/config/options

cd $maptourist

./update_bin.sh
make TYP=$TYP ID=$ID INPUT=$INPUT mkgbnd2
make TYP=$TYP ID=$ID INPUT=$INPUT

cd $cwd

mv $TYP $out
cp $maptourist/../*.bat $out
sed -i "s/M0000000/M000$IDHEX/" $out/install.bat
sed -i "s/FID/$IDHEXLE/" $out/install.bat
sed -i "s/MapTourist/$NAME/g" $out/install.bat
sed -i "s/MapTourist/$NAME/g" $out/uninstall.bat
cp -rd $maptourist/output/* $out
cp -rd $maptourist/logs/* $logs
#rm -f $out/gmapsupp.img

cd $maptourist

make clean

mv -f config/options.bak config/options
mv -f Makefile.bak Makefile
mv -f optionsfile.args.bak optionsfile.args
rm -f config/$TYP

cd $cwd
