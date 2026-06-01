; ============================================================================
; ElectroSim-DunnECASA Suite — Windows installer
; Inno Setup script (compile with ISCC.exe — https://jrsoftware.org/isinfo.php)
; ============================================================================
;
; This installer is tuned for non-technical end users. It deliberately:
;   • installs per-user under %LocalAppData% (NO admin / UAC prompt)
;   • skips the license, info, ready, and tasks pages
;   • picks the install location automatically (no directory chooser)
;   • makes the Streamlit/PyWebView hybrid the single user-facing app
;     (Tkinter is shipped alongside as a Start-Menu fallback only)
;   • always creates a Desktop shortcut (no opt-in question)
;   • auto-launches the app on Finish
;
; Net result: the user sees Welcome → Installing → Finish (3 screens).
;
; Build prerequisites
; -------------------
;   1. Build both PyInstaller bundles from the project root:
;        pyinstaller ElectroSim-DunnECASA-Suite.spec         --noconfirm
;        pyinstaller ElectroSim-DunnECASA-Suite-Tkinter.spec --noconfirm
;
;      This produces:
;        dist\ElectroSim-DunnECASA-Suite\
;        dist\ElectroSim-DunnECASA-Suite-Tkinter\
;
;   2. Install Inno Setup 6 from https://jrsoftware.org/isdl.php (free, OSS).
;
;   3. From the project root, compile this script:
;        "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" release\installer\electrosim_setup.iss
;
;      Output: release\installer\Output\ElectroSim-DunnECASA-Suite-Setup-2.0.exe
;
; What the installer does (user-visible)
; --------------------------------------
;   • Installs under %LocalAppData%\Programs\ElectroSim-DunnECASA Suite\
;     (no admin / UAC prompt; works on locked-down lab PCs).
;   • Creates ONE Desktop shortcut → "ElectroSim-DunnECASA Suite"
;     (hybrid build — what the README calls "recommended").
;   • Creates a Start Menu folder with: the main app, a Tkinter-fallback
;     shortcut, the User Guide, the Sample Data folder, and Uninstall.
;   • Bundles LICENSE, NOTICE, README, CHANGELOG, CITATION, sample_data,
;     and docs at the install root.
;   • Registers in Add/Remove Programs with full metadata.
;
; ============================================================================

#define MyAppName       "ElectroSim-DunnECASA Suite"
#define MyAppVersion    "2.0"
#define MyAppPublisher  "Rajeev Kumar, North Carolina Central University"
#define MyAppURL        "https://github.com/rajeev4187/ElectroSim-DunnECASA-Suite"
#define MyAppSupportURL "https://github.com/rajeev4187/ElectroSim-DunnECASA-Suite/issues"
#define MyAppExeHybrid  "ElectroSim-DunnECASA-Suite.exe"
#define MyAppExeTk      "ElectroSim-DunnECASA-Suite-Tkinter.exe"

; Paths to the PyInstaller bundles, relative to the project root.
; (ISCC's working dir is whatever the user `cd`s into before running it; the
; relative paths below assume the script is invoked from the project root.)
#define DistHybridDir   "..\..\dist\ElectroSim-DunnECASA-Suite"
#define DistTkDir       "..\..\dist\ElectroSim-DunnECASA-Suite-Tkinter"

; Auxiliary content (release/ folder is one level up from release\installer\)
#define ReleaseLicense  "..\LICENSE"
#define ReleaseNotice   "..\NOTICE"
#define ReleaseReadme   "..\README.md"
#define ReleaseChangelog "..\CHANGELOG.md"
#define ReleaseCitation "..\CITATION.cff"
#define ReleaseSampleData "..\sample_data\*"
#define ReleaseDocs     "..\docs\*"

[Setup]
; AppId is a stable GUID — DO NOT change between releases, otherwise the
; installer treats new versions as a separate product and won't upgrade.
AppId={{8E3A4F71-2C6B-4A1B-9C3D-7E5F8B2A9D14}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppSupportURL}
AppUpdatesURL={#MyAppURL}/releases
VersionInfoVersion={#MyAppVersion}.0.0
VersionInfoProductName={#MyAppName}
VersionInfoDescription={#MyAppName} {#MyAppVersion} setup
VersionInfoCopyright=Copyright (C) 2026 Rajeev Kumar. All rights reserved.

; ---------------------------------------------------------------------------
; Per-user install: no admin prompt, no UAC dialog. Works on locked-down
; lab/student PCs where the user can't elevate.
; ---------------------------------------------------------------------------
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
PrivilegesRequired=lowest
; Don't allow the user to switch to admin install — keeps the flow deterministic.
PrivilegesRequiredOverridesAllowed=

; ---------------------------------------------------------------------------
; Skip every optional/decision page so the flow is:
;   Welcome → (auto) Installing → Finish (with Launch checkbox)
; ---------------------------------------------------------------------------
DisableWelcomePage=no
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=no
DisableStartupPrompt=yes

OutputDir=Output
OutputBaseFilename=ElectroSim-DunnECASA-Suite-Setup-{#MyAppVersion}
Compression=lzma2/ultra
SolidCompression=yes
LZMAUseSeparateProcess=yes

; 64-bit only — the PyInstaller bundles target win-amd64.
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

UninstallDisplayName={#MyAppName} {#MyAppVersion}
UninstallDisplayIcon={app}\hybrid\{#MyAppExeHybrid}

; LicenseFile / InfoBeforeFile / InfoAfterFile are deliberately NOT set —
; those pages add clicks for non-tech users. LICENSE.txt and NOTICE still
; ship in the install dir and are linked from the Start Menu folder, so the
; user can read them after install if they want.

WizardStyle=modern
ShowLanguageDialog=no

MinVersion=10.0.17763

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; [Tasks] is intentionally empty. The Desktop shortcut is always created;
; users aren't asked. Re-introduce a Tasks entry only if you have a real
; user-facing choice (e.g. "auto-start on login").

[Files]
; PyWebView/Streamlit hybrid build (the "recommended" version).
Source: "{#DistHybridDir}\{#MyAppExeHybrid}"; DestDir: "{app}\hybrid"; Flags: ignoreversion
Source: "{#DistHybridDir}\*"; DestDir: "{app}\hybrid"; Excludes: "{#MyAppExeHybrid}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Tkinter native desktop build (smaller, no Edge WebView2 needed).
Source: "{#DistTkDir}\{#MyAppExeTk}"; DestDir: "{app}\tkinter"; Flags: ignoreversion
Source: "{#DistTkDir}\*"; DestDir: "{app}\tkinter"; Excludes: "{#MyAppExeTk}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Auxiliary release files — placed at the install root for easy access.
Source: "{#ReleaseLicense}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#ReleaseNotice}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#ReleaseReadme}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#ReleaseChangelog}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#ReleaseCitation}"; DestDir: "{app}"; Flags: ignoreversion

; Sample data templates and documentation.
Source: "{#ReleaseSampleData}"; DestDir: "{app}\sample_data"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#ReleaseDocs}"; DestDir: "{app}\docs"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; ---------------------------------------------------------------------------
; Desktop: ONE shortcut → the main (hybrid) app. No user choice; always
; created. The Tkinter build is reachable from Start Menu only — it's a
; fallback, not the primary entry point.
; ---------------------------------------------------------------------------
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\hybrid\{#MyAppExeHybrid}"; WorkingDir: "{app}\hybrid"; Comment: "Open the ElectroSim-DunnECASA Suite"

; ---------------------------------------------------------------------------
; Start Menu: friendly label for the main app, then a "Tools" subfolder for
; the secondary entries so the top of the menu stays uncluttered.
; ---------------------------------------------------------------------------
Name: "{autoprograms}\{#MyAppName}\{#MyAppName}"; Filename: "{app}\hybrid\{#MyAppExeHybrid}"; WorkingDir: "{app}\hybrid"; Comment: "Open the ElectroSim-DunnECASA Suite (recommended build)"
Name: "{autoprograms}\{#MyAppName}\User Guide"; Filename: "{app}\docs\user_guide.md"; Comment: "Open the user guide"
Name: "{autoprograms}\{#MyAppName}\Sample Data Folder"; Filename: "{app}\sample_data\"; Comment: "Browse sample CV templates"
Name: "{autoprograms}\{#MyAppName}\Tools\{#MyAppName} (Tkinter fallback)"; Filename: "{app}\tkinter\{#MyAppExeTk}"; WorkingDir: "{app}\tkinter"; Comment: "Lightweight Tkinter build — use if the main app fails to launch"
Name: "{autoprograms}\{#MyAppName}\Tools\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"

[Run]
; Offer to launch the hybrid build at the end of setup.
Filename: "{app}\hybrid\{#MyAppExeHybrid}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; The PyInstaller runtime occasionally writes log / cache files next to the
; .exe; clear them on uninstall so {app} can be removed cleanly.
Type: filesandordirs; Name: "{app}\hybrid\__pycache__"
Type: filesandordirs; Name: "{app}\tkinter\__pycache__"
Type: filesandordirs; Name: "{app}\*.log"
