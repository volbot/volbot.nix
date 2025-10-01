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
        go = nixCats('go') and { 'golangcilint' } or nil,
        c = nixCats('c') or nil,
        svelte = nixCats('svelte') or nil,
        ts = nixCats('ts') or nil,
        js = nixCats('ts') or nil,
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
})
