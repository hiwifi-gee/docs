#!/bin/sh

[ $# -lt 1 ] && {
    cat <<EOF
Usage:
    $0 <appname>    
EOF
    exit
}

appname=$1
(cd $appname && tar -czvf ${appname}.tgz * --exclude-vcs && mv ${appname}.tgz ../)
[ $? -eq 0 ] && echo "Done: ${appname}.tgz"
