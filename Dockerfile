FROM linkyard/concourse-helm-resource:2.8.2

ENV PATH=$PATH:/opt/google-cloud-sdk/bin
ENV GCLOUD_SDK_VERSION=234.0.0
ENV GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz

# Add helm-gcs pluginf
RUN helm init --client-only && \
    helm plugin install https://github.com/viglesiasce/helm-gcs.git --version v0.2.0

# Install gcloud
RUN apk update && apk add curl openssl python \
 && mkdir -p /opt && cd /opt \
 && wget -q -O - $GCLOUD_SDK_URL |tar zxf - \
 && /bin/bash -l -c "echo Y | /opt/google-cloud-sdk/install.sh && exit"

ADD assets /opt/resource
RUN chmod +x /opt/resource/*
