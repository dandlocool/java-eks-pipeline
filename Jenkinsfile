pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '123456789012.dkr.ecr.ap-south-1.amazonaws.com/java-http' // replace with your ECR URI
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/<your-username>/<your-repo>.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh '''
                javac SimpleHttpServer.java
                jar cfe app.jar SimpleHttpServer SimpleHttpServer.class
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                $(aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO)
                docker build -t java-http:latest .
                docker tag java-http:latest $ECR_REPO:latest
                docker push $ECR_REPO:latest
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks --region $AWS_REGION update-kubeconfig --name java-cluster
                sed "s#IMAGE_PLACEHOLDER#$ECR_REPO:latest#g" k8s/deployment.yaml | kubectl apply -f -
                kubectl apply -f k8s/service.yaml
                kubectl rollout status deployment/java-app --timeout=120s
                kubectl get svc java-app-service
                '''
            }
        }
    }
}