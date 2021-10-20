pipeline {
    agent none
    environment {
        DEPLOY_TO = 'staging'
        imageName = "fabioctba/spring-petclinic"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    stages {
        stage('Init'){
            agent any
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Starting"
                sh 'git --version'
                echo "Deploying to ${DEPLOY_TO}"
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.8.3-adoptopenjdk-11'
                    args '-v m2:/root/.m2 -v settings.xml:/root/.m2/settings.xml'
                }
            }
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Building"
                sh 'mvn -B -DskipTests clean package'

            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'maven:3.8.3-adoptopenjdk-11'
                    args '-v m2:/root/.m2 -v settings.xml:/root/.m2/settings.xml'
                }
            }
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Running Tests"
                sh 'mvn test' 
            }
            post {
                always {
                    archiveArtifacts artifacts: 'target/*.jar'
                    junit 'target/surefire-reports/*.xml' 
                }
            }
        }
        stage('Build Image') { 
            agent any
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Building Image"

                script {
                    dockerImage = docker.build imageName
                }
            }
        }
        stage('Publish Image') { 
            agent any
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Building Image"

                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Prod') {
            agent any
            when { 
                allOf { 
                    branch 'master'; 
                    environment name: 'DEPLOY_TO', value: 'production'
                } 
            }
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Running Production stage"
                echo 'Some extra step when on production release'
            }
        }
    }
}