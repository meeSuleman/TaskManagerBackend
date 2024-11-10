pipeline {
    agent any

    environment {
        BACKEND_REPO = 'https://github.com/meeSuleman/TaskManagerBackend.git'
        DOCKER_REGISTRY = 'https://hub.docker.com/repository/docker/meesuleman/task-manager-backend'
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
                        sh '/usr/local/bin/sonar-scanner -Dsonar.projectKey=task-manager-backend -Dsonar.projectName="Task Manager" -Dsonar.projectVersion=1.0 -Dsonar.sources=.'
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
        stage('Run Tests') {
            steps {
                script {
                    dir('backend') {
                        sh 'rspec'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dir('backend') {
                        def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                        docker.build("${DOCKER_REGISTRY}:${commitHash}")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                        docker.image("${DOCKER_REGISTRY}:${commitHash}").push()
                        docker.image("${DOCKER_REGISTRY}:${commitHash}").push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            deleteDir()
        }
    }
}