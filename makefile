CC=cl65
EMU=../../x16emur46/x16emu

make:
	$(CC) --cpu 65C02 -Or -Cl -C cx16-zsm-bank.cfg -o ./build/HAUNT.PRG -t cx16 -l HAUNT.list -Ln HAUNT.sym \
	src/main.s

run:
	cd build && \
	$(EMU) -prg HAUNT.PRG -run -debug

emu:
	cd build && \
	$(EMU)

debug:
	cd build && \
	$(EMU) -prg HAUNT.PRG -debug

pal:
	node tools/gimp-pal-convert.js gfx/allgrids.data.pal build/GRIDPAL.BIN

map:
	node tools/ldtk-convert.js
	
zip:
	cd build && \
	rm -f haunt.zip && \
	zip haunt.zip *
