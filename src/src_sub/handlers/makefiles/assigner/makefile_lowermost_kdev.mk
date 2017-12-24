# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

kdev : prepkdev force_look
	@echo ""
	@echo "*** Ignore Files ***"
	@echo ""
	@echo -e `find . -iname ".kdev_ignore" -type f`
	@echo ""
	@echo "*** Includes ***"
	@echo ""
	@cat .kdev_include_paths
	@echo ""
	
prepkdev : cleankdev force_look
	@rm -f $(HOME)/dir_temp_project
	@ln -sf `pwd` $(HOME)/dir_temp_project
	@$(HOME)/dev_in_place/scripts/write_kdev_includes.pl $(DIRS_DOTTED) $(DEP_INCLUDE_RAW)
	@$(HOME)/dev_in_place/scripts/write_kdev_ignores.pl  `find . -iname "_ignore*" -type d`
	
cleankdev : force_look
	@echo ""
	@echo "Clean - dir  - *.kdev*"
	@find . -iname "*.kdev*"  -type d -exec rm -rf "{}" \;
	@echo "Clean - dir  - *kdev*"
	@find . -iname  "*kdev*"  -type d -exec rm -rf "{}" \;
	@echo "Clean - file - *.kdev*"
	@find . -iname "*.kdev*"  -type f -delete
	@echo "Clean - file - *.kdev_*"
	@find . -iname "*.kdev_*" -type f -delete
	@echo ""