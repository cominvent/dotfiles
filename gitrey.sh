
cwd=$(pwd)
target="$cwd/.bon_commit"

if [ ! -f $target ]; then
	echo "No commit message file present"
	exit
fi

git commit --file=$target
rm $target
