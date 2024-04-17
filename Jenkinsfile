pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  stages {
    stage('Build Backend') {
      when {
        beforeAgent true
        anyOf {
          branch 'master'
          branch 'backend'
          branch pattern: "release-*", comparator: "REGEXP"
          branch pattern: "backend-*", comparator: "REGEXP"
        }
      }
      agent {
        docker {
          image 'maven:3.6.3-adoptopenjdk-14'
        }
      }
      steps {
        dir("./apps/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./taxonomy/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./rating/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./user-management/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./mhealthatlas-users/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./enterprise-management/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./enterprise-apps/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./gateway/") {
          sh 'mvn -B -DskipTests clean package'
        }

        dir("./Keycloak/keycloak/") {
          sh 'mvn -B -DskipTests clean package'
        }
      }
    }

    stage('Build Frontend') {
      when {
        beforeAgent true
        anyOf {
          branch 'master'
          branch 'frontend'
          branch pattern: "release-*", comparator: "REGEXP"
          branch pattern: "frontend-*", comparator: "REGEXP"
        }
      }
      agent {
        docker {
          image 'node:14.8.0-alpine3.12'
          args '-u root'
        }
      }
      steps {
        dir("./frontendWeb/") {
          sh 'npm install -g @angular/cli'
          sh 'npm install'
          sh 'npm run build -- --prod --base-href / --deploy-url /'
        }
      }
    }

    stage('Build Documentation') {
      when {
        beforeAgent true
        anyOf {
          branch 'master'
          branch 'backend'
          branch pattern: "release-*", comparator: "REGEXP"
        }
      }
      agent {
        docker {
          image 'maven:3.6.3-adoptopenjdk-14'
        }
      }
      steps {
        dir("./apps/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./taxonomy/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./rating/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./user-management/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./mhealthatlas-users/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./enterprise-management/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./enterprise-apps/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./gateway/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }

        dir("./Keycloak/keycloak/") {
          sh 'mvn javadoc:javadoc -Dshow=private'
        }
      }
      post {
        always {
          archiveArtifacts artifacts: '**/Documentation/**', onlyIfSuccessful: true
        }
      }
    }

    stage('Test Backend') {
      when {
        beforeAgent true
        anyOf {
          branch 'master'
          branch 'backend'
          branch pattern: "release-*", comparator: "REGEXP"
          branch pattern: "backend-*", comparator: "REGEXP"
        }
      }
      agent {
        docker {
          image 'maven:3.6.3-adoptopenjdk-14'
        }
      }
      steps {
        dir("./apps/") {
          sh 'mvn -B test'
        }
      }
      post {
        always {
          sh 'find . -name "*.xml" -exec touch {} \\;'
          junit allowEmptyResults: true,
            testResults: '**/target/surefire-reports/TEST-*.xml'
        }
      }
    }

    stage('Test Frontend') {
      when {
        beforeAgent true
        anyOf {
          branch 'master'
          branch 'frontend'
          branch pattern: "release-*", comparator: "REGEXP"
          branch pattern: "frontend-*", comparator: "REGEXP"
        }
      }
      agent {
        docker {
          image 'node:14.8.0-slim'
          args '-u root'
        }
      }
      steps {
        //install chrome in container; used instructions from https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker
        sh '''apt-get update \
            && apt-get install -y wget gnupg \
            && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
            && sh -c \'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list\' \
            && apt-get update \
            && apt-get install -y google-chrome-stable fonts-freefont-ttf libxss1 \
              --no-install-recommends \
            && rm -rf /var/lib/apt/lists/*'''

        dir("./frontendWeb/") {
          sh 'npm install -g @angular/cli'
          sh 'npm install'
          sh 'npm run test'
        }
      }
      post {
        always {
          sh 'find . -name "*.xml" -exec touch {} \\;'
          junit allowEmptyResults: true,
            testResults: '**/karma-results/*.xml'
        }
      }
    }

    stage('Deploy to Docker Registry') {
      steps {
        echo 'ToDo push new images in the docker registry'
      }
    }
  }
}
