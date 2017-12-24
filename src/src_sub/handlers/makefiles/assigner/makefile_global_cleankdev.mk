# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
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