# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

DIRS := source

all : geninfo help

geninfo : sourceclean
	@$(HOME)/dev_in_place/scripts/generate_alib_matlab_testers
	
sourceclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && find . -name "alib.m" -type f -delete && cd ..; done

help : force_look
	@echo ""
	@echo "RECIPES"
	@echo ""
	@echo "help        - prints this help"
	@echo "all         - cleans source dir and creates alib files"
	@echo "sourceclean - cleans source dir of alib files"
	
force_look :
	@true