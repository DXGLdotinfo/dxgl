; DXGL
; Copyright (C) 2011-2019 William Feely

; This library is free software; you can redistribute it and/or
; modify it under the terms of the GNU Lesser General Public
; License as published by the Free Software Foundation; either
; version 2.1 of the License, or (at your option) any later version.

; This library is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
; Lesser General Public License for more details.

; You should have received a copy of the GNU Lesser General Public
; License along with this library; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA


SetCompressor /SOLID lzma
!ifdef NSIS_PACKEDVERSION
  ManifestSupportedOS all
  ManifestDPIAware true
!endif

!include 'WinVer.nsh'
!include 'LogicLib.nsh'
!include "WordFunc.nsh"
!include 'x64.nsh'

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "DXGL"
!define PRODUCT_PUBLISHER "William Feely"
!define PRODUCT_WEB_SITE "https://dxgl.org/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\dxglcfg.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!include "..\common\version.nsh"

!if ${COMPILER} == "VC2019_2"
!ifdef _DEBUG
!define SRCDIR "Debug VS2019"
!else
!define SRCDIR "Release VS2019"
!endif
!else
!ifdef _DEBUG
!define SRCDIR "Debug"
!else
!define SRCDIR "Release"
!endif
!endif

; MUI2
!define MUI_BGCOLOR "SYSCLR:Window"
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\common\dxgl48.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "..\COPYING.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\dxglcfg.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Configure DXGL"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\ReadMe.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

!define HKEY_CURRENT_USER 0x80000001
!define RegOpenKeyEx     "Advapi32::RegOpenKeyEx(i, t, i, i, *i) i"
!define RegQueryValueEx  "Advapi32::RegQueryValueEx(i, t, i, *i, i, *i) i"
!define RegCloseKey      "Advapi32::RegCloseKey(i) i"
!define REG_MULTI_SZ     7
!define INSTPATH         "InstallPaths"
!define KEY_QUERY_VALUE          0x0001
!define KEY_ENUMERATE_SUB_KEYS   0x0008
!define ROOT_KEY         ${HKEY_CURRENT_USER}
!define GetVersion       "Kernel32::GetVersion() i"

!if ${COMPILER} == "VC2010"
!define download_runtime 1
!define runtime_url "http://www.dxgl.org/download/runtimes/vc10/vcredist_x86.exe"
!define runtime_name "Visual C++ 2010"
!define runtime_filename "vcredist_x86.exe"
!define runtime_sha512 "D2D99E06D49A5990B449CF31D82A33104A6B45164E76FBEB34C43D10BCD25C3622AF52E59A2D4B7F5F45F83C3BA4D23CF1A5FC0C03B3606F42426988E63A9770"
!define runtime_regkey SOFTWARE\Microsoft\VisualStudio\10.0\VC\VCRedist\x86
!define runtime_regvalue Installed
!define PRODUCT_SUFFIX "-msvc10"
!else if ${COMPILER} == "VC2013"
!define download_runtime 1
!define runtime_url "http://www.dxgl.org/download/runtimes/vc12/vcredist_x86.exe"
!define runtime_name "Visual C++ 2013"
!define runtime_filename "vcredist_x86.exe"
!define runtime_sha512 "729251371ED208898430040FE48CABD286A5671BD7F472A30E9021B68F73B2D49D85A0879920232426B139520F7E21321BA92646985216BF2F733C64E014A71D"
!define runtime_regkey SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0\RuntimeMinimum
!define runtime_regvalue Install
!define PRODUCT_SUFFIX "-msvc12"
!else if ${COMPILER} == "VC2019_2"
!define download_runtime 1
!define runtime_url http://www.dxgl.org/download/runtimes/vc14.22/vc_redist.x86.exe
!define runtime_name "Visual C++ 2019.2"
!define runtime_filename "vc_redist.x86.exe"
!define runtime_sha512 "9E023DD1258B20D3DD29EB3858282D5E99F86DC980BECB044A867A0AA8C5210EEBB426B3F7D574C3E10B58A72436C7E360C644A64F5653F19AD28B9C96ECD183"
!define runtime_regkey SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum
!define runtime_regvalue Install
!define runtime_regvalue2 Version
!define PRODUCT_SUFFIX ""
!else
!define download_runtime 0
!endif

!addplugindir "..\${SRCDIR}"

!ifdef _DEBUG
Name "${PRODUCT_NAME} ${PRODUCT_VERSION} DEBUG BUILD"
!else
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
!endif
!ifdef _BETA
!ifdef _DEBUG
OutFile "DXGL-${PRODUCT_VERSION}-Pre-${PRODUCT_REVISION}-win32-Debug${PRODUCT_SUFFIX}.exe"
!else
OutFile "DXGL-${PRODUCT_VERSION}-Pre-${PRODUCT_REVISION}-win32${PRODUCT_SUFFIX}.exe"
!endif
!else
!ifdef _DEBUG
OutFile "DXGL-${PRODUCT_VERSION}-win32-Debug${PRODUCT_SUFFIX}.exe"
!else
OutFile "DXGL-${PRODUCT_VERSION}-win32${PRODUCT_SUFFIX}.exe"
!endif
!endif
InstallDir "$PROGRAMFILES\DXGL"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

VIProductVersion "${PRODUCT_VERSION}.${PRODUCT_REVISION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "DXGL ${PRODUCT_VERSION} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "InternalName" "DXGL"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright � 2011-2019 William Feely"
VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "DXGL-${PRODUCT_VERSION}-win32.exe"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "DXGL"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${PRODUCT_VERSION}"

Section "DXGL Components (required)" SEC01
  SectionIn RO
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  Delete "$INSTDIR\dxgltest.exe"
  CreateDirectory "$SMPROGRAMS\DXGL"
  Delete "$SMPROGRAMS\DXGL\DXGL Test.lnk"
  File "..\${SRCDIR}\dxglcfg.exe"
  CreateShortCut "$SMPROGRAMS\DXGL\Configure DXGL.lnk" "$INSTDIR\dxglcfg.exe"
  File "..\${SRCDIR}\ddraw.dll"
  File /oname=ReadMe.txt "..\ReadMe.md"
  File "..\ThirdParty.txt"
  CreateShortCut "$SMPROGRAMS\DXGL\Third-party Credits.lnk" "$INSTDIR\ThirdParty.txt"
  File "..\COPYING.txt"
  File "..\Help\dxgl.chm"
  CreateShortCut "$SMPROGRAMS\DXGL\DXGL Help.lnk" "$INSTDIR\dxgl.chm"
  File "..\dxgl-example.ini"
  CreateShortCut "$SMPROGRAMS\DXGL\Example configuration file.lnk" "$INSTDIR\dxgl-example.ini"
  WriteRegStr HKLM "Software\DXGL" "InstallDir" "$INSTDIR"
SectionEnd

!ifndef _DEBUG
!if ${download_runtime} >= 1
Section "Download ${runtime_name} Redistributable" SEC_VCREDIST
  vcdownloadretry:
  DetailPrint "Downloading ${runtime_name} Runtime"
  NSISdl::download ${runtime_url} $TEMP\${runtime_filename}
  DetailPrint "Checking ${runtime_name} Runtime"
  dxgl-nsis::CalculateSha512Sum $TEMP\${runtime_filename} ${runtime_sha512}
  Pop $0
  ${If} $0 == "0"
    MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "Failed to download ${runtime_name} Redistributable.  Would you like to retry?" IDYES vcdownloadretry
    Delete $TEMP\vcredist_x86.exe
  ${Else}
    DetailPrint "Installing ${runtime_name} Runtime"
    ExecWait '"$TEMP\${runtime_filename}" /q /norestart' $0
	${If} $0 != "0"
	  ${If} $0 == "3010"
	  SetRebootFlag true
	  goto vcinstallcomplete
	  ${Else}
	  MessageBox MB_OK|MB_ICONSTOP "Failed to install ${runtime_name} Redistributable.  Click OK to attempt manual installation."
	  ${EndIf}
    ${Else}
	goto vcinstallcomplete
	${EndIf}
	ExecWait '"$TEMP\${runtime_filename}"'
	vcinstallcomplete:
    Delete $TEMP\${runtime_filename}
  ${EndIf}
SectionEnd
!endif
!endif

Section -PostInstall
  ExecWait '"$INSTDIR\dxglcfg.exe" upgrade'
  ExecWait '"$INSTDIR\dxglcfg.exe" profile_install'
SectionEnd

Section "Set Wine DLL Overrides" SEC_WINEDLLOVERRIDE
  DetailPrint "Setting Wine DLL Overrides"
  WriteRegDWORD HKLM "Software\DXGL" "WineDLLOverride" 1
  WriteRegStr HKCU "Software\Wine\DllOverrides" "ddraw" "native,builtin"
SectionEnd

Section "Fix DDraw COM registration" SEC_COMFIX
  DetailPrint "Setting DDraw Runtime path in registry"
  WriteRegDWORD HKLM "Software\DXGL" "COMFix" 1
  ${If} ${RunningX64}
  SetRegView 32
  ${EndIf}
  WriteRegStr HKCU "Software\Classes\CLSID\{D7B70EE0-4340-11CF-B063-0020AFC2CD35}\InprocServer32" "" "ddraw.dll"
  WriteRegStr HKCU "Software\Classes\CLSID\{D7B70EE0-4340-11CF-B063-0020AFC2CD35}\InprocServer32" "ThreadingModel" "Both"
  WriteRegStr HKCU "Software\Classes\CLSID\{3C305196-50DB-11D3-9CFE-00C04FD930C5}\InprocServer32" "" "ddraw.dll"
  WriteRegStr HKCU "Software\Classes\CLSID\{3C305196-50DB-11D3-9CFE-00C04FD930C5}\InprocServer32" "ThreadingModel" "Both"
  WriteRegStr HKCU "Software\Classes\CLSID\{593817A0-7DB3-11CF-A2DE-00AA00B93356}\InprocServer32" "" "ddraw.dll"
  WriteRegStr HKCU "Software\Classes\CLSID\{593817A0-7DB3-11CF-A2DE-00AA00B93356}\InprocServer32" "ThreadingModel" "Both"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\DXGL\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\DXGL\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\dxglcfg.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\dxglcfg.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd



Function .onInit
  !if ${COMPILER} == "VC2019_2"
  dxgl-nsis::CheckSSE2 $0
  Pop $0
  ${If} $0 == "0"
    MessageBox MB_OK|MB_ICONSTOP "This version of DXGL requires a processor with SSE2 capability.$\r\
	Please download the legacy build to use DXGL on your system."
	Quit
  ${EndIf}
  ${IfNot} ${AtLeastWinVista}
    MessageBox MB_OK|MB_ICONSTOP "This version of DXGL requires at least Windows Vista Service Pack 2.$\r\
	If you need to run DXGL on Windows XP, XP x64, or Server 2003, please download the legacy build."
	Quit
  ${EndIf}
  ${If} ${IsWinVista}
  ${AndIfNot} ${AtLeastServicePack} 2
    MessageBox MB_OK|MB_ICONSTOP "Your copy of Windows Vista or Windows Server 2008 must be upgraded to Service Pack 2 before you can use this version of DXGL.$\r\
	Please visit https://support.microsoft.com/en-us/kb/948465/ for instructions on upgrading to Service Pack 2."
	Quit
  ${endif}
  ${If} ${IsWin7}
  ${AndIfNot} ${AtLeastServicePack} 1
    MessageBox MB_OK|MB_ICONSTOP "Your copy of Windows 7 or Windows Server 2008 R2 must be upgraded to Service Pack 1 before you can use this version of DXGL.$\r\
	Please visit https://support.microsoft.com/en-us/kb/976932/ for instructions on upgrading to Service Pack 1."
	Quit
  ${endif}
  !else
  ${IfNot} ${AtleastWinXP}
    MessageBox MB_OK|MB_ICONSTOP "This version of DXGL requires at least Windows XP Service Pack 3."
	Quit
  ${EndIf}
  ${If} ${IsWinXP}
  ${AndIfNot} ${AtLeastServicePack} 3
  ${AndIfNot} ${RunningX64}
    MessageBox MB_OK|MB_ICONSTOP "Your copy of Windows XP must be upgraded to Service Pack 3 before you can use DXGL.$\r\
	Please visit http://web.archive.org/web/20151010042325/https://support.microsoft.com/en-us/kb/322389/ for instructions on upgrading to Service Pack 3."
	Quit
  ${EndIf}
  ${If} ${IsWin2003}
  ${AndIfNot} ${AtLeastServicePack} 1
    MessageBox MB_OK|MB_ICONSTOP "Your copy of Windows Server 2003 must be upgraded to at least Service Pack 1 before you can use DXGL.$\r\
	Please visit http://web.archive.org/web/20150501080245/https://support.microsoft.com/en-us/kb/889100/ for instructions on upgrading to Service Pack 2."
	Quit
  ${EndIf}
  !endif
  !ifdef _DEBUG
  MessageBox MB_OK|MB_ICONEXCLAMATION "This is a debug build of DXGL.  It is not meant for regular \
  usage and requires the debug version of the Visual C++ runtime to work.$\r$\r\
  The debug runtime for Visual C++ is non-redistributable, as are executable files generated by compiling \
  in debug mode.  For more information please visit https://msdn.microsoft.com/en-us/library/aa985618.aspx$\r\
  If you downloaded this file, please immediately report this to admin@www.williamfeely.info"
  !else
  !if ${download_runtime} >= 1
  ReadRegDWORD $0 HKLM ${runtime_regkey} ${runtime_regvalue}
  !if ${COMPILER} == "VC2019_2"
  StrCmp $0 1 skipvcredist1
  goto vcinstall
  skipvcredist1:
  ReadRegDWORD $0 HKLM ${runtime_regkey} ${runtime_regvalue2}
  ${VersionCompare} "$0" "14.22.27821" $1
  ${If} $1 == 0
    goto skipvcredist
  ${EndIf}
  ${If} $1 == 1
    goto skipvcredist
  ${EndIf}
  goto vcinstall
  !else
  StrCmp $0 1 skipvcredist
  goto vcinstall
  !endif
  skipvcredist:
  SectionSetFlags ${SEC_VCREDIST} 0
  SectionSetText ${SEC_VCREDIST} ""
  vcinstall:
  !endif
  !endif
  
  System::Call "${GetVersion} () .r0"
  IntOp $1 $0 & 255
  IntOp $2 $0 >> 8
  IntOp $2 $2 & 255
  IntCmp $1 6 CheckMinor BelowEight EightOrAbove
  CheckMinor:
  IntCmp $2 2 EightOrAbove BelowEight EightOrAbove
  EightOrAbove:
  SectionSetText ${SEC_COMFIX} "Fix DDraw COM registration (recommended)"
  goto VersionFinish
  BelowEight:
  SectionSetFlags ${SEC_COMFIX} 0
  VersionFinish:
  dxgl-nsis::IsWine $0
  Pop $0
  ${If} $0 == "0"
    SectionSetFlags ${SEC_WINEDLLOVERRIDE} 0
	SectionSetText ${SEC_WINEDLLOVERRIDE} ""
  ${EndIf}
FunctionEnd

LangString DESC_SEC01 ${LANG_ENGLISH} "Installs the required components for DXGL."
LangString DESC_SEC_VCREDIST ${LANG_ENGLISH} "The Visual C++ Redistributable package required for this version of DXGL was not detected.  Selecting this will download a copy of the redistributable hosted on dxgl.org and install it."
LangString DESC_SEC_WINEDLLOVERRIDE ${LANG_ENGLISH} "Sets a DLL override in Wine to allow DXGL to be used."
LangString DESC_SEC_COMFIX ${LANG_ENGLISH} "Adjusts the COM registration of ddraw.dll to allow DXGL to be used from a game's folder.  This option only applies to the user profile being used to install DXGL.  Use for Windows 8 and above."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC01} $(DESC_SEC01)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_VCREDIST} $(DESC_SEC_VCREDIST)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_WINEDLLOVERRIDE} $(DESC_SEC_WINEDLLOVERRIDE)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_COMFIX} $(DESC_SEC_COMFIX)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  MessageBox MB_YESNO "Do you want to remove all application profiles?" IDYES wipeprofile IDNO nowipeprofile
  wipeprofile:
  ExecWait '"$INSTDIR\dxglcfg.exe" uninstall 1'
  goto finishuninstall
  nowipeprofile:
  ExecWait '"$INSTDIR\dxglcfg.exe" uninstall 0'
  finishuninstall:
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\COPYING.txt"
  Delete "$INSTDIR\ThirdParty.txt"
  Delete "$INSTDIR\ReadMe.txt"
  Delete "$INSTDIR\ddraw.dll"
  Delete "$INSTDIR\dxglcfg.exe"
  Delete "$INSTDIR\dxgltest.exe"
  Delete "$INSTDIR\dxgl.chm"
  Delete "$INSTDIR\dxgl-example.ini"

  Delete "$SMPROGRAMS\DXGL\Uninstall.lnk"
  Delete "$SMPROGRAMS\DXGL\Website.lnk"
  Delete "$SMPROGRAMS\DXGL\Configure DXGL.lnk"
  Delete "$SMPROGRAMS\DXGL\DXGL Test.lnk"

  RMDir "$SMPROGRAMS\DXGL"
  RMDir "$INSTDIR"

  ReadRegDWORD $0 HKLM "Software\DXGL" "WineDLLOverride"
  ${If} $0 == "1"
    DeleteRegValue HKCU "Software\Wine\DllOverrides" "ddraw"
  ${EndIf}

  ReadRegDWORD $1 HKLM "Software\DXGL" "COMFix"
  ${If} $1 == "1"
    SetRegView 32
    DeleteRegKey HKCU "Software\Classes\CLSID\{D7B70EE0-4340-11CF-B063-0020AFC2CD35}"
    DeleteRegKey HKCU "Software\Classes\CLSID\{3C305196-50DB-11D3-9CFE-00C04FD930C5}"
	DeleteRegKey HKCU "Software\Classes\CLSID\{593817A0-7DB3-11CF-A2DE-00AA00B93356}"
  ${EndIf}

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "Software\DXGL"
  SetAutoClose true
SectionEnd

!if ${SIGNTOOL} == 1
!finalize 'signtool sign /t http://timestamp.comodoca.com %1'
!if ${COMPILER} == "VC2019_2"
!finalize 'signtool sign /tr http://timestamp.comodoca.com /td sha256 /fd sha256 /as %1'
!endif
!endif