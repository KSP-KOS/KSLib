# This file is distributed under the terms of the MIT license, (c) the KSLib team

# The purpose of this Makefile is to decrease size of .ks files for the final flight. However, please upload
# UNPACKED versions of programs to KSLib.

# This version mostly works in Unix and cygwin environments.

# This is where your live KSP script archive is located.
INSTALLDIR = ~/Desktop/Kerbal\\\ Space\\\ Program/Ships/Script
# This is where you want the packed/stripped versions to go (for now, you'll have to create the directory)
STAGEDIR = packed

# list all of your .ks files
files := $(wildcard *.ks)
# create a list of .ksp files, homed in your staging directory
packed := $(foreach file, $(files:.ks=.ksp), $(STAGEDIR)/$(file))
# create a list of all your .ks files, homed in your live archive
installed := $(foreach file, $(files), $(INSTALLDIR)/$(file))

# By default, pack up all your .ks files as .ksp files in your staging directory
all : $(packed)

# make install to copy your packed files to your live directory (and rename them back to .ks files)
install : $(installed)

# empty out your staging directory
clean :
	rm $(packed);

###
#   How to convert .ks files to staged .ksp files, and how to convert staged .ksp files to installed .ks files
###
$(STAGEDIR)/%.ksp : %.ks
	/bin/sed -e 's|^\(\([^"]*\)\("[^"]*"[^"]*\)*\)\s*//.*$$|\1|g' -e 's|^\(\([^"]*\)\("[^"]*"[^"]*\)*\)\s*//.*$$|\1|g' -e 's|^\s*\(.*\)\s*$$|\1|g' -e '/^$$/d' $< > $@;

$(INSTALLDIR)/%.ks : $(STAGEDIR)/%.ksp
	cp $< $@;
