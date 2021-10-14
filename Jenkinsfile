pipeline {
    agent {
        docker {
            image 'maven:3.8.3-adoptopenjdk-11'
            args '-v m2:/root/.m2 -v settings.xml:/root/.m2/settings.xml'
        }
    }
    stages {
        stage('Slack it'){
            steps {
                slackSend channel: '#jenkins', 
                          message: "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') { 
            steps {
                sh 'mvn test' 
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml' 
                }
            }
        }
    }
}
