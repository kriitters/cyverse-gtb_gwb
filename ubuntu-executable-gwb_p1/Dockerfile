FROM ubuntu:23.10
USER root

# Add sudo to user ubuntu; this is needed to run a chown on a dynamic volume mount in entry.sh
RUN apt-get update && \
    apt-get install -y sudo && \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN  apt-get update \
    &&  apt-get install apt-utils dialog -y \
	# for fake x server in GWB
	&& apt-get install libxinerama1 -y \
	# gettext-base is needed for command envsubst in entry.sh
	&& apt-get install gettext-base  -y \
    && apt-get install wget -y \
	&& apt-get autoremove -y \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# getting locales error; this seems to be needed to install GWB
RUN apt-get clean && apt-get update && apt-get install locales && locale-gen en_US.UTF-8
ENV TZ=America/Phoenix
ENV LANG=C.UTF-8 
ENV LC_ALL="en_US.UTF-8"
RUN ln -s /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone
#
# Install GWB
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install  /tmp/gwb_amd64.deb -y
RUN rm -f /tmp/gwb_amd64.deb
RUN rm -fr /home/ubuntu/input /home/ubuntu/output
# GWB handle the EULA
RUN mkdir /home/ubuntu/.gwb
RUN chown ubuntu:ubuntu  /home/ubuntu/.gwb
RUN touch /home/ubuntu/.gwb/EULA.txt
#
ENTRYPOINT ["/bin/bash"]










