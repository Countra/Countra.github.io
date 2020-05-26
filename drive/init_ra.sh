#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


RedBG="\033[41;37m"
Font="\033[0m"

cd /usr/share/vim
ls > ~/temporary.txt
version=$(grep -E "vim[0-9][0-9]" ~/temporary.txt)
wget -P /usr/share/vim/${version}/colors https://raw.githubusercontent.com/Countra/Countra.github.io/master/drive/gruvbox.vim
rm ~/temporary.txt
cd ~
echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> .vimrc
echo "set termencoding=utf-8" >> .vimrc
echo "set encoding=utf-8" >> .vimrc
echo "colorscheme gruvbox" >> .vimrc
echo "set bg=dark" >> .vimrc
echo "syntax on" >> .vimrc
echo "set nu" >> .vimrc
echo "set hlsearch" >> .vimrc
echo "set incsearch" >> .vimrc
echo "set number" >> .vimrc
echo "set ignorecase" >> .vimrc
echo "set smartcase" >> .vimrc
echo "inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap \" \"\"<LEFT>
inoremap ' ''<LEFT>
inoremap < <><LEFT>
function! RemovePairs()
    let s:line = getline(\".\")
    let s:previous_char = s:line[col(\".\")-1]
if index([\"(\",\"[\",\"{\"],s:previous_char) != -1
        let l:original_pos = getpos(\".\")
        execute \"normal %\"
        let l:new_pos = getpos(\".\")
        \" only right (
        if l:original_pos == l:new_pos
            execute \"normal! a\<BS>\"
            return
        end
let l:line2 = getline(\".\")
        if len(l:line2) == col(\".\")
            execute \"normal! v%xa\"
        else
            execute \"normal! v%xi\"
        end
    else
        execute \"normal! a\<BS>\"
    end
endfunction
function! RemoveNextDoubleChar(char)
    let l:line = getline(\".\")
    let l:next_char = l:line[col(\".\")]
if a:char == l:next_char
        execute \"normal! l\"
    else
        execute \"normal! i\" . a:char . \"\"
    end
endfunction
inoremap <BS> <ESC>:call RemovePairs()<CR>a
inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a
inoremap > <ESC>:call RemoveNextDoubleChar('>')<CR>a" >> .vimrc
echo -e "${RedBG}配置vim完成${Font}"
echo -e "${RedBG}接下来配置SSH免密登录${Font}"
cd /etc/ssh
echo "RSAAuthentication yes" >> sshd_config
echo "PubkeyAuthentication yes" >> sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" >> sshd_config
echo "PasswordAuthentication no" >> sshd_config
echo "PermitEmptyPasswords no" >> sshd_config
echo -e "${RedBG}SSH配置完成${Font}"
systemctl restart sshd
cd ~
echo -e "${RedBG}接下来配置bash快捷指令${Font}"
echo "alias ll=\"ls -all\"" >> .bashrc
echo "alias lc=\"ls --color\"" >> .bashrc
echo "alias cls=\"clear\"" >> .bashrc
source ~/.bashrc
echo -e "${RedBG}Finish${Font}"