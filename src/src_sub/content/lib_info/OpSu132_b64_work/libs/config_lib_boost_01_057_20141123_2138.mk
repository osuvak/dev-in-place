# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

TMP_DIR         := $(HOME)/sw_inst/lib/boost/01.057_20141123_2138
TMP_DIR_INCLUDE := $(TMP_DIR)/include
TMP_DIR_LIB     := $(TMP_DIR)/lib

TMP_LIB := \
		libboost_atomic.so \
		libboost_chrono.so \
		libboost_container.so \
		libboost_context.so \
		libboost_coroutine.so \
		libboost_date_time.so \
		libboost_filesystem.so \
		libboost_graph.so \
		libboost_iostreams.so \
		libboost_locale.so \
		libboost_log_setup.so \
		libboost_log.so \
		libboost_math_c99f.so \
		libboost_math_c99l.so \
		libboost_math_c99.so \
		libboost_math_tr1f.so \
		libboost_math_tr1l.so \
		libboost_math_tr1.so \
		libboost_prg_exec_monitor.so \
		libboost_program_options.so \
		libboost_random.so \
		libboost_regex.so \
		libboost_serialization.so \
		libboost_signals.so \
		libboost_system.so \
		libboost_thread.so \
		libboost_timer.so \
		libboost_unit_test_framework.so \
		libboost_wave.so \
		libboost_wserialization.so

# 	libboost_python.so

TMP_LIB := $(TMP_LIB:lib%.so=-l%)

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