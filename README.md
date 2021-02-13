# searchant.vim

Vim plugin for improved search highlighting

## Overview

When it comes to searching Vim is one of the editors which lacks the feature
of highlighting the current search result. Searchant wraps the hacky way to
achieve this in Vim into a plugin with a clean interface. Additionally it
provides a key mapping to stop the search highlighting.

View the documentation in Vim with `:help searchant` or [on the web](https://raw.githubusercontent.com/timakro/vim-searchant/master/doc/searchant.txt).

![vim-searchant demo](https://files.timakro.de/vim-searchant.png)

## Requirements

* Vim 7.0+

## Installation

It is recommended to install this plugin using a plugin manager like
[pathogen.vim](http://github.com/tpope/vim-pathogen),
[Vundle.vim](https://github.com/VundleVim/Vundle.vim) or
[vim-plug](https://github.com/junegunn/vim-plug).

Alternatively you can just drop the `plugin` and `doc` folders into your
`~/.vim` directory. Don't forget to run `:helptags ~/.vim/doc` to generate the
help tags after a manual installation.

If you are using [incsearch.vim](https://github.com/haya14busa/incsearch.vim)
and you'd like `vim-searchant` to play-nicely, you can add the following snippet
to hide the searchant highlight:

```vim
" Disable Searchant highlight when incsearch.vim highlights also disable
autocmd CursorMoved * call SearchantStop()
function SearchantStop()
  :execute "normal \<Plug>SearchantStop"
endfunction
```

This assumes that you have `let g:incsearch#auto_nohlsearch = 1` in your config.
