# WP-CLI directory
PATH=/Users/john/.wp-cli/bin:$PATH

# Pipe all SVN commands through colordiff
svn() {
	/usr/local/bin/svn "${@}" | colordiff
}
