#!/bin/sh

# pack.sh 
# Copyright © 2015 KSLib team 
# Lic. MIT

# The purpose of this file is to decrease size of .ks files for the final flight. However, please upload 
# UNPACKED versions of programs to KSLib.

# This version works in Unix environments.

# Run this file while being in your scripts directory. Please make a separate directory called "packed" - this
# is where your modified scripts will go.

FILES=`ls *.ks`
echo $FILES
for f in $FILES; do
	sed \
	-e 's/^\(\([^"]*\)\("[^"]*"[^"]*\)*\)\/\/.*/\1/g' \
	-e 's/^\( \|\t\)*//g' \
	-e 's/\( \|\t\)*$//g' \
	$f > packed/$f;
	# the first line strips comments
	# the second line strips leading whitespace
	# the third line strips trailing whitespace
done
