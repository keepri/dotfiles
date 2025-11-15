---@type vim.lsp.Config
return {
    cmd = { "intelephense", "--stdio" },

    root_markers = {
        ".git",
        "composer.json",
    },

    filetypes = {
        "php",
        "blade",
    },

    init_options = {
        licenceKey = os.getenv("INTELEPHENSE_LICENSE_KEY") or "",
    },

    get_language_id = function (_, filetype)
        if filetype == "blade" then
            return "php";
        end;

        return filetype;
    end,
};
