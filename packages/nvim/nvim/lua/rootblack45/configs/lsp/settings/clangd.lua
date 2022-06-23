local api, lsp = vim.api, vim.lsp

local lsp_handlers = require 'rootblack45.configs.lsp.handlers'

local capabilities = lsp_handlers.capabilities
capabilities.offsetEncoding = { 'utf-16' }

return {
    capabilities = capabilities,
}
