# /*
#  * This file is part of the "dev_in_place" repository located at:
#  * https://github.com/osuvak/dev_in_place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

DEP_INCLUDE:=
DEP_INCLUDE_RAW:=
DEP_LINK:=
PATH_LINK:=

include $(HOME)/dev_in_place/lib_info/config_lib_matlab_r2015a_b64.mk
include $(HOME)/dev_in_place/lib_info/config_lib_ngspice_02.06.00_20150509_1358.mk
include $(HOME)/dev_in_place/lib_info/config_system_lib.mk

include $(HOME)/dev_in_place/makefiles/genre/mex/makefile_in_place_mex.mk 
