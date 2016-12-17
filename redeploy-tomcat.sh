file="$HOME/redeploy.pid"
CATALINA_HOME="/home/local/apache-tomcat-7.0.67"
SOURCE_HOME="/home/test/test"
MIGRATION_HOME="$SOURCE_HOME/migration"
TARGET_HOME="$SOURCE_HOME/test-0.0.1.war"
PROJECT_NAME="ROOT.war"
ENV_NAME="envname"

function clean_up {
	rm $file
	exit 1
}

function restartProcess {
	rm -rf $CATALINA_HOME/webapps/$PROJECT_NAME
	rm -rf $CATALINA_HOME/logs/*
	eval "cp $TARGET_HOME $CATALINA_HOME/webapps/$PROJECT_NAME"
	
	echo 'sleep for restart'
	date "+%Y-%m-%d %H:%M:%S"
	sleep 2
	date "+%Y-%m-%d %H:%M:%S"

	echo 'start tomcat'
	echo "sh $CATALINA_HOME/bin/catalina.sh start"
	eval "sh $CATALINA_HOME/bin/catalina.sh start"
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

function stopPreviousProcess {
	pid=$(ps aux | grep "file=$CATALINA_HOME" | grep -v grep | awk '{print $2}')
	echo "kill -9 $pid"
	kill -9 $pid

	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Kill Successful"
	else
		echo "Kill Failed"
	fi
}

function databaseMigrate {	
	echo 'migrate database'

	echo "$MIGRATION_HOME"
	cd $MIGRATION_HOME

	echo "mvn clean compile flyway:migrate -P $ENV_NAME"
	eval "mvn clean compile flyway:migrate -P $ENV_NAME"

	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Migrate Successful"
	else
		echo "Migrate Failed"
		exit 1
	fi
}

function reloadSource {
	echo 'change branch'
	if [ $# != 1 ]
	  then
	  echo "checkout master"
	  git checkout master
	  else
	  echo "checkout provide branch"
	  echo $1
	  git checkout $1
	fi

	echo 'update code'
	git pull

	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Update Code Successful"
	else
		echo "Update Code Failed"
		exit 1
	fi
}

function buildSource {
	echo "cd $SOURCE_HOME"
	cd $SOURCE_HOME

	reloadSource

	echo "mvn clean -U -DskipTests  package -P $ENV_NAME"
	eval "mvn clean -U -DskipTests  package -P $ENV_NAME"

	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Build Source Successful"
	else
		echo "Build Source Failed"
		exit 1
	fi
}

function process {
	echo "start process"

	buildSource	

	databaseMigrate

	stopPreviousProcess

	restartProcess
	
	echo "end process"
}

# delete temp file when exit unexcepted
trap clean_up SIGHUP SIGINT SIGTERM

# check the process is already running
check_process

# main process
process

rm $file


