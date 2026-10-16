

# CCM101 – CLOUD COMPUTING

# ENTERPRISE CLOUD ARCHITECT: OPERATIONAL MANUAL

**Project:** Secure Multi-Tier Web Application  
**Application Stack:** WordPress + MariaDB

**Prepared by:**
- Angel R. Licay
- Jessie H. Toralba
- Willie R. Licay

**Section:** BSIT-4A  
**Instructor:** Jenkielyn C. Torres  
**Date:** October 2026

---

## Project Overview

This manual explains how to start, monitor, secure, back up, and restore the CCM101 web application. It uses WordPress and MariaDB containers managed by Docker Compose on an Ubuntu Server VM in VirtualBox. Before running the commands, make sure the passwords, folder paths, and port settings match your actual setup.

## 1. System Details

| Item | Project Configuration |
|---|---|
| Host computer | Windows laptop/desktop |
| Virtualization software | Oracle VirtualBox |
| Server operating system | Ubuntu Server 26.04.1 LTS |
| Project folder | `/home/ubuntu/ccm101-mission10` |
| Containers | WordPress (Apache) and MariaDB 11 |
| Browser access | `http://127.0.0.1:8080` |
| Port mapping | Windows port 8080 → VM port 8080 → WordPress container port 80 |
| Firewall (UFW) | Blocks incoming traffic by default; allows ports 8080 and 22 |
| Storage volumes | `mariadb_data`, `wordpress_data` |
| Backup script | `scripts/automation-script.sh` |
| Backup folder | `/home/ubuntu/ccm101-mission10/backups` |

**Important:** Open WordPress at `http://127.0.0.1:8080`. This address works through VirtualBox NAT port forwarding. Do not depend on an internal NAT address such as `10.0.2.15`, because it may change.

## 2. System Architecture: How It Works

The Windows computer runs VirtualBox, which runs Ubuntu Server, where Docker is installed. Docker Compose starts two connected containers: WordPress, which displays the website and manages its content, and MariaDB, which stores the website's database records.

Docker named volumes store data outside the containers, so removing and recreating a container does not normally delete the data saved in its volume.

When someone opens the website, the request travels from the Windows browser through `127.0.0.1:8080`, passes through VirtualBox NAT port forwarding to port 8080 on the Ubuntu virtual machine, and finally reaches port 80 of the WordPress container.

## 3. Before You Start

1. Start the Ubuntu VM in VirtualBox and sign in.
2. Make sure the VM can access the internet.
3. Open a terminal.
4. Go to the project folder:

   ```bash
   cd ~/ccm101-mission10
   ```

5. Protect your passwords. Do not share them in screenshots or upload real passwords to a public GitHub repository. Passwords used during setup appeared in troubleshooting screenshots, so replace them with new, unique passwords before treating the project as secure.

## 4. Start, Stop, and Check the Application

### Check Whether the Containers Are Running

```bash
cd ~/ccm101-mission10
sudo docker compose ps
```

Expected result: Both `ccm101-wordpress` and `ccm101-mariadb` should show a status such as `Up` or `running`.

### Start the Stack

```bash
cd ~/ccm101-mission10
sudo docker compose up -d
```

The `-d` option runs the containers in the background.

### Stop the Stack

```bash
cd ~/ccm101-mission10
sudo docker compose down
```

This command stops and removes the containers. It normally keeps the named volumes and the data stored in them.

**Warning:** Do not add `-v` unless you intentionally want to remove the persistent volumes and their data.

### Restart the Stack

```bash
cd ~/ccm101-mission10
sudo docker compose restart
```

### View Logs

View the recent logs from all containers:

```bash
sudo docker compose logs --tail=100
```

View WordPress logs:

```bash
sudo docker compose logs --tail=100 wordpress
```

View MariaDB logs:

```bash
sudo docker compose logs --tail=100 mariadb
```

These commands show recent messages from the containers. Logs can help you find errors.

To open the website, visit `http://127.0.0.1:8080` in the Windows browser. If it does not open, check the container status first. Then check VirtualBox NAT port forwarding and the UFW firewall.

## 5. WordPress Administration

Open the WordPress administration page:

**URL:** `http://127.0.0.1:8080/wp-admin/`

Sign in with the administrator username and password you created during the first WordPress setup. These login details should be different from your MariaDB credentials.

From the WordPress dashboard, you can:

- Create and edit pages and posts.
- Change the website theme.
- Add and manage users.

Use a strong administrator password. Install themes and plugins only from sources you trust, and keep them updated when needed.

## 6. Security and Firewall

UFW is the Ubuntu firewall. In this project, it blocks incoming connections by default and allows outgoing connections by default.

The project allows these ports:

- **TCP 8080:** Lets the Windows browser access the website.
- **TCP 22:** Used for SSH remote administration, if needed.

MariaDB uses port 3306. Keep this port inside the Docker network. Do not expose it directly to the Windows host or the public internet.

### Check Firewall Status

```bash
sudo ufw status verbose
```

### Review Current Rules

```bash
sudo ufw status numbered
```

### Set Up the Firewall Rules Again, If Necessary

Allow SSH before enabling the firewall if you use SSH. Otherwise, you could lose your remote connection.

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
sudo ufw status verbose
```

Only allow port 22 if you need SSH. If you do not need SSH, remove that rule only after confirming that you will not lock yourself out.

Port 8080 is allowed for this lab so your Windows browser can reach WordPress. Do not publish MariaDB port 3306.

## 7. Keep Data Safe with Docker Volumes

The Docker Compose setup uses two named volumes:

- `mariadb_data` stores the MariaDB database files.
- `wordpress_data` stores WordPress files.

These volumes normally remain available after a container restart or a standard `docker compose down`.

### View Docker Volumes

```bash
sudo docker volume ls
```

### Inspect the MariaDB Volume

```bash
sudo docker volume inspect ccm101-mission10_mariadb_data
```

### Inspect the WordPress Volume

```bash
sudo docker volume inspect ccm101-mission10_wordpress_data
```

The actual volume names may include a prefix based on the Compose project name. Check the names shown by `docker volume ls` and use those exact names.

**Remember:** A volume is not a backup. Keep separate backup files and check that they were created successfully.

## 8. Create Backups

The Bash backup script saves the MariaDB database as an SQL file. It also compresses the WordPress files into a `.tar.gz` archive. The files are saved in the project's backups folder.

### Run the Backup Script Manually

```bash
cd ~/ccm101-mission10
./scripts/automation-script.sh
```

If the script asks for your sudo password, enter your Ubuntu account password and press Enter. Linux will not display characters while you type; this is normal.

After the script finishes, look for a message saying that the backup is complete. If the command seems to take too long, check whether it is waiting for your password or showing an error.

### Check the Backup Files

```bash
ls -lh ~/ccm101-mission10/backups
```

A successful backup should create both:

- A file named similar to `database_*.sql`
- A file named similar to `wordpress_*.tar.gz`

Both files should have a size greater than zero. If a database backup is empty or an error appears, check the script and container logs before relying on the backup.

### Make Sure the Script Is Executable

```bash
chmod +x ~/ccm101-mission10/scripts/automation-script.sh
ls -l ~/ccm101-mission10/scripts/automation-script.sh
```

**Important:** Keep another copy of your backups outside the VM, such as on a secure external drive or in private storage. If the VM's disk is lost, backups stored only inside that VM may be lost too.

## 9. Schedule Automatic Backups with Cron

Cron can run the backup script automatically. This lab uses an example schedule of 2:00 AM every day. The scheduled command uses the full script path and saves output to a log file.

### Cron Schedule

```cron
0 2 * * * /home/ubuntu/ccm101-mission10/scripts/automation-script.sh >> /home/ubuntu/ccm101-mission10/backups/cron.log 2>&1
```

This schedule runs the script every day at 2:00 AM according to the VM's local time zone.

### Edit Your Personal Schedule

```bash
crontab -e
```

Add the cron line on its own line, then save and exit.

### Check the Saved Schedule

```bash
crontab -l
```

### Check the Cron Service

```bash
systemctl status cron --no-pager
```

The Cron service should show `active (running)`.

The schedule follows the VM's local time zone. If the backup runs at an unexpected time, check the VM clock and time zone with:

```bash
timedatectl
```

**Important:** The script uses Docker commands with `sudo`. An automatic job may fail if it needs a password or other input. Test the schedule and check the log.

A more reliable setup is to use an account with the required Docker access without interactive sudo, or to configure a carefully restricted system-level scheduled task.

## 10. Troubleshooting

| Problem | What to Check |
|---|---|
| Website does not open | Run `sudo docker compose ps`. Check VirtualBox NAT forwarding from host address `127.0.0.1:8080` to VM port 8080. Check `sudo ufw status verbose`. |
| WordPress shows a database connection error | Run `sudo docker compose logs --tail=100 mariadb`. Check that the database name, username, and password in WordPress match the MariaDB settings. |
| A container is not running | Run `sudo docker compose ps` and `sudo docker compose logs --tail=100`. |
| The backup script seems stuck | Check whether it is asking for a sudo password. Password characters are hidden while typing. Press `Ctrl+C` only if you need to stop it, then run it again and review the output. |
| No backup files appear | Check the script path, execute permission, project folder, and logs. Run the script manually to see any errors. |
| Cron does not create a backup | Check `crontab -l`, `systemctl status cron --no-pager`, the Cron log, and the full script path. |
| Changes disappear after a container is recreated | Check that the named volumes are attached in `docker-compose.yml`. Do not run `docker compose down -v` unless you intend to delete the volumes. |

### Useful Troubleshooting Commands

```bash
cd ~/ccm101-mission10
sudo docker compose ps
sudo docker compose logs --tail=100
sudo ufw status verbose
ls -lh backups
crontab -l
```

## 11. Backup Recovery Notes

Before restoring data, stop and protect the current application data. Keep another copy of the backup file so you do not overwrite your only backup.

The restore process depends on whether you need to restore the database or both the database and WordPress files.

### Database Recovery

To restore the database:

1. Find the correct SQL backup file.
2. Copy it to a safe location.
3. Confirm that the MariaDB container is running.
4. Import the SQL file into the intended database using the MariaDB client inside the container.
5. Verify that the database has been restored correctly.

The exact command depends on the database name, username, and password in your Compose file. Never show passwords in public screenshots or upload them to GitHub.

### WordPress File Recovery

To restore WordPress files:

1. Stop WordPress before extracting the archive into the correct data location.
2. Check the archive contents.
3. Ensure that file ownership and permissions are appropriate.
4. Make a separate copy of the current volumes before replacing existing data.
5. Verify that the website works after restoration.

Since an incorrect restore can overwrite current website data, ask the project administrator or instructor to verify the target path if necessary.

For the lab defense, demonstrate that backups have been created and explain how you would protect and restore them. Do not claim that disaster recovery has been fully tested until you have performed a restore and verified that it works.

## 12. Maintenance Checklist

Use this checklist during regular maintenance.

- [ ] Check container status using `docker compose ps`.
- [ ] Review recent WordPress and MariaDB logs.
- [ ] Check UFW rules and confirm MariaDB is not publicly exposed.
- [ ] Confirm the latest database and WordPress backup files exist and are not empty.
- [ ] Review the Cron schedule and log.
- [ ] Carefully update Ubuntu, Docker images, WordPress, themes, and plugins.
- [ ] Keep a secure copy of backups outside the virtual machine.
- [ ] Never upload passwords, `.env` files, or private backups to GitHub.

## 13. Project Files and GitHub

The Mission 10 repository should include the README, architecture diagram, Docker Compose file, automation script, operational manual, and final reflection. Use the filenames required by your instructor to keep the project organized and consistent.

### Recommended Repository Files

```text
CCM101-wlicay/
├── README.md
├── architecture-diagram.png
├── docker-compose.yml
├── automation-script.sh
├── operational-manual.md
└── final-reflection.md
```

Before uploading files to GitHub, check for passwords, private keys, personal information, and backup archives. Remove sensitive information to protect your system and data.

For a public repository, use placeholder values or environment variables for secrets in the Compose file. Never upload backups containing real website or user data.

The recommended files are:

- `README.md`
- `architecture-diagram.png`
- `docker-compose.yml`
- `automation-script.sh`
- `operational-manual.md`
- `final-reflection.md`

## 14. Final Notes

This project is for a student lab. It is not ready to be used as a public production service.

Before making it available on the internet:

- Set up HTTPS.
- Manage passwords and other secrets more safely.
- Limit administrator access.
- Keep backups outside the VM.
- Test the restore process.
- Follow a regular update plan.

Always check the final settings on the actual VM before claiming that the system is secure or working correctly.
