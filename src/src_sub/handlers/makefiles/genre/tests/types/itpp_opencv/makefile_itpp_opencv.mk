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

include $(HOME)/dev_in_place/lib_info/config_lib_itpp_04.03.01_20150330_1447.mk
include $(HOME)/dev_in_place/lib_info/config_lib_opencv_02.04.10_20150510_2323.mk
include $(HOME)/dev_in_place/lib_info/config_lib_fftw_03.03.04_20141128_1922.mk
include $(HOME)/dev_in_place/lib_info/config_lib_acml_5_3_1_gfortran_64bit.mk
# include $(HOME)/dev_in_place/lib_info/.mk
include $(HOME)/dev_in_place/lib_info/config_system_lib.mk

include $(HOME)/dev_in_place/makefiles/genre/tests/makefile_in_place_tests.mk 
