pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'
        ECR_REPO = '455896786568.dkr.ecr.eu-north-1.amazonaws.com/java-http'
        CLUSTER_NAME = 'java-cluster'
        DEPLOYMENT_NAME = 'java-http-deploy'
        SERVICE_NAME = 'java-http-svc'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/<your-username>/java-eks-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t java-http:latest .
                docker tag java-http:latest $ECR_REPO:latest
                $(aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO)
                docker push $ECR_REPO:latest
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME

                # Replace placeholder and deploy
                sed "s#IMAGE_PLACEHOLDER#$ECR_REPO:latest#g" k8s/deployment.yaml | kubectl apply -f -
                kubectl apply -f k8s/service.yaml

                # Wait for rollout
                kubectl rollout status deployment/$DEPLOYMENT_NAME --timeout=300s

                kubectl get svc $SERVICE_NAME
                '''
            }
        }
    }
}
