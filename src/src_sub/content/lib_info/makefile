# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

# This makefile tests if the lib_info makefiles work correctly.

include $(HOME)/dev_in_place_content/lib_info/current.mk

DIR_TYPES := $(HOME)/dev_in_place_content/lib_info/$(DIR_LIB_INFO_CURRENT)/types

# # # CHOOSE ONE OF THE BELOW # # #
FILE_TYPE:=core_os_n_c
# FILE_TYPE:=itpp_opencv
# FILE_TYPE:=ngspice
# FILE_TYPE:=simple

include $(DIR_TYPES)/$(FILE_TYPE).mk

default : force_look
	@echo ""
	@echo "DEP_INCLUDE :"
	@echo $(DEP_INCLUDE)
	@echo ""
	@echo "DEP_INCLUDE_RAW :"
	@echo $(DEP_INCLUDE_RAW)
	@echo ""
	@echo "DEP_LINK :"
	@echo $(DEP_LINK)
	@echo ""
	@echo "PATH_LINK :"
	@echo $(PATH_LINK)
	@echo ""

force_look :
	@true
