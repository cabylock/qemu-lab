KDIR ?= /home/cabylock/Desktop/qemu-lab/linux-5.15.163
obj-m += b3.o
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

.PHONY: all clean
