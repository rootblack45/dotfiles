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

-- local node modules bin dir
local project_node_bin = 'node_modules/.bin'
local local_eslint = project_node_bin .. '/eslint'
local local_prettier = project_node_bin .. '/prettier'

null_ls.setup {
    sources = {
        -- formatting
        formatting.clang_format,
        formatting.eslint.with {
            command = with_root_file(local_eslint) and local_eslint or 'eslint',
        },
        formatting.prettier.with {
            command = with_root_file(local_prettier) and local_prettier or 'eslint',
        },
        formatting.stylua.with {
            condition = with_root_file 'stylua.toml',
        },
        formatting.rustfmt,
        -- diagnostics
        diagnostics.cppcheck,
        diagnostics.hadolint,
        diagnostics.eslint.with {
            command = with_root_file(local_eslint) and local_eslint or 'eslint',
        },
        diagnostics.selene.with {
            condition = with_root_file 'selene.toml',
        },
        diagnostics.flake8,
        diagnostics.fish,
        -- code_actions
        code_actions.eslint.with {
            command = with_root_file(local_eslint) and local_eslint or 'eslint',
        },
    },
}
