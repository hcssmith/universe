{
  pkgs,
  lib,
  ...
}: {
  utils-module = {
    programs = {
      bat = {
        enable = true;
      };
      eza = {
        enable = true;
        enableZshIntegration = true;
        git = true;
        icons = true;
      };
    };
  };
  git-module = {
    programs.git = {
      enable = true;
      userName = "Hallam Smith";
      userEmail = "me@hcssmith.com";
    };
  };
  kitty-module = {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      font = {
        package = pkgs.fira-code-nerdfont;
        name = "Fira Code";
        size = 10;
      };
      settings = {
        term = "xterm-kitty";
        window_border_width = "0";
        background_opacity = "0.7";
        foreground = "#f8f8f2";
        background = "#282a36";
        selection_foreground = "#ffffff";
        selection_background = "#44475a";
        url_color = "#8be9fd";
        color0 = "#21222c";
        color8 = "#6272a4";
        color1 = "#ff5555";
        color9 = "#ff6e6e";
        color2 = "#50fa7b";
        color10 = "#69ff94";
        color3 = "#f1fa8c";
        color11 = "#ffffa5";
        color4 = "#bd93f9";
        color12 = "#d6acff";
        color5 = "#ff79c6";
        color13 = "#ff92df";
        color6 = "#8be9fd";
        color14 = "#a4ffff";
        color7 = "#f8f8f2";
        color15 = "#ffffff";
        cursor = "#f8f8f2";
        cursor_text_color = "background";
        active_tab_foreground = "#282a36";
        active_tab_background = "#f8f8f2";
        inactive_tab_foreground = "#282a36";
        inactive_tab_background = "#6272a4";
        mark1_foreground = "#282a36";
        mark1_background = "#ff5555";
        active_border_color = "#f8f8f2";
        inactive_border_color = "#6272a4";
      };
    };
  };
  zsh-module = {
    programs.zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      shellAliases = {
        l = "eza";
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza --tree";
        lta = "eza -la --tree";
        cat = "bat";
        srv = "${pkgs.python3}/bin/python -m http.server 8000";
        tbz2 = "tar -xvjf";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "robbyrussell";
      };
    };
  };
  starship-module = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](bg:#030B16 fg:#7DF9AA)"
          "[](bg:#7DF9AA fg:#090c0c)"
          "[](fg:#7DF9AA bg:#1C3A5E)"
          "$time"
          "[](fg:#1C3A5E bg:#3B76F0)"
          "$directory"
          "[](fg:#3B76F0 bg:#FCF392)"
          "$git_branch"
          "$git_status"
          "$git_metrics"
          "[](fg:#FCF392 bg:#282a36)"
          "$character"
        ];
        directory = {
          format = "[ $path ]($style)";
          style = "fg:#E4E4E4 bg:#3B76F0";
        };
        git_branch = {
          format = "[ $symbol$branch(:$remote_branch) ]($style)";
          symbol = "  ";
          style = "fg:#1C3A5E bg:#FCF392";
        };
        git_status = {
          format = "[$all_status]($style)";
          style = "fg:#1C3A5E bg:#FCF392";
        };
        git_metrics = {
          format = "([+$added]($added_style))[]($added_style)";
          added_style = "fg:#1C3A5E bg:#FCF392";
          deleted_style = "fg:bright-red bg:235";
          disabled = false;
        };
        hg_branch = {
          format = "[ $symbol$branch ]($style)";
          symbol = " ";
        };
        cmd_duration = {
          format = "[  $duration ]($style)";
          style = "fg:bright-white bg:18";
        };
        character = {
          success_symbol = "[ ➜](bold green)";
          error_symbol = "[ ✗](#E84D44)";
        };
        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:#1d2230";
          format = "[[ 󱑍 $time ](bg:#1C3A5E fg:#8DFBD2)]($style)";
        };
      };
    };
  };

	sway-module = {
		wayland.windowManager.sway = {
			enable = true;
			config = rec {
				modifier = "Mod4";
				# Use kitty as default terminal
				terminal = "kitty"; 
				startup = [
					# Launch Firefox on start
					{command = "firefox";}
				];
				assigns = {
					"2: web" = [{ class = "^Firefox$"; }];
				};


			};
  	};
	};
}
