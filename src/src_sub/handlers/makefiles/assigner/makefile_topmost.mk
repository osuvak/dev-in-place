# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

include $(HOME)/dev_in_place/makefiles/common/commands_flags.mk
include $(HOME)/dev_in_place/makefiles/common/extensions.mk

include $(HOME)/dev_in_place_content/lib_info/current.mk
DIR_TYPES := $(HOME)/dev_in_place_content/lib_info/$(DIR_LIB_INFO_CURRENT)/types

# get list of directories in pwd (ignored dirs included)
DIR_ALL_RAW := $(sort $(dir $(wildcard ./*/)))
DIR_ALL_RAW := $(filter-out ./,$(DIR_ALL_RAW))
DIR_ALL_RAW := $(patsubst %/,%,$(DIR_ALL_RAW))
DIR_ALL_RAW := $(notdir $(DIR_ALL_RAW))

DIRS := $(DIR_ALL_RAW)

# recipes

default : build help force_look
	@true;
	
build : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) && cd ..; done
	
geninfo : manager force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) geninfo && cd ..; done
	
manager : mngrclean force_look
	@$(HOME)/dev_in_place/scripts/relocate_manager_makefiles  $(DIR_TYPES);
	
mngrclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && find . -name "makefile" -type f -delete && cd ..; done
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && find . -name "*.mk" -type f -delete && cd ..; done
	@set -o pipefail -e; \
	for d in $(DIRS); \
		do cd $$d && \
		find . -name "_reserved_mex*" -type d -print0 | xargs -0 rm -rf -- && \
		cd ..; \
	done
	
sourceclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) sourceclean && cd ..; done
	
realclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) realclean && cd ..; done
	
allclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) allclean && cd ..; done
	
clean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) clean && cd ..; done
	
cleankdev : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) cleankdev && cd ..; done
	
help : force_look
	@echo ""
	@echo "RECIPES"
	@echo ""
	@echo "help        - prints this help"
	@echo "default     - builds and helps"
	@echo "build       - builds calling default recipes in subdirectories"
	@echo "geninfo     - runs manager, cleans source, relocates makefiles, restructures target directories"
	@echo "manager     - relocates manager makefiles under the topmost directory"
	@echo "mngrclean   - clean-up before the recipe manager"
	@echo "sourceclean - erases makefiles in subdirectories"
	@echo "realclean   - cleans target directories and global directory for binaries (if applicable)"
	@echo "allclean    - cleans target directories and global directory of relevant targets (if applicable)"
	@echo "clean       - cleans target directories only"
	@echo "cleankdev   - calls KDevelop fragments cleaners in subdirectories"
	@echo ""
	@true;
	
force_look :
	@true;