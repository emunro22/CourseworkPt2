pipeline {
    agent any
    tools {
        nodejs 'NodeJS' // Keep if you need Node.js runtime for other purposes
    }
    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-credentials' // DockerHub credentials ID in Jenkins
        DOCKER_HUB_REPO = 'euanmunro/cw2-server' // Replace with your DockerHub image
    }
    stages {
        stage('Checkout GitHub') {
            steps {
                cleanWs()
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/emunro22/CourseworkPt2.git'
                sh 'ls -al'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS_ID}") {
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Build & Deploy completed successfully!'
        }
        failure {
            echo 'Build & Deploy failed. Check logs.'
        }
    }
}
