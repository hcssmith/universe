{pkgs_stable, ...}: {
  plugins.neorg = {
    enable = true;
    package = pkgs_stable.vimPlugins.neorg;
    modules = {
      "core.defaults" = {__empty = null;};
      "core.concealer" = {__empty = null;};
      "core.itero" = {__empty = null;};
      "core.promo" = {__empty = null;};
      "core.dirman" = {
        config = {
          workspaces = {
            notes = "~/notes/";
          };
        };
      };
      "core.keybinds" = {
        config = {
          hook = {
            __raw = ''
              function(keybinds)
                keybinds.remap_event('norg', 'n', keybinds.leader .. 'nd', 'core.qol.todo_items.todo.task_done')
                keybinds.remap_event('norg', 'n', keybinds.leader .. 'nc', 'core.qol.todo_items.todo.task_cycle')
                keybinds.remap_event('norg', 'n', keybinds.leader .. 'nh', 'core.qol.todo_items.todo.task_on_hold')
                keybinds.remap_event('norg', 'n', keybinds.leader .. 'nr', 'core.qol.todo_items.todo.task_recurring')
                keybinds.remap_event('norg', 'n', keybinds.leader .. 'lt', 'core.pivot.toggle-list-type')
              end
            '';
          };
        };
      };
    };
  };
}
