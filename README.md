# LT<sub>E</sub>X LS Client for NeoVim

Small plugin that adds handlers for code actions fired by [LT<sub>E</sub>X Language Server](https://github.com/valentjn/ltex-ls):

-   Add to dictionary
-   Disable rule
-   Hide false positive

## Installation

First, you have to make sure [LT<sub>E</sub>X Language Server](https://github.com/valentjn/ltex-ls) is installed and configured. Please follow the instructions on the ltex-ls page. Please refer to [my configuration](https://github.com/icewind/nvim) for the example. Then, this plugin could be installed like this:

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use("icewind/ltex-client.nvim")
```

Or [lazy](https://github.com/folke/lazy.nvim):

```lua
{"icewind/ltex-client.nvim"}
```

## Configuration

Somewhere in your configuration call the setup function.

```lua
require("ltex-client").setup()
```

Default location to store user dictionaries is:

```
${HOME}/.ltex/dictionaries
```

The plugin will create three files there: `dictionary.json`, `disabled_rules.json`, `false_positives.json`.

If you want to change the location of dictionaries you can set it like this:

```lua
require("ltex-client").setup({
    user_dictionaries_path = vim.env.HOME .. 'some/other/path'
})
```

## Commands

| Command | Description |
| --- | --- |
|`:LTeXSetLanguage`| Sets the language for the current document |
|`:LTexStatus`| Shows a floating window with a status from LTeX-ls|
