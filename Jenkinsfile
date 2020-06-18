node {
	environment {
		registry = "http://192.168.50.39:32773/"
		registryCredential = 'dockerReg'
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
        script {
          dockerImage = docker.build("${imageName}", "-f applications/hello-kenzan/Dockerfile applications/hello-kenzan")
        }
    }
    stage('Deploy Image') {
        script {
          docker.withRegistry( "http://192.168.50.39:32773/", 'dockerReg' ) {
            dockerImage.push()
          }
        }
    }

    stage "Deploy"

        kubernetesDeploy configs: "applications/${appName}/k8s/*.yaml", kubeconfigId: 'kenzan_kubeconfig'

}