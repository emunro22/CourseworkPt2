pipeline {
    agent any
    tools {
        nodejs 'NodeJS'
    }
    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_HUB_REPO = 'euanmunro/cw2-server'
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
        stage('Install Kubectl') {
            steps {
                sh '''
                    if [ ! -f "$WORKSPACE/kubectl" ]; then
                        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mv kubectl "$WORKSPACE/"
                    fi
                '''
                // Add kubectl to PATH
                script {
                    env.PATH = "${env.WORKSPACE}:${env.PATH}"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubeconfig(
                        caCertificate: '''LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCakNDQWU2Z0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRJME1USXdNakE1TWpVME1Gb1hEVE0wTVRJd01UQTVNalUwTUZvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTTZ3ClJlbUF1d3ExcGhJemZsQ0ZSYndoRlRxbVg5OVFUUldjZGVLemd0VlU5UGJIcGdzU3IzeGM4SHM2bThoaEhOSEUKT2IzTGl3ZDMwS0NkVVh1M1liSjdMaGlpVjJwK01KYmJDREFjMTR5eU53ZUlEM0RCNWtuSDM1aG9nVkl4MkJjOAp4NVFGOFlXSVRJMnkva2NTWm05NVRjVnQrN2N1cmpPZit4eWROeUJTQ04xUFNXdm8rV3FwQnBCV1dpS1hKZVR2ClA4OWQ5NExtTlcxLzFza0NqNWhSQzAxK3RPUnppZVlCN05RUjhNell4SXdWRnNYR0R6SXVSa3F0WUd6K05Ia0UKNnpDWkNodEMxeE1sS1BtMlRXMEJvT010eUhBR01RRUtlcmZNS2ZQbUYwRkczbGRIdmdKRnMvVEMySGFScjZFRQpjYVlrODdtRjdKLzFNQlllNnBjQ0F3RUFBYU5oTUY4d0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQjBHQTFVZERnUVcKQkJSb25IV0FBRjk1R1NCQ2UzWi85L0pWMjZ4eEdEQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFRd1VsTVJGRgpYcnY5QU5tSnVtbG9uZCt1STcwT21IbUpMVklTUHJKMlU0aGQvWExUclFEa05JZDNraGlNWFdqeUNDbllja1ZKCm9ha09sTDJBczZ0UFFWZ1krNG9vbHdyUFp1K1FXYXJpQXVNOUk4enJLWnliSlZ6TmlYMElBbmVVekJSamZ4aWMKQjhSdXkweUkxeWtucHljSEpPSnJ3Y0NWaDdMRUROK1FNWlpmTkNQQjh6ckV0ZjVRS0ZEYytFendkbXJxb2xocApxd0dnR2VEWUJtdndkVWVVL2FUSEJxaTlLNHZCSGU5TUwvNEZjU01ZbFVoZDREMmsrYWNPbW10amlKYVVscjR6CnI1L3dveCtieW5uYldqL3huNURvTWpMR01BSVhoakt5dk1XYlkzMzdsRnIrVHJCbExJQk40eVR2Sk1IMitsK20KV0RiTDFTc0h3aXZVT1E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==''',
                        credentialsId: 'kubeconfig',
                        serverUrl: 'https://192.168.49.2:8443'
                    ) {
                        sh 'kubectl apply -f deployment.yaml'
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
