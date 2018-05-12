# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

include $(HOME)/dev_in_place_content/lib_info/current.mk

DEP_INCLUDE:=
DEP_INCLUDE_RAW:=
DEP_LINK:=
PATH_LINK:=

DIR_ABS_LIBS := $(HOME)/dev_in_place_content/lib_info/$(DIR_LIB_INFO_CURRENT)/libs

include $(DIR_ABS_LIBS)/config_lib_matlab_r2015a_b64.mk
include $(DIR_ABS_LIBS)/config_lib_ngspice_02.06.00_20150509_1358.mk
include $(DIR_ABS_LIBS)/config_system_lib.mk

undefine DIR_ABS_LIBS