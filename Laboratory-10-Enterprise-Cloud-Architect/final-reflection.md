
# Mission 10: Final Journey Reflection
## The Enterprise Cloud Architect

**Student / Group:** Licay Group  
**Course & Section:** BSIT 4-A  
**Subject:** CCM101 - Cloud Computing  
**Instructor:** Jenkielyn C. Torres  
**Date:** October 2026  

---

### I. Executive Summary
Concluding our journey in **CCM101 - Cloud Computing** through **Mission 10: The Enterprise Cloud Architect** marks a major transition from guided laboratory exercises to autonomous cloud engineering. In this mission, our objective was to design, deploy, harden, and automate a production-grade, multi-tier containerized infrastructure (WordPress + MariaDB) from scratch on an Ubuntu Server VirtualBox environment without guided step-by-step instructions.

---

### II. Synthesis of Learnings (Mission 1 to Mission 10)

1. **Foundations of Virtualization & Linux Administration (Missions 1 – 3):**
   * Early missions established foundational core competencies by deploying Ubuntu Server inside Oracle VM VirtualBox. We mastered headless server navigation, system process inspection (`systemctl`, `ss`), user privilege management, and secure remote terminal operations via SSH.

2. **Cloud Networking & Multi-Cloud Services (Missions 4 – 6):**
   * We explored virtualization networking models, configuring NAT networks, port forwarding, and bridged adapters to enable access to guest virtual machines from a host browser. We also examined fundamental public cloud services including compute instances, object storage, and identity management.

3. **Containerization & Service Orchestration (Missions 7 – 9):**
   * Shifting from monolithic virtual machines to modern microservices, we worked with Docker container architecture, images, volumes, and network namespaces. Using Docker Compose, we learned how to declare and orchestrate multi-container application stacks with persistent storage.

4. **The Enterprise Cloud Architect Capstone (Mission 10):**
   * Mission 10 integrated every skill acquired throughout the course into an enterprise deployment for CloudNova Technologies:
     - **Multi-Tier Architecture:** Orchestrated a decoupled stack featuring WordPress on Port 8080 and MariaDB 11 on Port 3306 using persistent Docker volumes (`mariadb_data` and `wordpress_data`).
     - **Host-Level Hardening & Defense-in-Depth:** Configured Uncomplicated Firewall (UFW) with a strict Default-Deny incoming policy, exposing only Port 22 (SSH) and Port 8080 (Web traffic), while isolating the MariaDB database on Port 3306 within the internal Docker bridge network.
     - **Automated Disaster Recovery:** Developed an autonomous Bash backup script (`automation-script.sh`) that executes MariaDB database dumps and WordPress file archives, scheduled via the Cron daemon to run automatically every day at 2:00 AM.

---

### III. Technical Challenges & Solutions

* **Network Bridging and Port Binding:** Mapping container services to host endpoints in a headless setup presented routing challenges. This was resolved by declaring explicit host-to-container port bindings (`8080:80`) in Docker Compose and configuring corresponding UFW ingress rules.
* **Database Persistence & Backup Automation:** Designing the backup script required handling database connectivity from within container runtime environments. Utilizing `docker exec` with non-interactive database dump utilities (`mariadb-dump`) and configuring cron standard output redirection ensured reliable scheduled backups without silent failures.

---

### IV. Conclusion & Industry Readiness

Mission 10 demonstrated that cloud architecture extends far beyond deploying virtual servers—it demands deliberate architectural planning, robust network isolation, and resilient automation. The technical foundation and troubleshooting methodologies acquired across all ten missions provide an invaluable asset as we prepare for professional roles in cloud computing, DevOps, and enterprise IT infrastructure.
