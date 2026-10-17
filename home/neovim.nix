{
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings = {
      vim = {
        vimAlias = true;
        viAlias = true;

        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };

        # --- Editor options -----------------------------------------
        options = {
          number = true;
          relativenumber = true;
          expandtab = true;
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          smartindent = true;
          wrap = false;
          mouse = "a";
          termguicolors = true;
        };

        # --- System clipboard (Wayland) -----------------------------
        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy.enable = true;
        };

        # --- LSP + format on save -----------------------------------
        lsp = {
          enable = true;
          formatOnSave = true;
        };

        # --- C / C++ (competitive programming) ----------------------
        languages.clang = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };

        # --- Rust ---------------------------------------------------
        languages.rust = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };

        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
        };

        # --- Autocompletion + snippets ------------------------------
        autocomplete.nvim-cmp = {
          enable = true;

          # nvf demotes snippets by default (deprio(kinds.Snippet)). Rank your
          # LuaSnip snippets FIRST, then fall back to nvf's usual ordering.
          setupOpts.sorting.comparators = [
            (lib.mkLuaInline ''
              function(e1, e2)
                local is_snip = function(e) return e.source.name == "luasnip" end
                if is_snip(e1) and not is_snip(e2) then return true end
                if is_snip(e2) and not is_snip(e1) then return false end
                return nil
              end
            '')
            (lib.mkLuaInline "deprio(kinds.Text)")
            "offset"
            "exact"
            "score"
            "kind"
            "length"
            "sort_text"
          ];
        };

        # Only YOUR snippets (providers = [] removes friendly-snippets).
        snippets.luasnip = {
          enable = true;
          providers = [];

          customSnippets.snipmate.cpp = [
            {
              trigger = "main";
              description = "solution template";
              body = "#include <bits/stdc++.h>\nusing namespace std;\n\nvoid solve() {\n  $0\n}\n\nint main() {\n  ios::sync_with_stdio(false);\n  cin.tie(nullptr);\n\n  int t;\n  cin >> t;\n  for(int i = 0; i<t; i++){\n    solve();\n  }\n  return 0;\n}";
            }
            {
              trigger = "for";
              description = "for loop";
              body = "for (int \${1:i} = 0; $1 < \${2:n}; ++\$1) {\n  $0\n}";
            }
            {
              trigger = "fori";
              description = "read array in a loop";
              body = "for (int \${1:i} = 0; $1 < \${2:n}; ++\$1) cin >> \${3:a}[$1];";
            }
            {
              trigger = "rep";
              description = "repeat T times";
              body = "for (int \${1:_} = 0; $1 < \${2:T}; ++\$1) {\n  $0\n}";
            }
            {
              trigger = "while";
              description = "while loop";
              body = "while (\${1:cond}) {\n  $0\n}";
            }
            {
              trigger = "read";
              description = "read an int";
              body = "int \${1:n}; cin >> \$1;";
            }
            {
              trigger = "out";
              description = "print line";
              body = "cout << \${1:ans} << '\\n';";
            }
            {
              trigger = "vec";
              description = "vector of n";
              body = "vector<\${1:int}> \${2:v};";
            }
            {
              trigger = "umap";
              description = "unordered_map";
              body = "unordered_map<\${1:long long}, \${2:long long}> \${3:m};";
            }
            {
              trigger = "omap";
              description = "ordered_map";
              body = "map<\${1:long long}, \${2:long long}> \${3:m};";
            }
            {
              trigger = "uset";
              description = "unordered_set";
              body = "unordered_set<\${1:int}> \${2:s};";
            }
            {
              trigger = "hmap";
              description = "unordered_map with reserve";
              body = "unordered_map<\${1:long long}, \${2:long long}> \${3:m};\n$3.reserve(\${4:1 << 20});\n$3.max_load_factor(\${5:0.7});";
            }
            {
              trigger = "sort";
              description = "sort a vector";
              body = "sort(\${1:v}.begin(), \$1.end());";
            }
            {
              trigger = "ll";
              description = "long long";
              body = "long long";
            }
            {
              trigger = "mod";
              description = "mod constant";
              body = "const int MOD = 1'000'000'007;";
            }
            {
              trigger = "dbg";
              description = "debug macro";
              body = "#ifdef LOCAL\n#define dbg(x) cerr << #x << \" = \" << (x) << '\\n'\n#else\n#define dbg(x)\n#endif";
            }
          ];
        };

        # --- Usability / looks --------------------------------------
        binds.whichKey.enable = true;

        luaConfigPost = ''
          -- <leader>r in a Rust buffer: compile and run in a terminal split.
          --   * inside a Cargo project -> `cargo run`
          --   * a standalone .rs file  -> `rustc <file> -o <stem> && ./<stem>`
          -- The mapping is BUFFER-LOCAL, so it shadows the global
          -- <leader>r (CompetiTest) only while a Rust file is focused.
          do
            local function rust_run()
              vim.cmd("write")

              local file = vim.api.nvim_buf_get_name(0)
              local dir = vim.fn.fnamemodify(file, ":p:h")
              local stem = vim.fn.fnamemodify(file, ":t:r")
              local root = vim.fs.root(0, "Cargo.toml")

              local cmd
              if root then
                cmd = string.format("cd %s && cargo run", vim.fn.shellescape(root))
              else
                local exe = dir .. "/" .. stem
                cmd = string.format(
                  "rustc %s -o %s && %s",
                  vim.fn.shellescape(file),
                  vim.fn.shellescape(exe),
                  vim.fn.shellescape(exe)
                )
              end

              vim.cmd("botright 12split")
              vim.cmd("terminal " .. cmd)
              vim.cmd("startinsert")
            end

            vim.api.nvim_create_autocmd("FileType", {
              pattern = "rust",
              group = vim.api.nvim_create_augroup("RustRunKeymap", {clear = true}),
              desc = "Buffer-local <leader>r to compile + run Rust",
              callback = function(ev)
                vim.keymap.set("n", "<leader>r", rust_run, {
                  buffer = ev.buf,
                  silent = true,
                  desc = "Rust: compile + run",
                })
              end,
            })
          end

          -- Black & white UI (matches the Sway/foot theme). Syntax groups are
          -- intentionally left untouched so code keeps its highlighting.
          do
            vim.o.background = "dark"
            pcall(vim.cmd.colorscheme, "default")

            local hl = vim.api.nvim_set_hl
            local black, white, gray = "#000000", "#ffffff", "#888888"

            hl(0, "Normal", { fg = white, bg = black })
            hl(0, "NormalNC", { fg = white, bg = black })
            hl(0, "NormalFloat", { fg = white, bg = "#0a0a0a" })
            hl(0, "FloatBorder", { fg = "#555555", bg = "#0a0a0a" })
            hl(0, "FloatTitle", { fg = white, bg = "#0a0a0a", bold = true })

            hl(0, "StatusLine", { fg = black, bg = white, bold = true })
            hl(0, "StatusLineNC", { fg = gray, bg = "#1a1a1a" })
            hl(0, "WinSeparator", { fg = "#333333", bg = black })
            hl(0, "VertSplit", { fg = "#333333", bg = black })

            hl(0, "LineNr", { fg = "#555555", bg = black })
            hl(0, "CursorLineNr", { fg = white, bg = black, bold = true })
            hl(0, "CursorLine", { bg = "#101010" })
            hl(0, "CursorColumn", { bg = "#101010" })
            hl(0, "ColorColumn", { bg = "#101010" })
            hl(0, "SignColumn", { bg = black })
            hl(0, "FoldColumn", { fg = "#555555", bg = black })
            hl(0, "Folded", { fg = gray, bg = "#0a0a0a" })

            hl(0, "Pmenu", { fg = white, bg = "#0a0a0a" })
            hl(0, "PmenuSel", { fg = black, bg = white })
            hl(0, "PmenuSbar", { bg = "#1a1a1a" })
            hl(0, "PmenuThumb", { bg = "#444444" })

            hl(0, "Visual", { fg = black, bg = white })
            hl(0, "Search", { fg = black, bg = white })
            hl(0, "IncSearch", { fg = black, bg = "#cccccc" })
            hl(0, "MatchParen", { fg = white, bg = "#333333", bold = true })

            hl(0, "Directory", { fg = white })
            hl(0, "Title", { fg = white, bold = true })
            hl(0, "Comment", { fg = gray })
            hl(0, "NonText", { fg = "#333333" })
            hl(0, "SpecialKey", { fg = "#555555" })
            hl(0, "Whitespace", { fg = "#2a2a2a" })

            hl(0, "TabLine", { fg = gray, bg = "#1a1a1a" })
            hl(0, "TabLineSel", { fg = black, bg = white, bold = true })
            hl(0, "TabLineFill", { bg = "#1a1a1a" })

            hl(0, "DiffAdd", { fg = "#bbbbbb", bg = "#1a1a1a" })
            hl(0, "DiffChange", { fg = "#bbbbbb", bg = "#1a1a1a" })
            hl(0, "DiffDelete", { fg = "#777777", bg = "#1a1a1a" })
            hl(0, "DiffText", { fg = white, bg = "#333333" })
          end
        '';

        statusline.lualine.enable = true;
        telescope.enable = true;
        utility.yazi-nvim = {
          enable = true;
          mappings.openYazi = "<leader>e";
        };
        git.gitsigns.enable = true;
        visuals.indent-blankline.enable = true;
        autopairs.nvim-autopairs.enable = true;

        # --- Keymaps (leader = space) -------------------------------
        keymaps = [
          {
            key = "<leader>w";
            mode = "n";
            silent = true;
            action = "<cmd>w<CR>";
            desc = "Save file";
          }
          {
            key = "<leader>q";
            mode = "n";
            silent = true;
            action = "<cmd>q<CR>";
            desc = "Quit";
          }
          {
            key = "<leader>r";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest run<CR>";
            desc = "Compile + run all testcases";
          }
          {
            key = "<leader>R";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest run_no_compile<CR>";
            desc = "Run testcases (no recompile)";
          }
          {
            key = "<leader>n";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest add_testcase<CR>";
            desc = "Add testcase";
          }
          {
            key = "<leader>ff";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope find_files<CR>";
            desc = "Find files";
          }
          {
            key = "<leader>fg";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope live_grep<CR>";
            desc = "Live grep";
          }
          {
            key = "<leader>fb";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope buffers<CR>";
            desc = "Find buffers";
          }
          {
            key = "<leader>fh";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope help_tags<CR>";
            desc = "Help tags";
          }
          {
            key = "<leader>E";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest edit_testcase<CR>";
            desc = "Edit testcase";
          }
          {
            key = "<leader>d";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest delete_testcase<CR>";
            desc = "Delete testcase";
          }
          {
            key = "<leader>P";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest receive problem<CR>";
            desc = "Receive problem (competitive-companion)";
          }
          {
            key = "<leader>C";
            mode = "n";
            silent = true;
            action = "<cmd>CompetiTest receive contest<CR>";
            desc = "Receive contest (competitive-companion)";
          }
        ];

        # Toolchain available inside the Neovim wrapper.
        extraPackages = with pkgs; [
          gcc
          clang-tools
          gdb
          yazi
          rustc
          cargo
        ];

        # --- CompetiTest (CP Editor-style testcase manager) ---------
        extraPlugins = {
          nui = {
            package = pkgs.vimPlugins.nui-nvim;
          };
          competitest = {
            package = pkgs.vimPlugins.competitest-nvim;
            after = ["nui"];
            setup = ''
              require('competitest').setup {
                testcases_use_single_file = true,
                testcases_auto_detect_storage = true,
                save_current_file = true,
                compile_command = {
                  cpp = {
                    exec = 'g++',
                    args = {
                      '-std=c++20', '-O2', '-Wall', '-Wextra', '-DLOCAL',
                      '$(FNAME)', '-o', '$(FNOEXT)',
                    },
                  },
                },
                run_command = {
                  cpp = { exec = './$(FNOEXT)' },
                },
              }
            '';
          };
        };
      };
    };
  };

  # Style used by clang-format (run by conform.nvim on save). clang-format
  # searches upwards for this file, so it applies to every problem dir.
  home.file.".clang-format".text = ''
    BasedOnStyle: Google
    Language: Cpp
    IndentWidth: 2
    ColumnLimit: 0
    PointerAlignment: Left
    AllowShortFunctionsOnASingleLine: Inline
    AllowShortIfStatementsOnASingleLine: true
    AllowShortLoopsOnASingleLine: true
    BreakBeforeBraces: Attach
  '';
}
