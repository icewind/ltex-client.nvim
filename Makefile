# Run NeoVim instance with this plugin being loaded
run:
	nvim --cmd "set rtp+=./" -c " :lua require('ltex-client').setup()"

# Run tests using plenary.nvim
test:
	nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}"
