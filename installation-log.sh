# fstarをインストールしたlog
#
#

# vscode devcontainer の linuxで、初期状態から実行

# 環境確認

uname -a # Linux 0541344b25e3 5.10.16.3-microsoft-standard-WSL2 #1 SMP Fri Apr 2 22:23:49 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
cat /etc/issue # Ubuntu 22.04.1 LTS \n \l

# opam (OCaml Package Manager) setup

## opam install
sudo bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
opam --version # 2.1.3


# https://github.com/FStarLang/FStar/blob/master/INSTALL.md#prerequisites-working-ocaml-setup

# opam init に bwrapが必要と言われるので、 bwrapをインストール

## apt更新
sudo apt update

## bwrap install
sudo apt install bubblewrap
which bwrap # /usr/bin/bwrap

## opam init
opam init

## [ERROR] Sandboxing is not working on your platform ubuntu:
##        "~/.opam/opam-init/hooks/sandbox.sh build sh -c echo SUCCESS >$TMPDIR/opam-sandbox-check-out && cat $TMPDIR/opam-sandbox-check-out; rm -f $TMPDIR/opam-sandbox-check-out" exited with code 1 "bwrap: No permissions to create new
##        namespace, likely because the kernel does not allow non-privileged user namespaces. See <https://deb.li/bubblewrap> or <file:///usr/share/doc/bubblewrap/README.Debian.gz>."
## Do you want to disable it?  Note that this will result in less secure package builds, so please ensure that you have some other isolation mechanisms in place (such as running within a container or virtual machine). [y/N] y
##
## y を選択


## Do you want opam to modify ~/.zshrc? [N/y/f]
## (default is 'no', use 'f' to choose a different file) y
##
## y を選択

source ~/.zshrc

## PATHにopam周りが入っていることを確認
echo $PATH | grep opam
# /home/vscode/.opam/default/bin:/vscode/vscode-server/bin/linux-x64/8fa188b2b301d36553cbc9ce1b0a146ccb93351f/bin/remote-cli:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vscode/.local/bin

# fstarのインストール
# cf. https://github.com/FStarLang/FStar/blob/master/INSTALL.md#opam-package

## versionを指定して fstar のインストール (10分かかる)
opam pin add fstar https://github.com/FStarLang/FStar.git  --with-version "2022.11.07"
fstar.exe --version
# F* 2022.11.07~dev
# platform=Linux_x86_64
# compiler=OCaml 4.14.0
# date=2022-11-07 14:39:50 -0800
# commit=b5a11b5d150891a481079359b46a0e19eb750a04


# この repositoryの内容で、動作確認
## このrepositoryからmakefileと main.fstさえ持ってくれば動くはず


make check
# fstar.exe main.fst
# main.fst(5,0-7,18): (Warning 272) Top-level let-bindings must be total; this term may have effects
# Verified module: Main
# All verification conditions discharged successfully

make execute
# rm -rf gen
# mkdir gen
# fstar.exe --codegen OCaml --extract "Main" --odir gen main.fst
# Extracted module Main
# main.fst(5,0-7,18): (Warning 272) Top-level let-bindings must be total; this term may have effects
# Verified module: Main
# All verification conditions discharged successfully
# ocamlfind ocamlopt -o program  -I gen -package fstarlib -linkpkg gen/*.ml
# ./program
# hello world from fstar!
