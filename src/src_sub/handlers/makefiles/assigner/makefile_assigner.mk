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
include $(HOME)/dev_in_place/makefiles/common/paths.mk

# get list of directories
DIR_ALL_RAW := $(sort $(dir $(wildcard ./*/)))
DIR_ALL_RAW := $(filter-out ./,$(DIR_ALL_RAW))
DIR_ALL_RAW := $(patsubst %/,%,$(DIR_ALL_RAW))
DIR_ALL_RAW := $(notdir $(DIR_ALL_RAW))

DIR_ELIMINATED := $(sort $(dir $(wildcard ./_ignore*/)))
DIR_ELIMINATED := $(filter-out ./,$(DIR_ELIMINATED))
DIR_ELIMINATED := $(patsubst %/,%,$(DIR_ELIMINATED))
DIR_ELIMINATED := $(notdir $(DIR_ELIMINATED))

DIR_ALL := $(filter-out $(DIR_ELIMINATED),$(DIR_ALL_RAW))
DIRS    := $(DIR_ALL)

# content - interim
CONTENT_MAKEFILE_INTERIM := $(HOME)/dev_in_place/makefiles/assigner/makefile_interim.mk

# recipes
default : build help force_look
	@true;
	
build : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) && cd ..; done
	
geninfo : sourceclean relocatemakefiles mkdirtarget force_look
	@true;

relocatemakefiles : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && \
		$(HOME)/dev_in_place/scripts/generate_makefiles_tests_mex \
			$(COPIED_MAKEFILE) \
			$(CONTENT_MAKEFILE_INTERIM) \
			$(TYPE_MK) && \
		cd ..; \
	done

mkdirtarget : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) mkdirtarget && cd ..; done

sourceclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && find . -name "makefile" -type f -delete && cd ..; done
	@set -o pipefail -e; \
	if [[ "$(TYPE_MK)" == "mex" ]]; then \
		for d in $(DIRS); do cd $$d && \
		find . -name "_reserved_mex*" -type d -print0 | xargs -0 rm -rf -- && cd ..; \
		done \
	fi
	
realclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) realclean && cd ..; done
	
allclean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) allclean && cd ..; done
	
clean : force_look
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) clean && cd ..; done
	
include $(HOME)/dev_in_place/makefiles/assigner/makefile_global_cleankdev.mk
	
help : force_look
	@echo ""
	@echo "RECIPES"
	@echo ""
	@echo "help        - prints this help"
	@echo "default     - builds and helps"
	@echo "build       - builds calling default recipes in subdirectories"
	@echo "geninfo     - cleans source, relocates makefiles, restructures target directories"
	@echo "sourceclean - erases makefiles in subdirectories"
	@echo "realclean   - cleans target directories and global directory for binaries (if applicable)"
	@echo "allclean    - cleans target directories and global directory of relevant targets (if applicable)"
	@echo "clean       - cleans target directories only"
	@echo "cleankdev   - cleans KDevelop fragments in home folder and subdirectories"
	@echo ""
	@true;
	
force_look :
	@true;