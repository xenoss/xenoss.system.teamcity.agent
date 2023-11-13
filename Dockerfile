FROM jetbrains/teamcity-agent:2023.05.4-linux

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

RUN curl -sL https://deb.nodesource.com/setup_16.x | -E bash -

RUN apt-get update && \
    apt-get install -y ffmpeg gnupg2 git kubectl \
    binfmt-support qemu-user-static mc jq

#RUN wget -O - https://apt.kitware.com/keys/kitware-archive-la3est.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
#RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
#    apt-get update && \
RUN apt install -y cmake build-essential wget

RUN  wget -O- https://apt.corretto.aws/corretto.key | apt-key add - \
     && add-apt-repository 'deb https://apt.corretto.aws stable main' \
     && apt-get update \
     && apt-get install -y java-11-amazon-corretto-jdk \
     && apt-get install -y java-15-amazon-corretto-jdk \
     && apt-get install -y java-16-amazon-corretto-jdk \
     && apt-get install -y java-17-amazon-corretto-jdk \
     && apt-get install -y java-18-amazon-corretto-jdk \
     && apt-get install -y java-19-amazon-corretto-jdk \
     && apt-get install -y java-21-amazon-corretto-jdk


# install helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null \
    && apt-get install apt-transport-https --yes \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install helm

RUN helm plugin install https://github.com/chartmuseum/helm-push

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help

ENV JAVA_TOOL_OPTIONS ""

RUN curl -Ls https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -

RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN apt-get update && apt-get install -y mongodb-org-shell

RUN wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb [trusted=yes] http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main"
RUN apt-get remove llvm-6.0
RUN apt-get install -y llvm-11 clang-11 lld-11 ninja-build gcc-multilib

# FPM
RUN apt-get install -y ruby-dev build-essential && gem i fpm -f

# Cypress
COPY keyboard /etc/default/

RUN apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb python3-pip
RUN pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
    
