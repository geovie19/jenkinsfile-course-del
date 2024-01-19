## Condictions
```groovy
BRANCH_NAME == "dev" || BRANCH_NAME == "prod"
BRANCH_NAME == "dev" || BRANCH_NAME == "prod" || BRANCH_NAME == "qa"
BRANCH_NAME == "dev" && BRANCH_NAME == "prod"
BRANCH_NAME == "dev" && BRANCH_NAME == "prod" && BRANCH_NAME == "qa"

BRANCH_NAME != "master" && BRANCH_NAME != "prod"

BRANCH_NAME == "dev" && CODE_CHANGES == true


env.BRANCH_NAME == "dev" || env.BRANCH_NAME == "prod"
env.BRANCH_NAME == "dev" || env.BRANCH_NAME == "prod" || env.BRANCH_NAME == "qa"
env.BRANCH_NAME == "dev" && env.BRANCH_NAME == "prod"
env.BRANCH_NAME == "dev" && env.BRANCH_NAME == "prod" && env.BRANCH_NAME == "qa"

env.BRANCH_NAME != "master" && env.BRANCH_NAME != "prod"

env.BRANCH_NAME == "dev" && env.CODE_CHANGES == true
```

```groovy
pipeline {
    agent any
    
    environment {
        DEPLOY_FLAG = true // Set a variable to control the stage
    }
    
    stages {
        stage('Deploy') {
            when {
                expression { return env.DEPLOY_FLAG == 'true' }
            }
            steps {
                sh 'deploy_script.sh'
            }
        }
    }
}
       

pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Deploy') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                sh 'deploy_script.sh'
            }
        }
    }
}

pipeline {
    agent any
    
    parameters {
        booleanParam(name: 'DEPLOY_FLAG', defaultValue: true, description: 'Deploy the application?')
    }
    
    stages {
        stage('Deploy') {
            when {
                expression { params.DEPLOY_FLAG == true }
            }
            steps {
                sh 'deploy_script.sh'
            }
        }
    }
}
   
pipeline {
    agent any

    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'development', description: 'Target environment')
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Deploy the application?')
    }

    stages {
        stage('Deployment') {
            when {
                expression { params.ENVIRONMENT == 'production' && params.DEPLOY == true }
            }
            steps {
                sh 'deploy_to_production.sh'
            }
        }
    }
}


pipeline {
    agent any

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Deployment environment')
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Git branch name')
    }

    stages {
        stage('Deploy') {
            when {
                expression { params.DEPLOY_ENV == 'production' && params.BRANCH_NAME == 'main' }
            }
            steps {
                sh 'deploy_to_production.sh'
            }
        }
    }
}


pipeline {
    agent any

    parameters {
        choice(name: 'DATABASE', choices: ['mysql', 'postgres'], description: 'Select a database')
        booleanParam(name: 'USE_SSL', defaultValue: false, description: 'Use SSL?')
    }

    stages {
        stage('Database Configuration') {
            when {
                expression { params.DATABASE == 'postgres' || (params.DATABASE == 'mysql' && params.USE_SSL == true) }
            }
            steps {
                sh 'configure_database.sh'
            }
        }
    }
}

            
            
pipeline {
    agent any

    parameters {
        string(name: 'DATABASE_TYPE', defaultValue: 'mysql', description: 'Database type')
        choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Deployment environment')
    }

    stages {
        stage('Database Deployment') {
            when {
                expression { params.DATABASE_TYPE == 'mysql' && params.DEPLOY_ENV == 'production' }
            }
            steps {
                sh 'deploy_mysql_to_production.sh'
            }
        }
    }
}
            

pipeline {
    agent any
    
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Deployment environment')
    }
    
    stages {
        stage('Deployment') {
            when {
                expression { params.DEPLOY_ENV != 'production' }
            }
            steps {
                sh 'deploy_to_staging.sh'
            }
        }
    }
}

                  
            
pipeline {
    agent any
    
    parameters {
        choice(name: 'BUILD_TYPE', choices: ['debug', 'release'], description: 'Build type')
    }
    
    stages {
        stage('Build') {
            when {
                expression { params.BUILD_TYPE != 'release' }
            }
            steps {
                sh 'build_debug.sh'
            }
        }
    }
}
    
        

pipeline {
    agent any

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Deployment environment')
    }

    stages {
        stage('Deploy') {
            when {
                expression { params.DEPLOY_ENV != 'staging' }
            }
            steps {
                sh 'deploy_to_production.sh'
            }
        }
    }
}
```