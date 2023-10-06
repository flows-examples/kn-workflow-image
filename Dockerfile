FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL maintainer="Flows Examples"
LABEL summary="Provides a container image to work with SonataFlow CLI tooling"
LABEL io.k8s.display-name="SonataFlow CLI Tooling Image"
LABEL io.openshift.expose-services=""
LABEL io.openshift.tags="sonataflow kn workflow kubectl"

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' KN_VERSION='v1.11.0' KN_WORKFLOW_VERSION='0.31.0' KUBERNETES_VERSION='v1.28' YQ_VERSION='v4.35.2'

RUN printf "[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/rpm/\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/rpm/repodata/repomd.xml.key\n" >> /etc/yum.repos.d/kubernetes.repo \
     && microdnf install -y --nodocs shadow-utils kubectl tar gzip \
     && microdnf clean all \
     && rpm -q shadow-utils kubectl tar gzip

COPY --chmod=744 scripts/*.sh /usr/local/bin
RUN ./usr/local/bin/install-kn.sh && \
    ./usr/local/bin/install-yq.sh && \
    rm -rf /usr/local/bin/*.sh

RUN groupadd -r sonataflow -g 1001 && useradd -u 1001 -r -g root -G sonataflow -m -d /home/sonataflow -s /sbin/nologin -c "SonataFlow" sonataflow
USER 1001
WORKDIR /home/sonataflow

ENTRYPOINT [ "kn-workflow" ]
