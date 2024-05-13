{prev, ...}:
let 
	gum = "${prev.gum}/bin/gum";
	git = "${prev.git}/bin/git";
	xclip = "${prev.xclip}/bin/xclip";
in prev.writeShellScriptBin "prepare-system" ''

${gum} style --bold --underline "Prepare NixOS System for installation."


MACHINE_ID=$(${gum} input --header="Enter Machine ID")




# retrive the universe flake.
#nix flake clone universe -dest ./universe

# generate ssh key
#ssh-keygen -f ~/.ssh/id_rsa -q -N ""

# put public ssh key on screen to be added to github

echo "Add the following SSH key to github (this can be removed after install):\n"

cat ~/.ssh/id_rsa.pub

# y/n confirm done, then update remotes to add ssh based remote


# generate diskio filesystem instructions to universe/machines/$machine/diskio.nix

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

''
