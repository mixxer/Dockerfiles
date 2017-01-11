FROM ubuntu:14.04.5
MAINTAINER Seungjae Lee <sj83.lee@lge.com>

ENV user sj

USER root
WORKDIR /root

RUN ln -s -f /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN sed -e 's/http:\/\/archive\.ubuntu\.com\//http:\/\/kr\.archive\.ubuntu\.com\//g' -i /etc/apt/sources.list
RUN locale-gen "en_US" "en_US.UTF-8"
RUN dpkg-reconfigure --frontend noninteractive locales
RUN echo "debconf debconf/frontend select noninteractive" | debconf-set-selections
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y apt-utils software-properties-common
RUN add-apt-repository multiverse
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install openssh-server
RUN apt-get -y install sudo bash git
RUN echo "debconf debconf/frontend select dialog" | debconf-set-selections

RUN mkdir /var/run/sshd
# RUN echo 'root:screencast' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN adduser --disabled-password --gecos '' --shell /bin/bash ${user}
RUN echo "${user}:trusty" | chpasswd
RUN adduser ${user} sudo
RUN sed -i.bkp -e \
		's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
		/etc/sudoers

USER ${user}
WORKDIR /home/${user}

COPY ubuntu-trusty-docker-setup.sh /home/${user}/
RUN sudo chown ${user}:${user} /home/${user}/ubuntu-trusty-docker-setup.sh
RUN chmod a+x /home/${user}/ubuntu-trusty-docker-setup.sh
RUN bash -c "ls -al /home/${user}/ubuntu-trusty-docker-setup.sh"
RUN bash -c "sudo /home/${user}/ubuntu-trusty-docker-setup.sh"
RUN rm -f /home/${user}/ubuntu-trusty-docker-setup.sh

RUN bash -c "echo \"debconf debconf/frontend select noninteractive\" | sudo debconf-set-selections"
RUN bash -c "sudo apt-get -y autoclean"
RUN bash -c "sudo apt-get -y purge \$( dpkg --get-selections | grep deinstall | cut -f1 )"
RUN bash -c "echo \"debconf debconf/frontend select dialog\" | sudo debconf-set-selections"

RUN sudo bash -c "rm -r -f /home/${user}/tmp/"

USER root
WORKDIR /root

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
