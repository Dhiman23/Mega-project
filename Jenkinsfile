pipeline {
    agent any
    tools { 
      jdk 'jdk17' 
      maven 'maven3' 
          } 
          
    environment { 
         SCANNER_HOME= tool 'sonar-scanner' 
         } 

    stages {
        stage('Git-checkout') {
            steps {
               git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/Dhiman23/Board-game.git'
            }
            
        }
            
             stage('Compile') {
            steps {
                sh "mvn compile"
            }
            
         }
            
             stage('Test'){
            steps {
                sh "mvn test"
            }
            
         }
            
             stage('File-Scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
            
            }
            
             stage('Sonar-Scan') {
            steps {
                withSonarQubeEnv('sonar') {
                         sh '''
                         $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame -Dsonar.java.binaries=. 
                                    
                        '''
                       }
               }
            
            }
            
             stage('Quality-Gate') {
            steps {
                script { 
                  waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'  
                }
            }
            
             }
            
             stage('Build-Stage') {
            steps {
               sh "mvn package"
            }
            
             }
            
        //   stage('Punlish-to-Nexus') {
        //     steps {
        //           withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
        //               sh "mvn deploy -DskipTests=true"
        //               }
        //     }
            
        //  }
            
             stage('Build & Tag docker img') {
            steps {
            
                script{
                      withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        
                        sh "docker build -t sajaldhimanitc1999/boardgame:latest ."
                        
                      }
                    
                   }
                 
               }
            
             }
            
             stage('Docker-Img-Scan') {
            steps {
                    sh "trivy image --format table -o trivy-image-report.html sajaldhimanitc1999/boardgame:latest" 
            }

          }
            
             stage('Docker-Push-Img') {
            steps {
                 script{
                      withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        
                        sh "docker push sajaldhimanitc1999/boardgame:latest"
                        
                      }
                    
                   }
               
                }
            
             }
            
             stage('Kubernetes-Deployment') {
            steps {
              withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.62.30:6443') {
 
                      sh "kubectl apply -f deployment-service.yaml --validate=false"
                    
                     }
                }
             }
             
            
             stage('Verify-Deployment') {
            steps {
                
                 withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.62.30:6443') {
 
                        sh "kubectl get pods -n webapps" 
                        sh "kubectl get svc -n webapps" 
                    
                     }
               
            }
            
        }
            
    }


 post { 
    always { 
        script { 
            def jobName = env.JOB_NAME 
            def buildNumber = env.BUILD_NUMBER 
            def pipelineStatus = currentBuild.result ?: 'UNKNOWN' 
            def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red' 
 
            def body = """ 
                <html> 
                <body> 
                <div style="border: 4px solid ${bannerColor}; padding: 10px;"> 
                <h2>${jobName} - Build ${buildNumber}</h2> 
                <div style="background-color: ${bannerColor}; padding: 10px;"> 
                <h3 style="color: white;">Pipeline Status: 
                    ${pipelineStatus.toUpperCase()}</h3> 
                </div> 
                <p>Check the <a href="${BUILD_URL}">console output</a>.</p> 
                </div> 
                </body> 
                </html> 
            """ 
 
            emailext ( 
                subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}", 
                body: body, 
                to: 'sajaldhiman16@gmail.com', 
                from: 'jenkins@example.com', 
                replyTo: 'jenkins@example.com', 
                mimeType: 'text/html', 
                attachmentsPattern: 'trivy-image-report.html' 
            ) 
        } 
    } 
}


 }







  
