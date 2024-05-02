local formatter_list = {
  lua = { 'stylua' },
  fish = { 'fish_indent' },
  sh = { 'shfmt' },
}
local addFormatter = function(listLang, formatter)
  for _, val in pairs(listLang) do
    formatter_list[val] = formatter
  end
end

addFormatter({
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
}, { 'prettierd', 'eslint_d' })
addFormatter({ 'html', 'css', 'scss', 'markdown' }, { 'prettierd' })

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
        injected = { options = { ignore_errors = true } },
        shfmt = {
          prepend_args = { '-i', '2', '-ci' },
        },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { 'sql', 'java' }
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
