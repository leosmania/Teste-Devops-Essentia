pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'teste-devops'
        CONTAINER_NAME = 'devops-app-container'
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Build') {
            steps {
                script {
                    dir('app') { sh 'docker build -t $DOCKER_IMAGE .' }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "docker rm -f $CONTAINER_NAME || true"
                    sh "docker run -d -p 3000:3000 --name $CONTAINER_NAME --restart always $DOCKER_IMAGE"
                }
            }
        }
    }
}