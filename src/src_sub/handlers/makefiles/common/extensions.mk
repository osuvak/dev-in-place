# /*
#  * This file is part of the "dev_in_place" repository located at:
#  * https://github.com/osuvak/dev_in_place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

LIST_EXTS_LANG_CPP := C cc cp cpp CPP cxx c++
LIST_EXTS_LANG_C   := c

EXT_MEX_32 := mexglx
EXT_MEX_64 := mexa64

ARCH := $(shell getconf LONG_BIT)
EXT_MEX := $(EXT_MEX_$(ARCH))
