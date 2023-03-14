# Run NeoVim instance with this plugin being loaded
run:
	nvim --cmd "set rtp+=./" -c " :lua require('ltex-client').setup()"
