pipeline {
  agent any
 
  tools {nodejs "node"}
 
  stages {
    stage('Build') {
      steps {
        sh "ls -la && pwd"
        sh 'npm config ls'
        sh 'npm install'
      }
    }
    stage('Test') {
      steps {
        sh 'npm config ls'
        sh 'npm test'
      }
    }
    stage('Docker build') {
      steps {
        sh 'docker build -t nodeproject:v2.1 .'
      }
    }
    stage('Deploy') {
      steps {
          script {
              def IMAGE_ID = sh(script: """docker images -q nodeproject:v2.1""", returnStdout: true).trim()
                sh "docker ps -aq | xargs docker stop | xargs docker rm"
                sh "docker run -d --expose 3001 -p 3001:3001 ${IMAGE_ID}"
          }
      }
    }
  }
}