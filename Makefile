all: gen_images build_installer build_uninstaller

gen_images:
	dd if=/dev/zero of=ramdisk.install bs=1024 count=0 seek=13312
	dd if=/dev/zero of=ramdisk.uninstall bs=1024 count=0 seek=13312
	mke2fs -Fvm0 ./ramdisk.install
	mke2fs -Fvm0 ./ramdisk.uninstall
	mkdir ./img
	mount -t ext2 -o loop ./ramdisk.install ./img
	tar -zxvpf src/ramdskfs.tar.gz -C ./img/
	cp -apv src/S90stage1-partition ./img/etc/init.d/
	cp -apv src/S99stage2-install ./img/etc/init.d/
	cp -apv src/installer-defaults ./img/etc/
	umount ./img
	mount -t ext2 -o loop ./ramdisk.uninstall ./img
	tar -zxvpf src/ramdskfs.tar.gz -C ./img/
	cp -apv src/S90stage1-uninstall ./img/etc/init.d/
	cp -apv src/installer-defaults ./img/etc/
	umount ./img

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
	rm -rf SystemInstaller SystemUninstaller uRamdisk.install uRamdisk.uninstall ramdisk.install ramdisk.uninstall img
