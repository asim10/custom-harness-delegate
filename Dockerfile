FROM us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:26.01.88201

USER root

RUN microdnf update -y && \
    microdnf install --nodocs unzip yum-utils python3.9 python3-pip wget jq sshpass openldap-clients -y && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    microdnf install -y terraform && \
    mkdir -p /opt/harness-delegate/tools && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && \
    rm -rf awscliv2.zip aws && \
    python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip install \
        jmespath lxml cryptography ansible pywinrm hvac beautifulsoup4 \
        google-auth google-api-python-client && \
    microdnf clean all && rm -rf /var/cache/dnf /var/cache/yum

ENV PATH=/opt/harness-delegate/tools/:$PATH
