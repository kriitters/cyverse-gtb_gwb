#FROM ubuntu:23.10
# change to 22.04 to get irods; 24.x doesn't support some other things so go backwards
FROM ubuntu:22.04
USER root

RUN adduser ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu
	
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

# Test July 22. install irods. From cyverse ubuntu example at https://github.com/CyVerse-learning-materials/container-camp/blob/mkdocs/examples/ubuntu/Dockerfile
# not copied, these are already installed: wget
#  Note: the json is copied to /home/ubuntu/.irods/ in entry.sh
RUN apt-get update -y && apt-get install -y gnupg python3 python3-distro && \
    wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/renci-irods.list && \
    apt-get update && apt-get install irods-icommands -y

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
#
ENTRYPOINT ["/bin/bash"]










