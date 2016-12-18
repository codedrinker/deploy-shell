TOMCAT_HOME=""
MAVEN_PROJECT_HOME=""
TOMCAT_TARGET="ROOT"
MAVEN_MODULE_NAME=""
if [ $# -lt 3 ]; then
	echo "Usage: Please given more than 3 param."
	echo "Example: sh tomcat-deploy.sh tomcat-home project-home module-name [war name, eq ROOT or front]"
	exit 1
fi
if [ $# == 3 ]; then
	TOMCAT_HOME=$1
	MAVEN_PROJECT_HOME=$2
	MAVEN_MODULE_NAME=$3
fi
if [ $# == 4 ]; then
	TOMCAT_HOME=$1
	MAVEN_PROJECT_HOME=$2
	MAVEN_MODULE_NAME=$3
	TOMCAT_TARGET=$4
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
		echo "Kill previsous process failed"
		exit 1
	fi
}

stopPreviousProcess

for i in $(echo $TOMCAT_TARGET | tr "," "\n")
do
  	echo "rm -rf $TOMCAT_HOME/webapps/$i.war"
	echo "rm -rf $TOMCAT_HOME/webapps/$i/"

	eval "rm -rf $TOMCAT_HOME/webapps/$i.war"
	eval "rm -rf $TOMCAT_HOME/webapps/$i/"

	echo "cp $MAVEN_PROJECT_HOME/$MAVEN_MODULE_NAME/target/$MAVEN_MODULE_NAME-0.0.1.war $TOMCAT_HOME/webapps/$i.war"
	eval "cp $MAVEN_PROJECT_HOME/$MAVEN_MODULE_NAME/target/$MAVEN_MODULE_NAME-0.0.1.war $TOMCAT_HOME/webapps/$i.war"
done

echo 'Sleep for restart'
date "+%Y-%m-%d %H:%M:%S"
sleep 1
date "+%Y-%m-%d %H:%M:%S"

echo 'Starting tomcat'
echo "sh $TOMCAT_HOME/bin/catalina.sh start"
eval "sh $TOMCAT_HOME/bin/catalina.sh start"