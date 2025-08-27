pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'           // Change if needed
        DEPLOYMENT_NAME = 'java-http-deploy'
        SERVICE_NAME = 'java-http-svc'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/dandlocool/java-eks-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t java-http:latest .
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                # Update kubeconfig to connect kubectl to EKS
                aws eks --region $AWS_REGION update-kubeconfig --name java-cluster

                # Apply deployment and service
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml

                # Wait for rollout
                kubectl rollout status deployment/$DEPLOYMENT_NAME --timeout=120s

                # Show service info
                kubectl get svc $SERVICE_NAME
                '''
            }
        }
    }
}
