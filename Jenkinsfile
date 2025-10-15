pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Rahul-Kumar-Paswan/DevOps-QR-Generator.git'
            }
        }

        stage('Testing') {
            steps {
                echo "Testing........"
            }
        }
	stage('Build') {
            steps {
                echo "Building........"
            }
        }	
        stage('Deploy to Production') {
                  steps {
                      echo "Deploying to PRODUCTION from main branch........"
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
