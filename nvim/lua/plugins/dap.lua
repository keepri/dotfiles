vim.pack.add({
    "https://codeberg.org/mfussenegger/nvim-dap.git",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/nvim-neotest/nvim-nio",

    -- "https://github.com/microsoft/vscode-js-debug",
    -- "https://github.com/mxsdev/nvim-dap-vscode-js",
});

local dap = require("dap");
local ui = require("dapui");
-- local js = require("dap-vscode-js");

ui.setup();

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" });
vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "DAP: Run to Cursor" });

-- eval var under cursor
vim.keymap.set(
    "n",
    "<leader>?",
    function ()
        --- @diagnostic disable-next-line: missing-fields
        ui.eval(nil, { enter = true });
    end,
    { desc = "DAP: Eval" }
);

vim.keymap.set("n", "<F1>", dap.continue, { desc = "DAP: Continue" });
vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP: Step into" });
vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP: Step over" });
vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP: Step out" });
vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP: Step back" });

dap.listeners.before.attach.dapui_config = function ()
    ui.open();
end;
dap.listeners.before.launch.dapui_config = function ()
    ui.open();
end;
dap.listeners.before.event_terminated.dapui_config = function ()
    ui.close();
end;
dap.listeners.before.event_exited.dapui_config = function ()
    ui.close();
end;

-- js.setup({
--     -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--     -- node_path = "node",
--     -- Path to vscode-js-debug installation.
--     -- debugger_path = "~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
--     -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--     debugger_cmd = { "~/.local/share/nvim/mason/packages/js-debug-adapter" },
--     -- which adapters to register in nvim-dap
--     adapters = {
--         "pwa-node",
--         "node-terminal",
--         "pwa-extensionHost",
--     },
--     -- Path for file logging
--     -- log_file_path = "(stdpath cache)/dap_vscode_js.log",
--     -- log_file_level = false,
--     -- Logging level for output to file. Set to false to disable file logging.
--     -- Logging level for output to console. Set to false to disable console output.
--     -- log_console_level = vim.log.levels.ERROR,
-- });

for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            restart = true,
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            address = "localhost",
            port = 9229,
            -- processId = require"dap.utils".pick_process,
            cwd = "${workspaceFolder}",
        },
    };
end;
