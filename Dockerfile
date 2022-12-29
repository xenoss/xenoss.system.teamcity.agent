FROM jetbrains/teamcity-agent:2022.10.1-linux-sudo

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN sudo sh -c 'echo deb https://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list'

RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

# https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/12/jdk/ubuntu/Dockerfile.hotspot.releases.full
RUN sudo apt-get update && \
    sudo apt-get install -y ffmpeg gnupg2 git sudo kubectl \
    binfmt-support qemu-user-static mc jq
    
#RUN wget -O - https://apt.kitware.com/keys/kitware-archive-la3est.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
#RUN sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
#    sudo apt-get update && \
RUN sudo apt install -y cmake build-essential wget

# Update the package manager and install dependencies
RUN apt-get update && apt-get install -y curl tar

# Download the Node.js package and extract it to the desired location
RUN curl -sL https://nodejs.org/dist/v14.7.3/node-v14.7.3-linux-x64.tar.gz | tar -xz -C /opt/node

# Add the node executable to the PATH
RUN echo 'export PATH=$PATH:/opt/node/bin' >> ~/.bashrc

# Test the installation
RUN node -v



RUN  wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - && \
     sudo add-apt-repository 'deb https://apt.corretto.aws stable main' && \
     sudo apt-get update && \
     sudo apt-get install -y java-15-amazon-corretto-jdk && \
     sudo apt-get install -y java-16-amazon-corretto-jdk && \
     sudo apt-get install -y java-17-amazon-corretto-jdk && \
     sudo apt-get install -y java-18-amazon-corretto-jdk

#RUN curl -Lso /tmp/openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15%2B36/OpenJDK15U-jdk_x64_linux_hotspot_15_36.tar.gz && \
#    cd /tmp && \
#    tar -xf /tmp/openjdk.tar.gz && \
#    rm /tmp/openjdk.tar.gz && \
#    sudo mkdir -p /usr/lib/jvm/jdk-15 && \
#    sudo mv jdk-15*/* /usr/lib/jvm/jdk-15/ && \
#    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-15/bin/java" 1040 && \
#    sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-15/bin/javac" 1040
#
#RUN curl -Lso /tmp/openjdk.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.3_7.tar.gz && \
#    cd /tmp && \
#    tar -xf /tmp/openjdk.tar.gz && \
#    rm /tmp/openjdk.tar.gz && \
#    sudo mkdir -p /usr/lib/jvm/jdk-17 && \
#    sudo mv jdk-17*/* /usr/lib/jvm/jdk-17/ && \
#    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-17/bin/java" 1050 && \
#    sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-17/bin/javac" 1050
#
#RUN curl -Lso /tmp/openjdk.tar.gz https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.1%2B10/OpenJDK18U-jdk_x64_linux_hotspot_18.0.1_10.tar.gz && \
#    cd /tmp && \
#    tar -xf /tmp/openjdk.tar.gz && \
#    rm /tmp/openjdk.tar.gz && \
#    sudo mkdir -p /usr/lib/jvm/jdk-18 && \
#    sudo mv jdk-18*/* /usr/lib/jvm/jdk-18/ && \
#    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-18/bin/java" 1060 && \
#    sudo update-alternatives --set java "/usr/lib/jvm/jdk-18/bin/java" && \
#    sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-18/bin/javac" 1060 && \
#    sudo update-alternatives --set javac "/usr/lib/jvm/jdk-18/bin/javac"

# install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > /tmp/install-helm.sh
RUN chmod u+x /tmp/install-helm.sh && \
    sudo /tmp/install-helm.sh && \
    rm -f /tmp/install-helm.sh

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN sudo dotnet help

ENV JAVA_TOOL_OPTIONS ""

RUN curl -Ls https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
	
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN sudo apt-get update && sudo apt-get install -y mongodb-org-shell 

RUN curl -Ls https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - && \
    sudo add-apt-repository "deb [trusted=yes] http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main" && \
    sudo apt-get update && \
    sudo apt-get remove llvm-6.0 && \
    sudo apt-get install -y llvm-11 clang-11 lld-11 ninja-build gcc-multilib

# FPM
RUN sudo apt-get install -y ruby-dev build-essential && sudo gem i fpm -f

# Cypress
COPY keyboard /etc/default/    

RUN sudo apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
    
