--- https://github.com/mrjosh/helm-ls
return {
	cmd = { "helm_ls", "serve" },
	filetypes = { "helm", "yaml.helm-values" },
	root_markers = { "Chart.yaml" },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
}
