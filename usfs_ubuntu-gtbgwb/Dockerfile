# #### GTB/GWB on USFS ubuntu desktop
# K. Riitters May 2024
#  Start with Tanvir Ahmed's image:
#   https://harbor.cyverse.org/usfs/kasm-stig-cyverse
#	docker pull harbor.cyverse.org/usfs/kasm-stig-cyverse@sha256:f5a4bb30633608a39ab2f6c292601809a227479ec6eb4feac03d01065e698509
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
FROM harbor.cyverse.org/usfs/kasm-stig-cyverse@sha256:f5a4bb30633608a39ab2f6c292601809a227479ec6eb4feac03d01065e698509
# ########
# Install GTB & GWB
RUN apt-get update \ 
	# && apt-get -y upgrade  \
    && apt-get install apt-utils dialog gedit nomacs -y 
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GTB/gtb_amd64.deb
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN apt-get install /tmp/gtb_amd64.deb /tmp/gwb_amd64.deb -y
RUN rm -f gtb_amd64.deb gwb_amd64.deb
# Move the default data directories into the GuidosToolbox folder, to avoid confusion.
#   The CyVerse app defines other "input" and "output" directories at run time.
RUN mv -f /home/kasm-user/input /home/kasm-user/GuidosToolbox/example_input
RUN mv -f /home/kasm-user/output /home/kasm-user/GuidosToolbox/example_output

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

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
# dockerfile end