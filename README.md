
# CI-CD Project: Full DevOps Pipeline with Terraform, Ansible, Docker, Jenkins & K3s

This repository implements a complete DevOps pipeline that automates the provisioning, configuration, deployment, and continuous delivery of a containerized web application using modern tools like **Terraform**, **Ansible**, **Docker**, **Jenkins**, and **K3s** (lightweight Kubernetes).

![Ansible](https://img.shields.io/badge/Ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)


![Image](https://github.com/user-attachments/assets/a8c7c8f2-f295-4bc7-b5da-cbae52f6d125)
---

## 📦 Project Structure

```
CI-CD-Project/
├── Website_image/         # Static web app (HTML + CSS + Dockerfile)
├── Jenkinsfile            # Jenkins CI/CD pipeline
├── terraform/             # Infrastructure provisioning on cloud
├── ansible/               # Configuration management for K3s cluster
├── k3s/                   # Kubernetes deployment manifests
├── bash_script/           # Shell scripts for automation
```

---

## 🌐 Static Website

- Built with HTML5, Bootstrap 5, and custom CSS
- Containerized using Docker (`Dockerfile`)
- Contains multiple media assets for demo UI

### 🔧 Run Locally

```bash
cd Website_image
docker build -t ci-cd-web .
docker run -d -p 8080:80 ci-cd-web
```

---

## 🛠 Infrastructure Provisioning with Terraform

- Located in `/terraform`
- Modular architecture:
  - VPC
  - Security Groups
  - EC2 Bastion Host
  - Worker Nodes
  - ALB
- Written using `.tf` modules for reusability

### 🚀 Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

> Make sure your AWS credentials are configured.

---

## 🔧 Configuration Management with Ansible

- Located in `/ansible`
- Installs K3s (lightweight Kubernetes) on provisioned nodes
- Uses inventory for master/worker designation

### 🧪 Run Playbook

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

> Requires SSH access to EC2 instances.

---

## ☸ Kubernetes (K3s) Setup

- Located in `/k3s`
- Contains:
  - `deployment.yml` – Deploys the web app
  - `service.yml` – Exposes the app internally
  - `ingress.yml` – Ingress setup (Nginx/Traefik)
  - `albservice.yml` – Integrates with AWS ALB (if used)

### ⛵ Deploy to K3s

```bash
kubectl apply -f k3s/
```

---

## 🔁 CI/CD with Jenkins

- `Jenkinsfile` defines pipeline:
  1. Checkout
  2. Build Docker image
  3. Push to Registry (optional)
  4. Deploy to K3s via `kubectl`

### 🛠 Prerequisites

- Jenkins installed with:
  - Docker plugin
  - Git plugin
  - Pipeline plugin
- Docker must be accessible from Jenkins agent
- Kubeconfig must be present on Jenkins server to deploy to K3s

---

## 🐚 Bash Automation

- `bash_script/script.sh` – General purpose setup or helper script
- Customize as needed to automate Docker/Jenkins/Ansible flows

---

## 🧰 Tools & Technologies

- **Terraform** – Infrastructure as Code (IaC)
- **Ansible** – Configuration Management
- **Docker** – Containerization
- **Jenkins** – Continuous Integration & Delivery
- **K3s** – Lightweight Kubernetes
- **Bootstrap** – Frontend styling

---

## 📬 Contact
**Mohab Abdelaal**

[![GitHub](https://img.shields.io/badge/GitHub-Mohab--Abdelaal-blue)](https://github.com/Mohab-Abdelaal-12)  
[![Email](https://img.shields.io/badge/Email-mohabahmed600gmail.com-red)](mailto:mohabahmed600@gmail.com)
---
