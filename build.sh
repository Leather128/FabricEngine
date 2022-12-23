#! /bin/sh

echo $(( $(cat "build.txt") + 1 )) > "build.txt"

lime test linux -debug