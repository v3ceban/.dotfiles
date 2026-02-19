require("nvchad.configs.lspconfig").defaults()

-- [1] = unnecessary, [2] = deprecated
local suppressed_ts_diagnostic_tags = { [1] = true, [2] = true }

local servers = {
  bashls = {},
  docker_compose_language_service = {},
  dockerls = {},
  html = {},
  prismals = {},
  jsonls = {},
  clangd = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
  },
  emmet_language_server = {
    filetypes = {
      "css",
      "eruby",
      "html",
      "htmlangular",
      "htmldjango",
      "javascriptreact",
      "less",
      "php",
      "pug",
      "sass",
      "scss",
      "typescriptreact",
    },
  },
  tsgo = {
    handlers = {
      ["textDocument/diagnostic"] = function(err, result, ctx)
        if result and result.items then
          result.items = vim.tbl_filter(function(d)
            if d.tags then
              for _, tag in ipairs(d.tags) do
                if suppressed_ts_diagnostic_tags[tag] then
                  return false
                end
              end
            end
            return true
          end, result.items)
        end
        vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
      end,
    },
  },
  intelephense = {
    init_options = {
      globalStoragePath = ".intelephense",
    },
    settings = {
      intelephense = {
        telemerty = {
          enabled = false,
        },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    },
  },
  cssls = {
    settings = {
      css = {
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          mccabe = {
            threshold = 50,
          },
          pycodestyle = {
            ignore = { "E501", "W503" },
            maxLineLength = 120,
          },
        },
      },
    },
  },
  tailwindcss = {
    filetypes = {
      "aspnetcorerazor",
      "astro",
      "astro-markdown",
      "blade",
      "clojure",
      "css",
      "django-html",
      "edge",
      "eelixir",
      "ejs",
      "elixir",
      "erb",
      "eruby",
      "gohtml",
      "gohtmltmpl",
      "haml",
      "handlebars",
      "hbs",
      "heex",
      "html",
      "html-eex",
      "htmlangular",
      "htmldjango",
      "jade",
      "javascript",
      "javascriptreact",
      "leaf",
      "less",
      "liquid",
      "mdx",
      "mustache",
      "njk",
      "nunjucks",
      "php",
      "postcss",
      "razor",
      "reason",
      "rescript",
      "sass",
      "scss",
      "slim",
      "stylus",
      "sugarss",
      "svelte",
      "templ",
      "twig",
      "typescript",
      "typescriptreact",
      "vue",
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
