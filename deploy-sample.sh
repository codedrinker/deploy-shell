sh git-pull.sh
status=$?
if [ $status -eq 0 ]; then 
	echo "exec successfully."
elif [ $status -eq 2 ]; then 
	echo "no need update code."
else
	echo "something wrong."
	exit 1
fi
