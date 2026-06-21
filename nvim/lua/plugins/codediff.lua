vim.pack.add({
    "https://github.com/esmuellert/codediff.nvim",
    -- dependencies
    "https://github.com/MunifTanjim/nui.nvim",
});

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function ()
        vim.keymap.del("n", "<leader>gd");
        vim.keymap.set("n", "<leader>gd", ":CodeDiff<CR>", { desc = "Toggle CodeDiff" });
    end,
});

local diff = require("codediff");

diff.setup({
    -- Highlight configuration
    highlights = {
        line_insert = "DiffAdd",
        line_delete = "DiffDelete",
        char_insert = nil,
        char_delete = nil,
        char_brightness = nil,
    },

    -- Diff view behavior
    diff = {
        layout = "side-by-side",
        disable_inlay_hints = true,
        max_computation_time_ms = 5000,
        cycle_next_hunk = true,
        cycle_next_file = true,
        jump_to_first_change = true,
        highlight_priority = 100,
        compute_moves = false,
    },

    -- Explorer panel configuration
    explorer = {
        position = "bottom",
        width = 34,
        height = 8,
        auto_refresh = true,
        indent_markers = true,
        initial_focus = "explorer",
        icons = {
            folder_closed = "",
            folder_open = "",
        },
        view_mode = "list",
        flatten_dirs = true,
        file_filter = {
            ignore = { ".git/**", ".jj/**" },
        },
        visible_groups = {
            staged = true,
            unstaged = true,
            conflicts = true,
        },
    },

    -- History panel configuration (for :CodeDiff history)
    history = {
        position = "bottom",
        width = 40,
        height = 15,
        initial_focus = "history",
        view_mode = "list",
    },

    -- Keymaps in diff view
    keymaps = {
        view = {
            quit = "q",
            toggle_explorer = "<leader>b",
            focus_explorer = "<leader>e",
            next_hunk = "]c",
            prev_hunk = "[c",
            next_file = "]f",
            prev_file = "[f",
            diff_get = "do",
            diff_put = "dp",
            toggle_stage = "-",
            stage_hunk = "<leader>hs",
            unstage_hunk = "<leader>hu",
            discard_hunk = "<leader>hr",
            hunk_textobject = "ih",
            show_help = "g?",
            align_move = "gm",
            toggle_layout = "t",
            toggle_compact = "gc",
        },
        explorer = {
            select = "<CR>",
            hover = "K",
            refresh = "R",
            toggle_view_mode = "i",
            stage_all = "S",
            unstage_all = "U",
            restore = "X",
            toggle_changes = "gu",
            toggle_staged = "gs",
            fold_open = "zo",
            fold_open_recursive = "zO",
            fold_close = "zc",
            fold_close_recursive = "zC",
            fold_toggle = "za",
            fold_toggle_recursive = "zA",
            fold_open_all = "zR",
            fold_close_all = "zM",
        },
        history = {
            select = "<CR>",
            toggle_view_mode = "i",
            refresh = "R",
            fold_open = "zo",
            fold_open_recursive = "zO",
            fold_close = "zc",
            fold_close_recursive = "zC",
            fold_toggle = "za",
            fold_toggle_recursive = "zA",
            fold_open_all = "zR",
            fold_close_all = "zM",
        },
    },
});
