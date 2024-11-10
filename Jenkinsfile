pipeline {
    agent any

    environment {
        BACKEND_REPO = 'https://github.com/meeSuleman/TaskManagerBackend.git'
        DOCKER_REGISTRY = 'https://hub.docker.com/r/meesuleman/demorepo'
        DOCKER_CREDENTIALS = credentials('dockerhubToken')
        GITHUB_CREDENTIALS = credentials('GithubToken')
        SONARQUBE_ENV = 'SonarQube' 
    }

    stages {

        stage('Code Checkout') {
            steps {
                script {
                    dir('backend') {
                        git url: "${env.BACKEND_REPO}", credentialsId: "${env.GITHUB_CREDENTIALS}", branch: 'main'
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv(SONARQUBE_ENV) {
                        sh 'sonar-scanner -Dsonar.projectKey=task-manager-backend -Dsonar.sources=src'
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}