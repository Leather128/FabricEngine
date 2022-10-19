#! /bin/bash

echo $(( $(cat "build.txt") + 1 )) > "build.txt"
echo $( git log --format="%h" -n 1 ) > "commit.txt"

lime test linux -debug