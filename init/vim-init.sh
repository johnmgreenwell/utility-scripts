#!/bin/bash
# Install, clone and copy in new vimrc file to set up vim
# Usage: vim-init.sh

if ! which git >/dev/null 2>&2; then
  echo "Installing git."
  sudo apt install git -y
fi

if which vim >/dev/null 2>&1; then
  echo "Vim is already installed."
  exit 0
else
  echo "Installing vim."
  sudo apt install vim -y
fi

# Bring in very useful pre-made template
git clone https://github.com/colbycheeze/dotfiles.git

cat >> dotfiles/vimrc <<- EOM

" Preference edits (original: https://github.com/colbycheeze/dotfiles.git)
set list listchars=tab:»·,nbsp:·
set belloff=all

nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" EOF

EOM

cp dotfiles/vimrc ~/.vimrc
rm -rf dotfiles

exit 0

# EOF
