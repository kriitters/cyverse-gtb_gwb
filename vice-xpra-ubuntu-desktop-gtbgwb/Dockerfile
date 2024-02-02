FROM harbor.cyverse.org/vice/xpra/ubuntu:22.04

# ########### Install GTB/GWB ###########
RUN sudo apt-get update && sudo apt-get upgrade -y  \
    && sudo apt-get install apt-utils dialog gedit nomacs -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get clean all
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GTB/gtb_amd64.deb
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN sudo apt-get install /tmp/gtb_amd64.deb /tmp/gwb_amd64.deb -y
##RUN rm -f gtb_amd64.deb gwb_amd64.deb
WORKDIR /home/ubuntu
# adapt to the custom CyVerse user setup
RUN sudo mkdir /home/.gwb
RUN sudo chown ubuntu:ubuntu /home/.gwb
# replace the default data directories,the user can define them as needed
RUN rm -fr /home/ubuntu/input /home/ubuntu/output
RUN mkdir /home/ubuntu/gwbinput /home/ubuntu/gwboutput
RUN cp -R /opt/GWB/input/. /home/ubuntu/gwbinput/
RUN cp -R /opt/GWB/output/. /home/ubuntu/gwboutput/
# fix up GWB things for user
RUN ln -s /home/.gwb /home/ubuntu/.gwb
RUN touch /home/ubuntu/.gwb/EULA.txt
# assign some meaningful applications... 
RUN  xdg-mime default nomacs.desktop "image/jpeg"
RUN  xdg-mime default nomacs.desktop "image/png"
RUN  xdg-mime default nomacs.desktop "image/tiff"
RUN  xdg-mime default mupdf.desktop "application/pdf"
# ######### End of GTB/GWB install ############
# create ~/data-store for CSI driver fuse mount
RUN mkdir /home/ubuntu/data-store
RUN echo 'set-option -g status off' >> ~/.tmux.conf
# entry.sh starts terminal
COPY entry.sh /bin
ENTRYPOINT ["bash", "/bin/entry.sh"]
# docker build -t fubar .
# docker run -it --rm -p 9876:9876 fubar
# point browser to 0.0.0.0:9876