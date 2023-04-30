-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    use({
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        -- or
        requires = { { 'nvim-lua/plenary.nvim' } }
    })

    use({
        'rebelot/kanagawa.nvim',
        as = 'kanagawa',
        config = function()
            vim.cmd('colorscheme kanagawa')
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    --LSP Stuff
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    })

    -- File Explorer Sidebar
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    }

    use('jose-elias-alvarez/null-ls.nvim')

    use('MunifTanjim/prettier.nvim') -- Setup with null-ls ^
    -- For formatting js/ts

    use({ 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' })

    

    use('numToStr/Comment.nvim')

    use {
        "windwp/nvim-autopairs",
        wants = "nvim-treesitter",
        module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
        config = function()
            require("config.autopairs").setup()
        end,
    }
end)
