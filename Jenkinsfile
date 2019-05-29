
pipeline {
  agent { label 'linux' }
  
  stages {
    stage('Поиск изменений develop') {
      when {
        branch 'develop'
      } 
      steps {
        sh 'echo "test"'
      }
      
    }
  } 
}
