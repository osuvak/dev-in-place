# /*
#  * This file is part of the "dev_in_place" repository located at:
#  * https://github.com/osuvak/dev_in_place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

# commands and flags
CC     := gcc
CXX    := g++
MEX    := mex

AR      := ar
ARFLAGS := crvs

MAKE    := make
 
CFLAGS     := -fPIC -Wall -Wwrite-strings -Wno-strict-aliasing -Wno-unknown-pragmas -g3 -O0
CXXFLAGS   := $(CFLAGS) -std=c++11

LDFLAGS    := -fPIC -Wall -Wwrite-strings -Wno-strict-aliasing -Wno-unknown-pragmas -g3 -O0
LDCXXFLAGS := $(LDFLAGS) -std=c++11

MEX_FLAGS  := \
	CFLAGS='-D_GNU_SOURCE  -fexceptions -fPIC -fno-omit-frame-pointer -pthread $(CFLAGS) -fopenmp' \
	CXXFLAGS='-ansi -D_GNU_SOURCE -fPIC -fno-omit-frame-pointer -pthread $(CXXFLAGS) -fopenmp' \
	LDFLAGS='$$LDFLAGS $(LDFLAGS) -fopenmp' \
	LDCXXFLAGS='$$LDCXXFLAGS $(LDCXXFLAGS) -fopenmp' \
	COMPFLAGS='$$COMPFLAGS /openmp'
