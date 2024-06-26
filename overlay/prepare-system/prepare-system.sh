#!/usr/bin/bash

main() {
	FLAKE_BASE=universe

	gum style --bold --underline "Prepare NixOS System for installation."

	MACHINE_ID=$(gum input --header="Enter Machine ID")
	CONFIG_DIR=$FLAKE_BASE/machines/$MACHINE_ID

	nix flake clone universe --dest $FLAKE_BASE

	mkdir -p "$CONFIG_DIR"

	#ssh-keygen -f ~/.ssh/id_rsa -q -N ""
	ssh-keygen -f ./test -q -N ""

	# if confifirm add to clipboard XCLIP else CAT
	DONE=0

	while [ $DONE -eq 0 ]; do
		gum confirm "Add sshkey to clipboard?" && xclip -selection clipboard < ./test || cat ./test
		gum confirm "Has the SSH Key been added to github?" && DONE=1
	done

	# generate diskio filesystem instructions to universe/machines/$machine/diskio.nix

	gum style --bold "Choose the filesystem type to generate:"
	SYSTEMTYPE=$(gum choose "Root on TmpFS" "...")

	case $SYSTEMTYPE in
	"Root on TmpFS")
		root_on_tmpfs
		;;
	esac
	# run diskio
	# mount filesystem
	# generate hardware config
	# extract filesystem to universe/machines/$machine/filesystems.nix
	# extract everything else to universe/machines/$machine/hardware.nix
	# create new host entry in universe/machines/$machine/host.nix
	# y/n confirm for common options (sound / packages / gui env / etc
	# add call to nixosConfigurations in universe/flake.nix for mkHost (import universe/machines/$machine/host.nix)
	# open flake for editing, use nvim if avalailable, else nix run universe#nvim
	# on close call nixos-install --flake universe#machine

}

root_on_tmpfs() {
	DISK_NAME=$(gum input --header "Name of disk: /dev/")
	export DISK_NAME
	envsubst root-on-tmpfs-template.nix > test.nix

	DISK_NAME=
}

main
