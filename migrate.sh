MAVEN_PROJECT_HOME="."
MAVEN_PROJECT_PROFILE=""
if [ $# -lt 2 ]; then
	echo "Usage: Please given more than 1 param."
	echo "Example: sh migrate.sh [profile] [module directory]"
	exit 1
fi
if [ $# == 2 ]; then
	MAVEN_PROJECT_PROFILE=$1
	MAVEN_PROJECT_HOME=$2
fi

eval "cd $MAVEN_PROJECT_HOME"
STATUS=$?
if [ $STATUS -ne 0 ]
then
	echo "Can not find migrate directory."
	exit 1
fi
echo "Current directory"
pwd

echo "Start migrate profile $MAVEN_PROJECT_PROFILE."
echo "mvn clean compile package flyway:migrate -P $MAVEN_PROJECT_PROFILE"
eval "mvn clean compile package flyway:migrate -P $MAVEN_PROJECT_PROFILE"
STATUS=$?
if [ $STATUS -eq 0 ]
then
	echo "Migrate successfully."
else
	echo "Migrate Failed."
	exit 1
fi