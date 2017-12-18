# /*
#  * This file is part of the "dev_in_place" repository located at:
#  * https://github.com/osuvak/dev_in_place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

NAME_SYMLINK := dev_in_place

# recipes

default : force_look
	@rm -f $(HOME)/$(NAME_SYMLINK)
	@ln -sf `pwd` $(HOME)/$(NAME_SYMLINK)
	
force_look :
	@true