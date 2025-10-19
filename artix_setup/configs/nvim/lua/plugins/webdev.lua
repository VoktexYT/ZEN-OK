-- LazyVim config ultra optimisée pour dev web/jeux
-- HTML, CSS, SCSS, JS, TS, JSX, TSX, React, Preact, Phaser3, Babylon.js
-- Place ce fichier dans: ~/.config/nvim/lua/plugins/webdev.lua

return {
  -- ============================================================================
  -- TREESITTER - Syntax highlighting moderne
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "regex",
        "glsl", -- Pour shaders WebGL
      })

      -- Active l'indentation automatique
      opts.indent = { enable = true }

      -- Active l'autoclose des tags HTML/JSX
      opts.autotag = { enable = true }
    end,
  },

  -- ============================================================================
  -- LSP - Language Servers pour tous les langages web
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- HTML
        html = {
          filetypes = { "html", "htmldjango" },
        },

        -- CSS/SCSS
        cssls = {
          filetypes = { "css", "scss", "less" },
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        },

        -- TypeScript/JavaScript (ULTRA IMPORTANT)
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
          },
        },

        -- ESLint (linting JS/TS)
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },

        -- Emmet (autocomplétion HTML/CSS)
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        },
      },
    },
  },

  -- ============================================================================
  -- SCHEMASTORE - Schemas JSON (package.json, tsconfig.json, etc.)
  -- ============================================================================
  {
    "b0o/schemastore.nvim",
  },

  -- ============================================================================
  -- AUTOCLOSE/AUTORENAME TAGS HTML/JSX
  -- ============================================================================
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- ============================================================================
  -- AUTOPAIRS - Fermeture auto des (), {}, [], "", ''
  -- ============================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- Utilise treesitter
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        typescript = { "template_string" },
      },
    },
  },

  -- ============================================================================
  -- PRETTIER - Formatage automatique
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- ============================================================================
  -- COLORIZER - Affiche les couleurs CSS inline
  -- ============================================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = {
        "css",
        "scss",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "html",
        "lua",
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
      },
    },
  },

  -- ============================================================================
  -- EMMET - Snippets HTML/CSS ultra rapides
  -- ============================================================================
  {
    "mattn/emmet-vim",
    event = "InsertEnter",
    ft = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    init = function()
      vim.g.user_emmet_leader_key = "<C-z>"
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescript = {
          extends = "tsx",
        },
      }
    end,
  },

  -- ============================================================================
  -- TYPESCRIPT TOOLS - Outils avancés TS
  -- ============================================================================
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact" },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
    },
  },

  -- ============================================================================
  -- PACKAGE.JSON - Versions packages inline
  -- ============================================================================
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufRead package.json",
    opts = {
      colors = {
        up_to_date = "#689d6a", -- Gruvbox green
        outdated = "#d79921", -- Gruvbox yellow
      },
    },
  },

  -- ============================================================================
  -- GLSL/SHADERS - Pour WebGL (Phaser3, Babylon.js)
  -- ============================================================================
  {
    "tikhomirov/vim-glsl",
    ft = { "glsl", "vert", "frag", "geom", "tesc", "tese", "comp" },
  },

  -- ============================================================================
  -- TELESCOPE - Recherche fichiers optimisée pour web
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git",
          "dist",
          "build",
          ".cache",
          ".next",
          "coverage",
        },
      },
    },
  },

  -- ============================================================================
  -- GRUVBOX THEME (intégration parfaite)
  -- ============================================================================
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "", -- Options: "hard", "soft", ""
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- ============================================================================
  -- NEO-TREE - File explorer avec filtres web
  -- ============================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            "node_modules",
            ".git",
            ".cache",
            "dist",
            "build",
          },
        },
      },
    },
  },

  -- ============================================================================
  -- MASON - Installer automatiquement les LSP/formatters
  -- ============================================================================
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP Servers
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "eslint-lsp",
        "json-lsp",
        "emmet-ls",

        -- Formatters
        "prettier",
        "eslint_d",

        -- Linters
        "stylelint",
      },
    },
  },
}
