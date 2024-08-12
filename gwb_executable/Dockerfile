# user is ruser, uid = 1000, sudo priv
FROM rocker/r-ver:4.1.1
USER root
ENV TZ=America/Phoenix
ENV LANG=C.UTF-8 
ENV LC_ALL=en_US.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone
RUN  apt update \
	&& apt upgrade -y \
	# gwb depends, and libxinerama1 for fake x server in GWB
	&& apt install bc curl xdg-utils x11-xserver-utils xvfb time wget libxinerama1 apt-utils dialog gettext-base gdal-bin libgdal-dev libudunits2-0 libudunits2-dev sudo -y \
    && apt autoremove -y \
    && apt clean all \
	&& rm -rf /var/lib/apt/lists/*
#
# Set up user ruser
RUN useradd ruser
# Add sudo to user ruser; this is needed to run a chown on a dynamic volume mount in entry.sh
RUN echo "ruser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 
COPY entry.sh /home/ruser/entry.sh
# Install GWB
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install  /tmp/gwb_amd64.deb -y
RUN rm -f /tmp/gwb_amd64.deb
RUN rm -fr /home/ruser/input /home/ruser/output
#    CyVerse has no normal user setup, adapt GWB to the custom setup
RUN mkdir /home/.gwb
RUN chown ruser:ruser /home/.gwb
# ensure rwx permissions everywhere in ~
RUN chmod 777 -R /home/ruser
# fix up GWB things for ruser
USER ruser
RUN  ln -s /home/.gwb /home/ruser/.gwb
RUN  touch /home/ruser/.gwb/EULA.txt
# add directory for iRODS iCommands to user profile as JSON, see entry.sh
RUN mkdir /home/ruser/.irods 
WORKDIR /home/ruser/data-store/
COPY entry.sh /bin/entry.sh
#
ENTRYPOINT ["bash", "/bin/entry.sh"]
# debug using this
# ENTRYPOINT ["/bin/bash"]










