#!/usr/bin/sh

basedir="$(readlink -f "$(dirname "$0")")"

# Udate all submodules first
git submodule update --init --recursive

find "$basedir" -mindepth 1 -maxdepth 1 -not -name '.git' -not -name 'instal.sh' -not -name '.gitmodules' |
while IFS= read -r file
do
    ln -vs "$file" "$HOME/$(basename "$file")"
done

