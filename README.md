# Toast  

**Screenshots**  
  
 http://byteben.com/bb/wp-content/uploads/2020/07/Toast-Example.jpg  
 http://byteben.com/bb/wp-content/uploads/2020/07/Content-Example.jpg  
   
**Description**  
  
The "Toast Notify" solution will pop a notification toast from the system tray in Windows 10 (See Toast-Example.jpg). This project was born out of the desire for me to understand Toast Notifications better and seek to replace a 3rd party desktop notification solution. The titles, texts and action button are customisable via an XML document.  
  
Toast_Notify.ps1 is a script designed to be deployed as a package from MEMCM. The "Set and forget" mentality of packages works really well because we don't need to specify a detection method once the script has run.  
  
Toast_Notify.ps1 will read an XML file on a file share or from the same directory. If the XML is stored on a fileservr, theo Toast Notifications can be changed "on the fly" without having to repackage the script. 
To create a custom XML, copy CustomMessage.xml and edit the text you want to display in the toast notification. Place the modified XML in the script directory or on a fileserver. Call your custom file using one of the script parameters below.  
  
**Points to Consider**  
  
I am using an existing app in Windows to call the Toasts. This script creates two buttons in the Toast, "Details" and "Dismiss". Cicking details is designed to take the user to an internal Service Desk announcement page. For that reason, **MSEdge** works really well because the Toast Action launches the browser in the foreground. Oh, you will need MSEdge installed on your client computers for this to work.  

The following files should be present in the Script Directory when you create the package in MEMCM:-   
  
**Toast_Notify.ps1  
BadgeImage.jpg  
HeroImage.jpg (364 x 180px, 3MB Normal Connection / 1MB Metered Connection)
CustomMessage.xml**  
  
**Parameters**  
You should specify either XMLScriptSourceDir **or** XMLOtherSource parameters but not both. If you specify no parameter the script will read the CustomMessage.xml in the script root.  
  
**.PARAMETER XMLScriptDirSource**    
  
Specify the name of the XML file to read. The XML file must exist in the same directory as Toast_Notify.ps1. If no parameter is passed, it is assumed the XML file is called CustomMessage.xml.
  
**.PARAMETER XMLOtherSource** 
  
Specify the location of the Custom XML file used for the Toast when it is not the same directory as Toast_Notify.ps1 e.g the full UNC path to the XML file.
  
**.EXAMPLE**  
  
Toast_Notify.ps1 -XMLOtherSource "\\\\fileserverhome\xml\CustomMessage.xml"
  
**.EXAMPLE**  
  
Toast_Notify.ps1 -XMLSciptDirSource "PhoneSystemProblems.xml"
  
**.EXAMPLE**  
  
Toast_Notify.ps1
  
**Known Issues** 
  
Currently, the images in the XML can only be read from the local file system. This is not an issue if we are deploying the package from MEMCM.
  
**Thanks for the help from**  
  
  @guyrleech
  @young_robbo
  
**Community**  
  
  Seriously check our Martin Bentsson's work on Toasts. It is very comprehensive.  https://www.imab.dk/windows-10-toast-notification-script/
  I challenged myself to learn how Windows Toasts work so this was a labour of love for me. I have enjoyed the ride so far
  
