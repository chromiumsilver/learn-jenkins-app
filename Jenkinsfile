pipeline {
    agent any

    environment {
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        APP_NAME = "learn-jenkins-app"
        AWS_DEFAULT_REGION = "us-west-2"
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        AWS_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
        AWS_ECS_CLUSTER = "ecs-prod-learn-jenkins-app"
        AWS_ECS_TASK_DEF = "learnjenkinsapp-prod"
        AWS_ECS_SERVICE = "learnjenkinsapp-prod-service"
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
                    image 'my-aws-cli'
                    args "-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=''"
                    reuseNode true
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-local-jenkins', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_REGISTRY
                        docker push $AWS_REGISTRY/$APP_NAME:$REACT_APP_VERSION
                    '''
                }
            }
        }

        stage('Deploy ECS') {
            agent {
                docker {
                    image 'my-aws-cli'
                    args "--entrypoint=''"
                    reuseNode true
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-local-jenkins', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws --version

                        sed -i "s/AWS_ECS_TASK_DEF/${AWS_ECS_TASK_DEF}/g" aws/task-def-template-prod.json
                        sed -i "s/AWS_ACCOUNT_ID/${AWS_ACCOUNT_ID}/g" aws/task-def-template-prod.json
                        sed -i "s/AWS_DEFAULT_REGION/${AWS_DEFAULT_REGION}/g" aws/task-def-template-prod.json
                        sed -i "s/APP_NAME/${APP_NAME}/g" aws/task-def-template-prod.json
                        sed -i "s/REACT_APP_VERSION/${REACT_APP_VERSION}/g" aws/task-def-template-prod.json
                        cat aws/task-def-template-prod.json

                        LATEST_TD_REVISION=$(aws ecs register-task-definition --cli-input-json file://aws/task-def-template-prod.json | jq -r '.taskDefinition.revision')
                        echo $LATEST_TD_REVISION
                        
                        aws ecs update-service \
                            --cluster $AWS_ECS_CLUSTER \
                            --service $AWS_ECS_SERVICE \
                            --task-definition $AWS_ECS_TASK_DEF:$LATEST_TD_REVISION

                        # aws ecs wait services-stable \
                        #     --cluster $AWS_ECS_CLUSTER \
                        #     --services $AWS_ECS_SERVICE

                    '''
                }
            }
        }
    }
}
