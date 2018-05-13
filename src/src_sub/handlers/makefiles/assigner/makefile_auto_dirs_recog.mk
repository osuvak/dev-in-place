# get list of directories
DIR_ALL_RAW := $(sort $(dir $(wildcard ./*/)))
DIR_ALL_RAW := $(filter-out ./,$(DIR_ALL_RAW))
DIR_ALL_RAW := $(patsubst %/,%,$(DIR_ALL_RAW))
DIR_ALL_RAW := $(notdir $(DIR_ALL_RAW))

DIR_ELIMINATED := $(sort $(dir $(wildcard ./_ignore*/)))
DIR_ELIMINATED += $(sort $(dir $(wildcard ./_reserved_mex*/)))
DIR_ELIMINATED := $(filter-out ./,$(DIR_ELIMINATED))
DIR_ELIMINATED := $(patsubst %/,%,$(DIR_ELIMINATED))
DIR_ELIMINATED := $(notdir $(DIR_ELIMINATED))

DIR_ALL := $(filter-out $(DIR_ELIMINATED),$(DIR_ALL_RAW))
DIRS    := $(DIR_ALL)

DIRS_DOTTED := $(addprefix ./,$(DIRS)) 
