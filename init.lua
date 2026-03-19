vim.g.mapleader = " "

-- options

local opt = vim.opt
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.termguicolors = true
opt.clipboard = "unnamedplus"

-- neovide config

if vim.g.neovide then
  opt.guifont = "JetBrainsMono Nerd Font:h14"

  vim.g.neovide_cursor_animation_length = 0.14
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_scroll_animation_length = 0.35
end

-- cursor

opt.guicursor = "n-v-c:block,i-ci-ve:ver35,r-cr:hor25,o:hor50"

-- bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

-- plugins

require("lazy").setup({
  spec = {

    -- theme

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("tokyonight")
      end,
    },

    -- telescope

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- treesitter

    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.config").setup({
          ensure_installed = { "lua", "java" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- explorer

    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("nvim-tree").setup({
          sync_root_with_cwd = true,
          update_focused_file = {
            enable = true,
            update_root = true,
          },
          view = { width = 35 },
        })
      end,
    },

    -- status line

    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = { theme = "tokyonight" },
        })
      end,
    },

    -- which key

   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("which-key").setup()
      end,
    },

    --  mason

   {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },

    -- mason lsp

    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "lua_ls",
            "jdtls",
            "pyright",
          },
        })
      end,
    },

    -- lsp config 

    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local servers = {
          lua_ls = {},
          jdtls = {},
          pyright = {},
        }

        for server, config in pairs(servers) do
          config.capabilities = capabilities
          lspconfig[server].setup(config)
        end

        -- keymaps lsp

        local keymap = vim.keymap
        keymap.set("n", "gd", vim.lsp.buf.definition)
        keymap.set("n", "K", vim.lsp.buf.hover)
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
        keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
      end,
    },

    -- autocomplete

    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
      },
      config = function()
        local cmp = require("cmp")

        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },

          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),

          sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          },
        })
      end,
    },
  },

  checker = { enabled = true },
})

-- autocheck cmd 

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    if dir ~= "" then
      vim.cmd.cd(dir)
    end
  end,
})

-- keymaps 

local keymap = vim.keymap

keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

keymap.set("n", "<leader>ef", function()
  vim.cmd.cd("%:p:h")
  vim.cmd("NvimTreeOpen")
end)
