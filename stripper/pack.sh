# This file is distributed under the terms of the MIT license, (c) the KSLib team

# The purpose of this file is to decrease size of .ks files for the final flight. However, please upload
# UNPACKED versions of programs to KSLib.

# This version works in Unix environments.

# Run this file while being in your scripts directory. Please make a separate directory called "packed" - this
# is where your modified scripts will go.

FILES=`ls *.ks`
echo $FILES
for f in $FILES; do
	sed \
        -e 's|^\(\([^"]*\)\("[^"]*"[^"]*\)*\)\s*//.*$$|\1|g' -e 's|^\(\([^"]*\)\("[^"]*"[^"]*\)*\)\s*//.*$$|\1|g' \
        -e 's|^\s*\(.*)\s*$|\1|g' \
        -e '/^$/d'
	$f > packed/$f;
  # the first line strips comments (doubled to catch pesky URLs in comments)
	# the second line strips leading and trailing whitespace
  # the third line removes all empty lines (which should be stripped down by the second line)
