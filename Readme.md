# Ansible Configuration Management with Jenkins and GitHub

> **DevOps Portfolio Project --- Infrastructure as Code, Configuration
> Management & CI/CD**

## Table of Contents

-   [Project Overview](#project-overview)
-   [Project Objectives](#project-objectives)
-   [Architecture](#architecture)
-   [Technology Stack](#technology-stack)
-   [Repository Structure](#repository-structure)
-   [Implementation](#implementation)
    -   [1. Ansible Control Node](#1-ansible-control-node)
    -   [2. SSH Key-Based
        Authentication](#2-ssh-key-based-authentication)
    -   [3. Ansible Inventory](#3-ansible-inventory)
    -   [4. Ansible Playbooks](#4-ansible-playbooks)
-   [Testing and Validation](#testing-and-validation)
-   [CI/CD Pipeline](#cicd-pipeline)
-   [GitHub Webhook Integration](#github-webhook-integration)
-   [Jenkins Automation](#jenkins-automation)
-   [Security](#security)
-   [Project Workflow](#project-workflow)
-   [Challenges and Troubleshooting](#challenges-and-troubleshooting)
-   [Lessons Learned](#lessons-learned)
-   [Future Improvements](#future-improvements)
-   [Conclusion](#conclusion)

------------------------------------------------------------------------

## Project Overview

This project demonstrates the implementation of an **Ansible-based
configuration management solution integrated with GitHub and Jenkins**.

The primary goal was to automate common Linux server administration
tasks instead of performing them manually on each remote server.

An Ubuntu server was configured as the **Ansible control node**. SSH
key-based authentication was established between the control node and
the managed servers, allowing Ansible to remotely execute configuration
tasks.

The Ansible project was organized into separate `inventory` and
`playbooks` directories. A development inventory file was created to
define the remote hosts, while multiple Ansible playbooks were developed
to automate:

-   Installation of Wireshark.
-   Creation of a directory and file on a remote server.
-   Configuration of the server timezone to `Africa/Nairobi`.

The project was then integrated with a **GitHub repository and
Jenkins**. A GitHub webhook was configured so that a repository change
can trigger the Jenkins job automatically.

The resulting workflow demonstrates a practical **Infrastructure as Code
(IaC) and CI/CD approach to configuration management**.

------------------------------------------------------------------------

## Project Objectives

The project was designed to achieve the following objectives:

1.  Configure an Ansible server to act as a control node.
2.  Establish SSH connectivity between the control node and remote Linux
    servers.
3.  Configure passwordless/key-based SSH authentication for automation.
4.  Create an Ansible inventory for development servers.
5.  Develop reusable Ansible playbooks for common server administration
    tasks.
6.  Automate software installation across remote servers.
7.  Automate filesystem configuration.
8.  Automate timezone configuration.
9.  Store infrastructure automation code in GitHub.
10. Integrate GitHub with Jenkins using a webhook.
11. Automatically trigger Jenkins when changes are pushed to the
    repository.
12. Demonstrate an end-to-end automated configuration management
    workflow.

------------------------------------------------------------------------

# Architecture

## High-Level Architecture

The architecture consists of a developer workstation, GitHub,
Jenkins/Ansible control node, and multiple managed servers.

``` text
                           +----------------------+
                           |     Developer PC     |
                           |      VS Code         |
                           +----------+-----------+
                                      |
                                      | git push
                                      v
                           +----------------------+
                           |       GitHub         |
                           |     Repository       |
                           +----------+-----------+
                                      |
                                      | Webhook
                                      v
                           +----------------------+
                           |       Jenkins        |
                           |   Automation Job     |
                           +----------+-----------+
                                      |
                                      | Execute
                                      v
                           +----------------------+
                           | Ansible Control Node  |
                           | Jenkins + Ansible    |
                           +----------+-----------+
                                      |
                              SSH / Ansible
                                      |
              +-----------------------+-----------------------+
              |                       |                       |
              v                       v                       v
       +-------------+         +-------------+         +-------------+
       | RHEL 8      |         | RHEL 8      |         | RHEL 8      |
       | Web Server 1|         | Web Server 2|         | DB / NFS    |
       +-------------+         +-------------+         +-------------+

                              +-------------+
                              | Ubuntu      |
                              | Load        |
                              | Balancer    |
                              +-------------+
```

### Architecture Diagram

```{=html}
<!-- TODO: Add the project architecture image to the repository. -->
```
```{=html}
<!-- Recommended location: images/architecture.png -->
```
![Project Architecture](images/architecture.png)

### Architecture Components

  -----------------------------------------------------------------------
  Component                           Role
  ----------------------------------- -----------------------------------
  Developer PC                        Used to create and modify Ansible
                                      automation code

  GitHub                              Version control and central
                                      repository for the automation code

  GitHub Webhook                      Sends an event to Jenkins when
                                      repository changes occur

  Jenkins                             Automates the CI/CD execution
                                      workflow

  Ansible Control Node                Executes playbooks against managed
                                      servers

  Ansible Inventory                   Defines and groups the managed
                                      hosts

  SSH                                 Secure communication between the
                                      control node and managed servers

  RHEL 8 Servers                      Remote servers managed by Ansible

  Ubuntu Server                       Remote development
                                      server/load-balancer environment
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# Technology Stack

  Technology   Purpose
  ------------ -------------------------------------------
  Linux        Server operating system
  Ubuntu       Ansible/Jenkins control environment
  RHEL 8       Managed server environment
  Ansible      Configuration management and automation
  Jenkins      CI/CD automation
  Git          Source control
  GitHub       Remote repository and webhook integration
  SSH          Secure remote server access
  YAML         Ansible playbook format
  Bash         Command-line administration and scripting

------------------------------------------------------------------------

# Repository Structure

The Ansible project is organized to separate inventory configuration
from automation playbooks.

``` text
ansible-configuration-mgmt/
│
├── inventory/
│   └── dev.ini
│
├── playbooks/
│   ├── install-wireshark.yml
│   ├── create-directory-file.yml
│   └── change-timezone.yml
│
├── images/
│   ├── architecture.png
│   ├── ssh-connection.png
│   ├── ansible-version.png
│   ├── ansible-ping.png
│   ├── inventory.png
│   ├── wireshark-installation.png
│   ├── directory-file.png
│   ├── timezone.png
│   ├── github-webhook.png
│   ├── jenkins-job.png
│   └── jenkins-success.png
│
├── README.md
└── Jenkinsfile
```

> **Note:** The filenames above are recommended documentation names.
> Adjust them to match the files actually present in the repository.

------------------------------------------------------------------------

# Implementation

## 1. Ansible Control Node

Ansible was installed on a dedicated server that acts as the **control
node**.

The control node is responsible for:

-   Maintaining the inventory.
-   Storing the playbooks.
-   Connecting to remote servers through SSH.
-   Executing configuration tasks.
-   Returning execution results.
-   Serving as the automation environment used by Jenkins.

### Verify Ansible Installation

```{=html}
<!-- TODO: Replace with the exact command/output used in your environment. -->
```
``` bash
ansible --version
```

Example:

``` text
ansible [core ...]
python version = ...
jinja version = ...
```

### Screenshot

```{=html}
<!-- TODO: Add screenshot showing successful Ansible installation. -->
```
![Ansible Installation](images/ansible-version.png)

------------------------------------------------------------------------

## 2. SSH Key-Based Authentication

Ansible uses SSH to communicate with the managed servers.

SSH key-based authentication was configured between the Ansible control
node and the remote hosts.

The SSH private key used for the Ansible connection was stored securely
on the control node.

> **Security:** Never commit the private SSH key to GitHub.

### SSH Key Location

The configured SSH key was:

``` text
/home/ubuntu/.ssh/ansible_key
```

### Test SSH Connectivity

```{=html}
<!-- TODO: Replace the username/host with a non-sensitive example if documenting publicly. -->
```
``` bash
ssh -i /home/ubuntu/.ssh/ansible_key ubuntu@<REMOTE_SERVER_IP>
```

Successful SSH access confirms that the control node can communicate
with the managed host.

### Screenshot

```{=html}
<!-- TODO: Add screenshot showing successful SSH connection. -->
```
![SSH Connection](images/ssh-connection.png)

------------------------------------------------------------------------

# 3. Ansible Inventory

Ansible inventory defines the hosts that are managed by Ansible.

A dedicated `inventory` directory was created in the project:

``` text
inventory/
└── dev.ini
```

The `dev.ini` file contains the IP addresses/host definitions of the
development servers.

### Example Inventory

``` ini
[webservers]
web-server-1 ansible_host=<WEB_SERVER_1_IP>
web-server-2 ansible_host=<WEB_SERVER_2_IP>

[database]
db-server ansible_host=<DATABASE_SERVER_IP>

[nfs]
nfs-server ansible_host=<NFS_SERVER_IP>

[loadbalancer]
load-balancer ansible_host=<LOAD_BALANCER_IP>
```

> **Important:** Do not expose private infrastructure addresses or
> credentials in a public portfolio repository unless they are
> intentionally public and safe to disclose.

### Screenshot

```{=html}
<!-- TODO: Add screenshot of your actual dev.ini inventory. -->
```
![Ansible Inventory](images/inventory.png)

------------------------------------------------------------------------

# 4. Ansible Playbooks

Three playbooks were developed as part of the project.

  -----------------------------------------------------------------------
  Playbook                            Purpose
  ----------------------------------- -----------------------------------
  `install-wireshark.yml`             Installs Wireshark on managed
                                      servers

  `create-directory-file.yml`         Creates a directory and file on a
                                      remote server

  `change-timezone.yml`               Changes the timezone of managed
                                      servers
  -----------------------------------------------------------------------

These playbooks demonstrate software management, filesystem management,
and operating-system configuration.

------------------------------------------------------------------------

## Playbook 1: Install Wireshark

### Objective

The first playbook automates the installation of Wireshark on the remote
servers.

This eliminates the need to manually log into each server and install
the package individually.

### Playbook

```{=html}
<!-- TODO: Replace the block below with the exact contents of your actual playbook if they differ. -->
```
``` yaml
---
- name: Install Wireshark
  hosts: all
  become: yes

  tasks:
    - name: Install Wireshark
      ansible.builtin.package:
        name: wireshark
        state: present
```

### Execute

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/install-wireshark.yml
```

### Validation

Verify that Wireshark is installed on a managed server:

``` bash
rpm -qa | grep wireshark
```

For Debian/Ubuntu systems:

``` bash
dpkg -l | grep wireshark
```

### Screenshot

```{=html}
<!-- TODO: Add screenshot showing successful playbook execution. -->
```
![Wireshark Installation](images/wireshark-installation.png)

------------------------------------------------------------------------

# Playbook 2: Create Directory and File

## Objective

The second playbook automates the creation of a directory and a file on
a remote server.

This demonstrates Ansible's ability to manage filesystem resources
remotely.

### Playbook

```{=html}
<!-- TODO: Replace with your exact playbook if the path, filename, permissions or module usage differ. -->
```
``` yaml
---
- name: Create directory and file
  hosts: all
  become: yes

  tasks:

    - name: Create directory
      ansible.builtin.file:
        path: /tmp/example-directory
        state: directory
        mode: '0755'

    - name: Create file
      ansible.builtin.file:
        path: /tmp/example-directory/example.txt
        state: touch
        mode: '0644'
```

### Execute

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/create-directory-file.yml
```

### Validation

``` bash
ls -la /tmp/example-directory
```

Expected:

``` text
example.txt
```

### Screenshot

```{=html}
<!-- TODO: Add screenshot showing the directory and file created on the remote host. -->
```
![Directory and File](images/directory-file.png)

------------------------------------------------------------------------

# Playbook 3: Change Server Timezone

## Objective

The third playbook automates timezone configuration across the remote
servers.

The project configured the timezone as:

``` text
Africa/Nairobi
```

### Playbook

The `community.general.timezone` module was used for timezone
configuration.

```{=html}
<!-- TODO: Replace with the exact contents of your actual playbook if they differ. -->
```
``` yaml
---
- name: Configure server timezone
  hosts: all
  become: yes

  tasks:
    - name: Set timezone to Africa/Nairobi
      community.general.timezone:
        name: Africa/Nairobi
```

### Execute

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/change-timezone.yml
```

### Validation

The configured timezone can be verified with:

``` bash
timedatectl
```

Expected:

``` text
Time zone: Africa/Nairobi (EAT, +0300)
```

### Screenshot

```{=html}
<!-- TODO: Add screenshot showing timedatectl output. -->
```
![Timezone Configuration](images/timezone.png)

------------------------------------------------------------------------

# Testing and Validation

Testing was performed at different stages to verify that the automation
environment was working correctly.

## 1. SSH Connectivity Test

The first validation step was to confirm that the Ansible control node
could connect to the remote servers.

``` bash
ssh -i /home/ubuntu/.ssh/ansible_key ubuntu@<REMOTE_SERVER_IP>
```

**Expected result:** Successful SSH authentication.

------------------------------------------------------------------------

## 2. Ansible Ping Test

Ansible's `ping` module was used to validate communication with the
managed nodes.

``` bash
ansible all \
  -i inventory/dev.ini \
  -m ping
```

A successful response should contain:

``` text
SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Screenshot

```{=html}
<!-- TODO: Add actual successful ping screenshot. -->
```
![Ansible Ping](images/ansible-ping.png)

------------------------------------------------------------------------

## 3. Inventory Validation

The configured hosts can be displayed using:

``` bash
ansible all \
  -i inventory/dev.ini \
  --list-hosts
```

This confirms that Ansible is reading the expected hosts from the
inventory.

------------------------------------------------------------------------

## 4. Playbook Syntax Validation

Before executing a playbook, syntax can be checked with:

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/install-wireshark.yml \
  --syntax-check
```

Expected:

``` text
playbook: playbooks/install-wireshark.yml
```

The same validation can be performed against the other playbooks.

------------------------------------------------------------------------

## 5. Ansible Check Mode

Ansible check mode can be used to preview changes before applying them:

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/change-timezone.yml \
  --check
```

This provides an additional safety mechanism when testing configuration
changes.

------------------------------------------------------------------------

## 6. Idempotency Testing

Ansible playbooks are designed to be **idempotent**, meaning repeated
execution should not continuously make the same changes.

For example:

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/create-directory-file.yml
```

Running the same playbook again should report fewer changes once the
desired state already exists.

This is an important characteristic of configuration management because
it allows automation to be safely repeated.

------------------------------------------------------------------------

# CI/CD Pipeline

The project integrates GitHub, Jenkins and Ansible to create an
automated configuration management workflow.

The pipeline is:

``` text
Developer
    |
    | git push
    v
GitHub Repository
    |
    | GitHub Webhook
    v
Jenkins
    |
    | Checkout latest code
    v
Ansible Control Node
    |
    | Execute Playbook
    v
Remote Servers
    |
    v
Configuration Applied
```

This approach means that infrastructure automation code is managed using
the same version-control and automation principles commonly used in
application CI/CD.

------------------------------------------------------------------------

# GitHub Webhook Integration

A GitHub webhook was configured for the project repository.

The webhook allows GitHub to notify Jenkins whenever a repository event
occurs, such as a push.

### Workflow

``` text
Git Push
   |
   v
GitHub detects repository change
   |
   v
GitHub sends webhook
   |
   v
Jenkins receives webhook
   |
   v
Jenkins starts configured job
```

### Screenshot

```{=html}
<!-- TODO: Add screenshot of the GitHub webhook configuration. -->
```
![GitHub Webhook](images/github-webhook.png)

------------------------------------------------------------------------

# Jenkins Automation

Jenkins was configured to execute the Ansible automation workflow.

The Jenkins job performs the following high-level operations:

1.  Receives the GitHub webhook.
2.  Starts the Jenkins job.
3.  Checks out the latest repository version.
4.  Loads the latest inventory and playbooks.
5.  Executes the required Ansible playbook.
6.  Reports the execution result.

### Example Ansible Command Executed by Jenkins

``` bash
ansible-playbook \
  -i inventory/dev.ini \
  playbooks/<playbook-name>.yml
```

### Jenkins Job

```{=html}
<!-- TODO: Add screenshot of the Jenkins job configuration. -->
```
![Jenkins Job](images/jenkins-job.png)

### Successful Build

```{=html}
<!-- TODO: Add screenshot showing a successful Jenkins build. -->
```
![Successful Jenkins Build](images/jenkins-success.png)

------------------------------------------------------------------------

# Jenkins Pipeline Design

The intended CI/CD flow can be represented as:

``` text
+----------------------+
| Developer             |
| Modify Ansible Code   |
+----------+-----------+
           |
           | git push
           v
+----------------------+
| GitHub Repository     |
+----------+-----------+
           |
           | Webhook
           v
+----------------------+
| Jenkins               |
|                       |
| 1. Checkout           |
| 2. Validate           |
| 3. Execute Ansible    |
+----------+-----------+
           |
           v
+----------------------+
| Ansible Control Node  |
+----------+-----------+
           |
           | SSH
           v
+----------------------+
| Managed Servers       |
|                       |
| Web / DB / NFS / LB   |
+----------------------+
```

------------------------------------------------------------------------

# Security

Security is an important consideration when implementing automated
infrastructure management.

## SSH Private Key

The SSH private key used by Ansible must remain on the control node and
should never be committed to GitHub.

Example:

``` text
/home/ubuntu/.ssh/ansible_key
```

A public repository should never contain the private key.

------------------------------------------------------------------------

## Credentials

Do not store the following directly in playbooks or Git:

-   SSH private keys
-   Passwords
-   Cloud credentials
-   API tokens
-   Jenkins credentials
-   Database passwords
-   Other secrets

For production environments, secrets should be managed through
appropriate secret-management mechanisms such as:

-   Jenkins Credentials
-   Ansible Vault
-   Cloud secret-management services
-   Environment-specific secure variables

------------------------------------------------------------------------

## Public Repository Considerations

If this repository is public, private IP addresses and
infrastructure-specific information should be replaced with
placeholders.

For example:

``` text
<WEB_SERVER_1_IP>
<DB_SERVER_IP>
<JENKINS_URL>
<SSH_USER>
```

This keeps the portfolio project useful without exposing internal
infrastructure details.

------------------------------------------------------------------------

# Project Workflow

The complete project workflow is:

### Step 1 --- Development

The developer creates or modifies an Ansible playbook locally.

``` text
VS Code
   |
   v
Ansible Playbook
```

### Step 2 --- Version Control

The changes are committed and pushed to GitHub.

``` bash
git add .
git commit -m "Update Ansible configuration"
git push origin main
```

### Step 3 --- GitHub Webhook

GitHub sends a webhook to Jenkins.

``` text
GitHub
   |
   | Webhook
   v
Jenkins
```

### Step 4 --- Jenkins Execution

Jenkins checks out the latest version of the repository.

``` text
Jenkins
   |
   v
Latest Ansible Code
```

### Step 5 --- Ansible Execution

Jenkins executes the Ansible playbook.

``` text
ansible-playbook -i inventory/dev.ini playbooks/<playbook>.yml
```

### Step 6 --- Remote Configuration

Ansible connects to the managed nodes over SSH and applies the required
configuration.

``` text
Ansible Control Node
          |
          | SSH
          v
    Remote Servers
```

### Step 7 --- Validation

The resulting server state is validated using Ansible output and
operating-system commands such as:

``` bash
timedatectl
```

or:

``` bash
ls -la /tmp/example-directory
```

------------------------------------------------------------------------

# Challenges and Troubleshooting

## SSH Authentication

One of the key requirements of the project was establishing reliable SSH
connectivity between the control node and managed servers.

The Ansible control node was configured with an SSH key specifically for
automated connections:

``` text
/home/ubuntu/.ssh/ansible_key
```

Ansible successfully connected to the configured reachable hosts.

During testing, one remote host remained unreachable because of an SSH
public-key authentication issue. This demonstrated the importance of
validating SSH connectivity independently before troubleshooting Ansible
itself.

### Troubleshooting Approach

The following commands are useful when diagnosing SSH connectivity:

``` bash
ssh -v -i /home/ubuntu/.ssh/ansible_key ubuntu@<REMOTE_SERVER_IP>
```

Verify the public key exists on the remote server:

``` bash
cat ~/.ssh/authorized_keys
```

Check SSH permissions:

``` bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Then retest:

``` bash
ssh -i /home/ubuntu/.ssh/ansible_key ubuntu@<REMOTE_SERVER_IP>
```

------------------------------------------------------------------------

# Lessons Learned

This project provided practical experience with several DevOps concepts.

## 1. Infrastructure as Code

Infrastructure configuration can be represented as code instead of
relying on manual server administration.

This makes configuration:

-   Repeatable
-   Version controlled
-   Auditable
-   Easier to maintain

## 2. Configuration Management

Ansible provides a consistent mechanism for applying configurations to
multiple servers.

For example, instead of manually changing the timezone on every server,
one playbook can define the desired state.

## 3. SSH Is Fundamental to Ansible

Reliable SSH connectivity is a prerequisite for traditional Ansible
management of Linux hosts.

Testing SSH independently makes troubleshooting much easier.

## 4. Version Control for Infrastructure

Storing Ansible playbooks in GitHub provides a history of infrastructure
changes.

This makes it possible to determine:

-   What changed?
-   Who changed it?
-   When was it changed?
-   Why was it changed?

## 5. CI/CD Can Be Applied to Infrastructure

Jenkins is not limited to application deployment.

The same CI/CD principles can be applied to infrastructure and
configuration management.

A code change can trigger:

``` text
GitHub
   ↓
Webhook
   ↓
Jenkins
   ↓
Ansible
   ↓
Infrastructure
```

------------------------------------------------------------------------

# Future Improvements

The current project provides a foundation for infrastructure automation.
The following improvements can make it more production-ready.

## Ansible Roles

Convert individual playbooks into reusable Ansible roles.

``` text
roles/
├── wireshark/
├── timezone/
├── webserver/
├── database/
└── nfs/
```

## Environment Separation

Create separate inventories for:

``` text
inventory/
├── dev/
├── staging/
└── production/
```

This allows the same automation code to be used across different
environments.

## Ansible Vault

Sensitive configuration values can be protected using Ansible Vault.

``` bash
ansible-vault encrypt secrets.yml
```

## Automated Validation

Introduce additional CI checks such as:

``` text
Git Push
   |
   v
Syntax Check
   |
   v
Ansible Lint
   |
   v
Check Mode
   |
   v
Deployment
   |
   v
Validation
```

## Jenkinsfile

Move Jenkins configuration into a version-controlled `Jenkinsfile`.

This makes the CI/CD pipeline itself Infrastructure/Configuration as
Code.

## Monitoring

Integrate server monitoring to track:

-   CPU utilization
-   Memory utilization
-   Disk utilization
-   Network utilization
-   Service availability
-   System health

------------------------------------------------------------------------

# Evidence and Screenshots

The following screenshots are recommended as evidence of implementation.

  Evidence                       Recommended File
  ------------------------------ -------------------------------------
  Overall architecture           `images/architecture.png`
  Ansible installation           `images/ansible-version.png`
  SSH connectivity               `images/ssh-connection.png`
  Ansible ping                   `images/ansible-ping.png`
  Inventory configuration        `images/inventory.png`
  Wireshark playbook execution   `images/wireshark-installation.png`
  Directory/file creation        `images/directory-file.png`
  Timezone configuration         `images/timezone.png`
  GitHub webhook                 `images/github-webhook.png`
  Jenkins job                    `images/jenkins-job.png`
  Successful Jenkins build       `images/jenkins-success.png`

------------------------------------------------------------------------

# Project Skills Demonstrated

This project demonstrates practical experience in:

-   Linux administration
-   Ansible
-   Configuration management
-   Infrastructure as Code
-   SSH
-   Git
-   GitHub
-   Jenkins
-   CI/CD
-   YAML
-   Remote server administration
-   Automated software installation
-   Filesystem automation
-   System configuration
-   Webhook-based automation
-   Troubleshooting
-   Infrastructure security

------------------------------------------------------------------------

# Conclusion

This project demonstrates an end-to-end approach to **automated Linux
server configuration management using Ansible**, with GitHub and Jenkins
providing version control and CI/CD automation.

The implementation moves server administration away from repetitive
manual configuration toward a repeatable, version-controlled and
automated workflow.

The core workflow is:

``` text
Developer
    |
    | Git Push
    v
GitHub
    |
    | Webhook
    v
Jenkins
    |
    | Execute
    v
Ansible Control Node
    |
    | SSH
    v
Managed Servers
    |
    v
Automated Configuration
```

The project establishes a foundation that can be expanded into a more
advanced infrastructure automation platform by introducing Ansible
roles, environment separation, secrets management, automated testing,
monitoring and a fully declarative Jenkins pipeline.

------------------------------------------------------------------------

## Author

**DevOps / Cloud Engineering Portfolio Project**

> This project was developed to demonstrate practical implementation of
> configuration management, Infrastructure as Code and CI/CD automation
> using Ansible, GitHub and Jenkins.
