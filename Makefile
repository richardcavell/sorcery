# Makefile
# Sorcery version 1.3
# https://github.com/richardcavell/sorcery

# This is a simple makefile that allows you to create a disk image from the
# accompanying BASIC program, and to test that disk image using MAME or XRoar.

# You should have installed decb from the toolshed - see here:
# https://github.com/boisy/toolshed

# You should have also installed MAME - see here:
# https://mamedev.org

# or XRoar - see here:
# https://www.6809.org.uk/xroar

DECBTOOL = decb
MAME     = mame
XROAR    = xroar
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
	@echo "This makefile was written by Richard Cavell"
	@echo "https://github.com/richardcavell/sorcery"
	@echo
	@echo "Your options are:"
	@echo "make disk"
	@echo "make info"
	@echo "make mame         # Test the disk with mame coco3"
	@echo "make mame-debug   # Test the disk with mame coco3 -debug"
	@echo "make xroar        # Test the disk with XRoar"

$(DSKIMAGE): $(SORCERY)
	$(RM) $@
	$(DECBTOOL) dskini $@ -3
	$(DECBTOOL) copy $(SORCERY) -0 -r -t $(DSKIMAGE),SORCERY.BAS

.PHONY: mame
.PHONY: mame-debug

mame: $(DSKIMAGE)
	@echo "Launching MAME..."
	$(MAME) coco3 -flop1 $(DSKIMAGE) -autoboot_command "RUN \"SORCERY\"\n" -autoboot_delay 2

mame-debug: $(DSKIMAGE)
	@echo "Launching MAME..."
	$(MAME) coco3 -flop1 $(DSKIMAGE) -autoboot_command "RUN """SORCERY"""\n" -autoboot_delay 2 -debug

.PHONY: xroar

xroar: $(DSKIMAGE)
	@echo "Launching XRoar..."
	$(XROAR) -m coco3 -load-fd0 $(DSKIMAGE) -type "RUN \"SORCERY\"\r"

.PHONY: clean
clean:
	$(RM) $(DSKIMAGE)
