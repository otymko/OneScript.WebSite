
pipeline {
  agent { label 'linux' }
  
  stage('Обновление исходников сайта') {
    dir("/home/andrei/os"){
      sh 'sudo git submodule update --init --recursive'
      sh 'docker-compose build --no-cache site-dev'
      sh 'docker-compose up -d --force-recreate site-dev'
    }
  } 
}
