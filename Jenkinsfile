pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1' // change if needed
        ECR_REPO = '123456789012.dkr.ecr.eu-north-1.amazonaws.com/java-http' // replace with your ECR URI
        DEPLOYMENT_NAME = 'java-http-deploy' // Deployment name in k8s YAML
        SERVICE_NAME = 'java-http-svc'      // Service name in k8s YAML
    }

    stages {
        stage('Checkout') {
            steps {
                // Replace with your GitHub repo
                git 'https://github.com/dandlocool/java-eks-pipeline.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh '''
                # Compile Java file and package into a JAR
                javac SimpleHttpServer.java
                jar cfe app.jar SimpleHttpServer SimpleHttpServer.class
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                # Option 1: Use ECR (if you have credentials)
                # $(aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO)
                # docker build -t java-http:latest .
                # docker tag java-http:latest $ECR_REPO:latest
                # docker push $ECR_REPO:latest

                # Option 2: Local Docker image (simpler for learning)
                docker build -t java-http:latest .
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                # Update kubeconfig to connect kubectl to EKS
                aws eks --region $AWS_REGION update-kubeconfig --name java-cluster

                # Deploy the app
                # Replace IMAGE_PLACEHOLDER with your image if using ECR
                # sed "s#IMAGE_PLACEHOLDER#$ECR_REPO:latest#g" k8s/deployment.yaml | kubectl apply -f -
                
                # Or use local image name directly
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml

                # Wait for rollout
                kubectl rollout status deployment/$DEPLOYMENT_NAME --timeout=120s
                kubectl get svc $SERVICE_NAME
                '''
            }
        }
    }
}
