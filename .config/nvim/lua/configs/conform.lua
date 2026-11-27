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
    go = { "goimports" },
    graphql = { "prettierd" },
    handlebars = { "rustywind", "prettierd" },
    html = { "rustywind", "prettierd" },
    htmlangular = { "rustywind", "prettierd" },
    java = { "clang-format" },
    javascript = { "rustywind", "prettierd" },
    javascriptreact = { "rustywind", "prettierd" },
    json = { "fixjson", "prettierd" },
    jsonc = { "prettierd" },
    less = { "prettierd" },
    lua = { "stylua" },
    markdown = { "prettierd" },
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
    rustywind = {
      condition = function(_, ctx)
        local markers = {
          "node_modules/tailwindcss",
          "tailwind.config.js",
          "tailwind.config.cjs",
          "tailwind.config.mjs",
          "tailwind.config.ts",
        }
        local uses_tailwind = false
        for dir in vim.fs.parents(ctx.filename) do
          if vim.uv.fs_stat(dir .. "/node_modules/prettier-plugin-tailwindcss") then
            return false
          end
          for _, marker in ipairs(markers) do
            uses_tailwind = uses_tailwind or vim.uv.fs_stat(dir .. "/" .. marker) ~= nil
          end
        end
        return uses_tailwind
      end,
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
