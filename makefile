uefi_boot_img:
	x86_64-w64-mingw32-gcc -ffreestanding -Iuefi_devl/inc -Iuefi_devl/inc/x86_64 -Iuefi_devl/inc/protocol -c -o bin/UEFIBootloader.o boot/uefi_boot.cpp
	x86_64-w64-mingw32-gcc -ffreestanding -Iuefi_devl/inc -Iuefi_devl/inc/x86_64 -Iuefi_devl/inc/protocol -c -o bin/UEFIBootloaderData.o uefi_devl/lib/data.c
	x86_64-w64-mingw32-gcc -nostdlib -Wl,-dll -shared -Wl,--subsystem,10 -e efi_main -o bin/BOOTX64.EFI bin/UEFIBootloader.o bin/UEFIBootloaderData.o -lgcc
	dd if=/dev/zero of=bin/fat.img bs=1k count=1440
	mformat -i bin/fat.img -f 1440 ::
	mmd -i bin/fat.img ::/EFI
	mmd -i bin/fat.img ::/EFI/BOOT
	mcopy -i bin/fat.img bin/BOOTX64.EFI ::/EFI/BOOT

uefi_run:
	qemu-system-x86_64 -L bin/ -bios OVMF.fd -hda bin/fat.img
