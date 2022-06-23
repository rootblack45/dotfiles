local keymap = vim.keymap

local status_ok, builtin = pcall(require, 'telescope.builtin')
if not status_ok then
    return
end

local bufopts = { noremap = true, silent = true }
local keymaps = {
    { mode = 'n', lhs = 'ff', rhs = builtin.find_files },
    { mode = 'n', lhs = 'fg', rhs = builtin.live_grep },
    { mode = 'n', lhs = 'fb', rhs = builtin.buffers },
    { mode = 'n', lhs = 'fh', rhs = builtin.help_tags },
}
for _, km in pairs(keymaps) do
    keymap.set(km.mode, km.lhs, km.rhs, bufopts)
end
