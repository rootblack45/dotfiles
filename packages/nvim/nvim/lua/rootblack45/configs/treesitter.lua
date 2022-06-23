local api = vim.api

local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    return
end

configs.setup {
    ensure_installed = {
        'c',
        'cpp',
        'cmake',
        'dockerfile',
        'go',
        'html',
        'json',
        'javascript',
        'typescript',
        'lua',
        'python',
        'rust',
        'svelte',
        'toml',
        'css',
        'scss',
        'yaml',
        'vim',
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = function(_, bufnr)
            return api.nvim_buf_line_count(bufnr) > 5000
        end,
    },
}
