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
      -- add your plugins here
    {
      "bluz71/vim-nightfly-colors",
      name = "nightfly",
      priority = 1000
    },

    {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    },
   
    {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
    },

    {
    "sphamba/smear-cursor.nvim",
     opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
       },
    }
    
      },
    -- Configure any other settings here. See the documentation for more details.
    checker = { enabled = true },
  })

vim.cmd.colorscheme("tokyonight")

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
