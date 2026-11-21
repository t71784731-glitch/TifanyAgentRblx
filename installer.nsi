; =====================================================
; NovaAgent - Instalador de Windows (version corregida)
; Rutas dentro del repositorio (sin ..\)
; =====================================================
!include "MUI2.nsh"
!include "LogicLib.nsh"

Name "NovaAgent"
OutFile "NovaAgent-Setup-1.0.0.exe"
InstallDir "$LOCALAPPDATA\NovaAgent"
InstallDirRegKey HKCU "Software\NovaAgent" "InstallDir"
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

    ; El ejecutable creado por PyInstaller (carpeta dist del proyecto)
    SetOutPath $INSTDIR
    File "dist\NovaAgent.exe"

    ; Configuracion: solo si existe en el proyecto
    !if /FileExists "config\config.example.json"
        SetOutPath "$INSTDIR\config"
        File /r "config\*"
    !endif

    ; Carpetas de datos del usuario
    CreateDirectory "$APPDATA\NovaAgent\models"
    CreateDirectory "$APPDATA\NovaAgent\logs"

    ; Accesos directos
    CreateDirectory "$SMPROGRAMS\NovaAgent"
    CreateShortcut "$SMPROGRAMS\NovaAgent\NovaAgent.lnk" "$INSTDIR\NovaAgent.exe"
    CreateShortcut "$SMPROGRAMS\NovaAgent\Desinstalar.lnk" "$INSTDIR\Uninstall.exe"
    CreateShortcut "$DESKTOP\NovaAgent.lnk" "$INSTDIR\NovaAgent.exe"

    ; Registro para "Agregar o quitar programas"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "DisplayName" "NovaAgent ${VERSION}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "InstallLocation" "$INSTDIR"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent" "DisplayVersion" "${VERSION}"
    WriteRegStr HKCU "Software\NovaAgent" "InstallDir" "$INSTDIR"

    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
    RMDir /r "$INSTDIR"
    Delete "$DESKTOP\NovaAgent.lnk"
    Delete "$SMPROGRAMS\NovaAgent\NovaAgent.lnk"
    Delete "$SMPROGRAMS\NovaAgent\Desinstalar.lnk"
    RMDir "$SMPROGRAMS\NovaAgent"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent"
    DeleteRegKey HKCU "Software\NovaAgent"
SectionEnd

Function .onInit
    ${IfNot} ${RunningX64}
        MessageBox MB_ICONSTOP "NovaAgent requiere Windows de 64 bits."
        Abort
    ${EndIf}
FunctionEnd
