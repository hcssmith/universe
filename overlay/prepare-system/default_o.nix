{prev, ...}: let
  gum = "${prev.gum}/bin/gum";
  git = "${prev.git}/bin/git";
  xclip = "${prev.xclip}/bin/xclip";
in
  prev.writeShellScriptBin "prepare-system" ''

        main() {
        		FLAKE_BASE=universe

        		${gum} style --bold --underline "Prepare NixOS System for installation."


        		MACHINE_ID=$(${gum} input --header="Enter Machine ID")
        		CONFIG_DIR=$FLAKE_BASE/machines/$MACHINE_ID

        		nix flake clone universe --dest $FLAKE_BASE

        		mkdir -p $CONFIG_DIR

        		#ssh-keygen -f ~/.ssh/id_rsa -q -N ""
        		ssh-keygen -f ./test -q -N ""

        		# if confifirm add to clipboard XCLIP else CAT
        	DONE=0

        	while [ $DONE -eq 0 ];
        	do
        		${gum} confirm "Add sshkey to clipboard?" && cat ./test | ${xclip} -selection clipboard || cat ./test
        		${gum} confirm "Has the SSH Key been added to github?" && DONE=1
        	done


        		# generate diskio filesystem instructions to universe/machines/$machine/diskio.nix

        	${gum} style --bold "Choose the filesystem type to generate:"
        	SYSTEMTYPE=$(${gum} choose "Root on TmpFS" "...")

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
    				DISK_NAME=$(${gum} input --header "Name of disk: /dev/")

    			cat << EOF > $CONFIG_DIR/filesystem.nix
    	{
    	 disko.devices = {
    		disk = {
    nodev = {
      		"/" = {
        		fsType = "tmpfs";
        		mountOptions = [
          		"size=2G"
    			"mode=755"
        		];
      		};
    		};
    		 my-disk = {
    			device = "/dev/$DISK_NAME";
    			type = "disk";
    			content = {
    			 type = "gpt";
    			 partitions = {
    				ESP = {
    				 type = "EF00";
    				 size = "500M";
    				 content = {
    					type = "filesystem";
    					format = "vfat";
    					mountpoint = "/boot";
    				 };
    				};
    				nix = {
    				 size = "60%";
    				 content = {
    					type = "filesystem";
    					format = "ext4";
    					mountpoint = "/nix";
    				 };
    				};
    				home = {
    				 size = "40%";
    				 content = {
    					type = "filesystem";
    					format = "ext4";
    					mountpoint = "/home";
    				 };
    				};
    			 };
    			};
    		 };
    		};
    	 };
    	}
    EOF
                          	}



                          main

  ''
