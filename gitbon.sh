
cwd=$(pwd)
target="$cwd/.bon_commit"

if [ -f $target ]; then
	rm $target
fi

changed=$(git diff --name-only $1)

for name in $changed; do

	git add -p $name

	echo "Enter commit message for later: (optional)"
	read cmt
	if [ ! -z "$cmt" ]; then
		touch $target
		echo $cmt >> $target
	fi

done
