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
                sh "npm install"
            }
        }
        stage('Test') {
            steps {
                script {
                echo 'The following "npm" command (if executed) installs the "cross-env"'
                echo 'dependency into the local "node_modules" directory, which will ultimately'
                echo 'be stored in the Jenkins home directory. As described in'
                echo 'https://docs.npmjs.com/cli/install, the "--save-dev" flag causes the'
                echo '"cross-env" dependency to be installed as "devDependencies". For the'
                echo 'purposes of this tutorial, this flag is not important. However, when'
                echo 'installing this dependency, it would typically be done so using this'
                echo 'flag. For a comprehensive explanation about "devDependencies", see'
                echo 'https://stackoverflow.com/questions/18875674/whats-the-difference-between-dependencies-devdependencies-and-peerdependencies.'
                set -x
                //npm install --save-dev cross-env
                set +x

                echo 'The following "npm" command tests that your simple Node.js/React'
                echo 'application renders satisfactorily. This command actually invokes the test'
                echo 'runner Jest (https://facebook.github.io/jest/).'
                set -x
                npm test
                }
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