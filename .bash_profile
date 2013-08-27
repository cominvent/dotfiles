export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH

# aliases
alias ls="ls -aGl"
alias git-svn="git svn"

# Apply a Trac patch.
function tracpatch() {

	if [ -z "$1" ]; then
		echo 'usage: tracpatch <url>'
		return
	fi

	curl "$1?format=raw" | patch -p0

}

# Generate an SVN-compatible patch from Git.
function svndiff() {

	if [ -z "$1" ]; then
		local branch=`git rev-parse --abbrev-ref HEAD`
	else
		local branch=$1
	fi

	if [ -z "$branch" ]; then
		return
	else
		git diff master... --no-prefix > "$branch.diff"
	fi

}

# git-aware prompt
#  \u           user
#  \h           host
#  \w           working dir
#  \[\033[XXm\] begin colour
#  \[\033[m\]   end colour
#  \$git_branch branch
#  \$git_dirty  dirty indicator
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source $GITAWAREPROMPT/main.sh
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[36m\]\h:\[\033[33m\]\w\[\033[m\]\[\033[36m\]\$git_branch\[\033[33m\]\$git_dirty\[\033[m\]\$ "

# WP-CLI Bash completions
source $HOME/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash
# Git autocompletions:
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
