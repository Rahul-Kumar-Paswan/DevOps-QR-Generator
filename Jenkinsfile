pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        ENV = "prod"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Rahul-Kumar-Paswan/DevOps-QR-Generator.git'
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo "Deploying to PRODUCTION from main branch..."
            }
        }
    }

    post {
        success {
            echo "Deployment succeeded!"
        }
        failure {
            echo "Deployment failed."
        }
    }
}
