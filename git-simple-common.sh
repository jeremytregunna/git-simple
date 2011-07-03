
# Log some output to stderr, prefix command name
warn() {
	echo "`basename $0`: $@" 2>&1
}
# Error with some string
die() {
	warn $1
	exit
}

# Checks if a branch is dirty.
is_dirty() {
	git diff-index --quiet HEAD
}

# Get the current branch name.
current_branch_name() {
	git branch | grep "^\*" | sed -e 's/[ \*]*//g'
}