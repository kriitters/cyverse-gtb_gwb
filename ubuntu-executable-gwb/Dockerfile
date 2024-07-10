FROM ubuntu:23.10
RUN  apt-get update \
    &&  apt-get install apt-utils dialog -y \
	# for fake x server
	&& apt-get install libxinerama1 -y \
    && apt-get install wget -y \
	&& apt-get autoremove -y \
    && apt-get clean all
# gettext-base is needed for command envsubst in entry.sh
RUN apt-get update && \
	apt-get install gettext-base  -y && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# getting locales error
RUN apt-get clean && apt-get update && apt-get install locales && locale-gen en_US.UTF-8

# 
ENV TZ America/Phoenix
ENV LANG=C.UTF-8 
ENV LC_ALL "en_US.UTF-8"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone
#
# Install GWB
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install  /tmp/gwb_amd64.deb -y
RUN rm -f /tmp/gwb_amd64.deb

# Add sudo to user ubuntu; this is needed to run a chown on a dynamic volume mount in entry.sh
RUN apt-get update && \
    apt-get install -y sudo && \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
   apt-get clean && \
    rm -rf /var/lib/apt/lists/*
	
# adapt to the custom CyVerse user setup
RUN mkdir /home/.gwb
RUN chown ubuntu:ubuntu /home/.gwb
RUN touch /home/.gwb/EULA.txt
RUN chown ubuntu:ubuntu /home/.gwb/EULA.txt

RUN rm -fr /home/ubuntu/input /home/ubuntu/output

COPY entry.sh /bin/entry.sh

# fix up GWB things for user
USER ubuntu
RUN ln -s /home/.gwb /home/ubuntu/.gwb
RUN touch /home/ubuntu/.gwb/EULA.txt
RUN mkdir /home/ubuntu/output

# add directory for iRODS iCommands to user profile as JSON, see entry.sh
RUN mkdir /home/ubuntu/.irods 
RUN chown ubuntu:ubuntu  /home/ubuntu/.irods
# create ~/data-store for CSI driver fuse mount
# RUN mkdir /home/ubuntu/data-store

ENTRYPOINT ["bash", "/bin/entry.sh"]

