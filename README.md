# dotnet10-devops

Deploying .NET 10 Microservices into Kubernetes, and moving deployments to the cloud Azure Kubernetes Services (AKS) with using Azure Container Registry (ACR) and how to Automating Deployments with Azure DevOps and GitHub.

[![Build Status](https://dev.azure.com/sweenil/shopping/_apis/build/status/shoppingclient-pipeline?branchName=main)](https://dev.azure.com/sweenil/shopping/_build/latest?definitionId=4&branchName=main)

[![Build Status](https://dev.azure.com/sweenil/shopping/_apis/build/status/shoppingapi-pipeline?branchName=main)](https://dev.azure.com/sweenil/shopping/_build/latest?definitionId=3&branchName=main)

## Running the services locally with Kubernetes

If you're running the sample on a local Kubernetes cluster (Docker Desktop, Minikube, kind, etc.) there are two reliable ways to reach the web apps from your host:

- Preferred (cross-platform, keep services healthy): configure the apps to listen on port 80 inside the container and use the NodePort exposed by the Service. This repository's manifests already set `ASPNETCORE_URLS=http://+:80` in the deployments and services target port `80`.

- Reliable fallback (works on all OS): use `kubectl port-forward` to forward pod ports to localhost. This is the simplest option that never depends on Docker Desktop/WSL networking.

Examples (run these in separate terminals and keep them open):

```powershell
# API
kubectl port-forward deployment/shoppingapi-deployment 31000:80

# Client
kubectl port-forward deployment/shoppingclient-deployment 30000:80
```

After the port-forwards are running you can open in your browser:

- API Swagger: http://localhost:31000/swagger/index.html
- Client: http://localhost:30000/

Notes and recommendations

- If your environment supports NodePort routing from the host, you can access the services using the NodePort (defaults in this repo):
  - API NodePort: http://<node-ip>:31000
  - Client NodePort: http://<node-ip>:30000
- On Docker Desktop / WSL the NodePort may not be reachable from your OS; `kubectl port-forward` is a cross-OS fallback.
- To run persistent port-forwards in background, use a terminal multiplexer (tmux/screen), systemd user service (Linux), `launchd` agent (macOS), or a Windows scheduled task/PowerShell background job.

## Persistent port-forward scripts (optional)

This repo includes helper scripts to run the two port-forwards as background/persistent services on each OS. Files added under `scripts/`:

- `scripts/portforward-windows.ps1` — PowerShell script to start two background jobs. Intended to be run at logon via a Scheduled Task.
- `scripts/portforward-macos.sh` — Bash script that restarts port-forwards automatically. Install with `launchd` using the provided plist template `scripts/com.example.k8s.portforward.plist` (replace **REPO_PATH**).
- `scripts/portforward-linux.sh` — Bash script that restarts port-forwards automatically. Install as a systemd user service using `scripts/systemd-user-k8s-portforward.service` (replace **REPO_PATH**).

Installation notes (one-time, automated)

Windows (recommended: Scheduled Task)

1. From a PowerShell prompt (run as your regular user), run the installer to register a Scheduled Task:

```powershell
.
scripts\install-windows-task.ps1
```

macOS (launchd)

1. Run the provided installer script — it replaces paths and loads the `launchd` agent automatically:

```bash
bash scripts/install-macos-launchd.sh
```

Linux (systemd user)

1. Run the systemd user installer — it replaces paths and enables/starts the user service:

```bash
bash scripts/install-systemd-user.sh
```

Notes

- The installers automatically detect the repository path, create a `logs/` folder in the repo, and install/start the service for your user.
- Ensure `kubectl` is on `PATH` and your kubecontext is configured before enabling the services.
- To uninstall, remove the installed service/plist or the Scheduled Task; the installer only sets up the service and does not attempt to remove previous versions.

Security & notes

- These scripts assume `kubectl` is on `PATH` and that the current kubecontext is configured.
- Running port-forwards as background services gives persistent local access but be sure you understand the security implications (access to cluster services from your host).
- If you prefer, I can install/enable these for you on a specific OS — tell me which one.
