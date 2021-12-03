#!/bin/bash
mkdir ~/playground/golang
export GOPATH=~/playground/golang
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

if [ ! -f  $GOPATH/bin/powerline-go ]
then
 go install github.com/justjanne/powerline-go@latest

fi


# Add powerline-go
function _update_ps1() {
    PS1="$($GOPATH/bin/powerline-go \
        -newline -cwd-max-depth 5 -mode compatible\
        -max-width 95 -shell bash\
         -modules 'docker,venv,host,ssh,cwd,perms,git,hg,jobs,exit,root,kube')"
}

export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
