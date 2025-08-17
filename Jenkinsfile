pipeline {
    agent any

    environment {
        REGISTRY   = "docker.io/juanpa0128j"
        IMAGE_NAME = "myapp"
        IMAGE_TAG  = "${env.BRANCH_NAME}-v1.0"   // → main-v1.0 or dev-v1.0
        DOCKER_IMG = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}",
                    credentialsId: 'github-ssh',
                    url: 'git@github.com:Juanpa0128j/Lab3-Continuous-Integration-and-Delivery-using-Jenkins.git'
            }
        }

        stage('Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${DOCKER_IMG}
                    docker logout
                    """
                }
            }
        }

        stage('Trigger Deploy Job') {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        build job: "Deploy_to_main"
                    } else if (env.BRANCH_NAME == "dev") {
                        build job: "Deploy_to_dev"
                    }
                }
            }
        }
    }
}
