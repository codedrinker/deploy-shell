TOMCAT_HOME=""
MAVEN_TARGET=""
TOMCAT_TARGET="ROOT"
if [ $# -lt 2 ]; then
	echo "Usage: Please given more than 3 param."
	echo "Example: sh tomcat-deploy.sh tomcat-home maven-target [war name, eq ROOT or front]"
	exit 1
fi
if [ $# == 2 ]; then
	TOMCAT_HOME=$1
	MAVEN_TARGET=$2
fi
if [ $# == 3 ]; then
	TOMCAT_HOME=$1
	MAVEN_TARGET=$2
	TOMCAT_TARGET=$3
fi

function stopPreviousProcess {
	pid=$(ps aux | grep "file=$TOMCAT_HOME" | grep -v grep | awk '{print $2}')
	echo "kill -9 $pid"
	kill -9 $pid

	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Kill previsous process successfully."
	else
		echo "Kill previsous process failed."
	fi
}

stopPreviousProcess

for i in $(echo $TOMCAT_TARGET | tr "," "\n")
do
  	echo "rm -rf $TOMCAT_HOME/webapps/$i.war"
	echo "rm -rf $TOMCAT_HOME/webapps/$i/"

	eval "rm -rf $TOMCAT_HOME/webapps/$i.war"
	eval "rm -rf $TOMCAT_HOME/webapps/$i/"

	echo "cp $MAVEN_TARGET $TOMCAT_HOME/webapps/$i.war"
	eval "cp $MAVEN_TARGET $TOMCAT_HOME/webapps/$i.war"
done

cp_status=$?
if [ $cp_status -eq 0 ];then
	echo "Copy war successfully."
	echo 'Sleep for restart'
	date "+%Y-%m-%d %H:%M:%S"
	sleep 1
	date "+%Y-%m-%d %H:%M:%S"

	echo 'Starting tomcat'
	echo "sh $TOMCAT_HOME/bin/catalina.sh start"
	eval "sh $TOMCAT_HOME/bin/catalina.sh start"
else
	echo "Copy war failed."
	exit 1
fi
