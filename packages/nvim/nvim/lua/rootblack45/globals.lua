local g = vim.g

local globals = {
    loaded_ruby_provider = 0, -- disable ruby provider
    loaded_node_provider = 0, -- disalbe node provider
    loaded_perl_provider = 0, -- disable perl provider
    UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)',
    UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)',
    UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)',
    UltiSnipsListSnippets = '<c-x><c-s>',
    UltiSnipsRemoveSelectModeMappings = 0,
    gruvbox_italic = 1,
    omni_sql_default_compl_type = 'syntax', -- default to static completion for SQL
}

for k, v in pairs(globals) do
    g[k] = v
end
