# custom-harness-delegate

![CI](https://github.com/asim10/custom-harness-delegate/workflows/CI/badge.svg)
![version](https://img.shields.io/docker/v/asimd10/custom-harness-delegate?sort=semver)
[![Docker Pulls](https://img.shields.io/docker/pulls/asimd10/custom-harness-delegate)](https://hub.docker.com/r/asimd10/custom-harness-delegate/)
![Docker Image Size](https://img.shields.io/docker/image-size/asimd10/custom-harness-delegate/latest)
![Docker Stars](https://img.shields.io/docker/stars/asimd10/custom-harness-delegate)
[![Security Scan Report](https://img.shields.io/badge/Security-Trivy_Scan_Report-blue)](https://github.com/asim10/custom-harness-delegate/security/code-scanning?query=is%3Aopen+branch%3Amain+tool%3ATrivy)

# Custom Harness Delegate with Cloud Tooling

This repository contains a custom Dockerfile that extends the official Harness Delegate image. It is pre-configured with essential CLI tools and Python libraries to support advanced orchestration, cloud management, and infrastructure-as-code (IaC) tasks.

# 🚀 Included Features
This image builds upon `harness/delegate:26.01.88201` and adds:

* Cloud CLIs: AWS CLI (v2) and Terraform.

* Kubernetes: `kubectl` (latest stable).

* Automation: `Ansible`, `Python 3.9`, and `sshpass`.

Dev Tools: `jq`, `wget`, `gcc`, and `LDAP client libraries`.

Python Libraries: * `google-auth` & `google-api-python-client` (GCP support)

* `pywinrm` (Windows management)

* `hvac` (HashiCorp Vault)

* `python-ldap`, `cryptography`, `beautifulsoup4`, and more.

# 🛠️ Build Instructions

To build this custom delegate locally, run the following command in the directory containing the `Dockerfile`:

```docker build -t your-registry/harness-delegate-custom:latest .```
# 🐳 Usage
**Kubernetes Deployment**

Update your Delegate `Deployment.yaml` to point to your new custom image:

```YAML
spec:
  template:
    spec:
      containers:
      - name: delegate
        image: your-registry/harness-delegate-custom:latest

```
**Environment Configuration**

The image includes a custom path for specialized tools:

**PATH:** Includes `/opt/harness-delegate/tools/`

**User:** Runs as `root` to facilitate tool installation (standard for many specialized delegate tasks).

# 🛡️ Security & Maintenance
* **Base Image:** `us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:26.01.88201`

* **Cleanup:** The build process includes `microdnf clean all` and removes temporary installer files to minimize the image footprint and reduce the attack surface.

Updates: It is recommended to rebuild this image periodically to pull the latest security patches provided by `microdnf update`.