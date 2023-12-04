# file: Makfile
#
# Makefile for building the flash boot copiers
# dvb 2004
#
# ex:set noexpandtab:

.NOTPARALLEL:

S = @
E = @echo \\\# `date +%Y.%m.%d.%H.%M.%S` ---

PREPROCESS_HACK = 1

OBJ = ./obj

# Just force OBJ to exist.


ifeq ("$(S)","@")
 DASH_S = "-s"
endif


# |
# | The code is fully relocatable. However! You may
# | wish to compile an elf for faux-debugging that
# | claims to be at a particular location (like where
# | your flash or epcs device is). To do this,
# | type "make CODE_BASE=0x<epcs_base>". The assignment
# | here uses it appropriately. dvb2004
# |

ifneq ("$(CODE_BASE)","")
 CODE_BASE_OPT = -Ttext=$(CODE_BASE)
endif

ifneq ("$(EPCS_REGS_BASE)","")
 EPCS_REGS_BASE_OPT = "-DEPCS_REGS_BASE=$(EPCS_REGS_BASE)"
endif

SRECS = \
	boot_loader_cfi.srec \
	boot_loader_epcs.srec \
	boot_loader_epcs_sii_siii_ciii.srec \
	boot_loader_cfi_be.srec \
	boot_loader_epcs_be.srec \
	boot_loader_epcs_sii_siii_ciii_be.srec


ALL_TARGS = \
	$(SRECS) \
	$(OBJ)/boot_loader_cfi.elf \
	$(OBJ)/boot_loader_cfi.objdump \
	$(OBJ)/boot_loader_cfi.nm \
	$(OBJ)/boot_loader_epcs.elf \
	$(OBJ)/boot_loader_epcs.objdump \
	$(OBJ)/boot_loader_epcs.nm \
	$(OBJ)/boot_loader_epcs_sii_siii_ciii.elf \
	$(OBJ)/boot_loader_epcs_sii_siii_ciii.objdump \
	$(OBJ)/boot_loader_epcs_sii_siii_ciii.nm \
	$(OBJ)/boot_loader_cfi_be.elf \
	$(OBJ)/boot_loader_cfi_be.objdump \
	$(OBJ)/boot_loader_cfi_be.nm \
	$(OBJ)/boot_loader_epcs_be.elf \
	$(OBJ)/boot_loader_epcs_be.objdump \
	$(OBJ)/boot_loader_epcs_be.nm \
	$(OBJ)/boot_loader_epcs_sii_siii_ciii_be.elf \
	$(OBJ)/boot_loader_epcs_sii_siii_ciii_be.objdump \
	$(OBJ)/boot_loader_epcs_sii_siii_ciii_be.nm

.PHONY: all
all : $(OBJ)
	$(S) $(MAKE) $(DASH_S) S=$(S) xall

.PHONY: xall
xall : $(ALL_TARGS)
	$(E) "Try \"make clean all S=\" to see more detailed spew."
	$(E) Done

.PHONY: clean
clean :
	$(E) Cleaning up
	$(S) rm -vf $(ALL_TARGS)
	$(S) rm -vf $(OBJ)/*.s
#	$(S) if [ -d $(OBJ) ] ; then rmdir -v $(OBJ) ; fi

.PHONY: install
install : $(SRECS)
ifneq ("$(DEST_PATH)","")
	$(E) Copying $(SRECS)
	$(E) To $(DEST_PATH)
	$(S) cp -f $(SRECS) $(DEST_PATH)
endif

$(OBJ) :
	$(E) Creating $@
	$(S) mkdir -p $@

$(OBJ)/boot_loader_cfi.elf : \
		boot_loader.S \
		boot_loader.h \
		boot_loader_cfi_bits.S \
		$(OBJ)
	$(E) Compiling to $@
ifeq ($(PREPROCESS_HACK),1)
	$(S) nios2-elf-cpp boot_loader.S \
			-o $(OBJ)/boot_loader_for_cfi_pp.s \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_cfi_bits.S \
			-o $(OBJ)/boot_loader_cfi_bits_pp.s \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-gcc -nostdlib \
			$(OBJ)/boot_loader_for_cfi_pp.s \
			$(OBJ)/boot_loader_cfi_bits_pp.s \
			$(CODE_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
else
	$(S) nios2-elf-gcc -nostdlib boot_loader.S boot_loader_cfi_bits.S \
			$(CODE_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
endif

$(OBJ)/boot_loader_epcs.elf : \
		boot_loader.S \
		boot_loader.h \
		boot_loader_epcs_bits.S \
		boot_loader_epcs_bits_cyclone.S \
		$(OBJ)
	$(E) Compiling to $@
ifeq ($(PREPROCESS_HACK),1)
	$(S) nios2-elf-cpp boot_loader.S \
			-o $(OBJ)/boot_loader_for_epcs_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits.S \
			-o $(OBJ)/boot_loader_epcs_bits_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits_cyclone.S \
			-o $(OBJ)/boot_loader_epcs_bits_cyclone_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-gcc -nostdlib \
			$(OBJ)/boot_loader_for_epcs_pp.s \
			$(OBJ)/boot_loader_epcs_bits_pp.s \
			$(OBJ)/boot_loader_epcs_bits_cyclone_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			$(CODE_BASE_OPT) \
			-DEPCS \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
else
	$(S) nios2-elf-gcc -nostdlib boot_loader.S boot_loader_epcs_bits.S boot_loader_epcs_bits_cyclone.S \
			-DEPCS \
			$(CODE_BASE_OPT) \
			$(EPCS_REGS_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
endif

$(OBJ)/boot_loader_epcs_sii_siii_ciii.elf : \
		boot_loader.S \
		boot_loader.h \
		boot_loader_epcs_bits.S \
		boot_loader_epcs_bits_sii_siii_ciii.S \
		$(OBJ)
	$(E) Compiling to $@
ifeq ($(PREPROCESS_HACK),1)
	$(S) nios2-elf-cpp boot_loader.S \
			-o $(OBJ)/boot_loader_for_epcs_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits.S \
			-o $(OBJ)/boot_loader_epcs_bits_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits_sii_siii_ciii.S \
			-o $(OBJ)/boot_loader_epcs_bits_sii_siii_ciii_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-gcc -nostdlib \
			$(OBJ)/boot_loader_for_epcs_pp.s \
			$(OBJ)/boot_loader_epcs_bits_pp.s \
			$(OBJ)/boot_loader_epcs_bits_sii_siii_ciii_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			$(CODE_BASE_OPT) \
			-DEPCS \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
else
	$(S) nios2-elf-gcc -nostdlib boot_loader.S boot_loader_epcs_bits.S boot_loader_epcs_bits_sii_siii_ciii.S \
			-DEPCS \
			$(CODE_BASE_OPT) \
			$(EPCS_REGS_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
endif

$(OBJ)/boot_loader_cfi_be.elf : \
		boot_loader.S \
		boot_loader.h \
		boot_loader_cfi_bits.S \
		$(OBJ)
	$(E) Compiling to $@
ifeq ($(PREPROCESS_HACK),1)
	$(S) nios2-elf-cpp boot_loader.S \
			-o $(OBJ)/boot_loader_for_cfi_pp.s \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_cfi_bits.S \
			-o $(OBJ)/boot_loader_cfi_bits_pp.s \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-gcc -EB -nostdlib \
			$(OBJ)/boot_loader_for_cfi_pp.s \
			$(OBJ)/boot_loader_cfi_bits_pp.s \
			$(CODE_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
else
	$(S) nios2-elf-gcc -EB -nostdlib boot_loader.S boot_loader_cfi_bits.S \
			$(CODE_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
endif

$(OBJ)/boot_loader_epcs_be.elf : \
		boot_loader.S \
		boot_loader.h \
		boot_loader_epcs_bits.S \
		boot_loader_epcs_bits_cyclone.S \
		$(OBJ)
	$(E) Compiling to $@
ifeq ($(PREPROCESS_HACK),1)
	$(S) nios2-elf-cpp boot_loader.S \
			-o $(OBJ)/boot_loader_for_epcs_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits.S \
			-o $(OBJ)/boot_loader_epcs_bits_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits_cyclone.S \
			-o $(OBJ)/boot_loader_epcs_bits_cyclone_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-gcc -EB -nostdlib \
			$(OBJ)/boot_loader_for_epcs_pp.s \
			$(OBJ)/boot_loader_epcs_bits_pp.s \
			$(OBJ)/boot_loader_epcs_bits_cyclone_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			$(CODE_BASE_OPT) \
			-DEPCS \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
else
	$(S) nios2-elf-gcc -EB -nostdlib boot_loader.S boot_loader_epcs_bits.S boot_loader_epcs_bits_cyclone.S \
			-DEPCS \
			$(CODE_BASE_OPT) \
			$(EPCS_REGS_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
endif

$(OBJ)/boot_loader_epcs_sii_siii_ciii_be.elf : \
		boot_loader.S \
		boot_loader.h \
		boot_loader_epcs_bits.S \
		boot_loader_epcs_bits_sii_siii_ciii.S \
		$(OBJ)
	$(E) Compiling to $@
ifeq ($(PREPROCESS_HACK),1)
	$(S) nios2-elf-cpp boot_loader.S \
			-o $(OBJ)/boot_loader_for_epcs_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits.S \
			-o $(OBJ)/boot_loader_epcs_bits_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-cpp boot_loader_epcs_bits_sii_siii_ciii.S \
			-o $(OBJ)/boot_loader_epcs_bits_sii_siii_ciii_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			-DEPCS \
			$(CODE_BASE_OPT)
	$(S) nios2-elf-gcc -EB -nostdlib \
			$(OBJ)/boot_loader_for_epcs_pp.s \
			$(OBJ)/boot_loader_epcs_bits_pp.s \
			$(OBJ)/boot_loader_epcs_bits_sii_siii_ciii_pp.s \
			$(EPCS_REGS_BASE_OPT) \
			$(CODE_BASE_OPT) \
			-DEPCS \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
else
	$(S) nios2-elf-gcc -EB -nostdlib boot_loader.S boot_loader_epcs_bits.S boot_loader_epcs_bits_sii_siii_ciii.S \
			-DEPCS \
			$(CODE_BASE_OPT) \
			$(EPCS_REGS_BASE_OPT) \
			-gdwarf2 -Wa,-gdwarf \
			-o $@
endif

$(OBJ)/%.objdump : $(OBJ)/%.elf $(OBJ)
	$(E) Objdumping $<
	$(S) nios2-elf-objdump -D --source $< > $@

$(OBJ)/%.nm : $(OBJ)/%.elf $(OBJ)
	$(E) Nm-ing $<
	$(S) nios2-elf-nm $< | sort > $@

%.srec : $(OBJ)/%.elf $(OBJ)
	$(E) Creating SREC file $@
	$(S) nios2-elf-objcopy --output-target=srec $< $@

.PHONY: help
help :
	@echo .
	@echo . Here is a typical run-from-RAM command
	@echo . make CODE_BASE=0x1000000 EPCS_REGS_BASE=0x900400 clean all
	@echo .

# end of file
