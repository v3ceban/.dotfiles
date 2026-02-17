return {
  {
    "tpope/vim-abolish",
    cmd = { "Abolish", "Subvert" },
    keys = { "cr" },
  },
  -- experimental nvchad blink integration
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    opts = require "configs.blink",
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require "configs.cmp"
    end,
  },
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    config = true,
    opts = require("configs.claudecode").opts,
    keys = require("configs.claudecode").keys,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "github/copilot.vim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Copilot" },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = require "configs.flash",
  },
  {
    "v3ceban/git-conflict.nvim",
    event = "VeryLazy",
    config = require "configs.git-conflict",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = require "configs.indent-blankline",
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "airblade/vim-matchquote",
    keys = { "%" },
  },
  {
    "antonk52/markdowny.nvim",
    ft = { "markdown", "copilot-chat" },
    config = function()
      require("markdowny").setup()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = require("configs.nvim-tree").opts,
    keys = require("configs.nvim-tree").keys,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "copilot-chat" },
    opts = require "configs.render-markdown",
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = require "configs.snacks",
  },
  {
    "christoomey/vim-sort-motion",
    keys = {
      { "gs", mode = { "n", "v" } },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    keys = {
      { "cs", mode = { "n" } },
      { "ds", mode = { "n" } },
      { "ys", mode = { "n" } },
      { "s", mode = { "v", "x" } },
    },
    config = function()
      return require("configs.surround").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = require "configs.telescope",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },
  {
    "windwp/nvim-ts-autotag",
    ft = require("configs.ts-autotag").ft,
    config = function()
      require("configs.ts-autotag").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = require "configs.which-key",
  },
}
