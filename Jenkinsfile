pipeline {
    agent any

    environment {
        BACKEND_REPO = 'https://github.com/meeSuleman/TaskManagerBackend.git'
        DOCKER_REGISTRY = 'meesuleman/task-manager-backend'
        DOCKER_CREDENTIALS = credentials('dockerhubToken')
        DOCKER_CREDENTIALS_PSW = 'treble@city'
        DOCKER_CREDENTIALS_USR = 'meesuleman'
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
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             def scannerHome = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        //             withSonarQubeEnv(SONARQUBE_ENV) {
        //                 sh '/usr/local/bin/sonar-scanner -Dsonar.projectKey=task-manager-backend -Dsonar.projectName="Task Manager" -Dsonar.projectVersion=1.0 -Dsonar.sources=.'
        //             }
        //         }
        //     }
        // }
        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 5, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }
        stage('Run Tests') {
            steps {
                script {
                    dir('backend') {
                        echo 'testing done'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('backend') {
                        sh "/usr/local/bin/docker build -t ${DOCKER_REGISTRY}:latest ."
                        sh "/usr/local/bin/docker tag ${DOCKER_REGISTRY}:latest ${DOCKER_REGISTRY}:latest"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "echo ${DOCKER_CREDENTIALS_PSW} | /usr/local/bin/docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin"

                    sh "/usr/local/bin/docker push ${DOCKER_REGISTRY}:latest"
                    sh "/usr/local/bin/docker push ${DOCKER_REGISTRY}:latest"
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