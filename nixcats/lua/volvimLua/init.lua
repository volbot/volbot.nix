require("lze").register_handlers(require("lzextras").lsp)

require("lze").h.lsp.set_ft_fallback(function(name)
	return dofile(nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) .. "/lsp/" .. name .. ".lua").filetypes
		or {}
end)

require("volvimLua.opts_and_keys")

require("lze").load {
	{ import = "volvimLua.plugins" },
	-- { import = "volvimLua.plugins.colorscheme" },
	{ import = "volvimLua.lsp" },
	{ import = "volvimLua.lint" },
	{ import = "volvimLua.format" },
	{ import = "volvimLua.debug" },
}
