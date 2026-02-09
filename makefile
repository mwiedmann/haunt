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
	node tools/gimp-pal-convert.js gfx/tiles.data.pal build/PAL.BIN
	node tools/gimp-pal-convert.js gfx/title.data.pal build/TITLEPAL.BIN

img:
	node tools/gimp-img-convert.js gfx/tiles.data build/TILES.BIN 16 16 12 0 12 19
	node tools/gimp-img-convert.js gfx/tiles.data build/TORCH.BIN 16 16 12 228 4 1
	node tools/gimp-img-convert.js gfx/title.data build/TITLE.BIN 320 240 1 0 1 1

map:
	node tools/ldtk-convert.js

ui:
	node tools/ui.js
	
calc:
	node tools/calcall.js
	
zip:
	cd build && \
	rm -f haunt.zip && \
	zip haunt.zip *
