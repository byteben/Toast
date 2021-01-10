# Version History  

**Version 1.2.10 - 10/01/21**    

-Removed XMLOtherSource Parameter  
-Cleaned up XML formatting which removed unnecessary duplication when the Snooze parameter was passed. Action ChildNodes are now appended to ToastTemplate XML.

**Version 1.2 - 09/01/21**  

-Added logic so if the script is deployed as SYSTEM it will create a scheduled task to run the script for the current logged on user.  
-If the Toast script is deployed in the SYSTEM context, the script source is copied to a new folder in the users %TEMP% Directory. The folder is given a unique GUID name.  
-A scheduled task is created for the current logged on user and is unique for the each time the Toast Script is deployed. Each scheduled task is named using the User SID and the unique Task GUID.  
-If the script is deployed to the current logged on user, a scheduled task is not created and the script is run as normal.  

**Version 1.1 - 30/12/20**  

-Added a Snooze option (Use the -Snooze switch).  

**Version 1.0 - 22/07/20**  

-Release
    
# Project Outline

**Screenshots**  
  
 http://byteben.com/bb/wp-content/uploads/2020/07/Toast-Example.jpg  
 http://byteben.com/bb/wp-content/uploads/2021/01/Toast-Example-Snooze.jpg  
 http://byteben.com/bb/wp-content/uploads/2020/07/Content-Example.jpg  
   
**Description**  
  
The "Toast Notify" solution will pop a notification toast from the system tray in Windows 10 (See Toast-Example.jpg). This project was born out of the desire for me to understand Toast Notifications better and seek to replace a 3rd party desktop notification solution. The titles, texts and action button are customisable via an XML document.  
  
Toast_Notify.ps1 is a script designed to be deployed as a package from MEMCM. The "Set and forget" mentality of packages works really well because we don't need to specify a detection method once the script has run.  
  
Toast_Notify.ps1 will read an XML file on a file share or from the same directory. If the XML is stored on a fileserver, the Toast Notifications can be changed "on the fly" without having to repackage the script. 
To create a custom XML, copy CustomMessage.xml and edit the text you want to display in the toast notification. Place the modified XML in the script directory or on a fileserver. Call your custom file using one of the script parameters below.  
  
**Points to Consider**  
  
I am using an existing app in Windows to call the Toasts. This script creates two buttons in the Toast, "Details" and "Dismiss". Cicking details is designed to take the user to an internal Service Desk announcement page. For that reason, **MSEdge** works really well because the Toast Action launches the browser in the foreground. Oh, you will need MSEdge installed on your client computers for this to work.  

The following files should be present in the Script Directory when you create the package in MEMCM:-   
  
**Toast_Notify.ps1  
BadgeImage.jpg  
HeroImage.jpg (364 x 180px, 3MB Normal Connection / 1MB Metered Connection)  
CustomMessage.xml**  
  
More information and Toast Content guidelines can be found at:-    
https://docs.microsoft.com/en-us/windows/uwp/design/shell/tiles-and-notifications/toast-ux-guidance  
  
**Parameters**  
If you specify no parameter for XMLSource the script will read the CustomMessage.xml in the script root.  
  
**.PARAMETER XMLSource**    
  
Specify the name of the XML file to read. The XML file must exist in the same directory as Toast_Notify.ps1. If no parameter is passed, it is assumed the XML file is called CustomMessage.xml.
  
**.EXAMPLE**  
  
Toast_Notify.ps1 -XMLSource "PhoneSystemProblems.xml"
  
**.EXAMPLE**  
  
Toast_Notify.ps1 -Snooze
  
**Known Issues** 
  
Currently, the images in the XML can only be read from the local file system. This is not an issue if we are deploying the package from MEMCM.
PowerShell Window flashes before Toast when deployed in SYSTEM context
  
**Inspiration, Credit and Help**  
  
  @guyrleech
  @young_robbo
  @mwbengtsson
  @ccmexec
  @syst_and_deploy
  
**Community**  
  
https://www.imab.dk/windows-10-toast-notification-script/
http://www.systanddeploy.com/2020/09/display-simple-toast-notification-with.html
https://github.com/Windos/BurntToast
https://wetterssource.com/ondemandtoast
https://msendpointmgr.com/2020/06/29/adding-notifications-to-win32appremedy-with-proactive-remediations/
https://msendpointmgr.com/2020/08/07/proactive-battery-replacement-with-endpoint-analytics/
  
If you have any comments, feedback or would like to contribute - please don't be shy!
  
