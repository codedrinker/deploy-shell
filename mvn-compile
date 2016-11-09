file="$HOME/redeploy.pid"

function clean_up {
	rm $file
	exit 1
}

function check_process {
	if [ -f "$file" ]
	then
		echo "redeploy script is already running!! on pid"
		more $file
		exit 1
	else
		echo $$ > "$file"
		echo "start redeploy"	
	fi
}

function process {
	echo "start process"
	cd /Users/codedrinker/Code/LocalDefault
	mvn compile
	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Deployment Successful"
	else
		echo "Deployment Failed"
	fi
	echo "end process"
}

# delete temp file when exit unexcepted
trap clean_up SIGHUP SIGINT SIGTERM

# check the process is already running
check_process

# main process
process

rm $file


