# Dockerfile to run GTB/GWB on a desktop GIS

# On cyverse the user is "kasm-user" with /home/kasm-user/data-
#	To link that in the container, to the real cyverse user's data-store directories
#	(e.g. /home/kriitters/data-store/), link the volumes during cyverse tool creation
#	by setting the working directory to /home/kasm-user/data-store
#

FROM harbor.cyverse.org/vice/kasm/ubuntu:qgis-22.04
#RUN apt-get update && apt-get -y upgrade  \
#    && apt-get install apt-utils dialog gedit nomacs -y \
#    && apt-get autoremove -y \
#    && apt-get clean all
# 
# once all is working fine use the sequence above to keep the container small
RUN apt-get update && apt-get -y upgrade  \
    && apt-get install apt-utils dialog gedit nomacs -y 

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
RUN rm -fr /home/kasm-user/input /home/kasm-user/output

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