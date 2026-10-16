# Laboratory 10: The Enterprise Cloud Architect

**Student:** Licay Group  
**Course & Section:** BSIT 4-A  
**Subject:** CCM101 - Cloud Computing  
**Instructor:** Jenkielyn C. Torres  
**Application Stack:** WordPress + MariaDB  

---

## Mission Overview
As an Enterprise Cloud Architect for CloudNova Technologies, the goal of this project is to design, deploy, secure, and automate a production-ready, multi-tier containerized cloud infrastructure from scratch without guided instructions.

---

## Deliverables Checklist

| File Name | Description | Status |
| :--- | :--- | :---: |
| `architecture-diagram.png` | Network topology and architecture diagram (Host, Hypervisor, Ubuntu Server VM, UFW, Docker Bridge) | Completed |
| `docker-compose.yml` | Multi-tier WordPress + MariaDB stack configuration with persistent data volumes | Completed |
| `automation-script.sh` | Bash script for autonomous MariaDB database and WordPress backups | Completed |
| `operational-manual.md` | Executive-level operational handover manual for the IT operations team | Completed |
| `final-reflection.md` | Personal reflection and synthesis of learnings from Mission 1 to Mission 10 | Completed |

---

## System Architecture & Specifications

- **Operating System:** Ubuntu Server 26.04.1 LTS (Headless)
- **Hostname:** `enterprise-ubuntu-server`
- **Virtualization:** Oracle VM VirtualBox (NAT with Port Forwarding)
- **Container Engine:** Docker Engine & Docker Compose Plugin
- **Web Tier:** WordPress (`wordpress:latest`, Port `8080:80`)
- **Database Tier:** MariaDB 11 (`mariadb:11`, Port 3306)
- **Persistence:** Named volumes (`mariadb_data`, `wordpress_data`)
- **Host Security:** UFW Firewall (Default Deny policy)
- **Task Automation:** Custom Bash script scheduled via Cron

---

## Quickstart



### 1. Launch the Stack

```bash
cd ~/ccm101-mission10
sudo docker compose up -d
sudo docker compose ps

```

### 2. Configure Firewall (UFW)

```bash

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 8080/tcp comment 'WordPress Web'
sudo ufw enable

```

### 3. Run Automation Backup

```bash

chmod +x scripts/automation-script.sh
./scripts/automation-script.sh

```
