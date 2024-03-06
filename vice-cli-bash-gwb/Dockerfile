FROM harbor.cyverse.org/vice/cli/bash:latest
# default user is "jovyan", home dir /home/jovyan, sudo priv

# ########### Install GWB ###########
RUN sudo apt-get update && sudo apt-get upgrade -y  \
    && sudo apt-get install apt-utils dialog -y \
	# for fake x server
	&& sudo apt-get install libxinerama1 -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get clean all
WORKDIR /tmp
RUN wget https://ies-ows.jrc.ec.europa.eu/gtb/GWB/gwb_amd64.deb
RUN sudo apt-get install  /tmp/gwb_amd64.deb -y
##RUN rm -f gwb_amd64.deb
WORKDIR /home/jovyan
# adapt to the custom CyVerse user setup
RUN sudo mkdir /home/.gwb
RUN sudo chown jovyan:jovyan /home/.gwb
# replace the default data directories,the user can define them as needed
RUN rm -fr /home/jovyan/input /home/jovyan/output
RUN mkdir /home/jovyan/gwbinput /home/jovyan/gwboutput
RUN cp -R /opt/GWB/input/. /home/jovyan/gwbinput/
RUN cp -R /opt/GWB/output/. /home/jovyan/gwboutput/
# fix up GWB things for user
RUN ln -s /home/.gwb /home/jovyan/.gwb
RUN touch /home/jovyan/.gwb/EULA.txt
# ######### End of GWB install ############
# create ~/data-store for CSI driver fuse mount
#RUN mkdir /home/jovyan/data-store
RUN echo 'set-option -g status off' >> ~/.tmux.conf
# entry.sh starts terminal
#COPY entry.sh /bin
ENTRYPOINT ["bash", "/bin/entry.sh"]
# docker build -t fubar .
# docker run -it --rm -p 7681:7681 fubar
# point browser to 0.0.0.0:7681