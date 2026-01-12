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
	{
		"omnisharp",
		enabled = nixCats("cs") or false,
		lsp = {
			filetypes = { "cs" },
			root_dir = function(bufnr, on_dir)
				local util = require("lspconfig.util")
				local fname = vim.api.nvim_buf_get_name(bufnr)
				on_dir(
					util.root_pattern("*.sln")(fname)
						or util.root_pattern("*.csproj")(fname)
						or util.root_pattern("omnisharp.json")(fname)
						or util.root_pattern("function.json")(fname)
				)
			end,
			init_options = {},
			capabilities = {
				workspace = {
					workspaceFolders = false, -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
				},
			},
			settings = {
				FormattingOptions = {
					-- Enables support for reading code style, naming convention and analyzer
					-- settings from .editorconfig.
					EnableEditorConfigSupport = true,
					-- Specifies whether 'using' directives should be grouped and sorted during
					-- document formatting.
					OrganizeImports = nil,
				},
				MsBuild = {
					-- If true, MSBuild project system will only load projects for files that
					-- were opened in the editor. This setting is useful for big C# codebases
					-- and allows for faster initialization of code navigation features only
					-- for projects that are relevant to code that is being edited. With this
					-- setting enabled OmniSharp may load fewer projects and may thus display
					-- incomplete reference lists for symbols.
					LoadProjectsOnDemand = nil,
				},
				RoslynExtensionsOptions = {
					-- Enables support for roslyn analyzers, code fixes and rulesets.
					EnableAnalyzersSupport = nil,
					-- Enables support for showing unimported types and unimported extension
					-- methods in completion lists. When committed, the appropriate using
					-- directive will be added at the top of the current file. This option can
					-- have a negative impact on initial completion responsiveness,
					-- particularly for the first few completion sessions after opening a
					-- solution.
					EnableImportCompletion = nil,
					-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
					-- true
					AnalyzeOpenDocumentsOnly = nil,
					-- Enables the possibility to see the code in external nuget dependencies
					EnableDecompilationSupport = nil,
				},
				RenameOptions = {
					RenameInComments = nil,
					RenameOverloads = nil,
					RenameInStrings = nil,
				},
				Sdk = {
					-- Specifies whether to include preview versions of the .NET SDK when
					-- determining which version to use for project loading.
					IncludePrereleases = true,
				},
			},
		},
	},
	{
		"nvim-jdtls",
		enabled = nixCats("java") or false,
	},
})
local jdtls = require("jdtls")
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		local config = {
			cmd = {
				"jdtls",
				"--jvm-arg=-javaagent:" ..  nixCats.extra("lombok"),
			},
			root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml" }),
			settings = {
				java = {
					contentProvider = { preferred = "cfr" },
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					import = {
						maven = {
							enabled = true,
						},
						gradle = {
							enabled = true,
							wrapper = {
								enabled = true,
							},
						},
					},
					--[[
					configuration = {
						runtimes = {
							{
								name = "JavaSE-1.8",
								path = nixCats.extra["jdk8-path"],
							},
							{
								name = "JavaSE-21",
								path = "/run/current-system/sw/lib/openjdk",
							},
						},
					},
					]]
				},
			},
			init_options = {
				--[[
				bundles = {
					"/home/indi/Development/Java/vscode-java-decompiler/server/dg.jdt.ls.decompiler.cfr-0.0.3.jar",
					"/home/indi/Development/Java/vscode-java-decompiler/server/dg.jdt.ls.decompiler.common-0.0.3.jar",
					"/home/indi/Development/Java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.2.jar",
				},
				]]
				extendedClientCapabilities = jdtls.extendedClientCapabilities,
			},
			on_attach = require("volvimLua.lsp.on_attach"),
		}
		jdtls.start_or_attach(config)
	end,
})
