local opts = function(_, conf)
  conf.defaults.mappings.i = {
    ["<Tab>"] = require("telescope.actions").move_selection_next,
    ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
    ["<C-j>"] = require("telescope.actions").move_selection_next,
    ["<C-k>"] = require("telescope.actions").move_selection_previous,
  }
  conf.defaults.mappings.n = {
    ["<Tab>"] = require("telescope.actions").move_selection_next,
    ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
    ["<C-j>"] = require("telescope.actions").move_selection_next,
    ["<C-k>"] = require("telescope.actions").move_selection_previous,
  }
end

return opts
