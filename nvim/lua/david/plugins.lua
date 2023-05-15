vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd vimball]]
local max_jobs = nil
return require("packer").startup {
  function(use)
    use "wbthomason/packer.nvim"
    -- startup stuff
    use "lewis6991/impatient.nvim"
    -- color stuff

    -- attempt to make own plugin
    use {
        '~/rust/todo-plugin/',
        run = 'make',
    }

    use "tjdevries/colorbuddy.nvim"
    use "tjdevries/gruvbuddy.nvim"
    -- use "tjdevries/nlua.nvim"
    use "tjdevries/express_line.nvim"
    use "tjdevries/green_light.nvim"

    use "norcalli/nvim-colorizer.lua"
    use {
      "norcalli/nvim-terminal.lua",
      config = function()
        require("terminal").setup()
      end,
    }

    use "tjdevries/cyclist.vim"
    use "L3MON4D3/LuaSnip"
    use "rcarriga/nvim-notify"
    use {
      "mhinz/vim-startify",
      -- cmd = {"SLoad", "SSave" },
      -- config = function()
      --     vim.g.startify_disable_at_vimenter = true
      -- end,
    }

    -- GIT:
    -- use "TimUntersberger/neogit"

    -- Github integration
    if vim.fn.executable "gh" == 1 then
      use "pwntester/octo.nvim"
    end
    use "ruifm/gitlinker.nvim"

    -- Sweet message committer
    use "rhysd/committia.vim"
    use "sindrets/diffview.nvim"

    -- Floating windows are awesome :)
    use {
      "rhysd/git-messenger.vim",
      keys = "<Plug>(git-messenger)",
    }
    use "tamago324/lir.nvim"
    use "tamago324/lir-git-status.nvim"
    if vim.fn.executable "mmv" then
      use "tamago324/lir-mmv.nvim"
    end

    use "pechorin/any-jump.vim"

    -- LSP Plugins:

    use "theHamsta/nvim-semantic-tokens"
    use "neovim/nvim-lspconfig"
    -- use "wbthomason/lsp-status.nvim"
    use "j-hui/fidget.nvim"
    use {
      "ericpubu/lsp_codelens_extensions.nvim",
      config = function()
        require("codelens_extensions").setup()
      end,
    }
    use "tjdevries/lsp_extensions.nvim"

    use "onsails/lspkind-nvim"

    -- Telescope related
    use "nvim-lua/popup.nvim"
    use("nvim-lua/plenary.nvim", {
      rocks = "lyaml",
    })

    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-rs.nvim"
    use "nvim-telescope/telescope-fzf-writer.nvim"
    use "nvim-telescope/telescope-packer.nvim"
    use "nvim-telescope/telescope-fzy-native.nvim"
    use "nvim-telescope/telescope-github.nvim"
    use "nvim-telescope/telescope-symbols.nvim"

    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-hop.nvim" }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    use { "nvim-telescope/telescope-ui-select.nvim" }
    use { "nvim-telescope/telescope-smart-history.nvim" }
    use { "tami5/sqlite.lua" }

    use { "nvim-telescope/telescope-frecency.nvim" }
    use { "nvim-telescope/telescope-cheat.nvim" }
    use { "nvim-telescope/telescope-arecibo.nvim", rocks = { "openssl", "lua-http-parser" } }
    -- use("nvim-telescope", "telescope-async-sorter-test.nvim")

    

    use {
      "AckslD/nvim-neoclip.lua",
      config = function()
        require("neoclip").setup()
      end,
    }


    -- use "tjdevries/sg.nvim"

    use "tjdevries/telescope-hacks.nvim"

    use {
      "antoinemadec/FixCursorHold.nvim",
      run = function()
        vim.g.curshold_updatime = 1000
      end,
    }
    use {
      "tpope/vim-scriptease",
      cmd = {
        "Messages", --view messages in quickfix list
        "Verbose", -- view verbose output in preview window.
        "Time", -- measure how long it takes to run some stuff.
      },
    }

    -- Quickfix enhancements. See :help vim-qf
    use "romainl/vim-qf"
    use {
      "glacambre/firenvim",
      run = function()
	vim.fn["firenvim#install"](0)
      end,
    }

    use "mkitt/tabline.vim"


    -- Crazy good box drawing
    use "gyim/vim-boxdraw"

    -- Better increment/decrement
    use "monaqa/dial.nvim"

    -- For narrowing regions of text to look at them alone
    use {
      "chrisbra/NrrwRgn",
      cmd = { "NarrowRegion", "NarrowWindow" },
    }
    use "kyazdani42/nvim-web-devicons"
    -- use "kyazdani42/nvim-tree.lua"
    use "lambdalisue/vim-protocol"

    -- Undo helper
    use "sjl/gundo.vim"
    --   FOCUSING:
    local use_folke = true
    if use_folke then
      use "folke/zen-mode.nvim"
      use "folke/twilight.nvim"
    end

    use {
      "junegunn/goyo.vim",
      cmd = "Goyo",
      disable = use_folke,
    }

    use {
      "junegunn/limelight.vim",
      after = "goyo.vim",
      disable = use_folke,
    }

    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install',
      cmd= 'MarkdownPreview', ft='markdown'
      }

    -- Completion
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lsp-document-symbol"
    use "saadparwaiz1/cmp_luasnip"
    use "tamago324/cmp-zsh"

    -- Comparators
    use "lukas-reineke/cmp-under-comparator"
    -- Find and replace
    use "windwp/nvim-spectre"

    -- Debug adapter protocol
    use "mfussenegger/nvim-dap"
    use "rcarriga/nvim-dap-ui"
    use "theHamsta/nvim-dap-virtual-text"
    use "mfussenegger/nvim-dap-python"
    use "nvim-telescope/telescope-dap.nvim"

    -- Pocco81/DAPInstall.nvim

    use "jbyuki/one-small-step-for-vimkind"
    -- TREE SITTER:
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/playground"

    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use {
      "mfussenegger/nvim-ts-hint-textobject",
      config = function()
        vim.cmd [[omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>]]
        vim.cmd [[vnoremap <silent> m :lua require('tsht').nodes()<CR>]]
      end,
    }
    -- Grammars
    -- use "tjdevries/tree-sitter-lua"

    -- TEXT MANIUPLATION
    use "godlygeek/tabular" -- Quickly align text by pattern
    use "tpope/vim-repeat" -- Repeat actions better
    use "tpope/vim-abolish" -- Cool things with words!
    use "tpope/vim-characterize"

    use "numToStr/Comment.nvim"

    use {
      "AndrewRadev/splitjoin.vim",
      keys = { "gJ", "gS" },
    }

    use "tpope/vim-surround" -- Surround text objects easily

    -- Folds!
    -- could not getting working
    -- use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

    -- copilot
    use {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
          },
          filetypes = {
            python = true,
            rust = true,
            ["*"] = false,
          },
        })
      end,
    }

    -- Async signs!
    use "lewis6991/gitsigns.nvim"
    -- Git worktree utility
    use {
      "ThePrimeagen/git-worktree.nvim",
      config = function()
        require("git-worktree").setup {}
      end,
    }
    use { "junegunn/fzf", run = "./install --all" }
    use { "junegunn/fzf.vim" }
  end,
  config = {
    max_jobs = max_jobs,
    luarocks = {
      python_cmd = "python3",
    },
    display = {
      -- open_fn = require('packer.util').float,
    },
  },
}
