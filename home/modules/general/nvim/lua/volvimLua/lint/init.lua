require("lze").load({
  {
    "nvim-lint",
    enabled = nixCats('general') or false,
    event = "FileType",
    after = function (plugin)
      require('lint').linters_by_ft = {
        -- NOTE: download some linters in lspsAndRuntimeDeps
        -- and configure them here
        -- markdown = {'vale',},
        -- javascript = { 'eslint' },
        -- typescript = { 'eslint' },
        go = { 'golangcilint' },
        html = {"htmlhint"},
        lua = {"luacheck"},
        javascript = {"eslint"},
        typescript = {"eslint"},
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
})
