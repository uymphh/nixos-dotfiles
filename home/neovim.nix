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

        # --- Theme: Noctalia / matugen ------------------------------
        # Noctalia renders a base16 palette to ~/.config/nvim/lua/matugen.lua
        # (regenerated on wallpaper change; the module reloads itself on
        # SIGUSR1). base16-nvim provides the `base16-colorscheme` module it
        # calls. We load it LAST so it wins over everything else.
        #
        # We also look in arctan's config so `sudo vi` (HOME=/root) still finds
        # the palette, and poll the file's mtime so root re-themes live too -
        # Noctalia signals nvim with SIGUSR1, but a normal user cannot signal a
        # root-owned process.
        luaConfigPost = ''
          do
            local dirs = {
              vim.fn.expand("~/.config/nvim/lua"),
              "/home/arctan/.config/nvim/lua",
            }
            local dir
            for _, d in ipairs(dirs) do
              if vim.fn.filereadable(d .. "/matugen.lua") == 1 then
                dir = d
                break
              end
            end

            local function apply()
              if dir then
                package.path = package.path .. ";" .. dir .. "/?.lua"
                package.loaded["matugen"] = nil
                require("matugen").setup()
              else
                require("base16-colorscheme").setup({
                  base00 = "#1f1f1f", base01 = "#333333", base02 = "#2e2e2e", base03 = "#696969",
                  base04 = "#b6afaf", base05 = "#f3f2f2", base06 = "#f3f2f2", base07 = "#f3f2f2",
                  base08 = "#fd4663", base09 = "#cc6666", base0A = "#d65c5c", base0B = "#e46767",
                  base0C = "#e99696", base0D = "#ec9393", base0E = "#e99696", base0F = "#f4bebe",
                })
              end
            end

            apply()

            if dir then
              local uv = vim.uv or vim.loop
              local path = dir .. "/matugen.lua"
              local function mtime()
                local s = uv.fs_stat(path)
                return s and (s.mtime.sec * 1000 + s.mtime.nsec / 1e6) or 0
              end
              local last = mtime()
              local timer = uv.new_timer()
              timer:start(1000, 1000, vim.schedule_wrap(function()
                local m = mtime()
                if m ~= last then
                  last = m
                  apply()
                end
              end))
            end
          end

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
          base16 = {
            package = pkgs.vimPlugins.base16-nvim;
          };
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
