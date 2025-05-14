Building a writable Singularity sandbox with Ubuntu 22.04

### 🛠️ Building the Singularity Sandbox

```bash
singularity build --sandbox ubuntu2204/ docker://ubuntu:22.04 && \
singularity shell --writable ubuntu2204/
singularity build ubuntu2204.sif ubuntu2204/
```

They perform the following steps:

1. **Builds a writable Singularity sandbox** named `ubuntu2204/` using the Ubuntu 22.04 base image.
2. **Enters the sandbox** in writable mode, allowing you to make changes within it.
3. The last command creates a `.sif` file from your sandbox, preserving all the changes you've made.

Preparations in locale are necessary, e.g., settings in .bashrc/.profile to be sourced,

```bash
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
```

They can be examined with `locale`.

The following steps are to install and run Docker within Singularity sandbox for setting up RAGFlow:

### 🧱 Step 1: Install Docker Inside the Singularity Sandbox

First, ensure that your Singularity container has network access and the necessary privileges to install packages. Then, inside the sandbox, execute the following commands:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

This installs Docker and Docker Compose within the sandbox.([DEV Community][1])

### ⚙️ Step 2: Configure Docker to Run Without Sudo

To allow non-root users to run Docker commands, add your user to the `docker` group:([phoenixNAP | Global IT Services][2])

```bash
usermod -aG docker $USER
newgrp docker
```

This step enables you to run Docker commands without prefacing them with `sudo`.([phoenixNAP | Global IT Services][2])

### 🚀 Step 3: Start Docker Daemon Inside the Sandbox

Start the Docker service within the sandbox:

```bash
dockerd &
```

This command runs the Docker daemon in the background.

### 🧩 Step 4: Set Up RAGFlow Using Docker Compose

Clone the RAGFlow repository and navigate to the `docker` directory:

```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow/docker
```

Configure the desired RAGFlow image version in the `.env` file:

```bash
nano .env
```

Set the `RAGFLOW_IMAGE` variable to your preferred version, for example:

```bash
RAGFLOW_IMAGE=infiniflow/ragflow:v0.18.0
```

Start the RAGFlow services using Docker Compose:([RAGFlow][3])

```bash
docker compose -f docker-compose.yml up -d
```

This command launches the RAGFlow services in detached mode.

### 🌐 Step 5: Access RAGFlow

Once the services are running, access RAGFlow by navigating to `http://127.0.0.1` or your server's IP address in a web browser. The default port is 80, so the full URL would be `http://127.0.0.1` or `http://<your-server-ip>`.

---

[1]: https://dev.to/ersinkoc/how-to-install-docker-on-ubuntu-2204-and-elevate-your-development-workflow-3346?utm_source=chatgpt.com "How to Install Docker on Ubuntu 22.04 and Elevate Your Development Workflow - DEV Community"
[2]: https://phoenixnap.com/kb/install-docker-ubuntu?utm_source=chatgpt.com "How to Install Docker on Ubuntu 22.04 and 24.04"
[3]: https://ragflow.io/docs/dev/build_docker_image?utm_source=chatgpt.com "Build RAGFlow Docker image | RAGFlow"
