# shell-script
A collection shell scripts contains compile project script, migrate script, redeploy project script, backup script etc.
Also all execptions have been handle.

#Usage
You can clone repo to anywhere, and then define a shell-script home to your path.

#Descriptio

## git-pull.sh
Integrate git pull command, and return whether need update code.
```
sh git-pull.sh
```

## migrate.sh 
Using Flyway migration tool.
```
sh migrate.sh profile module-directory
```

## mvn-package.sh
Package specific module, also no need to build any useless module.
```
sh mvn-package.sh module-name profile module-directory
```

## tomcat-deploy.sh
Deploy Tomcat easily. also this shell can restart tomcat by the specific name.
```
sh tomcat-deploy.sh tomcat-home maven-target webapp-name
```


## deploy-sample.sh
A sample for using `scripts`, also contains unexcepted stop execption, this sample depends on the [shell-script-web-sample](https://github.com/codedrinker/shell-script-web-sample) project.
