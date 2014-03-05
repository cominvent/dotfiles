export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=/usr/local/php5/bin:$PATH

# aliases
alias ls="ls -aGl"
alias git-svn="git svn"
alias got="say"

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
		echo 'No git branch found!'
		return
	else
		git diff master... --no-prefix > "$branch.diff"
	fi

	echo "Created $branch.diff"

}

function svn() {

	array=( $@ )
	len=${#array[@]}
	_args=${array[@]:1:$len}

	case "$1" in

	'difftool')
		svn diff --diff-cmd ~/svndiff "$_args"
		;;

	*)
		# Pipe all other SVN commands through colordiff
		/usr/local/bin/svn "${@}" | colordiff
		;;

	esac

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

# WP-CLI autocompletions:
if [ -f "$HOME/.wp-cli/utils/wp-completion.bash" ]; then
	source "$HOME/.wp-cli/utils/wp-completion.bash"
fi

# Git autocompletions:
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Find the top-most directory for a Git repo (helper function)
function find_git_repo_root {

	local dir=$PWD

	until [ "$dir" -ef / ]; do

		if [ -f "$dir/.git/HEAD" ]; then
			git_repo_root=$dir
			return
		fi

		dir="$(dirname "$dir")"

	done

	git_repo_root=""

}

# Add an entry to the current Git repo's .gitignore file
function gitignore {

	if [ -z "$1" ]; then
		echo 'usage: gitignore <file>'
		return
	fi

	find_git_repo_root
	touch "$git_repo_root/.gitignore"
	echo "$1" >> "$git_repo_root/.gitignore"

	echo "Added $1 to $git_repo_root/.gitignore"

}
