pipeline {
  agent any
 
  tools {
  maven 'Maven3'
  }
  stages {
    stage ('Checkout') {
      steps {
      git branch: 'main', credentialsId: 'cd6f0f77-d845-4a9c-bc44-26b9c58b60d5', url: 'https://github.com/vams-cmd/REDDY.git'
      }
    }  
    stage ('Build') {
      steps {
      sh 'mvn clean install -f webapp/pom.xml'
      }
    }
    stage ('Code Quality') {
      steps {
          withSonarQubeEnv('SonarQube') {
          sh 'mvn -f webapp/pom.xml sonar:sonar'
          }
      }
    }
    stage ('send build artifacts') {
        agent {
        label 'jenkins-slave1'
        }
        steps {
            sh '''
            cp /home/ubuntu/jenkins/workspace/Assignment_two/webapp/target/webapp.war /home/ubuntu/docker
            '''
        }
    }
    stage ('push image to ECR') {
        agent {
        label 'jenkins-slave1'
        }
        steps {
            sh '''
            cd /home/ubuntu/docker
            aws eks --region us-east-1 update-kubeconfig --name demo
            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 773567626102.dkr.ecr.us-east-1.amazonaws.com
            docker build -t assignment_two .
            docker tag assignment_two:latest 773567626102.dkr.ecr.us-east-1.amazonaws.com/assignment_two:latest
            docker push 773567626102.dkr.ecr.us-east-1.amazonaws.com/assignment_two:latest
            '''
        }
    }
    stage ('Creating EKS cluster') {
        agent {
        label 'jenkins-slave1'
        }
        steps {
            sh '''
            cd /home/ubuntu/git/CT_Assignments/terraform
            terraform init
            terraform plan
            terraform apply -auto-approve
            '''
        }
    }
    stage ('Deployment') {
        agent {
        label 'jenkins-slave1'
        }
        steps {
            sh '''
            cd /home/ubuntu/git/CT_Assignments/k8s_manifest
            aws eks --region us-east-1 update-kubeconfig --name demo
            kubectl apply -f aws-test.yaml
            kubectl apply -f deployment.yaml
            kubectl apply -f public-lb.yaml
            kubectl apply -f private-lb.yaml
            kubectl apply -f cluster-autoscaler.yaml
            '''
        }
    }
  }
}
