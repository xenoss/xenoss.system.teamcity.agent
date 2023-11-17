FROM jetbrains/teamcity-agent:2023.05.4-linux-sudo

RUN sudo apt-get update
RUN sudo apt-get install -y apt-transport-https ca-certificates curl
RUN sudo mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN sudo mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && NODE_MAJOR=16 \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list \
    && sudo apt-get update \
    && sudo apt-get install nodejs -y

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
     && sudo apt-get install -y java-19-amazon-corretto-jdk \
     && sudo apt-get install -y java-21-amazon-corretto-jdk


# install helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null \
    && sudo apt-get install apt-transport-https --yes \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && sudo apt-get update \
    && sudo apt-get install helm

RUN sudo helm plugin install https://github.com/chartmuseum/helm-push

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN sudo dotnet help

ENV JAVA_TOOL_OPTIONS ""

RUN curl -Ls https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN sudo apt-get update && sudo apt-get install -y mongodb-org-shell

RUN wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
RUN sudo add-apt-repository "deb [trusted=yes] http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main"
RUN sudo apt-get remove llvm-6.0
RUN sudo apt-get install -y llvm-11 clang-11 lld-11 ninja-build gcc-multilib

# FPM
RUN sudo apt-get install -y ruby-dev build-essential && sudo gem i fpm -f

# Cypress
COPY keyboard /etc/default/

RUN sudo apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb python3-pip
RUN sudo pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib

