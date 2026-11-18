# -*- mode: python ; coding: utf-8 -*-
# NovaAgent - Spec tolerante a carpetas faltantes
import sys
from pathlib import Path

PROJECT_DIR = Path(SPECPATH).parent

block_cipher = None

# Solo incluir carpetas que existan realmente en el repositorio
datas = []
for folder in ['config', 'docs', 'assets']:
    if (PROJECT_DIR / folder).is_dir():
        datas.append((folder, folder))

# Icono opcional: si no existe, se compila sin icono
icon_path = PROJECT_DIR / 'assets' / 'icon.ico'
icon_value = str(icon_path) if icon_path.exists() else None

a = Analysis(
    ['main.py'],
    pathex=[str(PROJECT_DIR)],
    binaries=[],
    datas=datas,
    hiddenimports=[
        'PySide6.QtCore',
        'PySide6.QtGui',
        'PySide6.QtWidgets',
        'llama_cpp',
        'novaagent',
        'novaagent.engine',
        'novaagent.engine.llm_engine',
        'novaagent.engine._engine_impl',
        'novaagent.engine.model_downloader',
        'novaagent.ui',
        'novaagent.ui.desktop_app',
        'novaagent.ui._desktop_impl',
        'novaagent.core',
        'novaagent.utils',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['tkinter', 'unittest', 'pytest', 'IPython', 'jupyter', 'notebook'],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='NovaAgent',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=icon_value,
)
