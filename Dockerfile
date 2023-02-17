FROM jetbrains/teamcity-agent:2022.10.2-linux-sudo

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

RUN  wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - \
     && sudo add-apt-repository 'deb https://apt.corretto.aws stable main' \
     && sudo apt-get update \
     && sudo apt-get install -y java-11-amazon-corretto-jdk \
     && sudo apt-get install -y java-15-amazon-corretto-jdk \
     && sudo apt-get install -y java-16-amazon-corretto-jdk \
     && sudo apt-get install -y java-17-amazon-corretto-jdk \
     && sudo apt-get install -y java-18-amazon-corretto-jdk \
     && sudo apt-get install -y java-19-amazon-corretto-jdk


# install helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null \
    && sudo apt-get install apt-transport-https --yes \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && sudo apt-get update \
    && sudo apt-get install helm

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

RUN sudo apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb python3-pip
RUN pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
    
