# BEFORE USING THIS: Check whether drivers/pps/generators/Kconfig indicates that one
# of the dependencies of this is BROKEN. If so then assume that this version of the
# module won't work, if not then check whether the module source in this directory
# matches what the kernel is shipping.
#
# See https://lkml.org/lkml/2011/2/18/310 and assume that while a tentative solution
# has been available since 2017 https://lore.kernel.org/patchwork/patch/760699/
# it has never been applied to the live tree.

MODULE_NAME=pps_gen_parport
MODULE_VERSION=4.19.0

# NOTE: The module source pps_gen_parport.c is pulled straight from the kernel tree
# and is unmodified except for the addition of  MODULE_SOFTDEP("post: parport"); as
# the final line; in principle this could be automated based on the current kernel
# version $(KVERSION) etc.
#
# Before attempting to load this module, remove the lp module to allow it access to
# parport. This can usefully be done by adding /etc/modprobe.d/blacklist-lp.conf or
# similar.
#
# This makefile and the associated dkms.conf are derived from Gunar Schorcht's
# i2c-ch341-usb sources which were conveniently to hand. I profess limited skills
# in this area, and would happily defer to correction from an expert. MarkMLl

DKMS       := $(shell which dkms)
PWD        := $(shell pwd)
KVERSION   := $(shell uname -r)
KERNEL_DIR  = /usr/src/linux-headers-$(KVERSION)/
MODULE_DIR  = /lib/modules/$(KVERSION)

ifneq ($(DKMS),)
MODULE_INSTALLED := $(shell dkms status $(MODULE_NAME))
else
MODULE_INSTALLED =
endif

obj-m       := $(MODULE_NAME).o

$(MODULE_NAME).ko: $(MODULE_NAME).c Makefile
	make -C $(KERNEL_DIR) M=$(PWD) modules

all:
	make -C $(KERNEL_DIR) M=$(PWD) modules

clean:
	make -C $(KERNEL_DIR) M=$(PWD) clean

ifeq ($(DKMS),)  # if DKMS is not installed

install: $(MODULE_NAME).ko
	mkdir -p $(MODULE_DIR)/kernel/drivers/pps/generators
	cp $(MODULE_NAME).ko $(MODULE_DIR)/kernel/drivers/pps/generators
	depmod
        
uninstall:
	modprobe -r $(MODULE_NAME)
	rm -f $(MODULE_DIR)/kernel/drivers/pps/generators/$(MODULE_NAME).ko
	depmod

else  # if DKMS is installed

install: $(MODULE_NAME).ko
ifneq ($(MODULE_INSTALLED),)
	@echo Module $(MODULE_NAME) is installed ... uninstall it first
	@make uninstall
endif
	@dkms install .
        
uninstall:
	modprobe -r $(MODULE_NAME)
ifneq ($(MODULE_INSTALLED),)
	dkms remove -m $(MODULE_NAME) -v $(MODULE_VERSION) --all
	rm -rf /usr/src/$(MODULE_NAME)-$(MODULE_VERSION)
endif

endif  # ifeq ($(DKMS),)

