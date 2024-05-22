# cyverse-gtb_gwb  
CyVerse deployment of Peter Vogt's Guidos ToolBox (GTB) and Guidos ToolBox Workbench (GWB).  
There are three desktop versions.  
   The "gis" version includes several GIS's and productivity software.  
   The "desktop" includes only some browsers.  
   The "usfs-desktop" is build on Tanvir Ahmed's hardened version of "desktop"  
 
## Repository Organization  
<pre>
.  
|-- AUTHORS.md  
|-- README.md  
|-- vice-kasm-ubuntu-gis-gtbgwb:  
      GWB and GTB on Tyson Swetnam's CyVerse DE VICE app "Ubuntu Desktop GIS"  
      vice/kasm/ubuntu:qgis-22.04  
|-- vice-cli-bash-gwb:  
      GWB on Tyson Swetnam's CyVerse DE VICE app "Cloud Shell"  
	  vice/cli/bash:latest (ubuntu 20.04)
|-- vice-kasm-desktop-gtbgwb:  
	  GWB and GTB on kasmweb/desktop  
      Adds Tyson Swetnam's dockerfile (https://github.com/cyverse-vice/kasm-ubuntu/tree/main/22.04)  
         to add Cyverse functionality with supporting files kasmvnc_defaults.yaml, sudoers, vnc_startup.sh  
      Installs Peter Vogt's GTB and GWB and sets up kasm-user functionality  
|-- usfs_ubuntu-gtbgwb:  
	  GWB and GTB on Tanvir Ahmed's harbor.cyverse.org/usfs/kasm-stig-cyverse  
	  Installs Peter Vogt's GTB and GWB and sets up kasm-user functionality  
</pre>
## Additional Information  
The repository consists mainly of Dockerfiles which install and set up GTB and GWB.  
For license and other information please visit  
GTB on GitHub (Peter Vogt) - https://github.com/ec-jrc/GTB  
GWB on GitHub (Peter Vogt) - https://github.com/ec-jrc/GWB  