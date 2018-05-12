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
include $(DIR_ABS_LIBS)/config_lib_itpp_04.03.01_20150330_1447.mk
include $(DIR_ABS_LIBS)/config_lib_opencv_02.04.10_20150510_2323.mk
include $(DIR_ABS_LIBS)/config_lib_fftw_03.03.04_20141128_1922.mk
include $(DIR_ABS_LIBS)/config_lib_acml_5_3_1_gfortran_64bit.mk
# include $(DIR_ABS_LIBS)/.mk
include $(DIR_ABS_LIBS)/config_system_lib.mk

undefine DIR_ABS_LIBS