# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
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

include $(HOME)/dev_in_place/lib_info/config_system_lib.mk

include $(HOME)/dev_in_place/makefiles/genre/tests/makefile_in_place_tests.mk 