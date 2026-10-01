KDIR ?= /home/cabylock/Desktop/qemu-lab/linux-5.15.163
PWD := $(shell pwd)
obj-m += provider.o consumer.o
ccflags-y := -I$(PWD)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

.PHONY: all clean
