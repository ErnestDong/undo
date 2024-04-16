# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# Copyright (c) 2022 Ernest DONG

# According to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

# Then ${0:h} to get plugin's directory

if [[ ${zsh_loaded_plugins[-1]} != */undo && -z ${fpath[(r)${0:h}]} ]] {
    fpath+=( "${0:h}" )
}

# Standard hash for plugins, to not pollute the namespace
typeset -gA Plugins
Plugins[UNDO_DIR]="${0:h}"

autoload -Uz template-script

undo(){
    local lastcmd=`history | tail -n1|head -n1 | gsed 's/[0-9]* //'`
    if [[ $lastcmd == *"brew install "* ]]; then
        local cmdtodo="uninstall"
        local cmd=${lastcmd//install/uninstall}
        echo $cmd
        eval ${cmd} && brew autoremove
    elif [[ $lastcmd == *"git commit "* ]]; then
        git reset HEAD^ --soft
    elif [[ $lastcmd == *"launchctl load"* ]]; then
		eval ${lastcmd//load/unload}
    elif [[ $lastcmd == *"cd "* ]]; then
        cd -
    fi
}
# Use alternate vim marks [[[ and ]]] as the original ones can
# confuse nested substitutions, e.g.: ${${${VAR}}}

# vim:ft=zsh:tw=80:sw=4:sts=4:et:foldmarker=[[[,]]]
