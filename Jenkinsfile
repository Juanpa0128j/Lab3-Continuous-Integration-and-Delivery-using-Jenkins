pipeline {
    agent any

    tools {
        nodejs "node"   // NodeJS tool configured in Global Tool Config
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKERHUB_USER        = 'juanpa0128j'
        APP_NAME              = "node-${env.BRANCH_NAME}"
        DOCKER_IMAGE          = "${DOCKERHUB_USER}/${APP_NAME}:${env.BUILD_NUMBER}"
        APP_PORT              = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
    }

    stages {
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

        stage('Build & Push Docker Image') {
            steps {
                script {
                    sh """
                    echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                    docker build -t ${DOCKER_IMAGE} .
                    docker push ${DOCKER_IMAGE}
                    docker tag ${DOCKER_IMAGE} ${DOCKERHUB_USER}/${APP_NAME}:latest
                    docker push ${DOCKERHUB_USER}/${APP_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                    CID=\$(docker ps -q --filter "name=myapp-${env.BRANCH_NAME}")
                    if [ ! -z "\$CID" ]; then
                        docker stop \$CID || true
                        docker rm \$CID || true
                    fi

                    docker pull ${DOCKER_IMAGE}

                    docker run -d --name myapp-${env.BRANCH_NAME} \
                        --expose ${APP_PORT} -p ${APP_PORT}:3000 \
                        ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }
}
