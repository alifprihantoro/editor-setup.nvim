local formatter_list = {
  lua = { 'stylua' },
  fish = { 'fish_indent' },
  sh = { 'shfmt' },
  astro = { 'astro' },
}
local ignore_filetypes = {}
local function pushTable(arr1, arr2)
  local result = {} -- Membuat tabel baru untuk hasil penggabungan
  -- Menyalin elemen dari arr1 ke tabel hasil
  for _, v in ipairs(arr1) do
    table.insert(result, v)
  end
  -- Menyalin elemen dari arr2 ke tabel hasil
  for _, v in ipairs(arr2) do
    table.insert(result, v)
  end
  return result -- Mengembalikan tabel hasil yang berisi gabungan dari arr1 dan arr2
end

local addFormatter = function(listLang, formatter, isIgnore)
  if isIgnore then
    pushTable(listLang, ignore_filetypes)
  end
  for _, val in pairs(listLang) do
    formatter_list[val] = formatter
  end
end

addFormatter({
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'typescriptreact',
}, { 'prettierd', 'eslint_d' }, true)
addFormatter({ 'html', 'css', 'scss', 'markdown' }, { 'prettierd' }, true)

return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  keys = {
    {
      '<c-f>',
      function()
        require('conform').format { timeout_ms = 3000 }
      end,
      mode = { 'n', 'v' },
      desc = 'Format Injected Langs',
    },
  },
  opts = function()
    ---@class ConformOpts
    local opts = {
      -- LazyVim will use these options when formatting with the conform.nvim formatter
      format = {
        timeout_ms = 3000,
        async = false,
        quiet = true,
        lsp_fallback = true, -- not recommended to change
      },
      ---@type table<string, conform.FormatterUnit[]>
      formatters_by_ft = formatter_list,
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2', '-ci' },
        },

        prettierd = {
          cwd = nil,
        },
        astro = {
          command = 'astrofm',
          args = { '$FILENAME' },
        },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match '/node_modules/' then
          return
        end
        -- ...additional logic...
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    }
    return opts
  end,
}
