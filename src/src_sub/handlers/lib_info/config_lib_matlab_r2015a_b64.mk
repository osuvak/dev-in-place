# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

TMP_DIR         := $(HOME)/matlab_folder
TMP_DIR_INCLUDE := $(TMP_DIR)/extern/include
 
DEP_INCLUDE_TMP := \
	-I$(TMP_DIR_INCLUDE)
	
# append

DEP_INCLUDE     += $(DEP_INCLUDE_TMP)
DEP_INCLUDE_RAW += $(TMP_DIR_INCLUDE)

undefine TMP_DIR
undefine TMP_DIR_INCLUDE
# undefine TMP_DIR_LIB
# undefine TMP_LIB
# undefine DEP_LINK_TMP
# undefine PATH_LINK_TMP
undefine DEP_INCLUDE_TMP