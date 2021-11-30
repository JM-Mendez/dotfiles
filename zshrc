#!/bin/zsh

# to debug, uncomment this line and the last one 'zprof'
# zmodload zsh/zprof
######################
#      PATHS	     #
######################
export PATH=/opt/homebrew/bin:$PATH
# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$ZSH/custom

autoload colors
if [[ "$terminfo[colors]" -gt 8 ]]; then
	colors
fi
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
	eval $COLOR='$fg_no_bold[${(L)COLOR}]'
	eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval RESET='$reset_color'

# Set the git editor
GIT_EDITOR="code --wait"

# Prevent git from using global config, ensures it's always set
git config --global user.useConfigOnly true

plugins=(zsh-autosuggestions zsh-syntax-highlighting)

ZSH_THEME="fwalch"
# load zsh
source $ZSH/oh-my-zsh.sh

##########################
#	      ALIASES	         #
##########################
alias cls='clear'

alias draftw='yarn dpad-draftjs:watch'
alias yr='yarn run'
alias ya='_add_prod_dep'
alias yad='_add_dev_dep'
alias yag='yarn global add'
alias yst='yarn start'
alias yup='yarn upgrade && yarn postinstall'
alias ycc='yarn cache clean'
alias yin='_yarn_install'
alias yui='_remove_dep'
alias yta='yarn test-all'
alias ytw='yarn test-watch'
alias ytc='yarn typecheck'
alias yte='yarn test-e2e'
alias plop='yr plop'

# alias gcmpkg='git commit -m "WIP: INSTALL PKGS"'
alias gchangedate='GIT_COMMITTER_DATE="$(date)" git commit --amend --no-edit --date "$(date)"'
alias gaa='git add --all'
alias gca='git commit --amend'
# alias glog='git-log --decorate --graph --remotes --all'
alias gpo='git push --follow-tags  origin $(git_current_branch)'
alias gpos='git push -o ci.skip --follow-tags origin $(git_current_branch)'
alias gfp='git push --follow-tags --force-with-lease origin $(git_current_branch)'
alias gfps='git push -o ci.skip --follow-tags --force-with-lease origin $(git_current_branch)'
alias gtag='git tag -a'
alias gffd='git fetch origin develop:develop'
alias gffm='git fetch origin master:master'
alias grbd='gffd && git rebase develop'
alias grbm='gffm && git rebase master && yin'
alias grbi='git rebase -i --keep-empty'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grh='git reset --hard HEAD~1'
alias gro='git reset --hard origin/$(git_current_branch) && yin'
alias grm='git reset --mixed HEAD~1'
alias grs='git reset --soft HEAD~1'
alias gwip='_wipstaged'
alias gwipnv='_wipstaged_nv'
alias gwipa='_wipall'
alias gcp='_git_checkpoint'
alias gcpnv='_git_checkpoint_nv'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gbs='git bisect'
alias gbb='git bisect bad'
alias gbg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gcmm='git commit -m'
alias gcm='git commit'
alias gcmnv='git commit --no-verify'
alias gcz='_git_commit'
alias gcze='_git_commit empty'
alias gcznv='_git_commit no-verify'
alias gss='git stash save $(print -Pn "%D{%m/%d %H:%M:%S} ")'
alias gslist='git stash list'
alias up='_up'
alias chgh='_synch_ch_with_github'

tabdpad() {
	tabset --badge "dpad $1"
}

tabdraft() {
	tabset --badge "draft $1"
}

_yarn_install() {
	yarn install $@
}

_git_commit() {
	local CURRENT_COMMIT=$(git rev-parse HEAD)
	if [[ $1 = 'empty' ]]; then
		yarn run cz --allow-empty
	elif [[ $1 = 'no-verify' ]]; then
		yarn run cz --no-verify
	else
		yarn run cz
	fi

	local NEXT_COMMIT=$(git rev-parse HEAD)
	if [[ $CURRENT_COMMIT != $NEXT_COMMIT ]]; then

		echo # (optional) move to a new line
		read "REPLY?Do you want to amend the commit? [Y/n] "

		if [[ $REPLY =~ ^[Yy]$ || -z $REPLY ]]; then
			if [[ $1 = 'empty' ]]; then
				git commit --amend --allow-empty
			else
				git commit --amend
			fi
		else
			echo
			echo commit amend aborted
		fi
	else
		echo
		echo commit aborted
	fi
}

_add_dev_dep() {
	yarn add -D $@
}

_add_prod_dep() {
	yarn add $@
}

check_has_postinstall_script() {
	[[ $(cat package.json | grep "\"ostinstall\":" | wc -l) -gt 0 ]]
}

_remove_dep() {
	yarn remove "$@"
	check_has_postinstall_script
	[[ $(cat package.json | grep "\"ostinstall\":" | wc -l) -gt 0 ]] && yarn postinstall
}

_wipall() {
	git add --all
	git rm $(git ls-files --deleted) 2>/dev/null
	git commit --no-verify -m "--wip-- $1 [skip ci]"
}

_wipstaged() {
	git rm $(git ls-files --deleted) 2>/dev/null
	git commit -m "--wip-- $1 [skip ci]"
}

_wipstaged_nv() {
	git rm $(git ls-files --deleted) 2>/dev/null
	git commit --no-verify -m "--wip-- $1 [skip ci]"
}

_git_checkpoint() {
	git commit -m "* CP - $1"
}

_git_checkpoint_nv() {
	git commit --no-verify -m "* CP - $1"
}

_up() {
	times=$1
	while [ "$times" -gt "0" ]; do
		cd ..
		times=$(($times - 1))
	done
}

# end of profiling
# zprof

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
