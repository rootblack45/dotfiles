local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
    return
end

local formatting = null_ls.builtins.formatting -- formatting sources
local diagnostics = null_ls.builtins.diagnostics -- diagnostic sources
local code_actions = null_ls.builtins.code_actions -- code_actions sources

local with_root_file = function(...)
    local files = { ... }
    return function(utils)
        return utils.root_has_file(files)
    end
end

null_ls.setup {
    sources = {
        -- formatting
        formatting.clang_format,
        formatting.eslint,
        formatting.prettier,
        formatting.stylua.with {
            condition = with_root_file 'stylua.toml',
        },
        formatting.rustfmt,
        -- diagnostics
        diagnostics.cppcheck,
        diagnostics.hadolint,
        diagnostics.eslint,
        diagnostics.selene.with {
            condition = with_root_file 'selene.toml',
        },
        diagnostics.flake8,
        diagnostics.fish,
        -- code_actions
        code_actions.eslint,
    },
}
