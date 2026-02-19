local lint = require "lint"

lint.linters._eslint_d = lint.linters.eslint_d

---@type table
---@diagnostic disable-next-line: assign-type-mismatch
local base_config = lint.linters._eslint_d or {}

local eslint_d_args = vim.list_extend(vim.deepcopy(base_config.args or {}), { "--no-warn-ignored" })

local eslint_config_cache = {}

local eslint_config_files = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
}

-- Eslint config detection for monorepos
local function find_eslint_config_dir(file_path)
  local dir = vim.fn.fnamemodify(file_path, ":p:h")
  local cwd = vim.fn.getcwd()
  local cache_key = dir .. "|" .. cwd

  if eslint_config_cache[cache_key] ~= nil then
    return eslint_config_cache[cache_key]
  end

  local found = vim.fs.find(eslint_config_files, {
    path = dir,
    upward = true,
    stop = vim.fn.fnamemodify(cwd, ":h"),
    type = "file",
  })

  if found[1] then
    local config_dir = vim.fn.fnamemodify(found[1], ":p:h")
    eslint_config_cache[cache_key] = config_dir
    return config_dir
  end

  eslint_config_cache[cache_key] = false
  return false
end

lint.linters.eslint_d = function()
  local file = vim.api.nvim_buf_get_name(0)
  local config_dir = find_eslint_config_dir(file)

  if config_dir then
    return vim.tbl_extend("force", base_config, {
      cwd = config_dir,
      args = eslint_d_args,
    })
  end

  return base_config
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    eslint_config_cache = {}
  end,
})

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  vue = { "eslint_d" },
}

local try_lint = function()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" and not file:match "node_modules" and not file:match "term" then
    lint.try_lint()
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = try_lint,
})

vim.o.updatetime = 150

local lint_timer = assert(vim.uv.new_timer())

-- Debounce lint calls so CursorHold doesn't stack overlapping invocations
vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
  callback = function()
    lint_timer:stop()
    lint_timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        try_lint()
      end)
    )
  end,
})
