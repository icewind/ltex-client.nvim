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
return {
    "icewind/ltex-client.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
}
```

Please pay attention, that you have to either call setup function manually, or provide `opts` with any truthy value, so lazy.nvim will call it automatically.

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
    config = function() 
        require("ltex-client").setup({
            user_dictionaries_path = vim.env.HOME .. 'some/other/path'
        })
    end
}
```

## Commands

| Command | Description |
| --- | --- |
|`:LTeXSetLanguage`| Sets the language for the current document |
|`:LTexStatus`| Shows a floating window with a status from LTeX-ls|

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
        config = true
    },
}
```

