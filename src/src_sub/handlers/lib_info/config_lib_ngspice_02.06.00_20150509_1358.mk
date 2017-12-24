# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

TMP_DIR          := $(HOME)/sw_temp/ngspice_02.06.00_20150509_1358/ngspice-26_install
TMP_DIR_INCLUDE  := $(TMP_DIR)/share/ngspice/include
TMP_DIR_LIB      := $(TMP_DIR)/lib64

TMP_LIB :=  \
		-lngspice
		
DEP_LINK_TMP := \
	-L$(TMP_DIR_LIB) $(TMP_LIB)
	
PATH_LINK_TMP := \
	$(TMP_DIR_LIB)
	
DEP_INCLUDE_TMP := \
	-I$(TMP_DIR_INCLUDE)
	
# append

DEP_INCLUDE     += $(DEP_INCLUDE_TMP)
DEP_INCLUDE_RAW += $(TMP_DIR_INCLUDE)
DEP_LINK        += $(DEP_LINK_TMP)

PATH_LINK:=$(PATH_LINK):$(PATH_LINK_TMP)

undefine TMP_DIR
undefine TMP_DIR_INCLUDE
undefine TMP_DIR_LIB
undefine TMP_LIB
undefine DEP_LINK_TMP
undefine PATH_LINK_TMP
undefine DEP_INCLUDE_TMP