# Needs to define KERNELDIR, TARGET_ARCH, LOCAL_TOOLCHAIN, LOCAL_COMPILER
-include local.cfg

PWD := $(shell pwd)

modules:
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) modules_install

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions

.PHONY: modules modules_install clean

obj-m += sja1110.o

sja1110-y := sja1110_init.o
