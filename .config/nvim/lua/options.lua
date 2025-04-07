vim.g.mapleader = '\\'

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.make_no_commands = 1

vim.opt.mouse = ''
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.opt.completeopt = 'menuone,noselect'
vim.opt.hlsearch = false
vim.opt.linebreak = true

vim.opt.guicursor = 'a:block'

if vim.g.neovide then 
	vim.opt.guifont = 'Adwaita Mono:h11.25'
	vim.g.neovide_floating_blur_amount_x = 0
	vim.g.neovide_floating_blur_amount_y = 0
end

vim.opt.laststatus = 0
vim.opt.ruler = true
vim.opt.showcmd = false
vim.opt.showmode = false
-- vim.opt.cmdheight = 1
vim.opt.updatetime = 10

-- vim.opt.statusline = "%#ModeMsg#%2{mode()} %{reg_recording() ==# '' ? '' : '@'..reg_recording()..' '}%#NonText#| %#Directory#%{fnamemodify(getcwd(), ':t')}%#Normal# %-f %0m%0r%=%l:%-2c "

vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.shortmess = 'oOWsFtCcIaT'

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.sidescrolloff = 999
vim.opt.scrolloff = 999
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true

vim.opt.cindent = true
vim.opt.cinoptions = 'Ns'
vim.opt.preserveindent = true
vim.opt.autoindent = true
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.softtabstop = 0

vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.expandtab = false

vim.opt.backspace = 'indent,eol,start'
vim.opt.virtualedit = { 'block', 'onemore' }

vim.opt.fillchars = { eob = ' ' }
vim.opt.termguicolors = true

vim.opt.incsearch = true
vim.opt.numberwidth = 5
vim.opt.spell = false
vim.opt.spelllang = 'en_us'

vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'
vim.opt.signcolumn = 'yes'

vim.opt.path:append('**')
vim.opt.isfname:append('@-@')
