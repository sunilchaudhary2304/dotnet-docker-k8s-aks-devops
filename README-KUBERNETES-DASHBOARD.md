# Kubernetes Dashboard Setup Guide

This guide explains how to set up and access the Kubernetes Dashboard.

## Prerequisites

- Docker Desktop with Kubernetes enabled, OR
- Minikube, OR
- AKS cluster with kubectl configured

## Step 1: Install Kubernetes Dashboard

Apply the official Dashboard manifest:

```powershell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

## Step 2: Create a Service Account

Create a service account for dashboard access:

```powershell
kubectl create serviceaccount dashboard-admin -n kubernetes-dashboard
```

## Step 3: Grant Cluster Admin Permissions

Bind the service account to the cluster-admin role:

```powershell
kubectl create clusterrolebinding dashboard-admin-binding --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin
```

## Step 4: Generate Token

Generate a token for authentication:

```powershell
kubectl create token dashboard-admin -n kubernetes-dashboard
```

Copy the generated token - you will need it to log in to the Dashboard.

> **Note:** Tokens are valid for a limited time. If your token expires, simply run the command above again to generate a new one.

## Step 5: Start kubectl Proxy

Start the kubectl proxy to access the Dashboard:

```powershell
kubectl proxy --port=8002
```

> **Note:** Use port 8002 (or any available port) if port 8001 is already in use by another application.

## Step 6: Access the Dashboard

Open your browser and navigate to:

```
http://localhost:8002/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

## Step 7: Login

1. When prompted, select **"Token"** option
2. Paste the token generated in Step 4
3. Click **"Sign In"**

You now have full access to the Kubernetes Dashboard.

## Quick Reference

| Command | Description |
|---------|-------------|
| `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml` | Install Dashboard |
| `kubectl create serviceaccount dashboard-admin -n kubernetes-dashboard` | Create service account |
| `kubectl create clusterrolebinding dashboard-admin-binding --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin` | Grant admin access |
| `kubectl create token dashboard-admin -n kubernetes-dashboard` | Generate login token |
| `kubectl proxy --port=8002` | Start proxy |
| `kubectl get pods -n kubernetes-dashboard` | Check Dashboard pods |
| `kubectl get svc -n kubernetes-dashboard` | Check Dashboard services |

## Troubleshooting

### Port already in use

If you get `bind: Only one usage of each socket address` error, use a different port:

```powershell
kubectl proxy --port=8003
```

### Token expired

Generate a new token:

```powershell
kubectl create token dashboard-admin -n kubernetes-dashboard
```

### Dashboard not running

Check Dashboard status:

```powershell
kubectl get pods -n kubernetes-dashboard
```

If pods are not running, check their logs:

```powershell
kubectl logs -n kubernetes-dashboard -l app.kubernetes.io/name=kubernetes-dashboard
```