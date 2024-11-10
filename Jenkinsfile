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
        stage('Verify SonarScanner Installation') {
            steps {
                script {
                    sh '/usr/local/bin/sonar-scanner --version'
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
    }
}