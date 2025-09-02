pipeline {
    agent any

    environment {
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        APP_NAME = "learn-jenkins-app"
        AWS_DEFAULT_REGION = "us-west-2"
        AWS_REGISTRY = "183392808235.dkr.ecr.us-west-2.amazonaws.com"
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                    ls -la
                '''
            }
        }

        stage('Build App Image') {
            steps {
                sh '''
                    docker build -t $AWS_REGISTRY/learn-jenkins-app:$REACT_APP_VERSION .
                '''
            }
        }

        stage('Push ECR') {
            agent {
                docker {
                    image 'amazon/aws-cli'
                    args "--entrypoint=''"
                    reuseNode true
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-local-jenkins', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_REGISTRY
                        docker images
                    '''
                }
            }
        }

        // stage('Deploy AWS') {
        //     agent {
        //         docker {
        //             image 'amazon/aws-cli'
        //             args "--entrypoint=''"
        //             reuseNode true
        //         }
        //     }
        //     environment {
        //         AWS_S3_BUCKET = 'learn-jenkins-20250901'
        //     }
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'aws-local-jenkins', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
        //             sh '''
        //                 echo "Deploy to AWS S3."
        //                 aws --version
        //                 aws s3 sync build s3://$AWS_S3_BUCKET
        //             '''
        //         }
        //     }
        // }
    }
}
