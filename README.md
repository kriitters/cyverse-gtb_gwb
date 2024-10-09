# cyverse-gtb_gwb  
CyVerse deployment of Peter Vogt's Guidos ToolBox (GTB) and Guidos ToolBox Workbench (GWB) on CyVerse.  

## Repository Organization  
<pre>
.  
|-- AUTHORS.md  
|-- README.md  
|-- vice-cli-gwb:  CyVerse DE VICE tool.    
    GWB (only) on Tyson Swetnam's "Cloud Shell"  
|-- gwb_executable:  CyVerse executable tool.  
    GWB (only) on rocker/r-ver:4.1.1 to be run as CyVerse executable    
|-- vice-kasm-desktop-gtbgwb:  CyVerse DE VICE tool.
	  GWB and GTB on kasmweb/desktop, adding Tyson Swetnam's CyVerse integration steps and supporting files kasmvnc_defaults.yaml, sudoers, vnc_startup.sh  
</pre>
## Additional Information  
The repository consists mainly of Dockerfiles and entry shells which install and set up GTB and GWB.  
For license and other information please visit  
GTB on GitHub (Peter Vogt) - https://github.com/ec-jrc/GTB  
GWB on GitHub (Peter Vogt) - https://github.com/ec-jrc/GWB  