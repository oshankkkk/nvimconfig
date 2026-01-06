-- Onvim
-- relative line numbers and line numbers
vim.opt.number = true
vim.opt.relativenumber = true
--annoying line wrap
vim.opt.wrap = false
-- 4 spaces for tabs than 8
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- clipboard sync
vim.opt.clipboard = "unnamedplus"
-- when typing cmds ignore case
vim.opt.ignorecase = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--this says either vim.uv or vim.loop
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
 require("lazy").setup(

--it goes like setup({plugins},{options})
	 {
         {
             "navarasu/onedark.nvim",
             priority = 1000,
             config = function()
                 require("onedark").setup({ style = "darker" })
                 require("onedark").load()
             end,
         },
         {
             "nvim-treesitter/nvim-treesitter",
             build = ":TSUpdate",
             lazy = true,              -- don't load immediately
             event = "BufReadPost",
             config = function()
                 require("nvim-treesitter.config").setup({
                     ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
                     auto_install = true,
                     highlight = { enable = true },
                 })
             end,
         },
         --mason 
         {
             "mason-org/mason.nvim",
             opts = {
                 ui = {
                     icons = {
                         package_installed = "✓",
                         package_pending = "➜",
                         package_uninstalled = "✗"
                     }
                 }
             },
             config = function()
                 require("mason").setup()
             end,
         },
         {
             "neovim/nvim-lspconfig",
         },
         {
             'saghen/blink.cmp',
             -- optional: provides snippets for the snippet source
             dependencies = { 'rafamadriz/friendly-snippets' },

             -- use a release tag to download pre-built binaries
             version = '1.*',
             -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
             -- build = 'cargo build --release',
             -- If you use nix, you can build from source using latest nightly rust with:
             -- build = 'nix run .#build-plugin',

             ---@module 'blink.cmp'
             ---@type blink.cmp.Config
             opts = {
                 -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                 -- 'super-tab' for mappings similar to vscode (tab to accept)
                 -- 'enter' for enter to accept
                 -- 'none' for no mappings
                 --
                 -- All presets have the following mappings:
                 -- C-space: Open menu or open docs if already open
                 -- C-n/C-p or Up/Down: Select next/previous item
                 -- C-e: Hide menu
                 -- C-k: Toggle signature help (if signature.enabled = true)
                 --
                 -- See :h blink-cmp-config-keymap for defining your own keymap
                 keymap = { preset = 'default' },

                 appearance = {
                     -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                     -- Adjusts spacing to ensure icons are aligned
                     nerd_font_variant = 'mono'
                 },

                 -- (Default) Only show the documentation popup when manually triggered
                 completion = { documentation = { auto_show = false } },

                 -- Default list of enabled providers defined so that you can extend it
                 -- elsewhere in your config, without redefining it, due to `opts_extend`
                 sources = {
                     default = { 'lsp', 'path', 'snippets', 'buffer' },
                 },

                 -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                 -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                 -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                 --
                 -- See the fuzzy documentation for more information
                 fuzzy = { implementation = "prefer_rust_with_warning" }
             },
             opts_extend = { "sources.default" }
         }
         -- blink conifg end
     },
     -- Configure any other settings here. See the documentation for more details.
   -- colorscheme that will be used when installing plugins.
   { 
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
    }
 )

-- keymaps
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Visual mode mapping for commenting lines for lua  quick fix
vim.api.nvim_set_keymap(
  "v",
  "<leader>/",
  ":s/^/-- /<CR>:noh<CR>",
  { noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")

vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")

