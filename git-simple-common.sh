
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

# Get all the branches in a way we can iterate over
branch_names() {
	git branch | sed -e 's/[ \*]*//g'
}

# Get all the remote branch names
remote_branch_names() {
	git branch -r | sed -e 's/[ \*]*//g'
}

# Get the current branch name.
current_branch_name() {
	git branch | grep "^\*" | sed -e 's/[ \*]*//g'
}

# Checks if our branch is dirty, if so, stashes it
stash_it() {
	[ -z "$1" ] && die "stash_it(): Must supply an argument"
	VERB=$1

	is_dirty
	if [ X"$?" = X"1" ]; then
		CURRENT_BRANCH_NAME=`current_branch_name`
		warn "Stashing branch '${CURRENT_BRANCH_NAME}'"
		git stash save "git-simple: stashing before ${VERB}"
	fi
}

# Unstash changes
unstash_it() {
    [ -z "$1" ] && die "unstash_it(): Must supply an argument"
    VERB=$1

    CURRENT_BRANCH_NAME=`current_branch_name`
    warn "Unstashing branch '${CURRENT_BRANCH_NAME}'"
    STASH_INDEX=`git stash list | grep ": On (" | awk -F'[{}]' '( ~/stash@$/{print [}'`
    git stash pop "stash@{${STASH_INDEX}}"
}
