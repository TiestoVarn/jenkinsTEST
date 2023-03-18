pipeline {
    agent any
    options {
        // Timeout counter starts AFTER agent is allocated
        timeout(time: 5000, unit: 'SECONDS')
    }
    stages {
        stage('Build') {
            steps {
                //
                sh "sudo scripts/build1.sh"
            }
        }
        stage('Test') {
            steps {
                sh "sudo scripts/test1.sh"
            }
        }
        stage('Create docker image') {
            steps {
                sh "docker build -t mybuildimage"
            }
        }
        stage('TriggerDeployJob') {
            steps {
                script {
                    def IMAGE_ID = sh(script: """docker images -q mybuildimage""", returnStdout: true).trim()
                    def branchCheck = sh(script: """git rev-parse --abbrev-ref HEAD""", returnStdout: true).trim()
                        if ("${branchCheck}" == "prod") {
                            build job: 'CD_deploy_master', parameters: [[$class: 'StringParameterValue', name: 'IMAGE_ID', value: IMAGE_ID]]
                            }
                        else {
                            build job: 'CD_deploy_dev', parameters: [[$class: 'StringParameterValue', name: 'IMAGE_ID', value: IMAGE_ID]]
                        }
                }
            }
        }
    }
}