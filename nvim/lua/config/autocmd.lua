-- highlight yank selection
local function highlight_yank_selection()
    vim.api.nvim_create_autocmd("TextYankPost", {
        pattern = "*",
        group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
        callback = function ()
            vim.hl.on_yank();
        end,
    });
end;

local function highlight_word_matches_under_cursor()
    local group = "CurrentWordHighlight";

    local function clear_match()
        if not vim.g.current_word_match_id then
            return nil;
        end;

        pcall(vim.fn.matchdelete, vim.g.current_word_match_id);

        vim.g.current_word_match_id = nil;
    end;

    local function highlight_word()
        local word = vim.fn.expand("<cword>");

        clear_match();

        if word ~= "" then
            local pattern = [[\V\<]] .. word .. [[\>]];
            local match = vim.fn.matchadd(group, pattern);

            vim.g.current_word_match_id = match;
        end;
    end;

    vim.api.nvim_set_hl(0, group, { standout = true });

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        callback = highlight_word,
    });

    vim.api.nvim_create_autocmd("CursorMoved", {
        callback = clear_match,
    });
end;

highlight_yank_selection();
-- highlight_word_matches_under_cursor();
