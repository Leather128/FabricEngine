#! /bin/sh

haxe docs/docs.hxml
haxelib run dox -i docs -o pages --title "Fabric Engine Documentation" -ex .*^ -in base/* -in external/* -in funkin/*