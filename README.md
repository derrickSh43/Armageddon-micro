# Armageddon-micro
Mini version of Armageddon 

# Multi-Region AWS Terraform Project

## Table of Contents
1. [Overview](#overview)
2. [Project Architecture](#project-architecture)
3. [Features](#features)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Infrastructure Details](#infrastructure-details)
7. [Post-Deployment Configuration](#post-deployment-configuration)
8. [Directory Structure](#directory-structure)
9. [Clean-Up](#clean-up)
10. [Future Enhancements](#future-enhancements)
11. [Author](#author)

---

## Overview

This Terraform project provisions a multi-region setup using AWS. It consists of two Virtual Private Clouds (VPCs) in different regions connected via a Transit Gateway (TGW). The infrastructure supports a SIEM solution with Loki and Grafana installed on a server in one region, while Promtail runs on an EC2 instance in the other region, forwarding logs to the SIEM server.

---

## Project Architecture

### Key Components:
1. **VPCs**:
   - **Region 1**: VPC with SIEM server (Loki + Grafana).
   - **Region 2**: VPC with an EC2 instance running Promtail.

2. **Transit Gateway (TGW)**:
   - Connects the VPCs across regions, enabling communication between the Promtail agent and the SIEM server.

3. **SIEM Solution**:
   - **Loki**: Centralized logging backend.
   - **Grafana**: Visualization and dashboard tool for logs.

4. **Promtail Agent**:
   - Installed on the EC2 instance in the second region to collect and forward logs to Loki.

---

## Features

- **Multi-Region Support**: Deploys resources in two AWS regions.
- **Centralized Logging**: Promtail sends logs securely across the TGW to the SIEM server.
- **Automated Deployment**: Fully automated using Terraform, ensuring consistency and reproducibility.

---

## Prerequisites

1. Install the following tools:
   - [Terraform](https://www.terraform.io/downloads.html)
   - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
   - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

2. AWS IAM permissions:
   - Ability to create VPCs, TGWs, EC2 instances, and associated resources.

3. Access to the Terraform configuration repository.

---

## Deployment Steps

### 1. Clone the Repository
```bash
git clone <repository_url>
cd <repository_folder>
```

### 2. Configure AWS Credentials
Ensure you have appropriate AWS credentials configured:
```bash
aws configure
```



```markdown
### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
Review the changes Terraform will make:
```bash
terraform plan
```

### 5. Apply the Deployment
Deploy the infrastructure:
```bash
terraform apply
```

---

## Infrastructure Details

### 1. **Region 1: SIEM Server**
- **Instance Type**: `t3.medium`
- **Services Installed**:
  - Loki (listening on port `3100`)
  - Grafana (listening on port `3000`)

### 2. **Region 2: Promtail Agent**
- **Instance Type**: `t3.micro`
- **Service Installed**:
  - Promtail (configured to forward logs to Loki on port `3100`)

### 3. **Transit Gateway**
- **Function**: Connects the VPCs in Region 1 and Region 2.
- **Routing**: Ensures secure communication between Promtail and the SIEM server.

---

## Post-Deployment Configuration

### 1. Access Grafana
- Open your browser and navigate to the public/private IP or domain of the SIEM server:
  ```
  http://<SIEM_SERVER_IP>:3000
  ```
- Default login:
  - **Username**: `admin`
  - **Password**: `admin` (change upon first login).

### 2. Verify Log Ingestion
- Confirm that logs from the Promtail agent are visible in Loki and Grafana.

---

## Directory Structure

```plaintext
.
|-- 01-provider.tf
|-- 02-main.tf
|-- 03-agent.tf
|-- 04-tgw.tf
|-- README.md
|-- promtail.sh
`-- userdata.sh

```

---

## Clean-Up

To destroy the infrastructure:
```bash
terraform destroy
```

---

## Future Enhancements

1. Add monitoring for resource usage and log ingestion rates.
2. Introduce automated scaling for the SIEM server.
3. Expand to additional regions or integrate more log sources.

---

## Author

### Connect with me:

[![Portfolio](https://img.shields.io/badge/Portfolio-derrick--weil.com-blue?style=flat-square&logo=internet-explorer)](https://derrick-weil.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-derrick--weil-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/derrick-weil)
[![YouTube](https://img.shields.io/badge/YouTube-AWS%20Tutorials-red?style=flat-square&logo=youtube)](https://www.youtube.com/channel/<channel_id>)

---
