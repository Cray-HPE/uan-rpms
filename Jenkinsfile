@Library('csm-shared-library') _

pipeline {
    agent {
        label "metal-gcp-builder"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: "10"))
        timestamps()
    }

    environment {
        NAME = "uan-rpms"
        IS_STABLE = getBuildIsStable()
    }

    stages {
        stage("Build") {
            agent {
                docker {
                    image "arti.dev.cray.com/dstbuildenv-docker-master-local/cray-sle15sp2_build_environment:latest"
                    reuseNode true
                     // Run as root
                    args "-u root"
                }
            }
            steps {
                sh "make"
            }
        }


        stage('Publish') {
            steps {
                script {
                    publishCsmRpms(component: env.NAME, pattern: "dist/rpmbuild/RPMS/noarch/*.rpm", arch: "noarch", isStable: env.IS_STABLE)
                    publishCsmRpms(component: env.NAME, pattern: "dist/rpmbuild/RPMS/x86_64/*.rpm", arch: "x86_64", isStable: env.IS_STABLE)
                    publishCsmRpms(component: env.NAME, pattern: "dist/rpmbuild/SRPMS/*.rpm", arch: "src", isStable: env.IS_STABLE)
                }
            }
        }
    }

    post {
        always {
            // Own files so jenkins can clean them up later
            postChownFiles()
        }
    }
}
