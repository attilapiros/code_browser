local api = vim.api
local fn = vim.fn

-- open the specified file in the window above and go to the line number
local function open_or_load_above(fileName, lineNumber)
    local curr_win_nr = fn.winnr()
    local above_nr = fn.winnr('k')
    if curr_win_nr == above_nr then
        api.nvim_command('above split +' .. lineNumber .. ' ' .. fileName)
    else
        api.nvim_command(above_nr .. 'wincmd w')
        api.nvim_command('e ' .. fileName)
        api.nvim_command(tostring(lineNumber))
    end
end

-- replace the link prefix with the dir and separate file from line number
-- give back those in a tuple
local function file_and_linenum(link, url, dir)
  -- local after_replace = string.gsub(link, url, dir)
  local git_dir, line_num = string.match(link, url .. "([^#]*)#L(%d+)")
  return dir .. git_dir, line_num
end

-- find nth link with the specified url prefix
local function find_link(current_line, url, target_index)
  local index = 0
  local i = 1
  local j = 0
  local regexp = url .. "[^#]*#L%d+" 
  while index < target_index
  do
    i, j = string.find(current_line, regexp, j + 1)
    if j == nil then break end
    index = index + 1
  end 

  if index == target_index then 
    return string.sub(current_line, i, j)
  else 
    print("no link found for the requested index (" .. target_index .. "), last index is: " .. index)
    return nil
  end
end

-- open 
local function open_code_at(target_index) 
  -- the number https://github.com/a.java#L32 is 23 or 89
  local current_line = fn.getline('.')
  print("line: " .. current_line) 
  if vim.g.code_browser_settings then
    local link = find_link(current_line, vim.g.code_browser_settings['url'], tonumber(target_index))
    print("link: " .. link) 
    if link then
      local filename, linenum = file_and_linenum(link, vim.g.code_browser_settings['url'], vim.g.code_browser_settings['dir'])
      open_or_load_above(filename, linenum)
    end
  else 
    print("Code browser not initialized, please call: \"let g:code_browser_settings = { 'url': '<url>', 'dir': '<dir>' }\"!")
  end
end

local function save_file_position_as_link_to_clipboard()
  local line_num = fn.line(".")
  local file_name = fn.resolve(fn.expand("%:t"))
  local dir_name = string.gsub(fn.resolve(fn.expand("%:p:h")), vim.g.code_browser_settings['dir'], "")
  fn.setreg("", vim.g.code_browser_settings['url'] .. '/' .. dir_name .. '/' .. file_name .. '#L' .. line_num)
end

-- Returning a Lua table at the end allows fine control of the symbols that
-- will be available outside this file. By returning the table, it allows the
-- importer to decide what name to use in their own code.
--
-- Examples of how this module is imported:
--    local codebrowser = require('codebrowser')
--    codebrowser.open_code_at(1)
return {
    open_code_at = open_code_at,
    save_file_position_as_link_to_clipboard = save_file_position_as_link_to_clipboard
}
