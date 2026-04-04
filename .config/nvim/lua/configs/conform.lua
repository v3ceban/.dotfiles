local options = {
  formatters_by_ft = {
    astro = { "rustywind", "prettierd" },
    bash = { "shfmt" },
    blade = { "rustywind", "prettierd" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    cs = { "clang-format" },
    css = { "rustywind", "prettierd" },
    cuda = { "clang-format" },
    django = { "rustywind", "prettierd" },
    erb = { "rustywind", "prettierd" },
    eruby = { "rustywind", "prettierd" },
    go = { "gofumpt", "golines" },
    graphql = { "prettierd" },
    handlebars = { "rustywind", "prettierd" },
    html = { "rustywind", "prettierd" },
    htmlangular = { "rustywind", "prettierd" },
    java = { "clang-format" },
    javascript = { "rustywind", "prettierd" },
    javascriptreact = { "rustywind", "prettierd" },
    json = { "fixjson", "prettierd" },
    jsonc = { "fixjson", "prettierd" },
    less = { "prettierd" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    mdx = { "prettierd" },
    proto = { "clang-format" },
    python = { "isort", "black" },
    scss = { "rustywind", "prettierd" },
    sh = { "shfmt" },
    svelte = { "rustywind", "prettierd" },
    templ = { "rustywind", "prettierd" },
    typescript = { "rustywind", "prettierd" },
    typescriptreact = { "rustywind", "prettierd" },
    vue = { "rustywind", "prettierd" },
    yaml = { "prettierd" },
    zsh = { "shfmt" },
  },

  formatters = {
    black = {
      prepend_args = {
        "--fast",
      },
    },
    ["goimports-reviser"] = {
      prepend_args = { "-rm-unused" },
    },
    shfmt = {
      prepend_args = {
        "-i",
        "2",
        "-ci",
        "-sr",
      },
    },
  },

  format_on_save = {
    timeout_ms = 2500,
    lsp_format = "fallback",
  },

  default_format_opts = {
    timeout_ms = 2500,
    lsp_format = "fallback",
  },
}

return options
