local layout = require 'muryp-editor-setup.telescope.configs.layout'
local maps = require 'muryp-editor-setup.telescope.configs.maps'
local extentions = require 'muryp-editor-setup.telescope.configs.extentions'

require 'muryp-editor-setup.telescope.extensi'
require('telescope').setup {
  defaults = {
    prompt_prefix = ' ',
    selection_caret = ' ',
    file_ignore_patterns = { '.git/', '.cache' },
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
    layout_config = layout,
    mappings = maps,
    extensions = extentions,
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
}