pipeline {
    agent any

    environment {
        APP_PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t myapp:${env.BRANCH_NAME} ."
            }
        }

        stage('Deploy') {
            steps {
                sh """
                docker stop myapp-${env.BRANCH_NAME} || true
                docker rm myapp-${env.BRANCH_NAME} || true
                docker run -d --name myapp-${env.BRANCH_NAME} -p ${APP_PORT}:3000 myapp:${env.BRANCH_NAME}
                """
            }
        }
    }
}
