PROJECT_HOME="/Users/codedrinker/Code/shell-script-web-sample"
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
			sh tomcat-deploy.sh /Users/codedrinker/App/apache-tomcat-7.0.67 /Users/codedrinker/Code/shell-script-web-sample/target/shell-script-web-sample-0.0.1.war ROOT
			tomcat_deploy_status=$?
			if [ $tomcat_deploy_status -eq 0 ]; then
				echo "Deploy successfully."
			else
				echo "Deploy failed."
			fi  
		else
			echo "Migrate failed."
			exit 1
		fi
	else
		echo "Maven build failed."
		exit 1
	fi
elif [ $status -eq 2 ]; then 
	echo "Don't need mvn package."
	sh tomcat-deploy.sh /Users/codedrinker/App/apache-tomcat-7.0.67 /Users/codedrinker/Code/shell-script-web-sample/target/shell-script-web-sample-0.0.1.war ROOT
	tomcat_deploy_status=$?
	if [ $tomcat_deploy_status -eq 0 ]; then
		echo "Deploy successfully."
	else
		echo "Deploy failed."
	fi  
else
	echo "something wrong."
	exit 1
fi
