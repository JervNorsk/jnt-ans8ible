#!/bin/sh

if [ ! -d ~/.ssh ]
then
  mkdir ~/.ssh || exit 0
fi

cp /srv/init/ssh/config ~/.ssh/config
chmod 400 ~/.ssh/config
