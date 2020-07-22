# Toast  
  
 http://byteben.com/bb/wp-content/uploads/2020/07/Toast-Example.jpg 
   
Toast_Notify.ps1 is a simple Toast Notification script designed to be deployed as a package from MEMCM  
  
Toast_Notify.ps1 will read an XML file on a file share so Toast Notifications can be changed "on the fly" without having to repackage. 
To create a custom XML, copy CustomMessage.xml and edit the text you want to display in the toast notification. Reference that file using one of the script parameters.  
  
**Points to Consider**    
  
I am using an existing app in Windows to call the Toasts. This script creates two buttons in the Toast, "Details" and "Dismiss". Cicking details is designed to take the user to an internal Service Desk announcement page. For that reason, **MSEdge** works really well because the Toast Action launches the browser in the foreground. Oh, you will need MSEdge installed on your client computers for this to work.  

The following files should be present in the Script Directory when you create the package in MEMCM:-   
  
**Toast_Notify.ps1  
BadgeImage.jpg  
HeroImage.jpg  
CustomMessage.xml**  
  
  
**.PARAMETER XMLScriptDirSource**    
Specify the name of the XML file to read. The XML file must exist in the same directory as Toast_Notify.ps1. If no parameter is passed, it is assumed the XML file is called CustomMessage.xml.
  
**.PARAMETER XMLOtherSource**  
Specify the location of the Custom XML file used for the Toast when it is not in the MEMCM package
  
**.EXAMPLE**  
Toast_Notify.ps1 -XMLOtherSource "\\fileserverhome\xml\CustomMessage.xml"
  
**.EXAMPLE**  
Toast_Notify.ps1 -XMLSciptDirSource "PhoneSystemProblems.xml"
  
**.EXAMPLE**  
Toast_Notify.ps1
  
**Known Issues**  
Currently, the images in the XML can only be read from the local files system. This is not an issue if we are deploying the package from MEMCM. Further development will see the ability to convert images to Base64 or host them on a web server.
  
**Thanks for the help from**  
  @guyrleech
  @young_robbo
  
**Community**  
  Seriously check our Martin Bentsson's work on Toasts. It is very comprehensive.  https://www.imab.dk/windows-10-toast-notification-script/
  I challenged myself to learn how Windows Toasts work so this was a labour of love for me. I have enjoyed the ride so far
  
