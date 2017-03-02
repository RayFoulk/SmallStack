#!/bin/bash

rm -f LICENSE
rm -f README.md
ln -s ./Documents/LICENSE
ln -s ./Documents/README.md
git add LICENSE
git add README.md
git commit -m "fix symlinks after MGit clobber"

