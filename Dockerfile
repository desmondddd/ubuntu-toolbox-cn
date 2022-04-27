FROM ubuntu:20.04
COPY sources.list /etc/apt/sources.list

ENV USERNAME="desmond"
ENV PASSWORD="admin_secret"

RUN apt update && apt upgrade -y

# sudo USERNAME@PASSWORD
RUN apt install sudo -y
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 $USERNAME
RUN echo "$USERNAME:$PASSWORD" | chpasswd

# openssh
RUN apt install openssh-server -y
RUN service ssh start

# python
RUN apt install python3 python3-pip -y

# azure-commandline
RUN apt install ca-certificates curl apt-transport-https lsb-release gnupg -y
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt update && apt install azure-cli

CMD ["/usr/sbin/sshd","-D"]