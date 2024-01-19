
## Jenkins Pipeline job Integration with slack | Integrate with Slack (Get started with Jenkins)
- https://www.youtube.com/watch?v=llg06jmt6X8
- https://eavnitech.com/blog/send-notification-to-slack-from-the-Jenkins-CI-job-and-jenkinsfile/
- https://github.com/devopstia/it/tree/master/Jenkins/Jenkins-Slack-Notification

## Create a token
- go to slack 
- tools and setting 
- manage app 
- searxh for jenkins in the search bar 
- click on jenkins 
- click on configuration to see all webhook
- If tou want to create a new weebkook, click on add to slack
- Select the default channel that you want
- When a webhook is created and configure in Jenkins, you can only change the channel in the post action to send notification to a specify channel. No more webhook needed

## Token
Kwt1y9UzVDowEtrnCUBcJBF0

## This use the same token to publish in 2 different channel
```groovy
pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                script {
                    sh """
                        ls -l
                    """
                }
            }
        }
    }
    post {
        success {
            slackSend color: '#2EB67D',
            channel: 'learning', 
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *SUCCESS*" +
            "\n Build url : ${env.BUILD_URL}"
        }
        failure {
            slackSend color: '#E01E5A',
            channel: 'learning',  
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *FAILED*" +
            "\n Action : Please check the console output to fix this job IMMEDIATELY" +
            "\n Build url : ${env.BUILD_URL}"
        }
        unstable {
            slackSend color: '#ECB22E',
            channel: 'learning', 
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *UNSTABLE*" +
            "\n Action : Please check the console output to fix this job IMMEDIATELY" +
            "\n Build url : ${env.BUILD_URL}"
        }   
    }
}


pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                script {
                    sh """
                        ls -l
                    """
                }
            }
        }
    }
    post {
        success {
            slackSend color: '#2EB67D',
            channel: 'testing-tia', 
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *SUCCESS*" +
            "\n Build url : ${env.BUILD_URL}"
        }
        failure {
            slackSend color: '#E01E5A',
            channel: 'testing-tia',  
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *FAILED*" +
            "\n Action : Please check the console output to fix this job IMMEDIATELY" +
            "\n Build url : ${env.BUILD_URL}"
        }
        unstable {
            slackSend color: '#ECB22E',
            channel: 'testing-tia', 
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *UNSTABLE*" +
            "\n Action : Please check the console output to fix this job IMMEDIATELY" +
            "\n Build url : ${env.BUILD_URL}"
        }   
    }
}

```


## Warning and alerts before the build
```groovy
pipeline {
    agent any
    stages {
        stage('Warning') {
            steps {
                script {
                    def slackConfig = [
                        color: '#2EB67D',
                        channel: 'testing-tia', 
message: """*Alpha Project Build Status*
Project Name: Alpha
Job Name: ${env.JOB_NAME}
Message : This is 5 minutes warning before production release starts"""
                    ]
                    slackSend(slackConfig)
                    sh """
                        sleep 300
                    """
                }
            }
        }
        stage('Anonce The Build') {
            steps {
                script {
                    def slackConfig = [
                        color: '#2EB67D',
                        channel: 'testing-tia', 
message: """*Alpha Project Build Status*
Project Name: Alpha
Job Name: ${env.JOB_NAME}
Message : DevOps Teams started the Production deployment and We will let the QA teams know when it is ready for testing"""
                    ]
                    slackSend(slackConfig)
                }
            }
        }
        stage('test') {
            steps {
                script {
                    sh """
                        ls -l
                    """
                }
            }
        }
    }
    post {
        success {
            slackSend color: '#2EB67D',
            channel: 'testing-tia', 
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *SUCCESS*" +
            "\n Build url : ${env.BUILD_URL}"
        }
        failure {
            slackSend color: '#E01E5A',
            channel: 'testing-tia',  
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *FAILED*" +
            "\n Action : Please check the console output to fix this job IMMEDIATELY" +
            "\n Build url : ${env.BUILD_URL}"
        }
        unstable {
            slackSend color: '#ECB22E',
            channel: 'testing-tia', 
            message: "*Alpha Project Build Status*" +
            "\n Project Name: Alpha" +
            "\n Job Name: ${env.JOB_NAME}" +
            "\n Build number: ${currentBuild.displayName}" +
            "\n Build Status : *UNSTABLE*" +
            "\n Action : Please check the console output to fix this job IMMEDIATELY" +
            "\n Build url : ${env.BUILD_URL}"
        }   
    }
}
```