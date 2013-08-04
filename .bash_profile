export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH

# aliases
alias ls="ls -aGl"

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
