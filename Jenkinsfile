pipeline {
    agent any

    tools {
        nodejs "node"   // use the NodeJS tool you set up in Global Tool Config
    }

    environment {
        // Different image names for main vs dev
        DOCKER_IMAGE = "${env.BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'}"
        APP_PORT     = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
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
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop & remove container if running (minimal downtime)
                    sh """
                    CID=\$(docker ps -q --filter "name=myapp-${env.BRANCH_NAME}")
                    if [ ! -z "\$CID" ]; then
                        docker stop \$CID || true
                        docker rm \$CID || true
                    fi

                    # Run new container
                    docker run -d --name myapp-${env.BRANCH_NAME} \
                        --expose ${APP_PORT} -p ${APP_PORT}:3000 \
                        ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }
}
