pipeline {
    agent any

    environment {
        AWS_REGION       = "ap-south-1"
        DOCKER_REGISTRY  = "rahulkumarpaswan"
        FRONTEND_IMAGE   = "${DOCKER_REGISTRY}/qr-generator-frontend:${BUILD_NUMBER}"
        BACKEND_IMAGE    = "${DOCKER_REGISTRY}/qr-generator-backend:${BUILD_NUMBER}"
        BUILD_TAG        = "${env.BUILD_NUMBER}"
        K8S_CLUSTER_NAME = "devops-qr-cluster"
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['create', 'destroy'],
            description: 'Select whether to CREATE or DESTROY resources'
        )
    }

    stages {
        stage('Cleanup Workspace') {
            steps { cleanWs() }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'infra/cicd', credentialsId: 'git-token', url: 'https://github.com/Rahul-Kumar-Paswan/DevOps-QR-Generator.git'
            }
        }

        
        // Terraform Infrastructure
        stage('Terraform Init & Apply/Destroy') {
            steps {
                withCredentials([
                    file(credentialsId: 'prod-tfvars', variable: 'TFVARS_FILE'),
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                ]) {
                    dir('./Infra/') {
                        script {
                            sh '''
                                terraform fmt -check
                                terraform validate
                                terraform init
                            '''
                            if (params.ACTION == 'create') {
                                sh 'terraform plan -var-file=$TFVARS_FILE'
                                sh 'terraform apply -auto-approve -var-file=$TFVARS_FILE'
                            } else {
                                sh 'terraform plan -destroy -var-file=$TFVARS_FILE'
                                sh 'terraform destroy -auto-approve -var-file=$TFVARS_FILE'
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Outputs') {
            steps {
                dir('./Infra/') {
                    sh 'terraform output || echo "No outputs available (resources may be destroyed)"'
                }
            }
        }
        
        // Build & Push Docker Images  
        stage('Build & Push Docker Images') {
            when { expression { params.ACTION == 'create' } }
            parallel {
                backend: {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        dir('./QR-Generator/backend-api/') {
                            sh "docker build -t ${BACKEND_IMAGE} . && docker push ${BACKEND_IMAGE}"
                        }
                    }
                },
                frontend: {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        dir('./QR-Generator/front-end-nextjs/') {
                            sh "docker build -t ${FRONTEND_IMAGE} . && docker push ${FRONTEND_IMAGE}"
                        }
                    }
                }
            }
        }
        
        // Deploy to EKS
        stage('Deploy to Kubernetes') {
            when { expression { params.ACTION == 'create' } }
            steps {
                dir('./Kubernetes/') {
                    withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                    ]) {
                        script {
                            sh """
                                export BACKEND_IMAGE=${BACKEND_IMAGE}
                                export FRONTEND_IMAGE=${FRONTEND_IMAGE}
                                aws eks --region ${AWS_REGION} update-kubeconfig --name ${K8S_CLUSTER_NAME}
                                kubectl apply -f secret.yml
                                kubectl apply -f configmap.yaml
                                envsubst < backend-deployment.yaml | kubectl apply -f -
                                envsubst < frontend-deployment.yaml | kubectl apply -f -
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed (success or failure)"
        }
        success {
            stage('Verify Kubernetes Deployment') {
                steps {
                    dir('./Kubernetes/') {
                        script {
                            sh """
                                echo 'Checking pods status...'
                                kubectl get pods -o wide
                                echo 'Checking services status...'
                                kubectl get svc -o wide
                                echo 'Waiting for backend pods to be ready...'
                                kubectl wait --for=condition=ready pod -l app=backend --timeout=120s
                                echo 'Waiting for frontend pods to be ready...'
                                kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s
                                echo 'Deployment verified successfully!'
                            """
                        }
                    }
                }
            }
        }
        failure {
            echo "Pipeline failed! Please check logs for errors."
        }
    }
}
