#!/bin/bash
#echo $1
#
EMAIL=lorenzo.carbonell.cerezo@gmail.com
SIGN=k6E890577
#
APPVERSION=$(head -n 1 debian/changelog)
APP=`expr "$APPVERSION" : '\(.* (\)'`
APP=${APP:0:-2}
PACKAGE=$APP
VERSION=`expr "$APPVERSION" : '.* \((.*)\)'`
VERSION=${VERSION:1:-1}
#
TEMPLATE=po/$PACKAGE.pot
FILES=po/*.po

usage()
{
cat << EOF
usage: $0 options

This script helps you to translate your project.

OPTIONS:
   -b Build
   -c Clean
   -d Create debian package
   -h Show this message
   -l Create translation file for language 'language'
   -t Translate all
   -u For upload to ppa
   -v Update version
EOF
}

translate()
{
	xgettext --msgid-bugs-address=$EMAIL --language=C --keyword=_ --output $TEMPLATE --escape src/*.vala
	for f in $FILES
	do
		    msgmerge -U $f $TEMPLATE
	done
	intltool-merge --quiet --desktop-style po/ data/$PACKAGE.desktop.in data/$PACKAGE.desktop
}
create()
{
	 msginit --output-file=po/$1.po --input=$TEMPLATE --locale=$1
	 sed -i 's/charset=ASCII/charset=UTF-8/g' po/$1.po
}
debian()
{
	debuild -i -us -uc -b -I.bzr
}
clean()
{
	rm -rf build
	rm -rf obj-x86_64-linux-gnu
	rm -f $PACKAGE
	rm ../"$APP"_"$VERSION"*
	rm ../"$APP"-dbg_"$VERSION"*
	rm -rf debian/"$PACKAGE"
	rm -rf debian/"$PACKAGE"-dbg
	rm -f debian/autoreconf.after
	rm -f debian/autoreconf.before
	rm -f debian/"$PACKAGE"-dbg.debhelper.log
	rm -f debian/"$PACKAGE"-dbg.substvars
	rm -f debian/"$PACKAGE".debhelper.log
	rm -f debian/"$PACKAGE".substvars
	rm -f debian/files
}
upload(){
	debuild -S -sa -I.bzr -$SIGN
	dput ppa:atareao/test ../"$APP"_"$VERSION"_source.changes
}
build(){
	# We need to make our build directory for all of our temp files.
	rm -r build
	mkdir build
	#Enter the build Directory
	cd build
	#Now we initiate cmake in this dir
	cmake ..
	#Next we build the source files!
	make
	#Next we copy the executable to our root project file.
	cp ./src/$PACKAGE ../$PACKAGE
}
update_version(){
	APPNAMEuc=${APP^^}
	APPNAMElc=${APP,,}
	APPNAME=${APPNAMEuc:0:1}${APPNAMElc:1}	
	array=(${VERSION//-/ })
	MMB=${array[0]}
	array1=(${MMB//./ })
	VERSION_MAJOR=${array1[0]}
	VERSION_MINOR=${array1[1]}
	VERSION_STATUS=${array1[2]}
	VERSION_BUILD=${array[1]}
	sed -i "s/set (PACKAGE \".*\")/set (PACKAGE \"$APP\")/g" CMakeLists.txt
	sed -i "s/set (VERSION_MAJOR \".*\")/set (VERSION_MAJOR \"$VERSION_MAJOR\")/g" CMakeLists.txt
	sed -i "s/set (VERSION_MINOR \".*\")/set (VERSION_MINOR \"$VERSION_MINOR\")/g" CMakeLists.txt
	sed -i "s/set (VERSION_STATUS \".*\")/set (VERSION_STATUS \"$VERSION_STATUS\")/g" CMakeLists.txt
	sed -i "s/set (VERSION_BUILD \".*\")/set (VERSION_BUILD \"$VERSION_BUILD\")/g" CMakeLists.txt
	sed -i "s/set (NAME \".*\")/set (NAME \"$APPNAME\")/g" CMakeLists.txt
	sed -i "s/set (GENERICNAME \".*\")/set (GENERICNAME \"$APPNAME\")/g" CMakeLists.txt
}
while getopts “bcdhl:tuv” OPTION
do
     case $OPTION in
         b)
             update_version
             translate
             build
             exit 1
             ;;
         c)
             clean
             exit 1
             ;;
         d)
             update_version
             translate
             debian
             exit 1
             ;;
         h)
             usage
             exit 1
             ;;
         l)
             LANGUAGE=$OPTARG
             create $OPTARG
             exit 1
             ;;
         t)
             translate
             exit 1
             ;;
         u)
             upload
             exit 1
             ;;
         v)
             update_version
             exit 1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $OPTARG ]]
then
     build
     exit 1
fi
