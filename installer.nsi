; NovaAgent - Instalador simple y robusto
!include "MUI2.nsh"

Name "NovaAgent"
OutFile "NovaAgent-Setup-1.0.0.exe"
InstallDir "$LOCALAPPDATA\NovaAgent"
RequestExecutionLevel user

!define VERSION "1.0.0"
!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\NovaAgent.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Iniciar NovaAgent ahora"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "Spanish"

Section "Instalar"
    SectionIn RO
    SetOutPath $INSTDIR
    File "dist\NovaAgent.exe"

    CreateDirectory "$APPDATA\NovaAgent\models"
    CreateDirectory "$APPDATA\NovaAgent\logs"

    CreateDirectory "$SMPROGRAMS\NovaAgent"
    CreateShortcut "$SMPROGRAMS\NovaAgent\NovaAgent.lnk" "$INSTDIR\NovaAgent.exe"
    CreateShortcut "$SMPROGRAMS\NovaAgent\Desinstalar.lnk" "$INSTDIR\Uninstall.exe"
    CreateShortcut "$DESKTOP\NovaAgent.lnk" "$INSTDIR\NovaAgent.exe"

    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "DisplayName" "NovaAgent ${VERSION}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "DisplayVersion" "${VERSION}"

    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
    RMDir /r "$INSTDIR"
    Delete "$DESKTOP\NovaAgent.lnk"
    Delete "$SMPROGRAMS\NovaAgent\NovaAgent.lnk"
    Delete "$SMPROGRAMS\NovaAgent\Desinstalar.lnk"
    RMDir "$SMPROGRAMS\NovaAgent"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent"
SectionEnd
