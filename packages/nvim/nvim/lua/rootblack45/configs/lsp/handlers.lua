local b, fn, api, lsp, cmd, keymap, inspect, diagnostic =
    vim.b, vim.fn, vim.api, vim.lsp, vim.cmd, vim.keymap, vim.inspect, vim.diagnostic

local M = {}

M.setup = function()
    local signs = {
        { name = 'DiagnosticSignError', text = ' ' },
        { name = 'DiagnosticSignWarn', text = ' ' },
        { name = 'DiagnosticSignInformation', text = ' ' },
        { name = 'DiagnosticSignHint', text = '' },
    }
    for _, sign in ipairs(signs) do
        fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
    end

    local border_opts = { border = 'single', focusable = false, scope = 'line' }

    -- global config for diagnostic
    diagnostic.config {
        virtual_text = false, -- disable virtual text
        signs = {
            active = signs, -- show signs
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = border_opts,
    }

    lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, border_opts)

    lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, border_opts)
end

M.on_attach = function(client, bufnr)
    -- enable completion triggered by <c-x><c-o>
    api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- mappings
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    local keymaps = {
        { mode = 'n', lhs = 'gd', rhs = lsp.buf.definition },
        { mode = 'n', lhs = 'K', rhs = lsp.buf.hover },
        { mode = 'n', lhs = 'gi', rhs = lsp.buf.implementation },
        { mode = 'n', lhs = '<C-k>', rhs = lsp.buf.signature_help },
        { mode = 'n', lhs = '<space>wa', rhs = lsp.buf.add_workspace_folder },
        { mode = 'n', lhs = '<space>wr', rhs = lsp.buf.remove_workspace_folder },
        {
            mode = 'n',
            lhs = '<space>wl',
            rhs = function()
                print(inspect(lsp.buf.list_workspace_folders()))
            end,
        },
        { mode = 'n', lhs = '<space>rn', rhs = lsp.buf.rename },
        { mode = 'n', lhs = '<space>ca', rhs = lsp.buf.code_action },
        { mode = 'n', lhs = 'gr', rhs = lsp.buf.references },
        { mode = 'n', lhs = '[d', rhs = diagnostic.goto_prev },
        { mode = 'n', lhs = 'd]', rhs = diagnostic.goto_next },
        {
            mode = 'n',
            lhs = '<space>q',
            rhs = function()
                diagnostic.setqflist { open = true }
            end,
        },
    }
    for _, km in pairs(keymaps) do
        keymap.set(km.mode, km.lhs, km.rhs, bufopts)
    end

    api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
            if not b.diagnostics_pos then
                b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = api.nvim_win_get_cursor(0)
            if
                (cursor_pos[1] ~= b.diagnostics_pos[1] or cursor_pos[2] ~= b.diagnostics_pos[2])
                and #diagnostic.get() > 0
            then
                diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                })
            end

            b.diagnostics_pos = cursor_pos
        end,
    })

    -- set some key bindings conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        keymap.set('n', '<space>f', lsp.buf.formatting_sync, bufopts)
    end
    if client.resolved_capabilities.document_range_formatting then
        keymap.set('x', '<space>f', lsp.buf.range_formatting, bufopts)
    end

    -- the blow command will highlight the current variable and its usages in the buffer
    if client.resolved_capabilities.document_highlight then
        cmd [[
            hi! link LspReferenceRead Visual
            hi! link LspReferenceText Visual
            hi! link LspReferenceWrite Visual
            augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end

    local status_ok, illuminate = pcall(require, 'illuminate')
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
end

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
    return
end

local capabilities = lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
