# GTB/GWB on ubuntu desktop
#  Start with kasm Swetnam's CyVerse VICE kasm-ubuntu 22.04:
#   https://github.com/cyverse-vice/kasm-ubuntu/tree/main/22.04
# included files are kasmvnc_defaults.yaml, sudoers, vnc_startup.sh
# First, pull the kasmweb image into local docker:
#   this can be either a productivity desktop -
#  https://hub.docker.com/r/kasmweb/ubuntu-jammy-desktop
#    or a desktop with much less installed -  This one is used below
#  https://hub.docker.com/r/kasmweb/desktop
# The two pulls are -
#  docker pull kasmweb/ubuntu-jammy-desktop:1.14.0-rolling
#or, docker pull kasmweb/desktop:1.14.0-rolling
# In either case, the local CLI is docker run -it --rm -p 9876:6901  <image>
FROM kasmweb/desktop:1.14.0-rolling

# Start with Swetnam's Dockerfile for kasm-ubuntu
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
# end of swetnam's dockerfile

# Install GTB/GWB
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GTB/gtb_amd64.deb
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install /tmp/gtb_amd64.deb /tmp/gwb_amd64.deb -y
RUN rm -f gtb_amd64.deb gwb_amd64.deb

# CyVerse has no normal user setup, adapt to the custom setup
RUN mkdir /home/.gwb
RUN chown kasm-user:kasm-user /home/.gwb
# delete the default data directories, the user can define them as needed
# RUN rm -fr /home/kasm-user/input /home/kasm-user/output

# Switch to normal user
WORKDIR /home/kasm-user
USER kasm-user
# fix up GWB things for kasm-user
RUN ln -s /home/.gwb /home/kasm-user/.gwb
RUN touch /home/kasm-user/.gwb/EULA.txt
# assign some meaningful applications... 
RUN xdg-mime default nomacs.desktop "image/jpeg"
RUN xdg-mime default nomacs.desktop "image/png"
RUN xdg-mime default nomacs.desktop "image/tiff"
RUN xdg-mime default mupdf.desktop "application/pdf"
# avoid nomacs asking for language preference on first start
RUN mkdir -p /home/kasm-user/.config/nomacs
COPY ["Image Lounge.conf", "/home/kasm-user/.config/nomacs/"]
RUN sudo chown kasm-user:kasm-user /home/kasm-user/.config/nomacs/'Image Lounge.conf'
RUN chmod 644 /home/kasm-user/.config/nomacs/'Image Lounge.conf'
# End of GTB/GWB installation

# Local docker image run (the internal 6901 port is mapped to external 9876)
#  docker run -it --rm -p 9876:6901 <imagename>
# Point browser to 127.0.0.1:9876

# same as original entrypoint in base image,maybe there's some additional configurations that could be added
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
#end