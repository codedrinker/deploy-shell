MAVEN_PROJECT_HOME="."
MAVEN_PROJECT_NAME=""
MAVEN_PROJECT_PROFILE=""
if [ $# -lt 2 ]; then
	echo "Usage: Please given more than 1 param."
	echo "Example: sh mvn-package.sh [module name] [profile] [module directory]"
	exit 1
fi
if [ $# == 2 ]; then
	MAVEN_PROJECT_NAME=$1
	MAVEN_PROJECT_PROFILE=$2
fi

if [ $# == 3 ]; then
	MAVEN_PROJECT_NAME=$1
	MAVEN_PROJECT_PROFILE=$2
	MAVEN_PROJECT_HOME=$3
fi

eval "cd $MAVEN_PROJECT_HOME"
echo "Current directory"
pwd

echo "Start package maven module $MAVEN_PROJECT_NAME, profile $MAVEN_PROJECT_PROFILE."
echo "mvn clean -U -DskipTests package -pl :$MAVEN_PROJECT_NAME -am -P $MAVEN_PROJECT_PROFILE"
eval "mvn clean -U -DskipTests package -pl :$MAVEN_PROJECT_NAME -am -P $MAVEN_PROJECT_PROFILE"
STATUS=$?
if [ $STATUS -eq 0 ]
then
	echo "Maven package Successful."
else
	echo "Maven package Failed."
	exit 1
fi