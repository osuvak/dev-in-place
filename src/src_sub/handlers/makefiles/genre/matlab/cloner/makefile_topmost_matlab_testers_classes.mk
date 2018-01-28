# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

DIRS := $(sort $(dir $(wildcard */)))

all : geninfo
	@echo ""
	@echo $(DIRS)

geninfo : clearall
	@$(HOME)/dev_in_place/scripts/generate_info_local_makefile_matlab_testers_classes
	
sourceclean : clean

clean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && find . -name "info_local.m" -type f -delete && cd ..; done
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && find . -name "alib.m"       -type f -delete && cd ..; done
	
clearall : force_look
	@echo ""
	@echo "Clearing all subdirectories..."
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && rm -rf ./* && cd ..; done
	@echo ""

force_look :
	@true