KDIR ?= /home/cabylock/Desktop/qemu-lab/linux-5.15.163
PWD := $(shell pwd)
obj-m += hello_multi.o
hello_multi-objs := main.o helper.o
ccflags-y := -I$(PWD)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

.PHONY: all clean
