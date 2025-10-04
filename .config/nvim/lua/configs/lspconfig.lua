require("nvchad.configs.lspconfig").defaults()

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
  ts_ls = {
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
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
end

vim.lsp.enable(vim.tbl_keys(servers))
