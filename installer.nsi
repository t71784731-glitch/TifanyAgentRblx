; =====================================================
; NovaAgent - Instalador de Windows (version tolerante)
; Sin icono personalizado, sin carpetas opcionales,
; sin permisos de administrador.
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

; ----- Paginas del asistente -----
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\NovaAgent.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Iniciar NovaAgent ahora"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "Spanish"

; ----- Instalacion -----
Section "Instalar"
    SectionIn RO

    ; El ejecutable (siempre existe tras PyInstaller)
    SetOutPath $INSTDIR
    File "..\dist\NovaAgent.exe"

    ; Configuracion: solo si existe en el repositorio
    !if /FileExists "..\config\config.example.json"
        SetOutPath "$INSTDIR\config"
        File /r "..\config\*"
    !endif

    ; Carpetas de datos del usuario (modelos y logs)
    CreateDirectory "$APPDATA\NovaAgent\models"
    CreateDirectory "$APPDATA\NovaAgent\logs"

    ; Accesos directos (Menu Inicio y Escritorio)
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

    ; Desinstalador
    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

; ----- Desinstalacion -----
Section "Uninstall"
    RMDir /r "$INSTDIR"
    Delete "$DESKTOP\NovaAgent.lnk"
    Delete "$SMPROGRAMS\NovaAgent\NovaAgent.lnk"
    Delete "$SMPROGRAMS\NovaAgent\Desinstalar.lnk"
    RMDir "$SMPROGRAMS\NovaAgent"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\NovaAgent"
    DeleteRegKey HKCU "Software\NovaAgent"
SectionEnd

; ----- Comprobacion inicial -----
Function .onInit
    ${IfNot} ${RunningX64}
        MessageBox MB_ICONSTOP "NovaAgent requiere Windows de 64 bits."
        Abort
    ${EndIf}
FunctionEnd
