sh git-pull.sh master ../git-continue-learning
status=$?
if [ $status -eq 0 ]; then 
	echo "Exec successfully."
	echo "Start mvn build"
	sh mvn-package.sh git-continue-learning vagrant ../git-continue-learning
	mvn_status=$?
	if [ $mvn_status -eq 0 ]; then
		echo "Maven build successfully."
	else
		echo "Maven build failed."
		exit 1
	fi
elif [ $status -eq 2 ]; then 
	echo "Don't need mvn package."
else
	echo "something wrong."
	exit 1
fi
