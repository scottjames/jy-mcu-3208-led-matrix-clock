
all: hex

hex: clockmtx.hex

bin: clockmtx.bin

eeprom: clockmtx_eeprom.hex

lst: clockmtx.lst

ISPDEV=/dev/ttyACM0

clean:
	rm -f clockmtx.bin clockmtx.lst clockmtx_eeprom.hex clockmtx.hex clockmtx.elf clockmtx.o

#==============================

clockmtx.o:
	avr-gcc -Os -std=c99 -mmcu=atmega8 -c clockmtx.c

clockmtx.elf: clockmtx.o
	avr-gcc -Os -mmcu=atmega8 -o clockmtx.elf clockmtx.o

clockmtx.lst: clockmtx.elf
	avr-objdump -h -S clockmtx.elf > clockmtx.lst

clockmtx.hex: clockmtx.elf
	avr-objcopy -j .text -j .data -O ihex clockmtx.elf clockmtx.hex

clockmtx.bin: clockmtx.elf
	avr-objcopy -j .text -j .data -O binary clockmtx.elf clockmtx.bin

clockmtx_eeprom.hex: clockmtx.elf
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex clockmtx.elf clockmtx_eeprom.hex

flashtest:
	avrdude  -p m8  -c usbtiny

flashread:
	avrdude  -p m8  -c usbtiny -U flash:r:original.hex:i
	cp original.hex jymcu3208.hex
	chmod 200 jymcu3208.hex

flashwrite: clockmtx.hex
	avrdude  -p m8  -c usbtiny -U flash:w:clockmtx.hex:i



