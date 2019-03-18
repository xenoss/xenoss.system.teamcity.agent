FROM jetbrains/teamcity-agent:2018.2.3-linux

# https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/11/jdk/ubuntu/Dockerfile.hotspot.releases.full
RUN apt update && \
    apt-get install -y ffmpeg && \
    curl -Lso /tmp/openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.2%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.2_7.tar.gz && \
    cd /tmp && \
    tar -xf /tmp/openjdk.tar.gz && \
    rm /tmp/openjdk.tar.gz && \
    mkdir -p /usr/lib/jvm/jdk-11 && \
    mv jdk-11*/* /usr/lib/jvm/jdk-11/ && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-11/bin/java" 1020 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-11/bin/javac" 1020 && \
    rm -rf /var/lib/apt/lists/*
