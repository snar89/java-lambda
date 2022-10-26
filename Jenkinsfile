pipeline {
    agent any

     options {
        //Disable concurrentbuilds for the same job
        disableConcurrentBuilds()
        // Colorize the console log
        ansiColor("xterm")          
        // Add timestamps to console log
        timestamps()
        
    }

    environment {
        AWS_ACCESS_KEY = credentials('aws_access_key')
        AWS_SECRET_KEY = credentials('aws_secret_key')
        ARTIFACTID = readMavenPom().getArtifactId()
        VERSION = readMavenPom().getVersion()
    }

    stages {

        stage('Build Lambda') {
            steps {
                echo 'Build'
                sh 'mvn clean install -Dmaven.test.skip=true'             
            }
        }
        stage('Test') {
            steps {
                echo 'Test'
                // sh 'mvn test'
            }
        }
        stage('Push to artifactory') {
            steps {
                echo 'Push to artifactory'
            }
        }

        stage('Deploy to QA') {
            steps {
                script {
                    echo 'Deploy to QA'

                    echo "ARTIFACTID: ${ARTIFACTID}"
                    echo "VERSION: ${VERSION}"
                    JARNAME = ARTIFACTID+'.'+VERSION+'.jar'
                    echo "JARNAME: ${JARNAME}"
                    sh 'pwd'
                    sh 'zip -g bermtec-0.0.1.zip target/bermtec-0.0.1.jar'              

                    sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY'
                    sh 'aws configure set aws_secret_access_key $AWS_SECRET_KEY'
                    sh 'aws configure set region us-east-1' 
                    sh 'aws s3 cp bermtec-0.0.1.zip s3://bermtec228/lambda-test/'
                    echo "Stage 2 Yes"
                    functionName = 'test'
                    if (does_lambda_exist($functionName)) {
                    //  sh './deploy-test.sh $AWS_ACCESS_KEY $AWS_SECRET_KEY'
                        sh 'aws lambda update-function-code --function-name $functionName  --zip-file fileb://./target/bermtec-0.0.1.zip'
                    }
                }          
            }
        }

        stage('Release to Prod') {
            steps {
                echo 'Release to Prod'
                script {
                    if (env.BRANCH_NAME == "master") {
                        input('Proceed for Prod  ?')
                    }
                }

            }
        }

         stage('Deploy to Prod') {
            steps {
                script {
                    if (env.BRANCH_NAME == "master") {
                        echo 'Deploy to Prod'
                        sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY'
                        sh 'aws configure set aws_secret_access_key $AWS_SECRET_KEY'
                        sh 'aws s3 cp bermtec-0.0.1.zip s3://bermtec288/lambda-prod'
                         functionName = 'test'
                        if (does_lambda_exist($functionName)) {
                            echo 'Function Exists'
                            sh 'aws lambda update-function-code --function-name prodfunction --s3-bucket bermtec288 --s3-key lambda-prod/bermtec-0.0.1.zip'
                        }  
                    }
                }
            }
        }

    }
    post {
      failure {
        echo 'failed'
             mail to: 'teambermtec@gmail.com',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_NUMBER}"
      }
      success {
        echo 'Success'
      }
      aborted {
        echo 'aborted'
      }
    }
}

def does_lambda_exist(name) {	
  isexist=false
  echo $name
  try{
    sh  'aws lambda get-function --function-name $name'
    isexist=true
  }
  catch(Exception e) {
    echo 'Failed'
    isexist=true
  }
  return isexist
}