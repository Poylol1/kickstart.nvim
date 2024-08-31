local M = {}
-- ensured installed LSP servers
-- ../LSP/masonI.lua
M['mason'] = { 'omnisharp', 'pyright', 'tsserver', 'gopls' }

-- ../LSP/autoformatI.lua
M['disable filetypes'] = { c = true, cpp = true }
-- Formatters by ft
M['autoformat'] = {
  lua = { 'stylua' }, -- Conform can also run multiple formatters sequentially python = { 'isort', 'black' },
  -- You can use a sub-list to tell conform to run *until* a formatter
  go = { 'gopls' },
  -- is found.
  csharp = { 'csharpier' },
  javascript = { { 'prettierd', 'prettier' } },
}

-- ../LSP/masonI.lua
M['servers'] = {
  -- clangd = {},
  gopls = {},
  omnisharp = {},
  pyright = {},
  -- rust_analyzer = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`tsserver`) will work just fine
  tsserver = {},
  --
  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = { checkThirdParty = false, library = { '${3rd}/luv/library', unpack(vim.api.nvim_get_runtime_file('', true)) } },
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

--
M['serverFunction'] = function()
  require('lspconfig').omnisharp.setup {}
end

-- ../LSP/treesitterI.lua
M['treesitter_installed'] = 'all'

-- ../LSP/treesitterI.lua
M['treesitter_indent'] = { enable = true, disable = { 'ruby', 'latex', 'gdscript' } }

-- ../LSP/treesitterI.lua
M['treesitter_highlight'] = {
  enable = true,
  disable = { 'tex', 'latex' },
  -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
  --  If you are experiencing weird indenting issues, add the language to
  --  the list of additional_vim_regex_highlighting and disabled languages for indent.
  additional_vim_regex_highlighting = { 'ruby' },
}

M['new_filetypes'] = function()
  vim.filetype.add {
    pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  }
end

M['sources_by_language'] = {
  general = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'vim_lsp' },
    { name = 'git' },
    { name = 'vimtex' },
    { name = 'npm' },
    { name = 'calc' },
    { name = 'buffer' },
    { name = 'treesitter' },
    { name = 'path' },
  },
  markdown = {
    { name = 'latex_symbols' },
  },
  tex = {
    { name = 'vimtex' },
  },
}

M['autocomplete_extra_dependencies'] = {
  'kdheepak/cmp-latex-symbols',
  'hrsh7th/cmp-buffer',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'micangl/cmp-vimtex',
}

return M
