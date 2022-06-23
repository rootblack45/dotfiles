local api, lsp = vim.api, vim.lsp

local lsp_handlers = require 'rootblack45.configs.lsp.handlers'

local capabilities = lsp_handlers.capabilities
capabilities.offsetEncoding = { 'utf-16' }

api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.c', '*.cpp' },
    callback = function()
        lsp.buf.formatting_seq_sync(nil, 3000)
    end,
})

return {
    capabilities = capabilities,
}
