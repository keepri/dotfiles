vim.pack.add({
    {
        src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
        version = vim.version.range("3"),
    },
    -- dependencies
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/3rd/image.nvim",
});

local neotree = require("neo-tree");

neotree.setup({
    -- If a user has a sources list it will replace this one.
    -- Only sources listed here will be loaded.
    -- You can also add an external source by adding it's name to this list.
    -- The name used here must be the same name you would use in a require() call.
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        -- "document_symbols",
    },
    -- Add a blank line at the top of the tree.
    add_blank_line_at_top = false,
    -- Automatically clean up broken neo-tree buffers saved in sessions
    auto_clean_after_session_restore = true,
    -- Close Neo-tree if it is the last window left in the tab
    close_if_last_window = false,
    -- you can choose a specific source `last` here which indicates the last used source
    default_source = "filesystem",
    enable_diagnostics = true,
    enable_git_status = true,
    -- Show markers for files with unsaved changes.
    enable_modified_markers = true,
    -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
    enable_opened_markers = true,
    -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
    enable_refresh_on_write = true,
    -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
    enable_cursor_hijack = false,
    git_status_async = true,
    -- These options are for people with VERY large git repos
    git_status_async_options = {
        -- how many lines of git status results to process at a time
        batch_size = 1000,
        -- delay in ms between batches. Spreads out the workload to let other processes run.
        batch_delay = 10,
        -- How many lines of git status results to process. Anything after this will be dropped.
        max_lines = 10000,
        -- Anything before this will be used. The last items to be processed are the untracked files.
    },
    -- Hide the root node.
    hide_root_node = true,
    -- IF the root node is hidden, keep the indentation anyhow.
    retain_hidden_root_indent = false,
    -- This is needed if you use expanders because they render in the indent.
    -- "trace", "debug", "info", "warn", "error", "fatal"
    log_level = "info",
    -- true, false, "/path/to/file.log", use ':lua require("neo-tree").show_logs()' to show the file
    log_to_file = false,
    -- false = open files in top left window
    open_files_in_last_window = true,
    -- when opening files, do not use windows containing these filetypes or buftypes
    open_files_do_not_replace_types = { "terminal",
        "Trouble", "qf", "edgy" },
    open_files_using_relative_paths = false,
    -- popup_border_style is for input and confirmation dialogs.
    -- Configurtaion of floating window is done in the individual source sections.
    -- "NC" is a special style that works well with NormalNC set
    -- "double", "none", "rounded", "shadow", "single" or "solid"
    popup_border_style = "NC",
    -- in ms, needed for containers to redraw right aligned and faded content
    resize_timer_interval = 500,
    -- set to -1 to disable the resize timer entirely
    -- NOTE: this will speed up to 50 ms for 1 second following a resize
    -- used when sorting files and directories in the tree
    sort_case_insensitive = false,
    -- uses a custom function for sorting files and directories in the tree
    sort_function = nil,
    -- If false, inputs will use vim.ui.input() instead of custom floats.
    use_popups_for_input = true,
    use_default_mappings = true,
    -- source_selector provides clickable tabs to switch between sources.
    source_selector = {
        -- toggle to show selector on winbar
        winbar = false,
        -- toggle to show selector on statusline
        statusline = false,
        -- this will replace the tabs with the parent path
        show_scrolled_off_parent_node = false,
        -- of the top visible node when scrolled down.
        sources = {
            { source = "filesystem" },
            { source = "buffers" },
            { source = "git_status" },
        },
        -- only with `tabs_layout` = "equal", "focus"
        content_layout = "start",
        --                start  : |/ 󰓩 bufname     \/...
        --                end    : |/     󰓩 bufname \/...
        --                center : |/   󰓩 bufname   \/...
        -- start, end, center, equal, focus
        tabs_layout = "equal",
        --             start  : |/  a  \/  b  \/  c  \            |
        --             end    : |            /  a  \/  b  \/  c  \|
        --             center : |      /  a  \/  b  \/  c  \      |
        --             equal  : |/    a    \/    b    \/    c    \|
        --             active : |/  focused tab    \/  b  \/  c  \|
        -- character to use when truncating the tab label
        truncation_character = "…",
        -- nil | int: if int padding is added based on `content_layout`
        tabs_min_width = nil,
        -- this will truncate text even if `text_trunc_to_fit = false`
        tabs_max_width = nil,
        -- can be int or table
        padding = 0,
        -- padding = { left = 2, right = 0 },
        -- can be string or table, see below
        separator = { left = "▏", right = "▕" },
        -- |/  a  \/  b  \/  c  \...
        -- separator = { left = "/", right = "\\", override = nil },
        -- |/  a  \  b  \  c  \...
        -- separator = { left = "/", right = "\\", override = "right" },
        -- |/  a  /  b  /  c  /...
        -- separator = { left = "/", right = "\\", override = "left" },
        -- |/  a  / b:active \  c  \...
        -- separator = { left = "/", right = "\\", override = "active" },
        -- ||  a  |  b  |  c  |...
        -- separator = "|",
        -- set separators around the active tab. nil falls back to `source_selector.separator`
        separator_active = nil,
        show_separator_on_edge = false,
        -- true  : |/    a    \/    b    \/    c    \|
        -- false : |     a    \/    b    \/    c     |
        highlight_tab = "NeoTreeTabInactive",
        highlight_tab_active = "NeoTreeTabActive",
        highlight_background = "NeoTreeTabInactive",
        highlight_separator = "NeoTreeTabSeparatorInactive",
        highlight_separator_active = "NeoTreeTabSeparatorActive",
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function ()
                vim.defer_fn(function ()
                    pcall(function ()
                        require("neo-tree.command").execute({ action = "close" });
                    end);
                end, 50);
            end,
        },
        {
            event = "file_opened",
            handler = function ()
                vim.defer_fn(function ()
                    pcall(function ()
                        require("neo-tree.sources.filesystem").reset_search();
                    end);
                end, 50);
            end,
        },
        {
            event = "file_renamed",
            handler = function (args)
                print(args.source, " renamed to ", args.destination);
            end,
        },
        {
            event = "file_moved",
            handler = function (args)
                print(args.source, " moved to ", args.destination);
            end,
        },
        --  {
        --    event = "neo_tree_buffer_enter",
        --    handler = function()
        --      vim.cmd 'highlight! Cursor blend=100'
        --    end
        --  },
        --  {
        --    event = "neo_tree_buffer_leave",
        --    handler = function()
        --      vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
        --    end
        --  },
        -- {
        --   event = "neo_tree_window_before_open",
        --   handler = function(args)
        --     print("neo_tree_window_before_open", vim.inspect(args))
        --   end
        -- },
        -- {
        --   event = "neo_tree_window_after_open",
        --   handler = function(args)
        --     vim.cmd("wincmd =")
        --   end
        -- },
        -- {
        --   event = "neo_tree_window_before_close",
        --   handler = function(args)
        --     print("neo_tree_window_before_close", vim.inspect(args))
        --   end
        -- },
        -- {
        --   event = "neo_tree_window_after_close",
        --   handler = function(args)
        --     vim.cmd("wincmd =")
        --   end
        -- }
    },
    default_component_configs = {
        container = {
            enable_character_fade = true,
            width = "100%",
            right_padding = 0,
        },
        --diagnostics = {
        --  symbols = {
        --    hint = "H",
        --    info = "I",
        --    warn = "!",
        --    error = "X",
        --  },
        --  highlights = {
        --    hint = "DiagnosticSignHint",
        --    info = "DiagnosticSignInfo",
        --    warn = "DiagnosticSignWarn",
        --    error = "DiagnosticSignError",
        --  },
        --},
        indent = {
            indent_size = 2,
            padding = 1,
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            -- if nil and file nesting is enabled, will enable expanders
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰉖",
            folder_empty_open = "󰷏",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
            -- default icon provider utilizes nvim-web-devicons if available
            provider = function (icon, node, _)
                if node.type == "file" or node.type == "terminal" then
                    local success, web_devicons = pcall(require, "nvim-web-devicons");
                    local name = node.type == "terminal" and "terminal" or node.name;
                    if success then
                        local devicon, hl = web_devicons.get_icon(name);
                        icon.text = devicon or icon.text;
                        icon.highlight = hl or icon.highlight;
                    end;
                end;
            end,
        },
        modified = {
            symbol = "[+] ",
            highlight = "NeoTreeModified",
        },
        name = {
            trailing_slash = false,
            -- Requires `enable_opened_markers = true`.
            highlight_opened_files = true,
            -- Take values in { false (no highlight), true (only loaded),
            -- "all" (both loaded and unloaded)}. For more information,
            -- see the `show_unloaded` config of the `buffers` source.
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
        git_status = {
            -- NOTE: this enables/disables the git status for directory/file information portrayed by the symbols below
            enabled = false,
            symbols = {
                -- Change type
                -- NOTE: you can set any of these to an empty string to not show them
                added = "✚",
                deleted = "✖",
                modified = "",
                renamed = "󰁕",
                -- Status type
                untracked = "",
                ignored = "",
                unstaged = "󰄱",
                staged = "",
                conflict = "",
            },
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
            enabled = true,
            -- width of the column
            width = 12,
            -- min width of window required to show this column
            required_width = 64,
        },
        type = {
            enabled = false,
            -- width of the column
            width = 10,
            -- min width of window required to show this column
            required_width = 110,
        },
        last_modified = {
            enabled = false,
            -- width of the column
            width = 20,
            -- min width of window required to show this column
            required_width = 88,
            -- format string for timestamp (see `:h os.date()`)
            format = "%Y-%m-%d %I:%M %p",
            -- or use a function that takes in the date in seconds and returns a string to display
            --format = require("neo-tree.utils").relative_date, -- enable relative timestamps
        },
        created = {
            enabled = false,
            -- width of the column
            width = 20,
            -- min width of window required to show this column
            required_width = 120,
            -- format string for timestamp (see `:h os.date()`)
            -- or use a function that takes in the date in seconds and returns a string to display
            format = "%Y-%m-%d %I:%M %p",
            -- enable relative timestamps
            --format = require("neo-tree.utils").relative_date,
        },
        symlink_target = {
            enabled = false,
            -- %s will be replaced with the symlink target's path.
            text_format = " ➛ %s",
        },
    },
    renderers = {
        directory = {
            { "indent" },
            { "icon" },
            { "current_filter" },
            {
                "container",
                content = {
                    {
                        "name",
                        zindex = 10,
                    },
                    {
                        "symlink_target",
                        zindex = 10,
                        highlight = "NeoTreeSymbolicLinkTarget",
                    },
                    {
                        "clipboard",
                        zindex = 10,
                    },
                    {
                        "diagnostics",
                        errors_only = true,
                        zindex = 20,
                        align = "right",
                        hide_when_expanded = true,
                    },
                    {
                        "git_status",
                        zindex = 10,
                        align = "right",
                        hide_when_expanded = true,
                    },
                    {
                        "file_size",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "type",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "last_modified",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "created",
                        zindex = 10,
                        align = "right",
                    },
                },
            },
        },
        file = {
            { "indent" },
            { "icon" },
            {
                "container",
                content = {
                    {
                        "name",
                        zindex = 10,
                    },
                    {
                        "symlink_target",
                        zindex = 10,
                        highlight = "NeoTreeSymbolicLinkTarget",
                    },
                    {
                        "clipboard",
                        zindex = 10,
                    },
                    {
                        "bufnr",
                        zindex = 10,
                    },
                    {
                        "modified",
                        zindex = 20,
                        align = "right",
                    },
                    {
                        "diagnostics",
                        zindex = 20,
                        align = "right",
                    },
                    {
                        "git_status",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "file_size",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "type",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "last_modified",
                        zindex = 10,
                        align = "right",
                    },
                    {
                        "created",
                        zindex = 10,
                        align = "right",
                    },
                },
            },
        },
        message = {
            { "indent", with_markers = false },
            { "name", highlight = "NeoTreeMessage" },
        },
        terminal = {
            { "indent" },
            { "icon" },
            { "name" },
            { "bufnr" },
        },
    },
    nesting_rules = {},
    -- Global custom commands that will be available in all sources (if not overridden in `opts[source_name].commands`)
    --
    -- You can then reference the custom command by adding a mapping to it:
    --    globally    -> `opts.window.mappings`
    --    locally     -> `opt[source_name].window.mappings` to make it source specific.
    --
    -- commands = {              |  window {                 |  filesystem {
    --   hello = function()      |    mappings = {           |    commands = {
    --     print("Hello world")  |      ["<C-c>"] = "hello"  |      hello = function()
    --   end                     |    }                      |        print("Hello world in filesystem")
    -- }                         |  }                        |      end
    --
    -- see `:h neo-tree-custom-commands-global`
    -- A list of functions
    commands = {},

    -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
    window = {
        -- possible options. These can also be functions that return these options.
        -- left, right, top, bottom, float, current
        position = "current",
        -- applies to left and right positions
        width = 40,
        -- applies to top and bottom positions
        height = 15,
        -- expand the window when file exceeds the window width. does not work with position = "float"
        auto_expand_width = false,
        -- settings that apply to float position only
        popup = {
            size = {
                height = "80%",
                width = "50%",
            },
            -- 50% means center it
            position = "50%",
            -- format the text that appears at the top of a popup window
            title = function (state)
                return "Neo-tree " .. state.name:gsub("^%l", string.upper);
            end,
            -- you can also specify border here, if you want a different setting from
            -- the global popup_border_style.
        },
        -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
        same_level = false,
        -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
        insert_as = "child",
        -- "child":   Insert nodes as children of the directory under cursor.
        -- "sibling": Insert nodes  as siblings of the directory under cursor.
        -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
        -- You can also create your own commands by providing a function instead of a string.
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            -- disable `nowait` if you have existing combos starting with this char that you want to use
            -- nowait = false,
            ["l"] = "open",
            ["<cr>"] = "open",
            -- expand nested file takes precedence
            -- ["<cr>"] = { "open", config = { expand_nested_files = true } },
            ["h"] = "close_node",
            -- close preview or floating neo-tree window
            ["<esc>"] = "cancel",
            -- ["P"] = {
            --     "toggle_preview",
            --     config = {
            --         use_float = true,
            --         use_image_nvim = false,
            --         -- You can define a custom title for the preview floating window.
            --         title = "Neo-tree Preview",
            --     },
            -- },
            -- ["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
            -- ["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
            -- ["l"] = "focus_preview",
            -- ["S"] = "open_split",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "open_vsplit",
            -- ["sr"] = "open_rightbelow_vs",
            -- ["sl"] = "open_leftabove_vs",
            -- ["s"] = "vsplit_with_window_picker",
            -- ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            -- ["w"] = "open_with_window_picker",
            -- ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            -- ["R"] = "refresh",
            ["%"] = {
                "add",
                -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                config = {
                    -- "none", "relative", "absolute"
                    show_path = "relative",
                },
            },
            -- also accepts the config.show_path and config.insert_as options.
            ["d"] = "add_directory",
            ["D"] = "delete",
            ["R"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ["c"] = "copy",
            -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ["m"] = "move",
            ["e"] = "toggle_auto_expand_width",
            ["q"] = "close_window",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
        },
    },
    filesystem = {
        window = {
            mappings = {
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                -- this was the default until v1.28
                -- ["/"] = "filter_as_you_type",
                -- ["/"] = "fuzzy_finder_directory",
                -- fuzzy sorting using the fzy algorithm
                ["#"] = "fuzzy_sorter",
                -- ["D"] = "fuzzy_sorter_directory",
                ["f"] = "filter_on_submit",
                ["<C-x>"] = "clear_filter",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                -- see `:h neo-tree-file-actions` for options to customize the window.
                ["i"] = "show_file_details",
                ["b"] = "rename_basename",
                ["o"] = {
                    "show_help",
                    nowait = false,
                    config = {
                        title = "Order by",
                        prefix_key = "o",
                    },
                },
                ["oc"] = {
                    "order_by_created",
                    nowait = false,
                },
                ["od"] = {
                    "order_by_diagnostics",
                    nowait = false,
                },
                ["og"] = {
                    "order_by_git_status",
                    nowait = false,
                },
                ["om"] = {
                    "order_by_modified",
                    nowait = false,
                },
                ["on"] = {
                    "order_by_name",
                    nowait = false,
                },
                ["os"] = {
                    "order_by_size",
                    nowait = false,
                },
                ["ot"] = {
                    "order_by_type",
                    nowait = false,
                },
            },
            -- define keymaps for filter popup window in fuzzy_finder_mode
            fuzzy_finder_mappings = {
                ["<down>"] = "move_cursor_down",
                ["<C-n>"] = "move_cursor_down",
                ["<up>"] = "move_cursor_up",
                ["<C-p>"] = "move_cursor_up",
                ["<esc>"] = "close",
            },
        },
        -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
        -- "always" means directory scans are always async.
        -- "never"  means directory scans are never async.
        async_directory_scan = "auto",
        -- "shallow": Don't scan into directories to detect possible empty directory a priori
        -- "deep": Scan into directories to detect empty or grouped empty directories a priori.
        scan_mode = "deep",
        -- true creates a 2-way binding between vim's cwd and neo-tree's root
        bind_to_cwd = true,
        cwd_target = {
            -- sidebar is when position = left or right
            sidebar = "tab",
            -- current is when position = current
            current = "window",
        },
        -- check gitignore status for files/directories when searching
        -- setting this to false will speed up searches, but gitignored
        -- items won't be marked if they are visible.
        -- The renderer section provides the renderers that will be used to render the tree.
        --   The first level is the node type.
        --   For each node type, you can specify a list of components to render.
        --       Components are rendered in the order they are specified.
        --         The first field in each component is the name of the function to call.
        --         The rest of the fields are passed to the function as the "config" argument.
        check_gitignore_in_search = true,
        filtered_items = {
            -- when true, they will just be displayed differently than normal items
            visible = true,
            -- when true, hidden files will be shown if the root folder is otherwise empty
            force_visible_in_empty_folder = false,
            -- when true, the number of hidden items in each folder will be shown as the last entry
            show_hidden_count = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            -- only works on Windows for hidden files/directories
            hide_hidden = false,
            -- hide_by_name = {
            --     ".DS_Store",
            --     "thumbs.db",
            --     "node_modules",
            -- },
            -- uses glob style patterns
            -- hide_by_pattern = {
            --     "*.meta",
            --     -- "*/src/*/tsconfig.json"
            -- },
            -- remains visible even if other settings would normally hide it
            -- always_show = {
            --     ".gitignore",
            -- },
            -- uses glob style patterns
            -- always_show_by_pattern = {
            --     ".env*",
            -- },
            -- remains hidden even if visible is toggled to true, this overrides always_show
            -- never_show = {
            --     ".DS_Store",
            --     "thumbs.db",
            -- },
            -- uses glob style patterns
            -- never_show_by_pattern = {
            --     ".null-ls_*",
            -- },
        },
        -- `false` means it only searches the tail of a path.
        -- `true` will change the filter into a full path
        -- search with space as an implicit ".*", so
        -- `fi init` will match: `./sources/filesystem/init.lua
        -- this is determined automatically, you probably don't need to set it
        find_by_full_path_words = true,
        find_command = "fd",
        -- you can specify extra args to pass to the find command.
        find_args = {
            fd = {
                "--exclude", ".git",
                "--exclude", "node_modules",
                "--exclude", "vendor",
                "--exclude", "dist",
                "--exclude", ".idea",
                "--exclude", "tmp",
            },
        },
        -- or use a function instead of list of strings
        -- find_args = function (cmd, path, search_term, args)
        --     if cmd ~= "fd" then
        --         return args;
        --     end;
        --     -- maybe you want to force the filter to always include hidden files:
        --     table.insert(args, "--hidden");
        --     -- but no one ever wants to see .git files
        --     table.insert(args, "--exclude");
        --     table.insert(args, ".git");
        --     -- or node_modules
        --     table.insert(args, "--exclude");
        --     table.insert(args, "node_modules");
        --     -- here is where it pays to use the function, you can exclude more for
        --     -- short search terms, or vary based on the directory
        --     if string.len(search_term) < 4 and path == "/home/cseickel" then
        --         table.insert(args, "--exclude");
        --         table.insert(args, "Library");
        --     end;
        --     return args;
        -- end,
        -- when true, empty folders will be grouped together
        group_empty_dirs = false,
        -- max number of search results when using filters
        search_limit = 50,
        follow_current_file = {
            -- This will find and focus the file in the active buffer every time
            -- the current file is changed while the tree is open.
            -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            enabled = true,
            leave_dirs_open = true,
        },
        -- "open_current", netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled", netrw left alone, neo-tree does not handle opening dirs
        -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        hijack_netrw_behavior = "open_current",
        -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        use_libuv_file_watcher = false,
    },
    buffers = {
        bind_to_cwd = true,
        follow_current_file = {
            -- This will find and focus the file in the active buffer every time
            -- the current file is changed while the tree is open.
            enabled = true,

            -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            leave_dirs_open = true,
        },
        -- when true, empty directories will be grouped together
        group_empty_dirs = false,
        -- When working with sessions, for example, restored but unfocused buffers
        -- are mark as "unloaded". Turn this on to view these unloaded buffer.
        show_unloaded = false,
        -- when true, terminals will be listed before file buffers
        terminals_first = false,
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["d"] = "buffer_delete",
                ["bd"] = "buffer_delete",
                -- see `:h neo-tree-file-actions` for options to customize the window.
                ["i"] = "show_file_details",
                ["b"] = "rename_basename",
                ["o"] = {
                    "show_help",
                    nowait = false,
                    config = {
                        title = "Order by",
                        prefix_key = "o",
                    },
                },
                ["oc"] = {
                    "order_by_created",
                    nowait = false,
                },
                ["od"] = {
                    "order_by_diagnostics",
                    nowait = false,
                },
                ["om"] = {
                    "order_by_modified",
                    nowait = false,
                },
                ["on"] = {
                    "order_by_name",
                    nowait = false,
                },
                ["os"] = {
                    "order_by_size",
                    nowait = false,
                },
                ["ot"] = {
                    "order_by_type",
                    nowait = false,
                },
            },
        },
    },
    git_status = {
        window = {
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
                -- see `:h neo-tree-file-actions` for options to customize the window.
                ["i"] = "show_file_details",
                ["b"] = "rename_basename",
                ["o"] = {
                    "show_help",
                    nowait = false,
                    config = {
                        title = "Order by",
                        prefix_key = "o",
                    },
                },
                ["oc"] = {
                    "order_by_created",
                    nowait = false,
                },
                ["od"] = {
                    "order_by_diagnostics",
                    nowait = false,
                },
                ["om"] = {
                    "order_by_modified",
                    nowait = false,
                },
                ["on"] = {
                    "order_by_name",
                    nowait = false,
                },
                ["os"] = {
                    "order_by_size",
                    nowait = false,
                },
                ["ot"] = {
                    "order_by_type",
                    nowait = false,
                },
            },
        },
    },
    document_symbols = {
        follow_cursor = false,
        client_filters = "first",
        renderers = {
            root = {
                { "indent" },
                {
                    "icon",
                    default = "C",
                },
                {
                    "name",
                    zindex = 10,
                },
            },
            symbol = {
                {
                    "indent",
                    with_expanders = true,
                },
                {
                    "kind_icon",
                    default = "?",
                },
                {
                    "container",
                    content = {
                        {
                            "name",
                            zindex = 10,
                        },
                        {
                            "kind_name",
                            zindex = 20,
                            align = "right",
                        },
                    },
                },
            },
        },
        window = {
            mappings = {
                ["<cr>"] = "jump_to_symbol",
                ["o"] = "jump_to_symbol",
                -- also accepts the config.show_path and config.insert_as options.
                ["A"] = "noop",
                ["d"] = "noop",
                ["y"] = "noop",
                ["x"] = "noop",
                ["p"] = "noop",
                ["c"] = "noop",
                ["m"] = "noop",
                ["a"] = "noop",
                ["/"] = "filter",
                ["f"] = "filter_on_submit",
            },
        },
        custom_kinds = {
            -- define custom kinds here (also remember to add icon and hl group to kinds)
            -- ccls
            -- [252] = 'TypeAlias',
            -- [253] = 'Parameter',
            -- [254] = 'StaticMethod',
            -- [255] = 'Macro',
        },
        kinds = {
            Unknown = {
                icon = "?",
                hl = "",
            },
            Root = {
                icon = "",
                hl = "NeoTreeRootName",
            },
            File = {
                icon = "󰈙",
                hl = "Tag",
            },
            Module = {
                icon = "",
                hl = "Exception",
            },
            Namespace = {
                icon = "󰌗",
                hl = "Include",
            },
            Package = {
                icon = "󰏖",
                hl = "Label",
            },
            Class = {
                icon = "󰌗",
                hl = "Include",
            },
            Method = {
                icon = "",
                hl = "Function",
            },
            Property = {
                icon = "󰆧",
                hl = "@property",
            },
            Field = {
                icon = "",
                hl = "@field",
            },
            Constructor = {
                icon = "",
                hl = "@constructor",
            },
            Enum = {
                icon = "󰒻",
                hl = "@number",
            },
            Interface = {
                icon = "",
                hl = "Type",
            },
            Function = {
                icon = "󰊕",
                hl = "Function",
            },
            Variable = {
                icon = "",
                hl = "@variable",
            },
            Constant = {
                icon = "",
                hl = "Constant",
            },
            String = {
                icon = "󰀬",
                hl = "String",
            },
            Number = {
                icon = "󰎠",
                hl = "Number",
            },
            Boolean = {
                icon = "",
                hl = "Boolean",
            },
            Array = {
                icon = "󰅪",
                hl = "Type",
            },
            Object = {
                icon = "󰅩",
                hl = "Type",
            },
            Key = {
                icon = "󰌋",
                hl = "",
            },
            Null = {
                icon = "",
                hl = "Constant",
            },
            EnumMember = {
                icon = "",
                hl = "Number",
            },
            Struct = {
                icon = "󰌗",
                hl = "Type",
            },
            Event = {
                icon = "",
                hl = "Constant",
            },
            Operator = {
                icon = "󰆕",
                hl = "Operator",
            },
            TypeParameter = {
                icon = "󰊄",
                hl = "Type",
            },

            -- ccls
            -- TypeAlias = {
            --     icon = " ",
            --     hl = "Type",
            -- },
            -- Parameter = {
            --     icon = " ",
            --     hl = "@parameter",
            -- },
            -- StaticMethod = {
            --     icon = "󰠄 ",
            --     hl = "Function",
            -- },
            -- Macro = {
            --     icon = " ",
            --     hl = "Macro",
            -- },
        },
    },
    example = {
        renderers = {
            custom = {
                { "indent" },
                {
                    "icon",
                    default = "C",
                },
                { "custom" },
                { "name" },
            },
        },
        window = {
            mappings = {
                ["<cr>"] = "toggle_node",
                ["<C-e>"] = "example_command",
                ["d"] = "show_debug_info",
            },
        },
    },
});
