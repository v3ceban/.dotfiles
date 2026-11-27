local M = {}

M.setup = function()
  require("nvim-ts-autotag").setup()
end

M.ft = {
  "astro",
  "blade",
  "eruby",
  "glimmer",
  "handlebars",
  "hbs",
  "heex",
  "html",
  "htmlangular",
  "htmldjango",
  "javascript",
  "javascriptreact",
  "liquid",
  "markdown",
  "php",
  "rescript",
  "svelte",
  "templ",
  "twig",
  "typescript",
  "typescriptreact",
  "vue",
  "xml",
}

return M
