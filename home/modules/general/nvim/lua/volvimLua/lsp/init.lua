-- NOTE: Register a handler from lzextras. This one makes it so that
-- you can set up lsps within lze specs,
-- and trigger vim.lsp.enable and the rtp config collection only on the correct filetypes
-- it adds the lsp field used below
-- (and must be registered before any load calls that use it!)
require("lze").register_handlers(require("lzextras").lsp)
-- also replace the fallback filetype list retrieval function with a slightly faster one
require("lze").h.lsp.set_ft_fallback(function(name)
	return dofile(nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) .. "/lsp/" .. name .. ".lua").filetypes
	or {}
end)
require("lze").load({
	{
		"nvim-lspconfig",
		enabled = nixCats("general") or false,
		-- the on require handler will be needed here if you want to use the
		-- fallback method of getting filetypes if you don't provide any
		on_require = { "lspconfig" },
		-- define a function to run over all type(plugin.lsp) == table
		-- when their filetype trigger loads them
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(_)
			vim.lsp.config("*", {
				on_attach = require("volvimLua.lsp.on_attach"),
			})
		end,
	},
	{
		-- name of the lsp
		"lua_ls",
		enabled = nixCats("lua") or false,
		-- provide a table containing filetypes,
		-- and then whatever your functions defined in the function type specs expect.
		-- in our case, it just expects the normal lspconfig setup options.
		lsp = {
			-- if you provide the filetypes it doesn't ask lspconfig for the filetypes
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim" },
						disable = { "missing-fields" },
					},
					telemetry = { enabled = false },
				},
			},
		},
		-- also these are regular specs and you can use before and after and all the other normal fields
	},
	{
		"gopls",
		enabled = nixCats("go") or false,
		-- if you don't provide the filetypes it asks lspconfig for them using the function we set above
		lsp = {
			-- filetypes = { "go", "gomod", "gowork", "gotmpl" },
		},
	},
	{
		"nixd",
		enabled = nixCats("nix") or false,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					-- nixd requires some configuration.
					-- luckily, the nixCats plugin is here to pass whatever we need!
					-- we passed this in via the `extra` table in our packageDefinitions
					-- for additional configuration options, refer to:
					-- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
					nixpkgs = {
						-- in the extras set of your package definition:
						-- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
						expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
					},
					options = {
						nixos = {
							-- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.nixos_options"),
						},
						["home-manager"] = {
							-- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.home_manager_options"),
						},
					},
					formatting = {
						command = { "alejandra" },
					},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
	{ "pyright", lsp = {} },
	{ "jsonls", lsp = {} },
	{ "yamlls", lsp = {} },
	{ "tailwindcss", lsp = {} },
	{ "html", lsp = {} },
	{ "cssls", lsp = {} },
	{ "svelte", lsp = {} },
	{ "ts_ls", lsp = {} },
	{ "taplo", lsp = {} },
	{
		"clangd",
		lsp = {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
			},
			root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json" },
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "y", "l" },
		},
	},
	{
	  "scheme_langserver",
	  enabled = nixCats("scheme") or false,
	  lsp = {
	    filetypes = { "scheme", "scm", "ss", "rkt" },
	  },
		"rust-analyzer",
		lsp = {
			enabled = nixCats("rust") or false,
			filetypes = { "rust" },
			settings = {
				["rust-analyzer"] = {
					check = {
						command = "clippy",
						extraArgs = { "--no-deps" },
					},
					cargo = {
						allTargets = false,
					},
					diagnostics = {
						experimental = {
							enable = true,
						},
					},
					cachePriming = {
						enable = false,
					},
				},
			},
			capabilities = {
				experimental = {
					serverStatusNotification = true,
				},
			},
			before_init = function(init_params, config)
				if config.settings and config.settings["rust-analyzer"] then
					init_params.initializationOptions = config.settings["rust-analyzer"]
				end
			end,
			root_markers = { "Cargo.toml" },
		},
	},
})
