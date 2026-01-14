# file: Jenkinsfile
# author: Michael Moscovitch
#
# Copyright (c) 2026 Pathway Communications
#
# Licensed under the MIT License. See LICENSE file for details.

pipeline {
  agent any

  // Run off-hours to avoid build conflicts
  triggers { cron('H 3 1 * *') }  // monthly around 03:00 local

  options {
    timeout(time: 60, unit: 'MINUTES')
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }

  environment {
    // Set to "true" to actually prune; "false" to dry-run
    EXECUTE_PRUNE = 'true'
  }

  stages {
    stage('Dry-run (optional)') {
      when { expression { env.EXECUTE_PRUNE != 'true' } }
      steps {
        sh '''
          echo "[DRY RUN] Showing disk usage and candidates to prune"
          df -h
          docker system df
          docker image ls --filter "dangling=true"
          docker ps -a --filter "status=exited"
          docker volume ls -qf dangling=true
        '''
      }
    }

    stage('Prune Docker (safe)') {
      when { expression { env.EXECUTE_PRUNE == 'true' } }
      steps {
        sh './scripts/docker-prune-images.sh'
      }
    }

    stage('Prune Buildx cache') {
      when { expression { env.EXECUTE_PRUNE == 'true' } }
      steps {
        sh './scripts/docker-prune-cache.sh'
      }
    }

    stage('Container logs trim (optional)') {
      steps {
        sh '''
          echo "==> Truncating large container JSON logs (safe)"
          find /var/lib/docker/containers -name "*-json.log" -size +50M -exec truncate -s 0 {} \\;
        '''
      }
    }
  }

  post {
    success {
      echo 'Prune completed successfully.'
    }
    failure {
      echo 'Prune failed — check logs.'
    }
  }
}
