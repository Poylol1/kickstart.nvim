CONFIG = require 'LSP.LSPconfig'
SOURCES = CONFIG['sources_by_language']
GENERAL = SOURCES['general']

function Concat(table_1, table_2)
  if table_2 == nil then
    error 'this too?'
  end
  local table_3 = table_1
  for i = 1, #table_2, 1 do
    table_3[#table_3 + 1] = table_2[i]
  end
  return table_3
end
return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {

      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      init = function()
        -- Snippets
        require('luasnip.loaders.from_lua').load {
          paths = { '~/.config/nvim/lua/LSP/Snippets' },
        }
      end,
      -- dependencies = {
      --   -- `friendly-snippets` contains a variety of premade snippets.
      --   --    See the README about individual language/framework/plugin snippets:
      --   --    https://github.com/rafamadriz/friendly-snippets
      --   {
      --     'rafamadriz/friendly-snippets',
      --     config = function()
      --       require('luasnip.loaders.from_vscode').lazy_load()
      --     end,
      --   },
      -- },
      unpack(CONFIG['autocomplete_extra_dependencies']),
    },
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-+>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-->'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-Space>'] = cmp.mapping.confirm { select = true },

        -- If you prefer more traditional completion keymaps,
        -- you can uncomment the following lines
        --['<CR>'] = cmp.mapping.confirm { select = true },
        --['<Tab>'] = cmp.mapping.select_next_item(),
        --['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-y>'] = cmp.mapping.complete {},

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      -- add for autocompletion
      sources = cmp.config.sources(GENERAL),
    }
    local function checkPairs(language, sources)
      if language == 'general' then
        return
      end
      cmp.setup.filetype(language, {
        sources = cmp.config.sources(Concat(GENERAL, sources)),
      })
    end

    for language, sources in pairs(SOURCES) do
      checkPairs(language, sources)
    end
    --comment here

    -- Setup lspconfig for nvim-cmp
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    require('lspconfig')['csharp_ls'].setup {
      capabilities = capabilities,
      root_dir = require('lspconfig').util.root_pattern('*.csproj', '*.sln'),
    }
  end,
}
