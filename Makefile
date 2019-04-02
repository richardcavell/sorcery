# Makefile
# Sorcery version 1.0
# https://github.com/richardcavell/sorcery

# This is a simple makefile that allows you to create a disk image from this
# BASIC program, and to test that disk image using MAME.

# You should have installed decb from the toolshed - see here:
# https://github.com/boisy/toolshed

# You should have also installed MAME - see here:
# https://mamedev.org

DECBTOOL = decb
MAME     = mame
SORCERY  = SORCERY.BAS
DSKIMAGE = SORCERY.DSK

.DEFAULT: all
.PHONY:   all
all: disk

.PHONY: disk
disk: $(DSKIMAGE)

.PHONY: help
help: info

.PHONY: info
info:
	@echo "Possible targets:"
	@echo "make disk"
	@echo "make info"
	@echo "make mame         # Test the disk with mame coco3"
	@echo "make mame-debug   # Test the disk with mame coco3 -debug"

$(DSKIMAGE): $(SORCERY)
	$(RM) $@
	$(DECBTOOL) dskini $@ -3
	$(DECBTOOL) copy $(SORCERY) -0 -t $(DSKIMAGE),SORCERY.BAS

.PHONY: mame
.PHONY: mame-debug

mame: $(DSKIMAGE)
	@echo "Launching MAME..."
	$(MAME) coco3 -flop1 $(DSKIMAGE) -autoboot_command "RUN \"SORCERY\"\n" -autoboot_delay 2

mame-debug:   $(DSKIMAGE)
	@echo "Launching MAME..."
	$(MAME) coco3 -flop1 $(DSKIMAGE) -autoboot_command "RUN \"SORCERY\"\n" -autoboot_delay 2 -debug


.PHONY:   clean
clean:
	$(RM) $(DSKIMAGE)

