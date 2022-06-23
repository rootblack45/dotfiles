local deep_ext = vim.tbl_deep_extend

local lsp_servers = {
    'clangd',
    'cmake',
    'dockerls',
    'eslint',
    'gopls',
    'html',
    'jsonls',
    'tsserver',
    'sumneko_lua',
    'pyright',
    'rust_analyzer',
    'svelte',
    'taplo',
    'tailwindcss',
    'yamlls',
}

local lsp_installer_status_ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not lsp_installer_status_ok then
    return
end

lsp_installer.setup {
    ensure_installed = lsp_servers,
}

local lsp_config_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_config_status_ok then
    return
end

for _, srv in pairs(lsp_servers) do
    local lsp_handlers = require 'rootblack45.configs.lsp.handlers'
    local opts = {
        on_attach = lsp_handlers.on_attach,
        capabilities = lsp_handlers.capabilities,
    }
    local has_custom_opts, custom_opts = pcall(require, 'rootblack45.configs.lsp.settings.' .. srv)
    if has_custom_opts and type(custom_opts) == 'table' then
        opts = deep_ext('force', custom_opts, opts)
    end
    lspconfig[srv].setup(opts)
end
