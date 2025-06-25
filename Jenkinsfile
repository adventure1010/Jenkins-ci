pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "frintzy2024/vpro-app:${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds-id"  // Replace with your Jenkins Docker Hub creds ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Farinze/vpro-app.git'
            }
        }

        stage('Build & Test') {
            steps {
                // Build package skipping tests in first step for speed (optional)
                sh 'mvn clean package'
                // Run tests (unit + integration)
                sh 'mvn test'
            }
        }

        stage('Generate Reports') {
            steps {
                // Checkstyle and coverage reports (optional, but no SonarQube)
                sh 'mvn checkstyle:checkstyle'
                sh 'mvn jacoco:report'
            }
            post {
                success {
                    echo '✅ Static code analysis reports generated.'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                // Replace with your deploy commands or scripts
                sh '''
                    docker rm -f vpro-container || true
                    docker run -d -p 8080:8080 --name vpro-container ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Build failed!'
        }
        success {
            echo '✅ Build and deploy successful!'
        }
    }
}
