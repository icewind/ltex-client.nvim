# LT<sub>E</sub>X LS Client for NeoVim

Small plugin that adds handlers for code actions fired by [LT<sub>E</sub>X Language Server](https://github.com/valentjn/ltex-ls):

-   Add to dictionary
-   Disable rule
-   Hide false positive

## Installation

First, you have to make sure [LT<sub>E</sub>X Language Server](https://github.com/valentjn/ltex-ls) is installed and configured. Please follow the instructions on the ltex-ls page. Please refer to [my configuration](https://github.com/icewind/dotfiles) for the example. Then, this plugin could be installed like this:

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use("icewind/ltex-client.nvim")
```

Or [lazy](https://github.com/folke/lazy.nvim):

```lua
return {
    "icewind/ltex-client.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
}
```

Please pay attention, in order to call the setup, lazy.nvim requires `opts` key to be any truthy value.

## Configuration

| Name | Default Value |
| -- | -- |
| user_dictionaries_path | `${HOME}/.ltex/dictionaries` |

The plugin will create three files there: `dictionary.json`, `disabled_rules.json`, `false_positives.json`.

In case you're using lazy.nvim, and default configuration works for you, there is no need to take any additional steps. Otherwise, the plugin could be configured by calling setup function manually like this:

```lua
return {
    "icewind/ltex-client.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        user_dictionaries_path = vim.env.HOME .. 'some/other/path'
    }
}
```

## Commands

| Command | Description |
| --- | --- |
|`:LTeXSetLanguage`| Sets the language for the current document |
|`:LTeXStatus`| Shows a floating window with a status from LTeX-ls|

## Hints

In order to make sure ltex-client is installed along with LTeX-ls, for lazy.nvim and Mason, you can define it like this:

```lua
return {
    { 
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "ltex-ls" })
        end,
    },
    {
        "icewind/ltex-client.nvim",
        opts = {},
    },
}
```

