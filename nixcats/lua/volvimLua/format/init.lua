require("lze").load({
  {
    "conform.nvim",
    --enabled = nixCats("general") or false,
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    after = function(plugin)
      local conform = require("conform")

      conform.setup({
        formatters = {
          goimports = {
            command = "goimports",
            args = { "-local", "gitlab.com/hmajid2301,git.curve.tools,go.curve.tools" },
          },
          yamlfmt = {
            args = { "-formatter", "retain_line_breaks_single=true" },
          },
        },
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          lua = { "stylua" },
          go = { "gofmt", "goimports" },
          nix = { "nixfmt" },
          c = { "clang-format" },
          cs = { "csharpier" },
          css = { "prettierd" },
          html = {"htmlbeautifier", "rustywind"},
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          svelte = { "prettierd" },
          python = { "isort", "black" },
          yaml = { "yamlfmt" },
          rust = {"rustfmt"},
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })
    end,
  },
})
