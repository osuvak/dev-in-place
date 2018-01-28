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
DIR_ELIMINATED += $(sort $(dir $(wildcard ./_reserved_mex*/)))
DIR_ELIMINATED := $(filter-out ./,$(DIR_ELIMINATED))
DIR_ELIMINATED := $(patsubst %/,%,$(DIR_ELIMINATED))
DIR_ELIMINATED := $(notdir $(DIR_ELIMINATED))

DIR_ALL := $(filter-out $(DIR_ELIMINATED),$(DIR_ALL_RAW))
DIRS    := $(DIR_ALL)

DIRS_DOTTED := $(addprefix ./,$(DIRS))

# directories
DIR_SRC    := .
DIR_TARGET := ./_ignore_obj

# defines
define obtain_src_subdir
SRC_SUBDIR += $$(wildcard ${1}/*.${2})
endef

define obtain_src_topmost
SRC += $$(wildcard $$(DIR_SRC)/*.$1)
endef

define matlab_mex_compile_link_BadSolution
$$(DIR_TARGET)/%.$$(EXT_MEX) : $$(DIR_SRC)/%.${1} force_look
#
	TGT_LOADED="$$*" && \
		TGT_LOADED+="_Loaded" && \
		DIR_MEX_RESERVED="_reserved_mex_" && \
		DIR_MEX_RESERVED+="$$*" && \
		echo $$* && \
		echo $$$$TGT_LOADED && \
		echo $$$$DIR_MEX_RESERVED && \
	$$(HOME)/dev_in_place/scripts/generate_mex_loader_internals "$$(DIR_GLOBAL_MEX_MATLAB)" "$$*" "$$(EXT_MEX)" && \
	$$(MEX) \
		CC=$$(CXX) CXX=$$(CXX) LD=$$(CXX) \
		-v -g -largeArrayDims \
		$$(MEX_FLAGS) \
		-output $$* \
		-outdir $$(DIR_TARGET) \
		$$(DIR_SRC)/$$$$DIR_MEX_RESERVED/mex_loader.cpp \
		$$(DIR_SRC)/$$$$DIR_MEX_RESERVED/mex_main.cpp \
		-I. \
		-I$$(HOME)/dev_in_place/code_aux/cpp/double_layer_mex/h_20150709_1718 \
		-ldl && \
	$$(MEX) \
		CC=$$(CC) CXX=$$(CXX) LD=$$(CXX) \
		-v -g -largeArrayDims \
		$$(MEX_FLAGS) \
		-output $$$$TGT_LOADED \
		-outdir $$(DIR_TARGET) \
		$$< \
		$$(SRC_SUBDIR) \
		-I. \
		$$(DEP_INCLUDE_SUBDIR) \
		$$(DEP_INCLUDE) \
		$$(DEP_LINK)  && \
	patchelf --set-rpath "$$(PATH_LINK)" $$(DIR_TARGET)/$$$$TGT_LOADED.$$(EXT_MEX)
endef

define octave_mex_compile_link_BadSolution
$$(DIR_TARGET)/%.$$(EXT_MEX_OCTAVE) : $$(DIR_SRC)/%.${1} force_look
#
	TGT_LOADED="$$*" && \
		TGT_LOADED+="_Loaded" && \
		DIR_MEX_RESERVED="_reserved_mex_" && \
		DIR_MEX_RESERVED+="$$*" && \
		echo $$* && \
		echo $$$$TGT_LOADED && \
		echo $$$$DIR_MEX_RESERVED && \
	$$(HOME)/dev_in_place/scripts/generate_mex_loader_internals "$$(DIR_GLOBAL_MEX_OCTAVE)" "$$*" "$$(EXT_MEX_OCTAVE)" && \
	export CC=$$(CC) && \
	export CXX=$$(CXX) && \
	export CFLAGS=$$(OCTAVE_MEX_CFLAGS) && \
	export CXXFLAGS=$$(OCTAVE_MEX_CXXFLAGS) && \
	export LDFLAGS=$$(OCTAVE_MEX_LDFLAGS) && \
	$$(OCTAVE_MEX) \
		--output $$(DIR_TARGET)/$$* \
		$$(DIR_SRC)/$$$$DIR_MEX_RESERVED/mex_loader.cpp \
		$$(DIR_SRC)/$$$$DIR_MEX_RESERVED/mex_main.cpp \
		-I. \
		-I$$(HOME)/dev_in_place/code_aux/cpp/double_layer_mex/h_20150709_1718 \
		-ldl && \
	$$(OCTAVE_MEX) \
		--output $$(DIR_TARGET)/$$$$TGT_LOADED \
		$$< \
		$$(SRC_SUBDIR) \
		-I. \
		$$(DEP_INCLUDE_SUBDIR) \
		$$(DEP_INCLUDE) \
		$$(DEP_LINK)  && \
	patchelf --set-rpath "$$(PATH_LINK)" $$(DIR_TARGET)/$$$$TGT_LOADED.$$(EXT_MEX_OCTAVE) && \
	find . -name "*.o" -type f -exec rm -rf {} \;
endef

# extensions
LIST_EXTS := $(LIST_EXTS_LANG_CPP) $(LIST_EXTS_LANG_C)

# subdir includes
DEP_INCLUDE_SUBDIR := $(addprefix -I./,$(DIRS))

# collect sources in subdirs
SRC_SUBDIR :=
$(foreach D,$(DIRS),\
  $(foreach EXT,$(LIST_EXTS),\
    $(eval $(call obtain_src_subdir,$(D),$(EXT)))\
  )\
)

# collect sources in the topmost src dir
SRC :=
$(foreach EXT,$(LIST_EXTS),$(eval $(call obtain_src_topmost,$(EXT))))

# collect all targets
ALL_TGT_MEX        :=
ALL_TGT_MEX_GLOBAL :=
ALL_TGT_MEX_LOADED        :=
ALL_TGT_MEX_LOADED_GLOBAL :=

ifeq ($(FLAG_BUILD_MEX_MATLAB),1)
  ALL_TGT_MEX        +=     $(addprefix $(DIR_TARGET)/,$(addsuffix .$(EXT_MEX),$(basename $(notdir $(SRC)))))
  ALL_TGT_MEX_GLOBAL += $(addprefix $(DIR_GLOBAL_MEX_MATLAB)/,$(addsuffix .$(EXT_MEX),$(basename $(notdir $(SRC)))))
  ALL_TGT_MEX_LOADED        +=     $(addprefix $(DIR_TARGET)/,$(addsuffix _Loaded.$(EXT_MEX),$(basename $(notdir $(SRC)))))
  ALL_TGT_MEX_LOADED_GLOBAL += $(addprefix $(DIR_GLOBAL_MEX_MATLAB)/,$(addsuffix _Loaded.$(EXT_MEX),$(basename $(notdir $(SRC)))))
endif

ifeq ($(FLAG_BUILD_MEX_OCTAVE),1)
  ALL_TGT_MEX        +=     $(addprefix $(DIR_TARGET)/,$(addsuffix .$(EXT_MEX_OCTAVE),$(basename $(notdir $(SRC)))))
  ALL_TGT_MEX_GLOBAL += $(addprefix $(DIR_GLOBAL_MEX_OCTAVE)/,$(addsuffix .$(EXT_MEX_OCTAVE),$(basename $(notdir $(SRC)))))
  ALL_TGT_MEX_LOADED        +=     $(addprefix $(DIR_TARGET)/,$(addsuffix _Loaded.$(EXT_MEX_OCTAVE),$(basename $(notdir $(SRC)))))
  ALL_TGT_MEX_LOADED_GLOBAL += $(addprefix $(DIR_GLOBAL_MEX_OCTAVE)/,$(addsuffix _Loaded.$(EXT_MEX_OCTAVE),$(basename $(notdir $(SRC)))))
endif

# Recipes below

default : reportall mkdirtarget $(ALL_TGT_MEX) cptargets help force_look

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

mkdirtarget : clean force_look
	@mkdir -p $(DIR_TARGET)
	
$(foreach EXT,$(LIST_EXTS),$(eval $(call matlab_mex_compile_link_BadSolution,$(EXT))))
$(foreach EXT,$(LIST_EXTS),$(eval $(call octave_mex_compile_link_BadSolution,$(EXT))))

cptargets : mkdirglobal force_look
	@cp $(DIR_TARGET)/*.$(EXT_MEX)        $(DIR_GLOBAL_MEX_MATLAB)/. 2>/dev/null || true
	@cp $(DIR_TARGET)/*.$(EXT_MEX_OCTAVE) $(DIR_GLOBAL_MEX_OCTAVE)/. 2>/dev/null || true
	
mkdirglobal : force_look
	@mkdir -p $(DIR_GLOBAL_MEX_MATLAB);
	@mkdir -p $(DIR_GLOBAL_MEX_OCTAVE);

realclean : mkdirglobal clean force_look
	@cd $(DIR_GLOBAL_MEX_MATLAB); rm -rf ./*
	@cd $(DIR_GLOBAL_MEX_OCTAVE); rm -rf ./*

allclean :  clean force_look
	@rm -f $(ALL_TGT_MEX_GLOBAL)
	@rm -f $(ALL_TGT_MEX_LOADED_GLOBAL)
	
clean : force_look
# 	@rm -f $(ALL_TGT_MEX)
	@mkdir -p $(DIR_TARGET)
	@cd $(DIR_TARGET); rm -rf ./*
	@find . -name "*.o" -type f -exec rm -rf {} \;
	
include $(HOME)/dev_in_place/makefiles/assigner/makefile_lowermost_kdev.mk
	
help : force_look
	@echo ""
	@echo "RECIPES"
	@echo ""
	@echo "help      - prints this help"
	@echo "default   - reports, makes target dir, makes targets, copies, helps"
	@echo "realclean - cleans global and local dir of all targets"
	@echo "allclean  - cleans global and local dir of only relevant targets"
	@echo "clean     - cleans only local dir of targets"
	@echo "kdev      - cleans and regenerates KDevelop auxilliary fragments"
	@echo "cleankdev - cleans KDevelop fragments"
	@echo ""
	
force_look :
	@true