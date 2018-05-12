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

# defines
define obtain_src_obj_subdir
SRC_SUBDIR_TEMP := $$(wildcard ${1}/*.${2})
SRC_SUBDIR      += $$(SRC_SUBDIR_TEMP)
endef

define obtain_src_obj_exe
SRC_TEMP := $$(wildcard $$(DIR_SRC)/./*.$1)
OBJ_TEMP := $$(addprefix $$(DIR_TARGET)/./,$$(notdir $$(SRC_TEMP:.$1=.${1}.$$(EXT_OBJ))))
EXE_TEMP := $$(addprefix $$(DIR_TARGET)/./,$$(notdir $$(SRC_TEMP:.$1=.${1}.$$(EXT_EXE))))

SRC += $$(SRC_TEMP)
OBJ += $$(OBJ_TEMP)
EXE += $$(EXE_TEMP)
endef

define rule_compile
$$(DIR_TARGET)/$2/%.${1}.$$(EXT_OBJ) : $$(DIR_SRC)/$2/%.$1
	@echo ""
	@echo "Source : $$<"
	@echo "Target : $$@"
	@echo ""
	${4} ${5} \
		-MP -MMD \
		-MT '$$@' \
		-MF $$(DIR_TARGET)/$2/$$*.${1}.$$(EXT_DEP) \
		-I. \
		$3 \
		$$(DEP_INCLUDE) \
		-c $$< -o $$@
endef

define include_dependencies
-include $$(wildcard $$(DIR_TARGET)/$2/*.${1}.$$(EXT_DEP))
endef

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

DIRS_DOTTED := $(addprefix ./,$(DIRS))

# directories
DIR_BLANK  :=
DIR_DOT    := .
DIR_SRC    := .
DIR_TARGET := ./_ignore_obj

# extensions
EXT_EXE := elf
EXT_OBJ := o
EXT_DEP := d

LIST_EXTS := $(LIST_EXTS_LANG_CPP) $(LIST_EXTS_LANG_C)

# top dir - src obj exe
SRC := 
OBJ := 
EXE := 

$(foreach EXT,$(LIST_EXTS),$(eval $(call obtain_src_obj_exe,$(EXT))))

SRC := $(sort $(SRC))
OBJ := $(sort $(OBJ))
EXE := $(sort $(EXE))

# sub dir - src obj
SRC_SUBDIR :=

$(foreach D,$(DIRS),\
  $(foreach EXT,$(LIST_EXTS),\
    $(eval $(call obtain_src_obj_subdir,$(D),$(EXT)))\
  )\
)
SRC_SUBDIR := $(sort $(SRC_SUBDIR))
OBJ_SUBDIR := $(addprefix $(DIR_TARGET)/,$(addsuffix .$(EXT_OBJ),$(SRC_SUBDIR)))

# subdir includes
DEP_INCLUDE_SUBDIR := $(addprefix -I./,$(DIRS))
DEP_INCLUDE_BLANK  := $(addprefix -I./,$(DIR_BLANK))


# Recipes below

default : reportall exe help force_look
	@true

run : reportall exe force_look
	@true
	@$(HOME)/dev_in_place/scripts/run_exe $(EXE)

fromscratch : reportall mkdirtarget exe help force_look
	@true

reportall : force_look
	@echo ""
	@echo "List of All Directories (RAW) :"
	@echo "$(DIR_ALL_RAW)"
	@echo ""
	@echo "List of Ignored Directories :"
	@echo "$(DIR_ELIMINATED)"
	@echo ""
	@echo "List of All Directories :"
	@echo "$(DIR_ALL)"
	@echo ""
	@echo "Sources in Topmost Directory :"
	@echo "$(SRC)"
	@echo ""
	@echo "Objects in Topmost Directory :"
	@echo "$(OBJ)"
	@echo ""
	@echo "Exe in Topmost Directory :"
	@echo "$(EXE)"
	@echo ""
	@echo "Sources in Subdirectories :"
	@echo "$(SRC_SUBDIR)"
	@echo ""
	@echo "Objects in Subdirectories :"
	@echo "$(OBJ_SUBDIR)"
	@echo ""
	@echo "DEP_INCLUDE_SUBDIR :"
	@echo "$(DEP_INCLUDE_SUBDIR)"
	@echo ""
	@echo "DEP_INCLUDE_BLANK :"
	@echo "$(DEP_INCLUDE_BLANK)"
	@echo ""
	
mkdirtarget : clean force_look
	@set -o pipefail -e; \
		for d in $(DIR_ALL); do cd $(DIR_TARGET) && mkdir -p $$d && cd ..; done
	
exe : $(EXE) force_look

$(DIR_TARGET)/./%.$(EXT_EXE) : $(DIR_TARGET)/./%.$(EXT_OBJ) $(OBJ_SUBDIR)
	@echo ""
	@echo "Source       : $<"
	@echo "Dependencies : $^"
	@echo "Target       : $@"
	@echo ""
	$(CXX) $(LDCXXFLAGS) \
		-o $@ \
		$< \
		$(OBJ_SUBDIR) \
		$(DEP_LINK)
	patchelf --set-rpath "$(PATH_LINK)" $@
	
$(foreach EXT,$(LIST_EXTS_LANG_CPP),\
  $(eval $(call rule_compile,$(EXT),$(DIR_DOT),$(DEP_INCLUDE_SUBDIR),$(CXX),$(CXXFLAGS)))\
)

$(foreach EXT,$(LIST_EXTS_LANG_C),\
  $(eval $(call rule_compile,$(EXT),$(DIR_DOT),$(DEP_INCLUDE_SUBDIR),$(CC),$(CFLAGS)))\
)
  
$(foreach D,$(DIRS),\
  $(foreach EXT,$(LIST_EXTS_LANG_CPP),\
    $(eval $(call rule_compile,$(EXT),$(D),$(addprefix -I./,$(D)),$(CXX),$(CXXFLAGS)))\
  )\
)

$(foreach D,$(DIRS),\
  $(foreach EXT,$(LIST_EXTS_LANG_C),\
    $(eval $(call rule_compile,$(EXT),$(D),$(addprefix -I./,$(D)),$(CC),$(CFLAGS)))\
  )\
)

$(foreach EXT,$(LIST_EXTS),\
  $(eval $(call include_dependencies,$(EXT),.))\
)
$(foreach EXT,$(LIST_EXTS),\
  $(foreach D,$(DIRS),\
    $(eval $(call include_dependencies,$(EXT),$(D)))\
  )\
)

.SECONDARY : $(OBJ)
.SECONDARY : $(OBJ_SUBDIR)

realclean : clean force_look
	@true
	
allclean  : clean force_look
	@true

clean : force_look
	@mkdir -p $(DIR_TARGET)
	@cd $(DIR_TARGET); rm -rf ./*

include $(HOME)/dev_in_place/makefiles/assigner/makefile_lowermost_kdev.mk
	
help : force_look
	@echo ""
	@echo "RECIPES"
	@echo ""
	@echo "help        - prints this help"
	@echo "default     - reports, makes targets checking dependencies, helps"
	@echo "run         - default jobs and asks user which elf to run"
	@echo "fromscratch - reports, restructures target dir, makes targets, helps"
	@echo "realclean   - same as clean"
	@echo "allclean    - same as clean"
	@echo "clean       - cleans target dir"
	@echo "kdev        - cleans and regenerates KDevelop auxilliary fragments"
	@echo "cleankdev   - cleans KDevelop fragments"
	@echo ""
	
force_look :
	@true
	