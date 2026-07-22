GODOT_PATH := godot


all: linux

linux:
	mkdir -p build/linux_x86_64; $(GODOT_PATH) --headless --export-release Linux "build/linux_x86_64/SV Mod Loader Example Game.x86_64"
