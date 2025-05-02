require("options")

local cwd_hist_path = vim.fn.expand(vim.fn.stdpath("cache") .. "/cwd.hist")

update_cwd_hist = function(path)
	local cwd_hist = io.open(cwd_hist_path, "r")

	local tmp = ""

	if path ~= nil then
		path = vim.fn.expandcmd(path)
		tmp = tmp .. path .. '\n'
	end

	for l in cwd_hist:lines() do
		if l ~= path and vim.uv.fs_stat(l) then
			tmp = tmp .. l .. '\n'
		end
	end

	cwd_hist:close()
	cwd_hist = io.open(cwd_hist_path, "w")

	if cwd_hist == nil then
		return
	end

	cwd_hist:write(tmp)

	cwd_hist:close()
end

vim.api.nvim_create_autocmd("DirChanged", {
	pattern = "global",
	callback = function(ev)
		update_cwd_hist(ev.file)
	end,
})

vim.keymap.set('n', '[b', '<CMD>bprev<CR>')
vim.keymap.set('n', ']b', '<CMD>bnext<CR>')

vim.keymap.set("n", "[l", function()
	if pcall(vim.cmd.lprev) or pcall(vim.cmd.llast) then
		return
	end

	vim.print("No location entries.")
end, {silent = true, noremap = true})

vim.keymap.set("n", "]l", function()
	if pcall(vim.cmd.lnext) or pcall(vim.cmd.lfirst) then
		return
	end

	vim.print("No location entries.")
end, {silent = true, noremap = true})

vim.keymap.set("n", "[c", function()
	if pcall(vim.cmd.cprev) or pcall(vim.cmd.clast) then
		return
	end

	vim.print("No quickfix entries.")
end, {silent = true, noremap = true})

vim.keymap.set("n", "]c", function()
	if pcall(vim.cmd.cnext) or pcall(vim.cmd.cfirst) then
		return
	end

	vim.print("No quickfix entries.")
end, {silent = true, noremap = true})

vim.keymap.set("n", "<Space>c", "<CMD>make! check<CR>", {silent = true, noremap = true})
vim.keymap.set("n", "<Space>r", "<CMD>make! run<CR>", {silent = true, noremap = true})

vim.keymap.set("n", "<leader>j", "<CMD>terminal<CR>", {silent = true})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
	group = vim.api.nvim_create_augroup('RecallCursor', { clear = true }),
	command = 'silent! normal! g`"zv',
})

local scratch_buf = nil

vim.keymap.set({ 'n' }, '<Space>w', vim.cmd.write)

vim.keymap.set({ 'n' }, '<leader>s', function()
	if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
		scratch_buf = vim.api.nvim_create_buf(true, true)
	end

	pcall(vim.cmd.buffer, scratch_buf)
end, { silent = true, noremap = true })

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

vim.cmd.autocmd("TermOpen * startinsert")

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

vim.g.colorscheme = 'gruvbox-material'

require('lazy').setup({
	{
		'sainnhe/gruvbox-material',
		config = function()
			-- vim.g.gruvbox_material_background = 'soft'
			-- vim.g.gruvbox_material_foreground = 'original'
			vim.g.gruvbox_material_transparent_background = true
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_better_performance = true
		end
	},
	{
		"mfussenegger/nvim-jdtls",
	},
	{
		'ibhagwan/fzf-lua',
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				fzf_bin = 'sk',
			})

			local default_cd_action = function(s)
				if s then
					vim.fn.chdir(s[1])
				end
			end

			vim.keymap.set("n", "<leader>o", function() fzf.files{} end)
			vim.keymap.set("n", "<leader>i", function() fzf.lsp_live_workspace_symbols{} end)
			vim.keymap.set("n", "<leader>l", function() fzf.live_grep{
				winopts = {
					preview = {
						hidden = "hidden",
					},
				}
			} end)

			vim.keymap.set("n", "<leader>r", fzf.oldfiles)

			vim.keymap.set("n", "<leader>n", function()
				fzf.fzf_exec("find -type d -maxdepth 1", {
					actions = {
						['default'] = default_cd_action,
					},
				})
			end)

			vim.keymap.set("n", "<leader>p", function()
				local remove_from_cwd_hist = function(s)
					local cwd_hist = io.open(cwd_hist_path, "r")

					local tmp = ""

					for l in cwd_hist:lines() do
						if not vim.list_contains(s, l) then
							tmp = tmp .. l .. '\n'
						end
					end

					cwd_hist:close()
					cwd_hist = io.open(cwd_hist_path, "w")

					if cwd_hist == nil then
						return
					end

					cwd_hist:write(tmp)

					cwd_hist:close()
				end

				update_cwd_hist(nil)

				fzf.fzf_exec("cat "..cwd_hist_path, {
					prompt = "CD ❯ ",
					fzf_opts = {
						['-m'] = true,
						['--exact'] = true,
						['--no-sort'] = true,
					},
					preview = "ls --color=always -1 {1}",
					actions = {
						['default'] = default_cd_action,
						['ctrl-d'] = remove_from_cwd_hist,
					},
				})
			end)

			vim.keymap.set("n", "<leader>t", function()
				vim.cmd.lgrep('"(TODO|FIX).*:" '.. vim.uv.cwd())
			end)
		end,
	},
	{
		'mbbill/undotree',
		config = function()
			vim.keymap.set("n", "<leader>u", "<CMD>UndotreeShow<CR>", {silent = true, noremap = true})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				enable = true,
				sync_install = false,
				auto_install = true,

				incremental_selection = {
					enable = true,
				},

				textobjects = {
					enable = true,
				},

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true,
				},
			})
		end,
	},
	{
		'echasnovski/mini.splitjoin',
		config = function()
			require("mini.splitjoin").setup()
		end,
	},
	{
		'bkad/CamelCaseMotion',
		config = function()
			vim.keymap.set({"n", "v"}, "w", "<Plug>CamelCaseMotion_w", {silent = true, remap = true})
			vim.keymap.set({"n", "v"}, "b", "<Plug>CamelCaseMotion_b", {silent = true, remap = true})
			vim.keymap.set({"n", "v"}, "e", "<Plug>CamelCaseMotion_e", {silent = true, remap = true})
			vim.keymap.set({"n", "v"}, "ge", "<Plug>CamelCaseMotion_ge", {silent = true, remap = true})
		end,
	},
	{
  		'saghen/blink.cmp',
  		dependencies = { 'rafamadriz/friendly-snippets' },

  		version = '1.*',
  		opts = {
    			keymap = { preset = 'enter' },
    			completion = { documentation = { auto_show = false } },
    			sources = {
      				default = { 'lsp', 'path', 'snippets', 'buffer' },
    			},
    			fuzzy = { implementation = "prefer_rust_with_warning" }
  		},
  		opts_extend = { "sources.default" }
	},
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'williamboman/mason.nvim' },
	{
		'neovim/nvim-lspconfig',
		config = function()
			local lspconfig = require('lspconfig')
			local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

			local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspUserConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
					vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				end,
			})

			-- vim.diagnostic.disable()

			local handlers = {
				function(server_name)
					vim.lsp.config(server_name, {
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
				["lua_ls"] = function(server_name)
					vim.lsp.config(server_name, {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" }
								}
							}
						}
					})
				end,
				["phpactor"] = function(server_name)
					vim.lsp.config(server_name, {
						capabilities = capabilities,
						on_attach = on_attach,
						root_dir = vim.loop.cwd,
					})
				end,
				["jdtls"] = function(server_name)
					vim.lsp.config(server_name, {
    						filetypes = { "java" },
    						capabilities = capabilities,
    						on_attach = on_attach,
    						root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
					})
				end,
			}

			require('mason').setup()
			require('mason-lspconfig').setup({ handlers = handlers })
		end,
	},
	{
		'smoka7/hop.nvim',
		config = function()
			require('hop').setup()

			vim.keymap.set('n', 'gw', '<CMD>HopWord<CR>', {remap = true, silent = true})
		end,
	},
})

vim.cmd.colorscheme(vim.g.colorscheme)
