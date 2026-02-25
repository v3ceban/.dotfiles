require "nvchad.options"

vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.shell = "/bin/zsh"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.g.markdown_recommended_style = 0
vim.g.copilot_no_tab_map = true
vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.opt.laststatus = 3

-- Auto-reload files when changed externally
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.filetype.add {
  pattern = {
    [".env.*"] = "bash",
    ["~/.ssh/hosts"] = "sshconfig",
    ["docker%-compose.*%.yml"] = "yaml.docker-compose",
    ["docker%-compose.*%.yaml"] = "yaml.docker-compose",
    [".*docker%-compose%.yml"] = "yaml.docker-compose",
    [".*docker%-compose%.yaml"] = "yaml.docker-compose",
  },
}

-- LSP open diagnostics on jump
vim.diagnostic.config {
  jump = {
    float = true,
  },
  float = {
    border = "rounded",
  },
}

-- higlight groups for markdown
vim.api.nvim_set_hl(0, "RenderMarkdownHeader", { fg = "#89b4fa" })
vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = "#fab387" })
-- higlight groups for git-conflict
vim.api.nvim_set_hl(0, "DiffAddGroup", { bg = "#272a3f" })
vim.api.nvim_set_hl(0, "DiffTextGroup", { bg = "#1e2030" })
-- highlight groups for LSP signature
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "", bg = "", bold = true, italic = true })
  end,
})
-- snacks input
vim.api.nvim_set_hl(0, "SnacksInputBorder", { fg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "SnacksInputTitle", { fg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "SnacksInputIcon", { fg = "#cba6f7" })

-- close quickfix window after pressing enter, q, or escape, leave open when pressing o
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "o", "<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":cclose<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":cclose<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "d",
      ":call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}))<CR>:redraw!<CR>",
      { noremap = true, silent = true }
    )
  end,
})

-- open Nvdash when closing the last buffer
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if
      #bufs == 1
      and vim.api.nvim_buf_get_name(bufs[1]) == ""
      and vim.api.nvim_buf_line_count(bufs[1]) == 1
      and vim.api.nvim_buf_get_lines(bufs[1], 0, -1, true)[1] == ""
    then
      vim.cmd "Nvdash"
      vim.api.nvim_buf_delete(bufs[1], { force = true })
    end
  end,
})
