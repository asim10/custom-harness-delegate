FROM us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:26.10.90200

USER root

# Update and install build dependencies only
RUN microdnf update -y && \
    microdnf install --nodocs python3.9 python3-pip gcc python3-devel openldap-devel cyrus-sasl-devel -y && \
    microdnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/* /var/tmp/*

# Build Python wheels in builder stage
RUN python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip wheel --no-cache-dir --wheel-dir /wheels \
        jmespath==1.0.1 \
        lxml==4.9.3 \
        cryptography==41.0.7 \
        ansible==8.7.0 \
        pywinrm==0.4.3 \
        hvac==1.2.1 \
        beautifulsoup4==4.12.2 \
        python-ldap==3.4.4 \
        google-auth==2.25.2 \
        google-api-python-client==2.107.0

# Final stage - minimal runtime
FROM us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:26.10.90200

USER root

# Install only runtime dependencies (no build tools)
RUN microdnf update -y && \
    microdnf install --nodocs unzip yum-utils python3.9 python3-pip wget jq rsync sshpass openldap-clients -y && \
    microdnf clean all && rm -rf /var/cache/dnf /var/cache/yum /tmp/* /var/tmp/*

# Install yq
RUN curl -o /usr/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" && \
    chmod +x /usr/bin/yq

# Install Terraform
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    microdnf install --nodocs -y terraform && \
    microdnf clean all && rm -rf /var/cache/dnf /var/cache/yum


# Install Kubectl
RUN mkdir -p /opt/harness-delegate/tools && cd /opt/harness-delegate/tools && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

# Copy pre-built wheels from builder and install
COPY --from=builder /wheels /wheels
RUN python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip install --no-cache-dir --no-index --find-links /wheels \
        jmespath \
        lxml \
        cryptography \
        ansible \
        pywinrm \
        hvac \
        beautifulsoup4 \
        python-ldap \
        google-auth \
        google-api-python-client && \
    rm -rf /wheels

# Final cleanup
RUN microdnf clean all && \
    rm -rf /var/cache/dnf /var/cache/yum /tmp/* /var/tmp/* \
    /usr/share/doc /usr/share/man /usr/lib/.build-id

ENV PATH=/opt/harness-delegate/tools/:$PATH
USER harness
