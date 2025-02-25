; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "LogicLib.nsh"

# Properly display all languages (Installer will not work on Windows 95, 98 or ME!)
Unicode true

; Macro Definitions
!define PRODUCT_NAME "PairMesh"
!define PRODUCT_VERSION "0.1"
!define PRODUCT_PUBLISHER "PairMesh Co.,Ltd."
!define PRODUCT_WEB_SITE "https://www.pairmesh.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\PairMesh.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define PRE_WIN10_MUST_READ_URL "https://github.com/xjasonlyu/tun2socks/issues/37"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\node\resources\icon_windows.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"


; Install Finished Settings
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION "RunIt"
!define MUI_FINISHPAGE_LINK $(LNG_PreWin10MustRead)
!define MUI_FINISHPAGE_LINK_LOCATION ${PRE_WIN10_MUST_READ_URL}

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"



; Install Pages
; Welcome page
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "OnPageWelcomeLeave"
!insertmacro MUI_PAGE_WELCOME

; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "..\node\resources\service_policy.rtf"

; Directory page
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "OnPageDirectoryLeave"
!insertmacro MUI_PAGE_DIRECTORY

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!define MUI_PAGE_CUSTOMFUNCTION_PRE PreFinish
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ShowFinish
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE LeaveFinish
!insertmacro MUI_PAGE_FINISH



; Uninstaller pages
;!insertmacro MUI_UNPAGE_WELCOME
;!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
;!insertmacro MUI_UNPAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "SimpChinese"

; Language i18s
;LangString LNG_PreWin10MustRead ${LANG_SIMPCHINESE} "Windows 10版本之前用户必读"
LangString LNG_PreWin10MustRead ${LANG_ENGLISH} "Pre-Windows 10 Must Read"

; misc
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\PairMesh_Setup.exe"
InstallDir "$PROGRAMFILES\PairMesh"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
BrandingText "Meet with Next-Gen VPN"
; MUI end ------


RequestExecutionLevel admin

; The Program
; https://stackoverflow.com/questions/46427206/how-to-detect-windows-updateor-kb-update-is-installed-or-not-using-nsis
Section "Prerequisites" SEC01
SectionEnd

Section "MainSection" SEC02
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  File "..\PairMesh.exe"
  CreateDirectory "$SMPROGRAMS\PairMesh"
  ;CreateDirectory "$INSTDIR\logs"
  CreateShortCut "$SMPROGRAMS\PairMesh\PairMesh.lnk" "$INSTDIR\PairMesh.exe"
  CreateShortCut "$DESKTOP\PairMesh.lnk" "$INSTDIR\PairMesh.exe"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\PairMesh\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\PairMesh\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -PostInstall
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\PairMesh.exe"
  ;WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "LogPath" "$INSTDIR\logs"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\PairMesh.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

SectionEnd


Section Uninstall
  ;kill proc
  ;DetailPrint "Stop the PairMesh.exe"
  nsExec::Exec "taskkill /f /im PairMesh.exe"

  ;DetailPrint "Stop & uninstall the service: PairMesh"
  ;nsExec::Exec "net stop PairMesh"
  ;nsExec::Exec '"$INSTDIR\PairMeshd.exe" uninstall-system-daemon'

  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\PairMesh.exe"
  ;Delete "$INSTDIR\PairMeshd.exe"

  Delete "$SMPROGRAMS\PairMesh\Uninstall.lnk"
  Delete "$SMPROGRAMS\PairMesh\Website.lnk"
  Delete "$DESKTOP\PairMesh.lnk"
  Delete "$SMPROGRAMS\PairMesh\PairMesh.lnk"

  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "PairMesh"
  ;IfErrors 0 +2
  ;MessageBox MB_OK "DeleteRegKey failed"

  RMDir "$SMPROGRAMS\PairMesh"

  RMDir /r "$INSTDIR\logs"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  ;DeleteRegValue HKLM "${PRODUCT_DIR_REGKEY}" "LogPath"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true

  ;todo: remove network adapter ?
SectionEnd

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onInstSuccess
FunctionEnd


Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to remove $(^Name) and its components completely?" IDYES +2
  Abort
FunctionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been successfully removed from your computer."
FunctionEnd



;https://www.cnblogs.com/crsky/p/11257543.html
Function "OnPageWelcomeLeave"
FunctionEnd

Function "OnPageDirectoryLeave"
FunctionEnd

Function RunIt
  ExecShell open "$INSTDIR\PairMesh.exe" "" SW_HIDE
FunctionEnd


Function PreFinish
FunctionEnd

Function ShowFinish
FunctionEnd

Function LeaveFinish
  ;nsExec::Exec '"$INSTDIR\PairMeshd.exe" install-system-daemon'
  ;nsExec::Exec "net start PairMesh"
FunctionEnd