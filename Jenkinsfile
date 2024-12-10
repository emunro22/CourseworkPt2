pipeline {
  environment {
    dockerimagename = "euanmunro/cw2-server" // Replace with your DockerHub image
    dockerImage = ""
  }
  agent any
  stages {
    stage('Checkout Source') {
      steps {
        echo 'Cloning repository from GitHub...'
        git 'https://github.com/emunro22/CourseworkPt2.git'
      }
    }
    stage('Build Docker Image') {
      steps {
        echo 'Building Docker image...'
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }
    stage('Push Docker Image') {
      environment {
        registryCredential = 'dockerhub-credentials' // DockerHub credentials ID in Jenkins
      }
      steps {
        echo 'Pushing Docker image to DockerHub...'
        script {
          docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
            dockerImage.push("latest")
          }
        }
      }
    }
    stage('Deploy Application to Kubernetes') {
      steps {
        echo 'Deploying application to Kubernetes cluster...'
        script {
          // Run kubectl apply for deployment.yaml and service.yaml
          sh '''
          kubectl apply -f deployment.yaml
          kubectl apply -f service.yaml
          '''
        }
      }
    }
  }
}
