pipeline {
    agent any

    environment {
        BACKEND_REPO = 'https://github.com/meeSuleman/TaskManagerBackend.git'
        DOCKER_REGISTRY = 'https://hub.docker.com/r/meesuleman/demorepo'
        DOCKER_CREDENTIALS = credentials('dockerhubToken')
        GITHUB_CREDENTIALS = credentials('GithubToken')
    }

    stages {

        stage('Code Checkout') {
            steps {
                script {
                    // Checkout backend code
                    dir('backend') {
                        git url: "${env.BACKEND_REPO}", credentialsId: "${env.GITHUB_CREDENTIALS}", branch: 'main'
                    }
                }
            }
        }

        stage('Static Code Analysis') {
            steps {
                dir('backend') {
                    sh 'sonar-scanner' // Assumes SonarQube configuration in Jenkins
                }
            }   
        }
    }
}