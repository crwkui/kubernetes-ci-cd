node {
	environment {
		registry = "http://192.168.50.39:32773/"
		registryCredential = 'dockerReg'
		dockerImage = ''
	}	
    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "hello-kenzan"
    registryHost = "192.168.50.39:32773/"
    imageName = "${registryHost}${appName}:${tag}"
    env.BUILDIMG=imageName

	stage('Building image') {
      steps{
        script {
          dockerImage = docker.build(registry + "${appName}:${tag}", "-f applications/hello-kenzan/Dockerfile")
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }

    stage "Deploy"

        kubernetesDeploy configs: "applications/${appName}/k8s/*.yaml", kubeconfigId: 'kenzan_kubeconfig'

}