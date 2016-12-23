PROJECT_HOME="/Users/codedrinker/Code/shell-script-web-sample"
file="$HOME/shell-script.pid"

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
		echo "Start deploy"	
	fi
}

function deploy {
	sh tomcat-deploy.sh /Users/codedrinker/App/apache-tomcat-7.0.67 /Users/codedrinker/Code/shell-script-web-sample/target/shell-script-web-sample-0.0.1.war ROOT
	tomcat_deploy_status=$?
	if [ $tomcat_deploy_status -eq 0 ]; then
		echo "Deploy successfully."
	else
		clean_up
		echo "Deploy failed."
	fi  
}

function process {
	sh git-pull.sh master $PROJECT_HOME
	status=$?
	if [ $status -eq 0 ]; then 
		echo "Exec successfully."
		echo "Start mvn build"
		sh mvn-package.sh shell-script-web-sample vagrant $PROJECT_HOME
		mvn_status=$?
		if [ $mvn_status -eq 0 ]; then
			echo "Maven package successfully."
			sh migrate.sh vagrant $PROJECT_HOME
			migrate_status=$?
			if [ $migrate_status -eq 0 ]; then
				echo "Migrate successfully."
				deploy
			else
				echo "Migrate failed."
				clean_up
				exit 1
			fi
		else
			echo "Maven build failed."
			clean_up
			exit 1
		fi
	elif [ $status -eq 2 ]; then 
		echo "Don't need mvn package."
		deploy
	else
		echo "something wrong."
		clean_up
		exit 1
	fi
}

# delete temp file when exit unexcepted
trap clean_up SIGHUP SIGINT SIGTERM

# check the process is already running
check_process

# main process
process

rm $file

