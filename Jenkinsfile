pipeline {
    agent {
        docker {
            image 'maven:3.8.3-adoptopenjdk-11'
            args '-v m2:/root/.m2 -v settings.xml:/root/.m2/settings.xml'
        }
    }
    stages {
        stage('Init'){
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Starting"
                sh 'java --version'
                sh 'git --version'
                sh 'mvn --version'
            }
        }
        stage('Build') {
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Building"
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') { 
            steps {
                slackSend channel: '#jenkins', message: "${env.BUILD_ID} on ${env.JENKINS_URL} - Running Tests"
                sh 'mvn test' 
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml' 
                }
            }
        }
        stage('Deploy') { 
            // Create Docker Image
        }

    }
}