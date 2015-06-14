#!/bin/sh
# file: sync-laptop
# vim:fileencoding=utf-8:ft=sh
# Use rsync to syncronize a directory to/from my laptop.
#
# Author: R.F. Smith <rsmith@xs4all.nl>
# Created: 2015-04-25 17:55:24 +0200
# Last modified: 2015-06-14 23:05:54 +0200

usage="Usage: sync-laptop [-h][[-f][-r] <dir>]"
args=`getopt fhr $*`
if [ $? -ne 0 ]; then
    echo $usage
    exit 1
fi
set -- $args
FORCE=""
REVERSE=""
while true; do
    case "$1" in
        -h)
            echo $usage
            exit 1
            ;;
        -f)
            FORCE='yes'
            shift
            ;;
        -r)
            REVERSE='yes'
            shift
            ;;
        --)
            shift; break
            ;;
        esac
done
if [ ! $1 ]; then
    echo $usage
    exit 1
fi
DIR=$(pwd)/${1%%/}
if [ ! -d ${DIR} ]; then
    echo "${DIR} is not a directory!"
    exit 2
fi
DIR=${DIR##/home/${USER}/}
OPTS='-avn'
if [ $FORCE ]; then
    OPTS='-av'
fi
if [ $REVERSE ]; then
    rsync ${OPTS} --delete rfs::home/${USER}/${DIR}/ /home/${USER}/${DIR}
else
    rsync ${OPTS} --delete /home/${USER}/${DIR}/ rfs::home/${USER}/${DIR}
fi