# #### GTB/GWB on USFS ubuntu desktop
# K. Riitters May 2024
#  Start with Tanvir Ahmed's image:
#   https://harbor.cyverse.org/usfs/kasm-stig-cyverse
#	docker pull harbor.cyverse.org/usfs/kasm-stig-cyverse@sha256:f5a4bb30633608a39ab2f6c292601809a227479ec6eb4feac03d01065e698509
#   Included files are kasmvnc_defaults.yaml, sudoers, vnc_startup.sh
# The local docker run is: docker run -it --rm -p 9876:6901  <image>
# ########
FROM harbor.cyverse.org/usfs/kasm-stig-cyverse@sha256:f5a4bb30633608a39ab2f6c292601809a227479ec6eb4feac03d01065e698509
RUN apt-get update \ 
	&& apt-get upgrade -y  \
    && apt-get install apt-utils dialog gedit nomacs gnumeric thunar-archive-plugin -y \
	&& apt-get autoremove -y \
    && apt-get clean all

# Install GTB & GWB
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GTB/gtb_amd64.deb
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install /tmp/gtb_amd64.deb /tmp/gwb_amd64.deb -y
RUN rm -f gtb_amd64.deb gwb_amd64.deb
#    CyVerse has no normal user setup, adapt GWB to the custom setup
RUN mkdir /home/.gwb
RUN chown kasm-user:kasm-user /home/.gwb
# Add GTB test data and "how to" pdf
COPY  GTB_NLCD-data/ /home/kasm-user/GuidosToolbox/data/

# Install Google Earth for using GTB export to kml option
#    https://ubuntuhandbook.org/index.php/2024/05/install-google-earth-ubuntu/
RUN mkdir /etc/apt/keyrings/
#    add GE public key
RUN wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor |  tee /etc/apt/keyrings/google-earth.gpg >/dev/null
#    add GE repo 
RUN sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-earth.gpg] https://dl.google.com/linux/earth/deb/ stable main" > /etc/apt/sources.list.d/google-earth.list'
RUN chmod -R 777 /etc/apt/*
#    update repo
RUN apt update
#    install GE
RUN  apt install google-earth-pro-stable

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
# create the CyVerse mount directory for external volumes
WORKDIR /home/kasm-user/data-store
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
# dockerfile end
# Local docker image run (the internal 6901 port is mapped to external 9876)
#  docker run -it --rm -p 9876:6901 <imagename>
# Point browser to 127.0.0.1:9876
