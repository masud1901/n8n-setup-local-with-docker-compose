# n8n Docker Compose Setup

This repository contains the Docker Compose configuration for running n8n, the workflow automation platform.

## Getting Started

1. **Prerequisites:**
- Make sure you have Docker and Docker Compose installed on your system.

2. **Clone the Repository:**
```bash
git clone https://github.com/your-username/n8n-docker-compose.git
cd n8n-docker-compose
```
(Replace `https://github.com/your-username/n8n-docker-compose.git` with the actual URL of your repository)

3. **Configure Environment Variables:**
- Copy the `.env.example` file to `.env`:
```bash
cp .env.example .env
```
- **Important:** Open the `.env` file and fill in the **actual values** for any environment variables you need to configure (e.g., n8n basic auth credentials, webhook URL, etc.). **Do NOT commit your `.env` file to GitHub if it contains sensitive information!**

4. **Start n8n:**
```bash
docker compose -f docker-compose.yml up -d
```
This will start the n8n container in detached mode (in the background).

5. **Access n8n:**
- Open your web browser and go to [http://localhost:5678](http://localhost:5678) (or the hostname/IP and port you configured in your `.env` file if you changed them).

## Updating n8n

To update n8n to the latest version, run the update script:

```bash
./update-n8n-compose.sh
```
This script will:
- Check if the `n8n_data` volume exists (for data persistence).
- Stop and remove the existing n8n container.
- Pull the latest n8n Docker image.
- Start a new n8n container with the latest image, using the existing `n8n_data` volume to preserve your data.

## Data Persistence

This setup uses a Docker named volume called `n8n_data` to store n8n's persistent data (workflows, credentials, etc.). This volume is defined in `docker-compose.yml` and is mounted to `/home/node/.n8n` inside the n8n container. **Your n8n data will be preserved across container updates and restarts.**

## Custom Configuration

If you need to provide custom configuration files to n8n, you can:

1. Create a `config` directory in the root of this repository.
2. Place your custom configuration files (e.g., `n8n-config.json`) inside the `config` directory.
3. The `docker-compose.yml` file is configured to mount the `config` directory to `/config` inside the container. You can then reference these files using environment variables like `N8N_CONFIG_FILES: /config/n8n-config.json`.

## Important Notes

- **Security:** Be very careful about storing sensitive information in your `.env` file. For production environments, consider using more robust secret management solutions.
- **Backups:** This setup provides data persistence, but it is still **essential to implement a regular backup strategy for your `n8n_data` volume** to protect against data loss due to hardware failures or other unforeseen issues.
