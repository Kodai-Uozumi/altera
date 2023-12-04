# release.sh

DST=`cygpath -u $QUARTUS_ROOTDIR`/cusp/synthinclude
SRC=`dirname $0`

echo $SRC "->" $DST

mkdir "$DST"
rm -rf "$DST/*"

(cd $SRC ; tar -c --exclude "release.sh" --exclude "CVS" --exclude ".*" * ) | (cd $DST ; tar -x ) 
