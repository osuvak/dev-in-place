# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
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

OCTAVE_MEX := mkoctfile --mex

AR      := ar
ARFLAGS := crvs

MAKE    := make
 
CFLAGS     := -fPIC -fopenmp -Wall -Wwrite-strings -Wno-strict-aliasing -Wno-unknown-pragmas -g3 -O0
CXXFLAGS   := $(CFLAGS) -std=c++11

LDFLAGS    := -fPIC -fopenmp -Wall -Wwrite-strings -Wno-strict-aliasing -Wno-unknown-pragmas -g3 -O0
LDCXXFLAGS := $(LDFLAGS) -std=c++11

MEX_FLAGS  := \
	CFLAGS='-D_GNU_SOURCE  -fexceptions -fPIC -fno-omit-frame-pointer -pthread $(CFLAGS) -fopenmp' \
	CXXFLAGS='-ansi -D_GNU_SOURCE -fPIC -fno-omit-frame-pointer -pthread $(CXXFLAGS) -fopenmp' \
	LDFLAGS='$$LDFLAGS $(LDFLAGS) -fopenmp' \
	LDCXXFLAGS='$$LDCXXFLAGS $(LDCXXFLAGS) -fopenmp' \
	COMPFLAGS='$$COMPFLAGS /openmp'
	
OCTAVE_MEX_CFLAGS     := "-fexceptions -fPIC -fno-omit-frame-pointer -pthread $(CFLAGS) -fopenmp"
OCTAVE_MEX_CXXFLAGS   := "-ansi -D_GNU_SOURCE -fPIC -fno-omit-frame-pointer -pthread $(CXXFLAGS) -fopenmp"
OCTAVE_MEX_LDFLAGS    := "$(LDFLAGS) -fopenmp"
OCTAVE_MEX_LDCXXFLAGS := "$(LDCXXFLAGS) -fopenmp"
