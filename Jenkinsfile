pipeline {
    agent any

    environment {
        AWS_REGION       = "ap-south-1"
        DOCKER_REGISTRY  = "rahulkumarpaswan"
        FRONTEND_IMAGE   = "${DOCKER_REGISTRY}/qr-generator-frontend:${BUILD_NUMBER}"
        BACKEND_IMAGE    = "${DOCKER_REGISTRY}/qr-generator-backend:${BUILD_NUMBER}"
        BUILD_TAG        = "${env.BUILD_NUMBER}"
        K8S_CLUSTER_NAME = "devops-qr-cluster"
        IAM_POLICY_NAME  = "QRGenerator-S3-Policy"
        SERVICE_ACCOUNT  = "aws-secrets-sa"
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
                git branch: 'main', credentialsId: 'git-token', url: 'https://github.com/Rahul-Kumar-Paswan/DevOps-QR-Generator.git'
            }
        }

        stage('Cleanup Kubernetes Resources Before Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                dir('./K8S-ISRA/') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']]) {
                        script {
                            sh """
                                aws eks --region ${AWS_REGION} update-kubeconfig --name ${K8S_CLUSTER_NAME}
                                echo "Deleting Kubernetes services and deployments to cleanup load balancers and related SGs..."
                                kubectl delete -f backend-deployment.yaml || true
                                kubectl delete -f frontend-deployment.yaml || true
                                kubectl delete -f configmap.yaml || true
                                kubectl delete svc --all || true
                                kubectl delete serviceaccount ${SERVICE_ACCOUNT} || true
                                # Wait a bit to allow AWS to cleanup load balancers and security groups
                                echo "Waiting 90 seconds for AWS to cleanup resources..."
                                sleep 90
                            """
                        }
                    }
                }
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
                                terraform init
                                terraform validate
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
            steps {
                withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                    script {
                        dir('./QR-Generator/backend-api/') {
                            sh "docker build -t ${BACKEND_IMAGE} . && docker push ${BACKEND_IMAGE}"
                        }
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
                dir('./K8S-ISRA/') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                    ]) {
                        script {
                            // 1. Update kubeconfig
                            sh """
                                aws eks --region ${AWS_REGION} update-kubeconfig --name ${K8S_CLUSTER_NAME}
                            """

                            // 2. Associate OIDC provider
                            echo "Associating OIDC provider with EKS (if needed)..."
                            def oidcStatus = sh(script: "eksctl utils associate-iam-oidc-provider --region ${AWS_REGION} --cluster ${K8S_CLUSTER_NAME} --approve", returnStatus: true)
                            if (oidcStatus != 0) {
                                echo "OIDC already associated, skipping."
                            }

                            // 3. Get policy ARN dynamically
                            def policyArn = sh(
                                script: "aws iam list-policies --query \"Policies[?PolicyName=='${IAM_POLICY_NAME}'].Arn\" --output text",
                                returnStdout: true
                            ).trim()
                            echo "Using IAM Policy ARN: ${policyArn}"

                            // Step 4. Create and validate IRSA ServiceAccount
                            echo "Creating IRSA ServiceAccount '${SERVICE_ACCOUNT}'..."
                            sh """
                                eksctl create iamserviceaccount \
                                    --name ${SERVICE_ACCOUNT} \
                                    --cluster ${K8S_CLUSTER_NAME} \
                                    --region ${AWS_REGION} \
                                    --attach-policy-arn ${policyArn} \
                                    --approve \
                                    --override-existing-serviceaccounts
                            """
                            // 5. Apply K8s resources
                            sh """
                                export BACKEND_IMAGE=${BACKEND_IMAGE}
                                export FRONTEND_IMAGE=${FRONTEND_IMAGE}
                                kubectl apply -f configmap.yaml
                                envsubst < backend-deployment.yaml | kubectl apply -f -
                                envsubst < frontend-deployment.yaml | kubectl apply -f -
                            """
                        }
                    }
                }
            }
        }


        // Verify Kubernetes Deployment (NEW separate stage)
        stage('Verify Kubernetes Deployment') {
            when { expression { params.ACTION == 'create' } }
            steps {
                dir('./K8S-ISRA/') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']]) {
                        script {
                            sh """
                                echo 'Checking pods status...'
                                kubectl get pods -o wide
                                echo 'Checking services status...'
                                kubectl get svc -o wide
                                echo 'Waiting for backend pods to be ready...'
                                echo 'Waiting for backend pods to be ready...'
                                kubectl wait --for=condition=ready pod -l app=qr-generator-backend --timeout=120s
                                echo 'Waiting for frontend pods to be ready...'
                                kubectl wait --for=condition=ready pod -l app=qr-generator-frontend --timeout=120s
                                echo 'Deployment verified successfully!'
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
        failure {
            echo "Pipeline failed! Please check logs for errors."
        }
    }
}

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
		stage('Checking') {
			steps {
	            echo "checking........"
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
