vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
vim.opt.termguicolors = true

require("lazy").setup({
  spec = {

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },

     -- telescope

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- smear cursor 

    {
      "sphamba/smear-cursor.nvim",
      opts = {
        stiffness = 0.5,
        trailing_stiffness = 0.5,
        trailing_exponent = 1,
        distance_stop_animating = 0.5,
      },
    },

    -- treesitter

    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        local ok, ts = pcall(require, "nvim-treesitter.configs")
        if ok then
          ts.setup({
            ensure_installed = { "lua", "java" },
            highlight = { enable = true },
            indent = { enable = true },
          })
        end
      end,
    },

    -- file explorer

    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons"
      },
      config = function()
        require("nvim-tree").setup({})
      end
    },

    -- status line

    {
      "nvim-lualine/lualine.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons"
      },
      config = function()
        require("lualine").setup({
          options = {
            theme = "tokyonight"
          }
        })
      end
    },

    -- which key

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("which-key").setup()
      end
    },

    -- auto complete

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
  end
},

  },

  checker = { enabled = true },
  })

vim.cmd.colorscheme("tokyonight")

-- keymaps

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- abrir file explorer
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
