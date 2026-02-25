local _theme
local _trans

_theme = nixCats.extra("base16colors.base16")
_trans = nixCats.extra("base16colors.translucent")

if _theme ~= nil then
	--require('base16-colorscheme').setup(_theme)
	vim.cmd.packadd("mini.base16")
	require("mini.base16").setup({
		palette = _theme,
		plugins = {
			default = true,
			["echanovski/mini.nvim"] = true,
			["nvim-lualine/lualine.nvim"] = true,
			["rcarriga/nvim-dap-ui"] = true,
		},
	})

	--if _trans then
	vim.cmd.packadd("transparent.nvim")
	require("transparent").setup({
		auto = true,
	})
	--end
end

return {}
