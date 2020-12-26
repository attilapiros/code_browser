# code_browser

This is a Neovim plugin to open github links in a splitted window if the project is already cloned into a local directory.

## Installation

### vim-plug

An example of how to load this plugin using vim-plug:

```VimL
Plug 'attilapiros/code_browser'
```

After running `:PlugInstall`, the files should appear in your `~/.config/nvim/plugged` directory (or whatever path you have configured for plugins).

## Configs and usage

1) Clone the project source code to a local directory, i.e. `~/git/project_to_document`
2) start a wiki / markdown and set the followings (one can add such the line at the begining and source it by `:exec eval(@):` after yank it with `yy`):
```
let g:code_browser_settings = { 'url': 'https://github.com/attilapiros/code_browser/blob/main', 'dir': '/Users/attilazsoltpiros/git/attilapiros/code_browser' }
```
3) during code reading / documenting when a github link from the current line is needed one can use the vim command: `:SaveFilePosAsGithubLinkToClipboard`.
You can paste it and wrap around as wiki / markdown link, i.e: [example link](https://github.com/attilapiros/code_browser/blob/main/lua/codebrowser/init.lua#L63)

4) when you read the document and you are at line where a link is given to a line you can visit it by `:OpenCodeAt <index-of-the-link-within-the-current-line>`
regarding this the following mapping can be useful:
```
nnoremap <C-]> :<C-U>exe 'OpenCodeAt' . v:count1<CR>
```
Which can be called even with a number like `2<C-]>`.
