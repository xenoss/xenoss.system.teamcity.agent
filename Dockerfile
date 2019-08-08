FROM jetbrains/teamcity-agent:2019.1.2-linux

# https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/11/jdk/ubuntu/Dockerfile.hotspot.releases.full
RUN apt update && \
    apt-get install -y ffmpeg gnupg2 && \
    curl -Lso /tmp/openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.2%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.2_7.tar.gz && \
    cd /tmp && \
    tar -xf /tmp/openjdk.tar.gz && \
    rm /tmp/openjdk.tar.gz && \
    mkdir -p /usr/lib/jvm/jdk-11 && \
    mv jdk-11*/* /usr/lib/jvm/jdk-11/ && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-11/bin/java" 1020 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-11/bin/javac" 1020

# install helm
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo deb https://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update

RUN apt-get install -y kubectl
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
RUN chmod u+x install-helm.sh
RUN ./install-helm.sh

RUN apt-get update && apt-get install -y git sudo
RUN curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
RUN apt-get install -y nodejs
# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help


ENV JAVA_TOOL_OPTIONS ""
