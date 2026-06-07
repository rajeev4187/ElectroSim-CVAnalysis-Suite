# Quick Start — ElectroSim-CV Analysis Suite

Welcome! This page walks you through installing and opening the app for the first time. **You don't need any technical background.** The whole process takes about a minute.

---

## Step 1 — Download

1. Go to the project's **Releases** page: <https://github.com/rajeev4187/ElectroSim-CVAnalysis-Suite/releases>.
2. Under the latest release, click **`ElectroSim-CVAnalysis-Suite-Setup-2.1.exe`** to download it. The file is ~169 MB; it may take a minute.
3. The file usually lands in your **Downloads** folder.

> **Verifying the download (optional).** If you want to confirm the file wasn't corrupted or tampered with in transit, check its SHA-256 hash. In PowerShell:
>
> ```powershell
> Get-FileHash -Algorithm SHA256 $env:USERPROFILE\Downloads\ElectroSim-CVAnalysis-Suite-Setup-2.1.exe
> ```
>
> The output should match this expected hash exactly (case-insensitive):
>
> ```text
> 10A0DB7F8BCAC53C92206BBA28C99CA89FF6B4D9761043EB049F5265A6FC1294
> ```
>
> Skip this check if you don't know what hashes are — Windows will scan the file with Defender automatically.

---

## Step 2 — Run the installer

1. Open your **Downloads** folder.
2. Double-click `ElectroSim-CVAnalysis-Suite-Setup-2.1.exe`.

### If Windows shows a blue "Windows protected your PC" warning

This is normal for new applications. Windows shows it on any installer it hasn't seen many times yet.

1. Click the small text **"More info"**.
2. A new button appears: click **"Run anyway"**.

The installer will now start.

### What the installer asks

Almost nothing.

1. **Welcome** — click **Next**.
2. **Installing** — wait ~15 seconds.
3. **Finished** — leave the **"Launch ElectroSim-CV Analysis Suite"** box ticked and click **Finish**.

The app opens automatically.

---

## Step 3 — Open the app later

After installing once, you can re-open the app any time by:

- Double-clicking the **ElectroSim-CV Analysis Suite** icon on your **Desktop**, **or**
- Opening the **Start Menu** and typing `ElectroSim`.

---

## Step 4 — Load some data

The app already includes sample data so you can try it without your own files:

1. Inside the app, click **Load files…**.
2. Browse to the **`sample_data`** folder inside the install location (the Start Menu has a shortcut: **`ElectroSim-CV Analysis Suite → Sample Data Folder`**).
3. Open **`Dunn method template.xlsx`** (for Dunn's Method) or **`ECASA CV template.xlsx`** (for ECASA).
4. Switch to the analysis tab on the left (e.g. **Dunn's Method**) and click **Run analysis**.

The result appears in the same window. Use the toolbar above each plot to zoom, pan, or save as a PNG.

For a deeper walk-through of every feature, open the **User Guide** from the Start Menu folder.

---

## If the app refuses to open

1. **Try the "Tkinter" version.** Open Start Menu → `ElectroSim-CV Analysis Suite → Tools → ElectroSim-CV Analysis Suite (Tkinter fallback)`. This version is lighter and works even if the main one fails to launch.
2. **Restart your computer once** and try again — Windows occasionally needs to refresh after a new install.
3. **Still nothing?** Email <rkumar@nccu.edu> with:
   - Which Windows version you're on (press `Win` + `R`, type `winver`, press Enter — copy what the box shows).
   - Whether you saw any error message (a screenshot is perfect).
   - Whether the Tkinter fallback also fails.

---

## Uninstalling

Start Menu → `ElectroSim-CV Analysis Suite → Tools → Uninstall ElectroSim-CV Analysis Suite`. **Or:** Windows Settings → **Apps** → **Installed apps** → find **ElectroSim-CV Analysis Suite** → **Uninstall**.

The installer is per-user, so removing it does not require an administrator password.

---

## Citing the app

If you use the app for published research, please cite it — citation details are in [CITATION.cff](CITATION.cff), and the format is also shown in the **Help → About** menu inside the app.
