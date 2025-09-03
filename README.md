# Jenkins React AWS Pipeline

A comprehensive Jenkins CI/CD pipeline implementation with AWS deployment. This project showcases modern DevOps practices including containerization, automated testing, and cloud deployment using Jenkins, Docker, and AWS services.

## 🚀 Project Overview

This project serves as a hands-on learning resource for Jenkins pipeline development, featuring:

- **React Frontend**: Simple React application with version display
- **Jenkins Pipeline**: Complete CI/CD pipeline with multiple stages
- **Docker Containerization**: Multi-stage Docker builds with nginx
- **AWS Integration**: Deployment to AWS ECS with ECR image registry
- **Infrastructure as Code**: ECS task definitions and IAM policies

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Developer     │───▶│   Jenkins        │───▶│   AWS Cloud     │
│   Git Push      │    │   Pipeline       │    │   ECS + ECR     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Pipeline Stages

1. **Build**: Node.js application build using npm
2. **Docker Image**: Create production Docker image with nginx
3. **Push to ECR**: Upload image to AWS Elastic Container Registry
4. **Deploy to ECS**: Update ECS service with new task definition

## 📁 Project Structure

```
├── src/                    # React application source code
├── aws/                    # AWS configuration files
│   ├── iam-policy-s3.json
│   ├── s3-bucket-policy.json
│   └── task-def-template-prod.json
├── ci/                     # CI/CD Docker images
│   ├── Dockerfile-aws-cli
│   ├── Dockerfile-playwright
│   └── Jenkinsfile-nightly
├── Dockerfile              # Production Docker image
├── Jenkinsfile            # Main CI/CD pipeline
└── README.md
```

## 🛠️ Technologies Used

### Frontend
- **React 18**: Modern React with functional components
- **Create React App**: Development and build tooling
- **CSS3**: Custom styling with animations

### DevOps & Infrastructure
- **Jenkins**: CI/CD pipeline orchestration
- **Docker**: Containerization and multi-stage builds
- **nginx**: Production web server (Alpine Linux)
- **AWS ECS**: Container orchestration service
- **AWS ECR**: Docker container registry
- **AWS CLI**: Infrastructure management
- **AWS IAM**: Permissions and access management

### Pipeline Tools
- **Node.js 18**: Build environment
- **Playwright**: End-to-end testing framework
- **Docker-in-Docker**: Container builds within pipeline

## 🔧 Jenkins Pipeline Configuration

### Environment Variables

The pipeline uses the following environment variables:

- `REACT_APP_VERSION`: Application version (auto-generated)
- `APP_NAME`: Application name for AWS resources
- `AWS_DEFAULT_REGION`: Target AWS region
- `AWS_ACCOUNT_ID`: AWS account identifier
- `AWS_ECS_CLUSTER`: ECS cluster name
- `AWS_ECS_TASK_DEF`: ECS task definition name
- `AWS_ECS_SERVICE`: ECS service name

### Required Jenkins Credentials

- `aws-account-id`: AWS Account ID (secret text)
- `aws-local-jenkins`: AWS credentials (username/password)

### Pipeline Features

- **Parallel Builds**: Efficient resource utilization
- **Docker Agents**: Isolated build environments
- **AWS Integration**: Seamless cloud deployment
- **Automated Versioning**: Build-based version numbers
- **Service Health Checks**: Wait for deployment stability

## 📚 Learning Objectives

This project demonstrates:

1. **Jenkins Pipeline as Code**: Declarative pipeline syntax
2. **Docker Multi-stage Builds**: Optimized production images
3. **AWS Container Services**: ECS and ECR integration
4. **Infrastructure Automation**: Parameterized deployments
5. **DevOps Best Practices**: CI/CD implementation patterns

## 🎯 Next Steps

To extend this project, consider:

- Adding automated testing stages
- Implementing blue/green deployments
- Adding monitoring and alerting
- Setting up multiple environment deployments
- Integrating security scanning tools