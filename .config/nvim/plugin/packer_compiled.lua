-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/fumiya_nakamura/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/fumiya_nakamura/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/fumiya_nakamura/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/fumiya_nakamura/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/fumiya_nakamura/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["bufferline.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  catppuccin = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["dracula.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/dracula.nvim",
    url = "https://github.com/Mofiqul/dracula.nvim"
  },
  ["gotests-vim"] = {
    config = { "\27LJ\2\ne\0\0\4\0\6\0\t6\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\1'\3\5\0B\1\2\2=\1\2\0K\0\1\0\22~/.config/gotests\14normalize\afs\25gotests_template_dir\6g\bvim\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/gotests-vim",
    url = "https://github.com/buoto/gotests-vim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  neotest = {
    config = { "\27LJ\2\n[\0\0\2\1\4\0\r-\0\0\0009\0\0\0009\0\0\0B\0\1\1-\0\0\0009\0\1\0009\0\2\0B\0\1\1-\0\0\0009\0\3\0009\0\2\0B\0\1\1K\0\1\0\1¿\fsummary\topen\17output_panel\brun\127\0\0\5\1\b\0\18-\0\0\0009\0\0\0009\0\0\0006\2\1\0009\2\2\0029\2\3\2'\4\4\0B\2\2\0A\0\0\1-\0\0\0009\0\5\0009\0\6\0B\0\1\1-\0\0\0009\0\a\0009\0\6\0B\0\1\1K\0\1\0\1¿\fsummary\topen\17output_panel\6%\vexpand\afn\bvim\brunÅ\1\0\0\5\1\b\0\18-\0\0\0009\0\0\0009\0\0\0006\2\1\0009\2\2\0029\2\3\2'\4\4\0B\2\2\0A\0\0\1-\0\0\0009\0\5\0009\0\6\0B\0\1\1-\0\0\0009\0\a\0009\0\6\0B\0\1\1K\0\1\0\1¿\fsummary\topen\17output_panel\b%:h\vexpand\afn\bvim\brunH\0\0\2\1\3\0\t-\0\0\0009\0\0\0009\0\1\0B\0\1\1-\0\0\0009\0\2\0009\0\1\0B\0\1\1K\0\1\0\1¿\fsummary\nclose\17output_panel&\0\0\2\1\2\0\5-\0\0\0009\0\0\0009\0\1\0B\0\1\1K\0\1\0\1¿\tstop\brun|\0\1\6\0\b\0\0229\1\0\0\18\3\1\0009\1\1\1'\4\2\0'\5\3\0B\1\4\2\18\3\1\0009\1\1\1'\4\4\0'\5\3\0B\1\4\2\18\3\1\0009\1\1\1'\4\5\0'\5\3\0B\1\4\2\18\3\1\0009\1\1\1'\4\6\0'\5\a\0B\1\4\2L\1\2\0\5\t^%s+\b%s+\6\t\6 \6\n\tgsub\fmessageç\5\1\0\r\0&\1P6\0\0\0006\2\1\0'\3\2\0B\0\3\0036\2\0\0006\4\1\0'\5\3\0B\2\3\3\15\0\0\0X\4DÄ\15\0\2\0X\4BÄ6\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\b\0003\b\t\0005\t\n\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\v\0003\b\f\0005\t\r\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\14\0003\b\15\0005\t\16\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\17\0003\b\18\0005\t\19\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\20\0003\b\21\0005\t\22\0B\4\5\0016\4\4\0009\4\23\0049\4\24\4'\6\2\0B\4\2\0026\5\4\0009\5\25\0059\5\26\0055\a\30\0005\b\28\0003\t\27\0=\t\29\b=\b\31\a\18\b\4\0B\5\3\0019\5 \0015\a$\0004\b\3\0\18\t\3\0005\v\"\0005\f!\0=\f#\vB\t\2\0?\t\0\0=\b%\aB\5\2\0012\0\0ÄK\0\1\0\radapters\1\0\0\targs\1\0\0\1\2\0\0\r-count=1\nsetup\17virtual_text\1\0\0\vformat\1\0\0\0\vconfig\15diagnostic\26nvim_create_namespace\bapi\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tq\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tc\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tp\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tf\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tn\6n\bset\vkeymap\bvim\15neotest-go\fneotest\frequire\npcall\3ÄÄ¿ô\4\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-go"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/neotest-go",
    url = "https://github.com/nvim-neotest/neotest-go"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/fumiya_nakamura/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: neotest
time([[Config for neotest]], true)
try_loadstring("\27LJ\2\n[\0\0\2\1\4\0\r-\0\0\0009\0\0\0009\0\0\0B\0\1\1-\0\0\0009\0\1\0009\0\2\0B\0\1\1-\0\0\0009\0\3\0009\0\2\0B\0\1\1K\0\1\0\1¿\fsummary\topen\17output_panel\brun\127\0\0\5\1\b\0\18-\0\0\0009\0\0\0009\0\0\0006\2\1\0009\2\2\0029\2\3\2'\4\4\0B\2\2\0A\0\0\1-\0\0\0009\0\5\0009\0\6\0B\0\1\1-\0\0\0009\0\a\0009\0\6\0B\0\1\1K\0\1\0\1¿\fsummary\topen\17output_panel\6%\vexpand\afn\bvim\brunÅ\1\0\0\5\1\b\0\18-\0\0\0009\0\0\0009\0\0\0006\2\1\0009\2\2\0029\2\3\2'\4\4\0B\2\2\0A\0\0\1-\0\0\0009\0\5\0009\0\6\0B\0\1\1-\0\0\0009\0\a\0009\0\6\0B\0\1\1K\0\1\0\1¿\fsummary\topen\17output_panel\b%:h\vexpand\afn\bvim\brunH\0\0\2\1\3\0\t-\0\0\0009\0\0\0009\0\1\0B\0\1\1-\0\0\0009\0\2\0009\0\1\0B\0\1\1K\0\1\0\1¿\fsummary\nclose\17output_panel&\0\0\2\1\2\0\5-\0\0\0009\0\0\0009\0\1\0B\0\1\1K\0\1\0\1¿\tstop\brun|\0\1\6\0\b\0\0229\1\0\0\18\3\1\0009\1\1\1'\4\2\0'\5\3\0B\1\4\2\18\3\1\0009\1\1\1'\4\4\0'\5\3\0B\1\4\2\18\3\1\0009\1\1\1'\4\5\0'\5\3\0B\1\4\2\18\3\1\0009\1\1\1'\4\6\0'\5\a\0B\1\4\2L\1\2\0\5\t^%s+\b%s+\6\t\6 \6\n\tgsub\fmessageç\5\1\0\r\0&\1P6\0\0\0006\2\1\0'\3\2\0B\0\3\0036\2\0\0006\4\1\0'\5\3\0B\2\3\3\15\0\0\0X\4DÄ\15\0\2\0X\4BÄ6\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\b\0003\b\t\0005\t\n\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\v\0003\b\f\0005\t\r\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\14\0003\b\15\0005\t\16\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\17\0003\b\18\0005\t\19\0B\4\5\0016\4\4\0009\4\5\0049\4\6\4'\6\a\0'\a\20\0003\b\21\0005\t\22\0B\4\5\0016\4\4\0009\4\23\0049\4\24\4'\6\2\0B\4\2\0026\5\4\0009\5\25\0059\5\26\0055\a\30\0005\b\28\0003\t\27\0=\t\29\b=\b\31\a\18\b\4\0B\5\3\0019\5 \0015\a$\0004\b\3\0\18\t\3\0005\v\"\0005\f!\0=\f#\vB\t\2\0?\t\0\0=\b%\aB\5\2\0012\0\0ÄK\0\1\0\radapters\1\0\0\targs\1\0\0\1\2\0\0\r-count=1\nsetup\17virtual_text\1\0\0\vformat\1\0\0\0\vconfig\15diagnostic\26nvim_create_namespace\bapi\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tq\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tc\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tp\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tf\1\0\2\fnoremap\2\vsilent\2\0\15<Leader>tn\6n\bset\vkeymap\bvim\15neotest-go\fneotest\frequire\npcall\3ÄÄ¿ô\4\0", "config", "neotest")
time([[Config for neotest]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: gotests-vim
time([[Config for gotests-vim]], true)
try_loadstring("\27LJ\2\ne\0\0\4\0\6\0\t6\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\1'\3\5\0B\1\2\2=\1\2\0K\0\1\0\22~/.config/gotests\14normalize\afs\25gotests_template_dir\6g\bvim\0", "config", "gotests-vim")
time([[Config for gotests-vim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
