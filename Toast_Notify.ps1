<#
===========================================================================
Created on:   22/07/2020 11:04
Created by:   Ben Whitmore
Filename:     Toast_Notify.ps1
===========================================================================

.SYNOPSIS
The purpose of the script is to create simple Toast Notifications in Windows 10, deliverd as a package by MEMCM.

.DESCRIPTION
Toast_Notify.ps1 will read an XML file so Toast Notifications can be changed "on the fly" without having to repackage an application. The CustomMessage.xml file can be hosted on a fileshare.
To create a custom XML, copy CustomMessage.xml and edit the text you want to disaply in the toast notification. The following files should be present in the Script Directory when you create the package in MEMCM:-

Toast_Notify.ps1
BadgeImage.jpg
HeroImage.jpg
CustomMessage.xml

.PARAMETER XMLScriptDirSource
Specify the name of the XML file to read. The XML file must exist in the same directory as Toast_Notify.ps1. If no parameter is passed, it is assumed the XML file is called CustomMessage.xml.

.PARAMETER XMLOtherSource
Specify the location of the Custom XML file used for the Toast when it is not in the same directory as the Toast_Notify.ps1 script

.EXAMPLE
Toast_Notify.ps1 -XMLOtherSource "\\fileserverhome\xml\CustomMessage.xml"

.EXAMPLE
Toast_Notify.ps1 -XMLSciptDirSource "PhoneSystemProblems.xml"

.EXAMPLE
Toast_Notify.ps1
#>

Param
(
    [Parameter(Mandatory = $False)]
    [String]$XMLScriptDirSource = "CustomMessage.xml",
    [String]$XMLOtherSource

)

#Current Directory
$ScriptPath = $MyInvocation.MyCommand.Path
$CurrentDir = Split-Path $ScriptPath

#Check if XML will come from the Script Source Directory or another source
If (!($PSBoundParameters.ContainsKey('XMLOtherSource') -eq $True)) {
    $XMLPath = Join-Path $CurrentDir $XMLScriptDirSource
}
else {
    $XMLPath = $XMLOtherSource
}

#Test if XML exists
if (!(Test-Path -Path $XMLPath)) {
    throw "$XMLPath is invalid."
}

#Check XML is valid
$XMLToast = New-Object System.Xml.XmlDocument
try {
    $XMLToast.Load((Get-ChildItem -Path $XMLPath).FullName)
    $XMLValid = $True
}
catch [System.Xml.XmlException] {
    Write-Verbose "$XMLPath : $($_.toString())"
    $XMLValid = $False
}

#Continue if XML is valid
If ($XMLValid -eq $True) {

    #Read XML Nodes
    [XML]$Toast = Get-Content $XMLPath

    #Create Toast Variables
    $ToastTitle = $XMLToast.ToastContent.ToastTitle
    $Signature = $XMLToast.ToastContent.Signature
    $EventTitle = $XMLToast.ToastContent.EventTitle
    $EventText = $XMLToast.ToastContent.EventText
    $ButtonTitle = $XMLToast.ToastContent.ButtonTitle
    $ButtonAction = $XMLToast.ToastContent.ButtonAction

    #ToastDuration: Short = 7s, Long = 25s
    $ToastDuration = "long"

    #Toast Time Format
    $Time = Get-Date -Format HH:mm

    #Images
    $BadgeImage = "file:///$CurrentDir/badgeimage.jpg"
    $HeroImage = "file:///$CurrentDir/heroimage.jpg"

    #Set COM App ID > To bring a URL on button press to focus use a browser for the appid e.g. MSEdge
    #$LauncherID = "Microsoft.SoftwareCenter.DesktopToasts"
    #$LauncherID = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"
    $Launcherid = "MSEdge"

    #Get last(current) logged on user
    $LoggedOnUserPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI"
    If (!((Get-ItemProperty $LoggedOnUserPath).LastLoggedOnDisplayName)) {
        Try {
            $Firstname = $Null
        }
        Catch [System.Management.Automation.ItemNotFoundException] {
            Write-Warning "$RegistryKey was not found."
        }
        Catch {
            Write-Warning "Error $($error[0].Exception)."
        } 
    }
    else {
        $User = Get-Itemproperty -Path $LoggedOnUserPath -Name "LastLoggedOnDisplayName" | Select-Object -ExpandProperty LastLoggedOnDisplayName
        $DisplayName = $User.Split(" ")
        $Firstname = $DisplayName[0]
    }

    #Get Hour of Day and set Custom Hello
    $Hour = (Get-Date).Hour
    If ($Hour -lt 12) { $CustomHello = "Good Morning $($Firstname)" }
    ElseIf ($Hour -gt 16) { $CustomHello = "Good Evening $($Firstname)" }
    Else { $CustomHello = "Good Afternoon $($Firstname)" }

    #Load Assemblies
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    #Build XML Template
    [xml]$ToastTemplate = @"
<toast duration="$ToastDuration" scenario="reminder">
    <visual>
        <binding template="ToastGeneric">
            <text>$CustomHello</text>
            <text>$ToastTitle</text>
            <text placement="attribution">$Signature</text>
            <image placement="hero" src="$HeroImage"/>
            <image placement="appLogoOverride" hint-crop="circle" src="$BadgeImage"/>
            <group>
                <subgroup>
                    <text hint-style="title" hint-wrap="true" >$EventTitle</text>
                </subgroup>
            </group>
            <group>
                <subgroup>
                    <text hint-style="body" hint-wrap="true" >$EventText</text>
                </subgroup>
            </group>
        </binding>
    </visual>
    <audio src="ms-winsoundevent:notification.default"/>
    <actions>
        <action arguments="$ButtonAction" content="$ButtonTitle" activationType="protocol" />
        <action arguments="dismiss" content="Dismiss" activationType="system"/>
    </actions>
</toast>
"@

    #Prepare XML
    $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
    $ToastXml.LoadXml($ToastTemplate.OuterXml)

    #Prepare and Create Toast
    $ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($LauncherID).Show($ToastMessage)
}