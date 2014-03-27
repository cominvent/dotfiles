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

function wpt {

	if [ -z "$1" ]; then
		echo 'usage: wpt <ticket-number>'
		return
	fi

	open $(printf https://core.trac.wordpress.org/ticket/%d $1)

}

function wpc {

	if [ -z "$1" ]; then
		echo 'usage: wpc <changeset-number>'
		return
	fi

	open $(printf https://core.trac.wordpress.org/changeset/%d $1)

}

function wpblame {

	padding=10

	if [ -z "$1" -o -z "$2" ]; then
		echo "usage: wpblame <file> <line-number> [<padding>]"
		return
	fi

	if [ -n "$3" ]; then
		padding="$3"
	fi

	first_line=$(($2 - $padding))
	last_line=$(($2 + $padding))

	if [ "$first_line" -lt 1 ]; then
		target="$2"
		first_line=1
	else
		target=$(($padding+1))
	fi

	blame=$(svn blame $1)
	lines=$(echo "$blame" | cat -n | sed -n ${first_line},${last_line}p)
	changeset=$(echo "$blame" | tr -s ' ' | cut -f 2 -d ' ' | sed -n ${2}p)
	count=1

	while read -r line; do
		if [ $count -eq $target ]; then
			echo "$(tput setaf 2)${line}$(tput sgr0)"
		else
		    echo "$line"
		fi
	    (( count++ ))
	done <<< "$lines"

	read -p "View changeset $changeset? (y/n) " -n 1 -r
	echo    # move to a new line

	if [[ $REPLY =~ ^[Yy]$ ]]; then
	    wpc "$changeset"
	fi

}
