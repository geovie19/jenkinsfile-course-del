
## Sonarquabe intergration with jenins
1- install plugin
- Quality Gates Plugin: Quality Gates
- Sonar Quality Gates Plugin: Sonar Quality
- SonarQube Scanner Plugin: SonarQube Scanner
- Docker Pipeline Plugin : Docker Pipeline

2- Genarate a toke in sonarqube
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
- We want to install SonarQube from jenkinskins here and put it in /opt

5- Install sonar-scanner
- Avoid using Jenkins installation in tools
- Install sonar-scanner in your agent before taking the image

```sh
# https://github.com/SonarSource/sonar-scanner-cli/releases

sudo apt update -y
sudo apt install nodejs npm -y

sonar_scanner_version="5.0.1.3006"                 
wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonar_scanner_version}-linux.zip
unzip sonar-scanner-cli-${sonar_scanner_version}-linux.zip
sudo mv sonar-scanner-${sonar_scanner_version}-linux sonar-scanner
sudo rm -rf  /var/opt/sonar-scanner || true
sudo mv sonar-scanner /var/opt/
sudo rm -rf /usr/local/bin/sonar-scanner || true
sudo ln -s /var/opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/ || true
sonar-scanner -v
```

```groovy
        stage('SonarQube Analysis') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        withSonarQubeEnv('SonarScanner') {
                            sh "sonar-scanner"
                        }
                    }
                }
            }
        }
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

```sh
# https://github.com/SonarSource/sonar-scanner-cli/releases

sudo apt update -y
sudo apt install nodejs npm -y

sonar_scanner_version="5.0.1.3006"                 
wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonar_scanner_version}-linux.zip
unzip sonar-scanner-cli-${sonar_scanner_version}-linux.zip
sudo mv sonar-scanner-${sonar_scanner_version}-linux sonar-scanner
sudo rm -rf  /var/opt/sonar-scanner || true
sudo mv sonar-scanner /var/opt/
sudo rm -rf /usr/local/bin/sonar-scanner || true
sudo ln -s /var/opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/ || true
sonar-scanner -v
```


```groovy
pipeline {
    agent {
        label 'aws-deploy'
    }
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
                        // Check if sonar-project.properties exists and remove it if found
                        if (fileExists('sonar-project.properties')) {
                            sh 'rm sonar-project.properties'
                        }
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
        stage('Install sonar-scanner CLI') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        def sonar_scanner_version="5.0.1.3006"
                        sh """
                            # https://github.com/SonarSource/sonar-scanner-cli/releases

                            sudo apt update -y
                            sudo apt install nodejs npm -y

                            wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonar_scanner_version}-linux.zip
                            unzip sonar-scanner-cli-${sonar_scanner_version}-linux.zip
                            sudo mv sonar-scanner-${sonar_scanner_version}-linux sonar-scanner
                            sudo rm -rf  /var/opt/sonar-scanner || true
                            sudo mv sonar-scanner /var/opt/
                            sudo rm -rf /usr/local/bin/sonar-scanner || true
                            sudo ln -s /var/opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/ || true
                            sonar-scanner -v
                        """
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        withSonarQubeEnv('SonarScanner') {
                            sh "sonar-scanner"
                        }
                    }
                }
            }
        }
    }
}

```


```groovy
pipeline {
    agent {
        label 'aws-deploy'
    }
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
                        // Check if sonar-project.properties exists and remove it if found
                        if (fileExists('sonar-project.properties')) {
                            sh 'rm sonar-project.properties'
                        }
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
        stage('Install sonar-scanner CLI') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        def sonar_scanner_version="5.0.1.3006"
                        sh """
                            # https://github.com/SonarSource/sonar-scanner-cli/releases

                            sudo apt update -y
                            sudo apt install nodejs npm -y

                            wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonar_scanner_version}-linux.zip
                            unzip sonar-scanner-cli-${sonar_scanner_version}-linux.zip
                            sudo mv sonar-scanner-${sonar_scanner_version}-linux sonar-scanner
                            sudo rm -rf  /var/opt/sonar-scanner || true
                            sudo mv sonar-scanner /var/opt/
                            sudo rm -rf /usr/local/bin/sonar-scanner || true
                            sudo ln -s /var/opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/ || true
                            sonar-scanner -v
                        """
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                dir("${WORKSPACE}/code/application/${params.APP_NAME}") {
                    script {
                        withSonarQubeEnv('SonarScanner') {
                            sh "/var/opt/sonar-scanner/bin/sonar-scanner"
                        }
                    }
                }
            }
        }
    }
}
```