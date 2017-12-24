# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

TMP_DIR_LIB     := $(HOME)/sw_inst/lib/acml/acml-5-3-1-gfortran-64bit/gfortran64/lib

TMP_LIB :=  \
	-lacml

# compile and link dependencies
DEP_LINK_TMP := \
	-L$(TMP_DIR_LIB) $(TMP_LIB)
	
PATH_LINK_TMP := \
	$(TMP_DIR_LIB)

# append

# DEP_INCLUDE     +=
# DEP_INCLUDE_RAW +=
DEP_LINK        += $(DEP_LINK_TMP)

PATH_LINK:=$(PATH_LINK):$(PATH_LINK_TMP)

# undefine TMP_DIR
# undefine TMP_DIR_INCLUDE
undefine TMP_DIR_LIB
undefine TMP_LIB
undefine DEP_LINK_TMP
undefine PATH_LINK_TMP
# undefine DEP_INCLUDE_TMP