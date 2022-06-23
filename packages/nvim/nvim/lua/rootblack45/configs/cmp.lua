local fn, api, cmd = vim.fn, vim.api, vim.cmd

local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
    return
end

local function t(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup {
    snippet = {
        expand = function(args)
            fn['UltiSnips#Anon'](args.body)
        end,
    },
    mapping = {
        ['<Tab>'] = cmp.mapping {
            c = function()
                if cmp.visible() then
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                elseif fn['UltiSnips#CanJumpForwards']() == 1 then
                    api.nvim_feedkeys(t '<Plug>(ultisnips_jump_forward)', 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if fn['UltiSnips#CanJumpForwards']() == 1 then
                    api.nvim_feedkeys(t '<Plug>(ultisnips_jump_forward)', 'm', true)
                else
                    fallback()
                end
            end,
        },
        ['<S-Tab>'] = cmp.mapping {
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
                elseif fn['UltiSnips#CanJumpBackwards']() == 1 then
                    return api.nvim_feedkeys(t '<Plug>(ultisnips_jump_backward)', 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if fn['UltiSnips#CanJumpBackwards']() == 1 then
                    return api.nvim_feedkeys(t '<Plug>(ultisnips_jump_backward)', 'm', true)
                else
                    fallback()
                end
            end,
        },
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
        ['<C-n>'] = cmp.mapping {
            c = function()
                if cmp.visible() then
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                else
                    api.nvim_feedkeys(t '<Down>', 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                else
                    fallback()
                end
            end,
        },
        ['<C-p>'] = cmp.mapping {
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                else
                    api.nvim_feedkeys(t '<Up>', 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                else
                    fallback()
                end
            end,
        },
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ['<CR>'] = cmp.mapping {
            i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                else
                    fallback()
                end
            end,
        },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer', keyword_length = 4 },
        { name = 'path' },
        { name = 'omni' },
        { name = 'ultisnips' },
    },
    window = {
        completion = {
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -3,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
            local lspkind_status_ok, lspkind = pcall(require, 'lspkind')
            if not lspkind_status_ok then
                return
            end

            local kind = lspkind.cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })

            kind.kind = ' ' .. strings[1] .. ' '
            kind.menu = '    (' .. strings[2] .. ')'

            return kind
        end,
    },
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    sources = {
        { name = 'buffer', option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
    },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
    sources = {
        { name = 'path' },
        { name = 'cmdline' },
    },
})

cmd [[
    highlight! PmenuSel guibg=#282C34 guifg=NONE
    highlight! Pmenu guibg=#22252A guifg=#C5CDD9
    
    highlight! CmpItemAbbrDeprecated gui=strikethrough guibg=NONE guifg=#7E8294
    highlight! CmpItemAbbrMatch gui=bold guibg=NONE guifg=#82AAFF
    highlight! CmpItemAbbrMatchFuzzy gui=bold guibg=NONE guifg=#82AAFF
    highlight! CmpItemMenu gui=italic guibg=NONE guifg=#C792EA
    
    highlight! CmpItemKindField guibg=#B5585F guifg=#EED8DA
    highlight! CmpItemKindProperty guibg=#B5585F guifg=#EED8DA
    highlight! CmpItemKindEvent guibg=#B5585F guifg=#EED8DA
    
    highlight! CmpItemKindText guibg=#9FBD73 guifg=#C3E88D
    highlight! CmpItemKindEnum guibg=#9FBD73 guifg=#C3E88D
    highlight! CmpItemKindKeyword guibg=#9FBD73 guifg=#C3E88D
    
    highlight! CmpItemKindConstant guibg=#D4BB6C guifg=#FFE082
    highlight! CmpItemKindConstructor guibg=#D4BB6C guifg=#FFE082
    highlight! CmpItemKindReference guibg=#D4BB6C guifg=#FFE082
    
    highlight! CmpItemKindFunction guibg=#A377BF guifg=#EADFF0
    highlight! CmpItemKindStruct guibg=#A377BF guifg=#EADFF0
    highlight! CmpItemKindClass guibg=#A377BF guifg=#EADFF0
    highlight! CmpItemKindModule guibg=#A377BF guifg=#EADFF0
    highlight! CmpItemKindOperator guibg=#A377BF guifg=#EADFF0
    
    highlight! CmpItemKindVariable guibg=#7E8294 guifg=#C5CDD9
    highlight! CmpItemKindFile guibg=#7E8294 guifg=#C5CDD9
    
    highlight! CmpItemKindUnit guibg=#D4A959 guifg=#F5EBD9
    highlight! CmpItemKindSnippet guibg=#D4A959 guifg=#F5EBD9
    highlight! CmpItemKindFolder guibg=#D4A959 guifg=#F5EBD9
    
    highlight! CmpItemKindMethod guibg=#6C8ED4 guifg=#DDE5F5
    highlight! CmpItemKindValue guibg=#6C8ED4 guifg=#DDE5F5
    highlight! CmpItemKindEnumMember guibg=#6C8ED4 guifg=#DDE5F5
    
    highlight! CmpItemKindInterface guibg=#58B5A8 guifg=#D8EEEB
    highlight! CmpItemKindColor guibg=#58B5A8 guifg=#D8EEEB
    highlight! CmpItemKindTypeParameter guibg=#58B5A8 guifg=#D8EEEB
]]
