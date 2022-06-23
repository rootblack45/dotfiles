local api = vim.api

api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
    command = 'EslintFixAll',
})
