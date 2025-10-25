pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "devops8114/jenkins-ci:${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS = "credential"   // You should create a Jenkins credential with this ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/adventure1010/Jenkins-ci.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package'
                sh 'mvn test'
            }
        }

        stage('Generate Reports') {
            steps {
                sh 'mvn checkstyle:checkstyle'
                sh 'mvn jacoco:report'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
            sh '''
                echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                docker push devops8114/jenkins-ci:${BUILD_NUMBER}
            '''
        }
    }
}

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f vpro-container || true
                    docker run -d -p 8000:8080 --name vpro-container devops8114/jenkins-ci:${BUILD_ID}
                '''
                echo "🚀 Deployed at: http://16.16.160.169:8000"
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
