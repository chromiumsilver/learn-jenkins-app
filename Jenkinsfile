pipeline {
    agent any

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
        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo 'Test Stage'
                    test -f build/index.html
                    npm test
                '''
            }
        }
        stage('E2E') {
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.55.0-noble'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo 'E2E Stage'
                    npm install serve
                    node_modules/.bin/serve -s build & # the & symbol places the process in the background.
                    sleep 10 # It takes some time for the server to start
                    npx playwright test
                '''
            }
        }
    }

    post {
        always {
            junit 'jest-results/junit.xml' // changed from test-results to jest-results in order to avoid conflict with playwright
        }
    }
}
