@Library('shared-lib@main') _
pipeline {
  agent any
  environment {
    REGISTRY   = "docker.io/juanpa0128j"
    IMAGE_NAME = "myapp"
    IMAGE_TAG  = "${env.BRANCH_NAME}-v1.0"
    DOCKER_IMG = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
  }
  stages {
    stage('Install') { steps { sh 'npm install' } }
    stage('Test')    { steps { sh 'npm test' } }

    stage('Lint Dockerfile') { steps { lintDockerfile() } }

    stage('Build & Push') {
      steps {
        buildAndPushImage("${DOCKER_IMG}", 'dockerhub-creds')
      }
    }

    // stage('Scan Image') {
    //   steps { scanImage("${DOCKER_IMG}", 'HIGH,CRITICAL') }
    // }

    stage('Trigger Deploy') {
      steps {
        script {
          if (env.BRANCH_NAME == 'main') { build job: 'Deploy_to_main' }
          else if (env.BRANCH_NAME == 'dev') { build job: 'Deploy_to_dev' }
        }
      }
    }
  }
}
