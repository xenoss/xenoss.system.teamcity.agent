FROM jetbrains/teamcity-agent:2019.1.2-linux

# https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/12/jdk/ubuntu/Dockerfile.hotspot.releases.full
RUN apt-get update && \
    apt-get install -y ffmpeg gnupg2 && \
    curl -Lso /tmp/openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-12.0.2%2B10/OpenJDK12U-jdk_x64_linux_hotspot_12.0.2_10.tar.gz && \
    cd /tmp && \
    tar -xf /tmp/openjdk.tar.gz && \
    rm /tmp/openjdk.tar.gz && \
    mkdir -p /usr/lib/jvm/jdk-12 && \
    mv jdk-11*/* /usr/lib/jvm/jdk-12/ && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-11/bin/java" 1020 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-11/bin/javac" 1020

# install helm
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo deb https://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list

RUN apt-get install -y kubectl && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh && \
    chmod u+x install-helm.sh && \
    ./install-helm.sh

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN apt-get install -y git sudo && \
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    dotnet help


ENV JAVA_TOOL_OPTIONS ""
