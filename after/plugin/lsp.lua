local lsp = require('lsp-zero').preset("recommended")
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lsp_config = require('lspconfig')

mason.setup()

mason_lspconfig.setup({
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'tsserver',
        'pylsp',
        'jsonls',
        'yamlls',
        'marksman',
        'dockerls',
        'docker_compose_language_service',
        'eslint',
        'html',
        'sqlls'
    }
})

lsp_config.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server tp recongnize the 'vim' global
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete()
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.lsp.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.lsp.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.lsp.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

local null_ls = require('null-ls')

local group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
    on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
            vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim.get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = async })
                end,
                desc = "[lsp] format on save",
            })
        end

        if client.supports_method('textDocument/rangeFormatting') then
            vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim.get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
})

-- prettier stuff
local prettier = require('prettier')

prettier.setup({
    bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
    filetypes = {
        'css',
        'graphql',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'less',
        'markdown',
        'scss',
        'typescript',
        'typescriptreact',
        'yaml'
    },
    cli_options = {
        arrow_parens = "always",
        bracket_spacing = true,
        bracket_same_line = false,
        embedded_language_formatting = "auto",
        end_of_line = "lf",
        html_whitespace_sensitivity = "css",
        -- jsx_bracket_same_line = false,
        jsx_single_quote = false,
        print_width = 80,
        prose_wrap = "preserve",
        quote_props = "as-needed",
        semi = true,
        single_attribute_per_line = false,
        single_quote = false,
        tab_width = 2,
        trailing_comma = "es5",
        use_tabs = false,
        vue_indent_script_and_style = false,
    }
})
