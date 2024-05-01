# #### GTB/GWB on ubuntu desktop
# K. Riitters April 2024
#  Start with Tyson Swetnam's CyVerse VICE kasm-ubuntu 22.04:
#   https://github.com/cyverse-vice/kasm-ubuntu/tree/main/22.04
#   Included files are kasmvnc_defaults.yaml, sudoers, vnc_startup.sh
# The kasmweb image can be either the productivity desktop Swetnam used -
#   https://hub.docker.com/r/kasmweb/ubuntu-jammy-desktop
#    or a desktop with much less installed -  
#   https://hub.docker.com/r/kasmweb/desktop
# The two pulls to local machine are -
#  docker pull kasmweb/ubuntu-jammy-desktop:1.14.0-rolling
#  docker pull kasmweb/desktop:1.14.0-rolling
# In both cases, the local docker run is: docker run -it --rm -p 9876:6901  <image>
# ########
# Use the light version of the desktop
FROM kasmweb/desktop:1.14.0-rolling
# Or, use the jammy desktop
# FROM kasmweb/ubuntu-jammy-desktop:1.14.0-rolling
# ########
# Copy and use parts of Tyson's dockerfile for VICE kasm-ubuntu
#  This is from the jammy desktop dockerfile but hopefully will work with the light desktop too.
# create ~/data-store for CSI driver fuse mount
WORKDIR /home/kasm-user/data-store
# Install GoCommands
RUN mkdir /home/kasm-user/.irods
RUN echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > /home/kasm-user/.irods/irods_environment.json
USER root
# Install a few dependencies for goCommands, text editing, and monitoring instances
RUN apt update && \
    apt install -y lsb-release apt-transport-https curl libfreetype6-dev pkg-config libx11-dev gcc less software-properties-common apt-utils glances htop nano 
# Install Go
RUN wget -q -c https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz -O - | tar -xz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin 
# Install GoCommands
RUN cd /usr/local/bin/ && \
    GOCMD_VER=$(curl -L -s https://raw.githubusercontent.com/cyverse/gocommands/main/VERSION.txt); \
    curl -L -s https://github.com/cyverse/gocommands/releases/download/${GOCMD_VER}/gocmd-${GOCMD_VER}-linux-amd64.tar.gz | tar zxvf -
COPY kasmvnc_defaults.yaml /usr/share/kasmvnc/kasmvnc_defaults.yaml
COPY vnc_startup.sh /dockerstartup/vnc_startup.sh
COPY sudoers /etc/sudoers
RUN chmod +x /dockerstartup/vnc_startup.sh
ENTRYPOINT [ "/dockerstartup/vnc_startup.sh" ]
# end of Tyaon's dockerfile
# #######
# Install GTB & GWB
RUN apt-get update \ 
	# && apt-get -y upgrade  \
    && apt-get install apt-utils dialog gedit nomacs -y 
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GTB/gtb_amd64.deb
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install /tmp/gtb_amd64.deb /tmp/gwb_amd64.deb -y
RUN rm -f gtb_amd64.deb gwb_amd64.deb
# delete the default data directories, the user can define them as needed
# RUN rm -fr /home/kasm-user/input /home/kasm-user/output

# CyVerse has no normal user setup, adapt to the custom setup
RUN mkdir /home/.gwb
RUN chown kasm-user:kasm-user /home/.gwb
# Switch to normal user
WORKDIR /home/kasm-user
USER kasm-user
# fix up GWB things for kasm-user
RUN  ln -s /home/.gwb /home/kasm-user/.gwb
RUN  touch /home/kasm-user/.gwb/EULA.txt
# assign some preferred applications... 
RUN xdg-mime default nomacs.desktop "image/jpeg"
RUN xdg-mime default nomacs.desktop "image/png"
RUN xdg-mime default nomacs.desktop "image/tiff"
RUN xdg-mime default mupdf.desktop "application/pdf"
# avoid nomacs asking for language preference on first start
RUN mkdir -p /home/kasm-user/.config/nomacs
COPY ["Image Lounge.conf", "/home/kasm-user/.config/nomacs/"]
RUN sudo chown kasm-user:kasm-user /home/kasm-user/.config/nomacs/'Image Lounge.conf'
RUN chmod 644 /home/kasm-user/.config/nomacs/'Image Lounge.conf'

# fix for K8S clusters https://stackoverflow.com/questions/63627955/cant-load-shared-library-libqt5core-so-5
RUN sudo strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
# End of GTB/GWB installation
# ######
# Local docker image run (the internal 6901 port is mapped to external 9876)
#  docker run -it --rm -p 9876:6901 <imagename>
# Point browser to 127.0.0.1:9876

# same as Tyson's entrypoint  (is this needed here?)
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
# dockerfile end