local fn, cmd = vim.fn, vim.cmd

local packer_bootstrap

-- Automatically install packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    }
    print 'Installing packer close and reopen Neovim...'
    cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float { border = 'rounded' }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- Impatient needs to be setup before any other lua plugin is loaded
    use { 'lewis6991/impatient.nvim', config = [[require 'impatient']] }

    -- Let packer manage itself
    use 'wbthomason/packer.nvim'

    -- All the lua functions I don't want to write twice
    use 'nvim-lua/plenary.nvim'

    -- Auto-completion engine
    use {
        'hrsh7th/nvim-cmp', -- auto-completion engine
        requires = { -- nvim-cmp completion sources
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-omni',
            {
                'quangnguyen30192/cmp-nvim-ultisnips',
                requires = {
                    { 'SirVer/ultisnips', event = 'InsertEnter' },
                    'honza/vim-snippets',
                },
            },
            { 'onsails/lspkind-nvim', event = 'VimEnter' },
        },
        config = [[require 'rootblack45.configs.cmp']],
    }

    -- Configurations for Nvim LSP
    use {
        'neovim/nvim-lspconfig',
        after = 'cmp-nvim-lsp', -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
        requires = {
            'williamboman/nvim-lsp-installer',
            'RRethy/vim-illuminate',
            { 'jose-elias-alvarez/null-ls.nvim', after = 'plenary.nvim' },
        },
        config = [[require 'rootblack45.configs.lsp']],
    }
    use 'b0o/schemastore.nvim'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = [[require 'rootblack45.configs.treesitter']],
        event = 'BufEnter',
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        after = 'plenary.nvim',
        config = [[require 'rootblack45.configs.telescope']],
    }

    -- Colorscheme
    use {
        'npxbr/gruvbox.nvim',
        config = [[require 'rootblack45.configs.theme']],
    }

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = [[require 'rootblack45.configs.lualine']],
    }

    -- Discord Rich Presence
    use 'andweeb/presence.nvim'

    -- GitHub Copilot
    use 'github/copilot.vim'

    -- Wakatime
    use 'wakatime/vim-wakatime'

    -- automatically set up your configuration after cloning packer.nvim
    -- ** put this at the end after all plugins **
    if packer_bootstrap then
        require('packer').sync()
    end
end)
