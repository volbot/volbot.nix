return {
  {
    "lualine.nvim",
    enabled = nixCats('general') or false,
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    load = function (name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("lualine-lsp-progress")
    end,
    after = function (plugin)

      require('lualine').setup({
        options = {
          icons_enabled = false,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_c = {
            {
              'filename', path = 1, status = true,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              'filename', path = 3, status = true,
            },
          },
          lualine_x = {'filetype'},
        },
        tabline = {
          lualine_a = { 'buffers' },
          lualine_b = { 'lsp_progress', },
          lualine_z = { 'tabs' }
        },
      })
    end,
  },
  {
    "which-key.nvim",
    enabled = nixCats('general') or false,
    event = "DeferredUIEnter",
    after = function (plugin)
      require('which-key').setup({})
      require('which-key').add {
        { "<leader><leader>", group = "buffer commands" },
        { "<leader><leader>_", hidden = true },
        { "<leader>c", group = "[c]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d", group = "[d]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>g", group = "[g]it" },
        { "<leader>g_", hidden = true },
        { "<leader>r", group = "[r]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>f", group = "[f]ind" },
        { "<leader>f_", hidden = true },
        { "<leader>s", group = "[s]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t", group = "[t]oggles" },
        { "<leader>t_", hidden = true },
        { "<leader>w", group = "[w]orkspace" },
        { "<leader>w_", hidden = true },
      }
    end,
  },
}
