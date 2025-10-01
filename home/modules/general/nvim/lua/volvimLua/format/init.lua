require("lze").load({
  {
    "conform.nvim",
    enabled = nixCats('general') or false,
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    after = function (plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          lua = nixCats('lua') and { "stylua" } or nil,
          go = nixCats('go') and { "gofmt", "golint" } or nil,
          nix = nixCats('nix') and { "alejandra" } or nil,
          c = nixCats("c") or nil,
          cs = nixCats("cs") or nil,
          javascript = nixCats('js') and { { "prettierd", "prettier" } } or nil,
          typescript = nixCats('js') and { { "prettierd", "prettier" } } or nil,
          -- templ = { "templ" },
          -- Conform will run multiple formatters sequentially
          -- python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
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
  }
})
