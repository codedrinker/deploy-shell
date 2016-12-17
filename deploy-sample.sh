sh git-pull.sh master ../git-continue-learning
status=$?
if [ $status -eq 0 ]; then 
	echo "exec successfully."
	echo "start mvn build"
	pwd
	sh mvn-package.sh shell-script vagrant
elif [ $status -eq 2 ]; then 
	echo "no need update code."
	echo "start mvn build"
	pwd
	sh mvn-package.sh shell-script vagrant
	echo $?
else
	echo "something wrong."
	exit 1
fi
