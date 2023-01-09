; ai.planet (NSIS [nsis.sourceforge.net] 2.0b3 Script)
; http://aiplanet.sourceforge.net
; Developed by Dave Kerr
; Install Script written by Aaron Hochwimmera
; 
; $Id: aiplanet.nsi,v 1.28 2003/10/01 06:48:36 aidave Exp $

; Configuration
; ---------------------------------------------------------
!include "MUI.nsh"
!define MUI_PRODUCT "ai.planet"

SetDateSave on
SetDataBlockOptimize on
ShowInstDetails show
ShowUninstDetails show
CRCCheck on

InstType "Full"
InstType "Normal"
InstType "Minimal"

OutFile "Output\aiplanet100.exe"

InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"
InstallDirRegKey HKCU "Software\${MUI_PRODUCT}" ""

; Modern UI Configuration
!define MUI_VERSION "1.0.0"
!define MUI_WELCOMEPAGE
!define MUI_LICENSEPAGE
!define MUI_COMPONENTSPAGE
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_DIRECTORYPAGE

!define MUI_FINISHPAGE
!define MUI_FINISHPAGE_RUN "$INSTDIR\aiplanet.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\manual\index.html"
 
!define MUI_ABORTWARNING

!define MUI_UNINSTALLER
!define MUI_UNCONFIRMPAGE

  !define MUI_HEADERBITMAP "${NSISDIR}\Contrib\Icons\modern-header.bmp"
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
;Language Strings

;Description
LangString DESC_SecCopyApp ${LANG_ENGLISH} "Install the ai.planet application and required files."
LangString DESC_SecIcons ${LANG_ENGLISH} "Adds icons to your start menu and your desktop for easy access"
;--------------------------------

;LicenseData - uncomment to include in install
LicenseData gpl.txt 

Section "ai.planet" SecCopyApp
  SectionIn 1 2 3 RO
  SetOutPath "$INSTDIR"
  File "aiplanet.exe"
  File "Readme.txt"
  File "changes.txt"
  File "gpl.txt" ;could be enabled in the installer by uncommenting the Licence entry
  File "construction.log"
  File "bass.dll" ;version 0.8
  File "main.BMP"

; Need Write to registry functions here

; Audio
  SetOutPath "$INSTDIR\audio"
  File "audio\707kick.wav"
  File "audio\accessdeniedfemale.wav"
  File "audio\bird-die.wav"
  File "audio\blast.wav"
  File "audio\bliptick.wav"
  File "audio\clamp.wav"
  File "audio\cricket.wav"
  File "audio\crunch.wav"
  File "audio\electronicping.wav"
  File "audio\explode.wav"
  File "audio\fire.wav"
  File "audio\forest.wav"
  File "audio\hawk.wav"
  File "audio\incoming.wav"
  File "audio\lightrainloop.wav"
  File "audio\lion.wav"
  File "audio\mouse1.wav"
  File "audio\mouse2.wav"
  File "audio\nightengale.wav"
  File "audio\ohhh.wav"
  File "audio\pigeon.wav"
  File "audio\plink.wav"
  File "audio\quake3.wav"
  File "audio\rocksmash.wav"
  File "audio\shock.wav"
  File "audio\shutdowninprocess.wav"
  File "audio\Snare1.wav"
  File "audio\sparrow.wav"
  File "audio\START.wav"
  File "audio\superior.wav"
  File "audio\throw.wav"
  File "audio\uproot.wav"
  File "audio\waterdrop.wav"
  File "audio\watersplash.wav"
  File "audio\watersploosh.wav"
  File "audio\whodaman.wav"
  File "audio\Zwarble.wav"
  File "audio\tiger.wav"
  File "audio\quack.wav"
  File "audio\duckling.wav"

; Models
  SetOutPath "$INSTDIR\models"
  File "models\asteroid.3ds"
  File "models\beacon.3ds"
  File "models\bird-1.3ds"
  File "models\bird-2.3ds"
  File "models\bird-3.3ds"
  File "models\bird-4.3ds"
  File "models\birddead.3ds"
  File "models\bird-sit.3ds"
  File "models\newtree.3ds"
  File "models\cloud.3ds"
  File "models\crab.3ds"
  File "models\dynamite.3ds"
  File "models\fish.3ds"
  File "models\fish-female.3ds"
  File "models\fruit.3ds"
  File "models\fruit2.3ds"
  File "models\grassblade.3ds"
  File "models\grazer.3ds"
  File "models\hawk.3ds"
  File "models\orangetree.3ds"
  File "models\rain.3ds"
  File "models\seed.3ds"
  File "models\shark.3ds"
  File "models\spirit.3ds"
  File "models\terrier.3ds"
  File "models\turtle.3ds"
  File "models\tyranno.3ds"
  File "models\weapon.3ds"
  File "models\iceberg.3ds"
  File "models\duck.3ds"
  File "models\duck-girl.3ds"
  File "models\dolphin1.3ds"
  File "models\dolphin2.3ds"
  File "models\dolphin3.3ds"
  File "models\dolphin4.3ds"
  File "models\aquaplant.3ds"
  File "models\ladybug.3ds"
  File "models\ant.3ds"
  File "models\ant2.3ds"
  File "models\ant3.3ds"
  File "models\appletree.3ds"
  File "models\defence.3ds"

; Textures
  SetOutPath "$INSTDIR\textures"
  File "textures\alltex.bmp"
  File "textures\sunfire.bmp"
  File "textures\moonshine.bmp"
  File "textures\highlighter.bmp"
  File "textures\cloud-tex.bmp"
  File "textures\glacier.bmp"
  File "textures\beachball.JPG"
  File "textures\soccer.JPG"
  File "textures\rock.JPG"

; Photos
  SetOutPath "$INSTDIR\photos"
  File "photos\readme.txt"

; Worlds
  SetOutPath "$INSTDIR\worlds"
  File "worlds\readme.txt"
  File "worlds\river.air"
  File "worlds\mountain-evolve.air"

; Data
  SetOutPath "$INSTDIR\data"
  File "data\tips.txt"
  File "data\ladybug.ini"
  File "data\fox.ini"
  File "data\rabbit.ini"
  File "data\evolving tree.ini"
  File "data\evolving fruit.ini"
  File "data\evolving seed.ini"

; Manual
  SetOutPath "$INSTDIR\manual"
  File "manual\*.*"
; Manual Images
  SetOutPath "$INSTDIR\images"
  File "images\*.*"

;Create uninstaller
  WriteUninstaller "$INSTDIR\uninst-aiplanet.exe"
SectionEnd

Section "Start Menu + Desktop Shortcut" SecIcons
  SectionIn 1 2
  SetOutPath "$INSTDIR"

  CreateDirectory "$SMPROGRAMS\${MUI_PRODUCT}"
  
  IfFileExists "$INSTDIR\aiplanet.exe" "" +3
    CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\Artificial Planet.lnk" "$INSTDIR\aiplanet.exe" ""
;    CreateShortCut "$QUICKLAUNCH\aiplanet.lnk" "$INSTDIR\aiplanet.exe" ""
  
  WriteIniStr "$SMPROGRAMS\${MUI_PRODUCT}\aiplanet Website.url" "InternetShortcut" "URL" "http://aiplanet.sourceforge.net/"
  WriteIniStr "$SMPROGRAMS\${MUI_PRODUCT}\aiplanet Online Manual.url" "InternetShortcut" "URL" "http://aiplanet.sourceforge.net/manual/index.html"
  WriteIniStr "$SMPROGRAMS\${MUI_PRODUCT}\aiplanet Offline Manual.url" "InternetShortcut" "URL" "$INSTDIR\manual\index.html"
  
 IfFileExists "$INSTDIR\uninst-aiplanet.exe" "" +2
  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\Uninstall aiplanet.lnk" "$INSTDIR\uninst-aiplanet.exe"
  
  IfFileExists "$INSTDIR\aiplanet.exe" "" +2
    CreateShortCut "$DESKTOP\Artificial Planet.lnk" "$INSTDIR\aiplanet.exe"
SectionEnd

;Descriptions

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCopyApp} $(DESC_SecCopyApp)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecIcons} $(DESC_SecIcons)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN STUFF HERE!
  RMDir /r "$SMPROGRAMS\${MUI_PRODUCT}" ;force delete start menu entry - its safe...
  Delete "$QUICKLAUNCH\Artificial Planet.lnk"
  Delete "$DESKTOP\Artificial Planet.lnk"

  Delete "$INSTDIR\audio\707kick.wav"
  Delete "$INSTDIR\audio\accessdeniedfemale.wav"
  Delete "$INSTDIR\audio\bird-die.wav"
  Delete "$INSTDIR\audio\blast.wav"
  Delete "$INSTDIR\audio\bliptick.wav"
  Delete "$INSTDIR\audio\clamp.wav"
  Delete "$INSTDIR\audio\cricket.wav"
  Delete "$INSTDIR\audio\crunch.wav"
  Delete "$INSTDIR\audio\electronicping.wav"
  Delete "$INSTDIR\audio\explode.wav"
  Delete "$INSTDIR\audio\fire.wav"
  Delete "$INSTDIR\audio\forest.wav"
  Delete "$INSTDIR\audio\hawk.wav"
  Delete "$INSTDIR\audio\incoming.wav"
  Delete "$INSTDIR\audio\lightrainloop.wav"
  Delete "$INSTDIR\audio\lion.wav"
  Delete "$INSTDIR\audio\mouse1.wav"
  Delete "$INSTDIR\audio\mouse2.wav"
  Delete "$INSTDIR\audio\nightengale.wav"
  Delete "$INSTDIR\audio\ohhh.wav"
  Delete "$INSTDIR\audio\pigeon.wav"
  Delete "$INSTDIR\audio\plink.wav"
  Delete "$INSTDIR\audio\quake3.wav"
  Delete "$INSTDIR\audio\rocksmash.wav"
  Delete "$INSTDIR\audio\shock.wav"
  Delete "$INSTDIR\audio\shutdowninprocess.wav"
  Delete "$INSTDIR\audio\Snare1.wav"
  Delete "$INSTDIR\audio\sparrow.wav"
  Delete "$INSTDIR\audio\START.wav"
  Delete "$INSTDIR\audio\superior.wav"
  Delete "$INSTDIR\audio\throw.wav"
  Delete "$INSTDIR\audio\uproot.wav"
  Delete "$INSTDIR\audio\waterdrop.wav"
  Delete "$INSTDIR\audio\watersplash.wav"
  Delete "$INSTDIR\audio\watersploosh.wav"
  Delete "$INSTDIR\audio\whodaman.wav"
  Delete "$INSTDIR\audio\Zwarble.wav"
  Delete "$INSTDIR\audio\tiger.wav"
  Delete "$INSTDIR\audio\quack.wav"
  Delete "$INSTDIR\audio\duckling.wav"
  Delete "$INSTDIR\audio\*.*"
  RMDir "$INSTDIR\audio" ; only delete if empty

; Models
  Delete "$INSTDIR\models\asteroid.3ds"
  Delete "$INSTDIR\models\beacon.3ds"
  Delete "$INSTDIR\models\bird-1.3ds"
  Delete "$INSTDIR\models\bird-2.3ds"
  Delete "$INSTDIR\models\bird-3.3ds"
  Delete "$INSTDIR\models\bird-4.3ds"
  Delete "$INSTDIR\models\birddead.3ds"
  Delete "$INSTDIR\models\bird-sit.3ds"
  Delete "$INSTDIR\models\newtree.3ds"
  Delete "$INSTDIR\models\cloud.3ds"
  Delete "$INSTDIR\models\crab.3ds"
  Delete "$INSTDIR\models\dynamite.3ds"
  Delete "$INSTDIR\models\fish.3ds"
  Delete "$INSTDIR\models\fruit.3ds"
  Delete "$INSTDIR\models\grassblade.3ds"
  Delete "$INSTDIR\models\grazer.3ds"
  Delete "$INSTDIR\models\hawk.3ds"
  Delete "$INSTDIR\models\orangetree.3ds"
  Delete "$INSTDIR\models\rain.3ds"
  Delete "$INSTDIR\models\seed.3ds"
  Delete "$INSTDIR\models\shark.3ds"
  Delete "$INSTDIR\models\spirit.3ds"
  Delete "$INSTDIR\models\terrier.3ds"
  Delete "$INSTDIR\models\turtle.3ds"
  Delete "$INSTDIR\models\tyranno.3ds"
  Delete "$INSTDIR\models\weapon.3ds"
  Delete "$INSTDIR\models\iceberg.3ds"
  Delete "$INSTDIR\models\duck.3ds"
  Delete "$INSTDIR\models\dolphin1.3ds"
  Delete "$INSTDIR\models\dolphin2.3ds"
  Delete "$INSTDIR\models\dolphin3.3ds"
  Delete "$INSTDIR\models\aquaplant.3ds"
  Delete "$INSTDIR\models\ladybug.3ds"
  Delete "$INSTDIR\models\ant.3ds"
  Delete "$INSTDIR\models\ant2.3ds"
  Delete "$INSTDIR\models\ant3.3ds"
  Delete "$INSTDIR\models\appletree.3ds"
  Delete "$INSTDIR\models\defence.3ds"
  Delete "$INSTDIR\models\*.*"
  RMDIR "$INSTDIR\models" ; only delete if empty

; Textures
  Delete "$INSTDIR\textures\alltex.bmp"
  Delete "$INSTDIR\textures\sunfire.bmp"
  Delete "$INSTDIR\textures\moonshine.bmp"
  Delete "$INSTDIR\textures\highlighter.bmp"
  Delete "$INSTDIR\textures\cloud-tex.bmp"
  Delete "$INSTDIR\textures\glacier.bmp"
  Delete "$INSTDIR\textures\beachball.JPG"
  Delete "$INSTDIR\textures\soccer.JPG"
  Delete "$INSTDIR\textures\rock.JPG"
  Delete "$INSTDIR\textures\*.*"
  RMDir "$INSTDIR\textures" ; only delete if empty

; Photos
  Delete "$INSTDIR\photos\*.*"
  RMDir "$INSTDIR\photos" ; only delete if empty

; Worlds
  Delete "$INSTDIR\worlds\*.*"
  RMDir "$INSTDIR\worlds" ; only delete if empty

; Manual
  Delete "$INSTDIR\manual\*.*"
  RMDir "$INSTDIR\manual" ; only delete if empty
; Images
  Delete "$INSTDIR\images\*.*"
  RMDir "$INSTDIR\images" ; only delete if empty

; Data
  Delete "$INSTDIR\data\ladybug.ini"
  Delete "$INSTDIR\data\fox.ini"
  Delete "$INSTDIR\data\rabbit.ini"
  Delete "$INSTDIR\data\evolving tree.ini"
  Delete "$INSTDIR\data\evolving fruit.ini"
  Delete "$INSTDIR\data\evolving seed.ini"
  Delete "$INSTDIR\data\*.*"
  RMDir "$INSTDIR\data" ; only delete if empty

  Delete "$INSTDIR\Readme.txt"
  Delete "$INSTDIR\changes.txt"
  Delete "$INSTDIR\gpl.txt" 
  Delete "$INSTDIR\construction.log"
  Delete "$INSTDIR\bass.dll" 
  Delete "$INSTDIR\main.BMP"

  Delete "$INSTDIR\aiplanet.exe"
  Delete "$INSTDIR\uinst-aiplanet.exe"
  Delete "$INSTDIR\*.*"
  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\${MUI_PRODUCT}"
  
  ;Display the Finish header
  !insertmacro MUI_UNFINISHHEADER

SectionEnd

Function .onInit
  FindWindow $0 "TfmReality" "ai.planet"
    IsWindow $0 0 done
      MessageBox MB_OKCANCEL|MB_TOPMOST|MB_ICONEXCLAMATION "ai.planet is currently running!$\nClick OK to have ai.planet closed, or Cancel to quit the install" IDOK killaiplanet IDCANCEL quitme
  quitme:
    abort
  killaiplanet:
    SendMessage $0 16 0 0 
  done:
FunctionEnd


Function un.onInit
  FindWindow $0 "TfmReality" "ai.planet"
    IsWindow $0 0 done
      MessageBox MB_OKCANCEL|MB_TOPMOST|MB_ICONEXCLAMATION "ai.planet is currently running!$\nClick OK to have ai.planet closed, or Cancel to quit the uninstall" IDOK killaiplanet IDCANCEL quitme
  quitme:
    abort
  killaiplanet:
    SendMessage $0 16 0 0 
  done:
FunctionEnd