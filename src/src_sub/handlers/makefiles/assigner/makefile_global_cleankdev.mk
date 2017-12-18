# /*
#  * This file is part of the "dev_in_place" repository located at:
#  * https://github.com/osuvak/dev_in_place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

cleankdev : force_look
	@rm -rf ~/.kde4/share/apps/kdevelop
	@rm -rf ~/.cache/kdevduchain
	@cd ~/.kde4/share/apps; find . -wholename "./kdev*"  -type d -exec rm -rf "{}" \;
	@set -o pipefail -e; \
	for d in $(DIRS); do cd $$d && $(MAKE) cleankdev && cd ..; done
