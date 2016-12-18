GIT_HOME="."
GIT_BRANCH="master"
if [ $# == 1 ]; then
	GIT_BRANCH=$1
fi

if [ $# == 2 ]; then
	GIT_BRANCH=$1
	GIT_HOME=$2
fi

eval "cd $GIT_HOME"
echo "Current directory"
pwd

echo "Start checkout branch to $GIT_BRANCH."
eval "git checkout $GIT_BRANCH"
STATUS=$?
if [ $STATUS -eq 0 ]
then
	echo "Checkout branch Successful."
	echo "Start git pull"
	if [ "$(git pull)" == "Already up-to-date." ];then
		exit 2 # need update
	fi
else
	echo "Need checkout new branch from remote."
	eval "git branch $GIT_BRANCH"
	echo "Start git pull"
	git pull
fi

STATUS=$?
if [ $STATUS -eq 0 ]
then
	echo "Update Code Successful"
else
	echo "Update Code Failed"
	exit 1 # unexpected error
fi
