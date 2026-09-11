pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out Ansible repository...'
                checkout scm
            }
        }

        stage('Verify Ansible') {
            steps {
                echo 'Checking Ansible installation...'
                sh 'ansible --version'
            }
        }

        stage('Test Connectivity') {
            steps {
                echo 'Testing connectivity to managed servers...'

                sh '''
                    ansible all \
                    -i inventory/dev.ini \
                    -m ping
                '''
            }
        }

        stage('Validate Playbooks') {
            steps {
                echo 'Checking playbook syntax...'

                sh '''
                    ansible-playbook \
                    -i inventory/dev.ini \
                    playbooks/install-wireshark.yml \
                    --syntax-check

                    ansible-playbook \
                    -i inventory/dev.ini \
                    playbooks/create-directory-file.yml \
                    --syntax-check

                    ansible-playbook \
                    -i inventory/dev.ini \
                    playbooks/change-timezone.yml \
                    --syntax-check
                '''
            }
        }

        stage('Install Wireshark') {
            steps {
                echo 'Installing Wireshark on managed servers...'

                sh '''
                    ansible-playbook \
                    -i inventory/dev.ini \
                    playbooks/install-wireshark.yml
                '''
            }
        }

        stage('Create Directory and File') {
            steps {
                echo 'Creating directory and file on managed servers...'

                sh '''
                    ansible-playbook \
                    -i inventory/dev.ini \
                    playbooks/createfile.yml
                '''
            }
        }
    }

    post {

        success {
            echo 'Ansible configuration completed successfully.'
        }

        failure {
            echo 'Ansible configuration failed.'
        }

        always {
            echo 'Jenkins pipeline execution completed.'
        }
    }
}