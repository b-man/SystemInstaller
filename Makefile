all: build_installer build_uninstaller

build_installer:
	rm -rf SystemInstaller uRamdisk
	mkimage -A arm -O linux -T ramdisk -C none -d ramdisk.install uRamdisk.install
	mkimage -a 0 -e 0 -A arm -O linux -T multi -C none -n "SystemInstaller kernel/initrd for HP TouchPad" -d uImage:uRamdisk.install SystemInstaller

build_uninstaller:
	rm -rf SystemUninstaller uRamdisk
	mkimage -A arm -O linux -T ramdisk -C none -d ramdisk.uninstall uRamdisk.uninstall
	mkimage -a 0 -e 0 -A arm -O linux -T multi -C none -n "SystemUninstaller kernel/initrd for HP TouchPad" -d uImage:uRamdisk.uninstall SystemUninstaller

.PHONY clean:

clean:
	rm -rf SystemInstaller SystemUninstaller uRamdisk.install uRamdisk.uninstall
