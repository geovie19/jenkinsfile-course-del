
## Sonarquabe intergration with jenins
1- install plugin
- Quality Gates Plugin: Quality Gates
- Sonar Quality Gates Plugin: Sonar Quality
- SonarQube Scanner Plugin: SonarQube Scanner
- Docker Pipeline Plugin : Docker Pipeline

2- Genarate a token in sonarqube
- go to account 
- security
- generate the token - user-token
- create a secret test in jenkins

3- Configure sonarquabe in system
- go to SonarQube servers - Add SonarQube
- put the name, the url and token

4- System configuration
- got to SonarQube Scanner installations - Add SonarQube Scanner
- put the name: SonarScanner. This is because it will be used in the jenkinsfile
- add the installation version - keep the latest version
- check Environment variables
- PS: SonarScanner name configure in jenkins should be the same here withSonarQubeEnv('SonarScanner') in jenkinsfile
- We do not want to install SonarQube from jenkinskins here

```groovy
        stage('SonarQube analysis') {
            steps {
                script {
                    def sourceCodeDir = "${WORKSPACE}/code/application/${params.APP_NAME}"
                    dir(sourceCodeDir) {
                        docker.image('sonarsource/sonar-scanner-cli:5').inside {
                            withSonarQubeEnv('SonarScanner') {
                                sh "ls"
                                sh "/opt/sonar-scanner/bin/sonar-scanner"
                            }
                        }
                    }
                }
            }
        }
```
## Check the SonarQube binary path in the container
the binary is located in /opt/sonar-scanner/bin/sonar-scanner inside the container. Use put the path here: sh "/opt/sonar-scanner/bin/sonar-scanner" so that it will use it to scan the code
```
docker run -it sonarsource/sonar-scanner-cli:5 /bin/bash
find / -name sonar-scanner
```
## create a project in SonarQube
- go to project - create project - choose manually - put Project display name and Project key as the same name and hit set up 
- choose jenkins - click on Github - confiure analysis - configure - choose the languare - and hit finsh this tutorial
- create a file call sonar-project.properties at the root of your project
- Change the sonar.projectKey to match the key name in SonarQube and sonar.projectName to the project name in SonarQube
- sonar.sources=.: this means the source code is where the sonar-project.properties is in the repository
```s
sonar.host.url=https://sonarqube.ektechsoftwaresolution.com/
sonar.projectKey=test-sonar2
sonar.projectName=test-sonar2
sonar.projectVersion=1.0
sonar.sources=.
qualitygate.wait=true 
```

```groovy
node {
  stage('SCM') {
    checkout scm
  }
  stage('SonarQube Analysis') {
    def scannerHome = tool 'SonarScanner';
    withSonarQubeEnv() {
      sh "${scannerHome}/bin/sonar-scanner"
    }
  }
}
```


```groovy
pipeline {
    agent any
    parameters {
        string (name: 'BRANCH_NAME', defaultValue: 'dev', description: '')
        string (name: 'APP_NAME', defaultValue: 'articles', description: '')
    }
    
    stages {
        stage ('Checkout') {
            steps {
                dir("${WORKSPACE}/code") {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "*/${env.BRANCH_NAME}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[$class: 'LocalBranch']],
                        submoduleCfg: [],
                        userRemoteConfigs: [[
                            url: 'https://github.com/devopstia/pipelines.git',
                            credentialsId: 'tia-github-auth'
                        ]]
                    ])
                }
            }
        }
        stage('Remove Existing sonar-project.properties') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        sh """
                            rm -rf sonar-project.properties || true
                        """
                    }
                }
            }
        }
        stage('Create sonar-project.properties') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        // Define the content of sonar-project.properties
                        def sonarProjectPropertiesContent = """
                            sonar.host.url=https://sonarqube.ektechsoftwaresolution.com/
                            sonar.projectKey=test-sonar2
                            sonar.projectName=test-sonar2
                            sonar.projectVersion=1.0
                            sonar.sources=.
                            qualitygate.wait=true
                        """

                        // Create the sonar-project.properties file
                        writeFile file: 'sonar-project.properties', text: sonarProjectPropertiesContent
                    }
                }
            }
        }
        stage('Open sonar-project.properties') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        // Use 'cat' command to display the content of sonar-project.properties
                        sh 'cat sonar-project.properties'
                    }
                }
            }
        }
        stage('SonarQube analysis') {
            steps {
                script {
                    def sourceCodeDir = "${WORKSPACE}/code/application/${params.APP_NAME}"
                    dir(sourceCodeDir) {
                        docker.image('sonarsource/sonar-scanner-cli:5').inside {
                            withSonarQubeEnv('SonarScanner') { // this SonarScanner must be the same as the one configire in global in jenkins so that SonarQube will get the credentials to publish of SonarQube analysis to SonarQube UI
                                sh "ls"
                                sh "/opt/sonar-scanner/bin/sonar-scanner"
                            }
                        }
                    }
                }
            }
        }
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
    }
}
```



```groovy
pipeline {
    agent any
    parameters {
        string (name: 'BRANCH_NAME', defaultValue: 'dev', description: '')
        string (name: 'APP_NAME', defaultValue: 'articles', description: '')
    }
    
    stages {
        stage ('Checkout') {
            steps {
                dir("${WORKSPACE}/code") {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "*/${env.BRANCH_NAME}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[$class: 'LocalBranch']],
                        submoduleCfg: [],
                        userRemoteConfigs: [[
                            url: 'https://github.com/devopstia/pipelines.git',
                            credentialsId: 'tia-github-auth'
                        ]]
                    ])
                }
            }
        }
        stage('Remove Existing sonar-project.properties') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        sh """
                            rm -rf sonar-project.properties || true
                        """
                    }
                }
            }
        }
        stage('Create sonar-project.properties') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        // Define the content of sonar-project.properties
                        def sonarProjectPropertiesContent = """
                            sonar.host.url=https://sonarqube.ektechsoftwaresolution.com/
                            sonar.projectKey=test-sonar2
                            sonar.projectName=test-sonar2
                            sonar.projectVersion=1.0
                            sonar.sources=.
                            qualitygate.wait=true
                        """

                        // Create the sonar-project.properties file
                        writeFile file: 'sonar-project.properties', text: sonarProjectPropertiesContent
                    }
                }
            }
        }
        stage('Open sonar-project.properties') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        // Use 'cat' command to display the content of sonar-project.properties
                        sh 'cat sonar-project.properties'
                    }
                }
            }
        }
        stage('SonarQube analysis') {
            steps {
                script {
                    def sourceCodeDir = "${WORKSPACE}/code/application/${params.APP_NAME}"
                    def scannerHome='/opt/sonar-scanner'
                    dir(sourceCodeDir) {
                        docker.image('sonarsource/sonar-scanner-cli:5').inside {
                            withSonarQubeEnv('SonarScanner') { // this SonarScanner must be the same as the one configire in global in jenkins so that SonarQube will get the credentials to publish of SonarQube analysis to SonarQube UI
                                sh "ls"
                                sh "${scannerHome}/bin/sonar-scanner"
                            }
                        }
                    }
                }
            }
        }
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
    }
}
```