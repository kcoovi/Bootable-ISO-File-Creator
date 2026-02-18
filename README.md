# 💿 Bootable ISO File Creator

A lightweight Windows GUI tool for creating bootable ISO files from any folder — powered by PowerShell and Microsoft's `oscdimg.exe`.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Features

- **Simple GUI** — No command-line knowledge needed. Browse, name, and create.
- **Drag-and-drop** — Drop folders directly onto the Source and Output fields from Explorer.
- **Auto-detection** — Automatically locates `oscdimg.exe` from the Windows ADK installation.
- **Custom oscdimg path** — Optionally specify a custom `oscdimg.exe` location if it's not in the default ADK paths.
- **Boot sector support** — Optionally specify a custom boot sector file, or let the tool auto-detect `boot\etfsboot.com` inside your source folder.
- **Real progress tracking** — Marquee progress bar animates during the actual ISO creation process.
- **Robust error handling** — Checks `oscdimg` exit codes and displays specific error messages on failure.
- **Overwrite protection** — Prompts before overwriting an existing ISO file.
- **Open output folder** — One-click button to open the output directory after creation.

---

## Prerequisites

1. **Windows OS** (Windows 10/11 recommended)
2. **Windows ADK Deployment Tools** — The tool relies on `oscdimg.exe`, which is included with the [Windows Assessment and Deployment Kit (ADK)](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install).
   - During ADK installation, ensure you select **Deployment Tools**.
   - The tool searches for `oscdimg.exe` in the default install paths:
     ```
     C:\Program Files (x86)\Windows Kits\10\...\amd64\Oscdimg\oscdimg.exe
     C:\Program Files (x86)\Windows Kits\10\...\x86\Oscdimg\oscdimg.exe
     ```
   - Alternatively, you can specify a custom `oscdimg.exe` path directly in the GUI.

---

##  Usage

### 1. Launch the tool

Right-click `ISOCreator.ps1` and select **Run with PowerShell**, or run from a terminal:

```powershell
powershell -ExecutionPolicy Bypass -File .\ISOCreator.ps1
```

### 2. Fill in the fields

You can type paths manually, use the **Browse** buttons, or **drag-and-drop** folders from Explorer onto the Source/Output fields.

| Field                            | Description                                                             |
| -------------------------------- | ----------------------------------------------------------------------- |
| **Source Folder**                 | The folder containing the files to include in the ISO.                  |
| **Output Folder**                | Where the generated `.iso` file will be saved.                          |
| **ISO Name**                     | The filename for the ISO (`.iso` extension is added automatically).     |
| **Boot Sector File** *(opt)*     | Path to a boot sector file (e.g. `etfsboot.com`). Auto-detected if present in `source\boot\`. |
| **oscdimg.exe Path** *(opt)*     | Custom path to `oscdimg.exe`. Falls back to auto-detection if left blank. |

### 3. Create

Click **Create ISO**. A marquee progress bar animates while the ISO is being built. Once complete, use **Open Folder** to jump straight to your new ISO.

---

## Project Structure

```
Bootable-ISO-File-Creator/
├── .gitignore       # Git ignore rules
├── ISOCreator.ps1   # Main application script
├── LICENSE          # MIT License
└── README.md        # This file
```

---

## How It Works

Under the hood, the script calls Microsoft's `oscdimg.exe` with the following flags:

| Flag    | Purpose                                     |
| ------- | ------------------------------------------- |
| `-n`    | Allows long file names                      |
| `-m`    | Ignores the maximum ISO image size limit     |
| `-b`    | Specifies the boot sector file (when provided) |

---

## License

This project is open source and available under the [MIT License](LICENSE).
