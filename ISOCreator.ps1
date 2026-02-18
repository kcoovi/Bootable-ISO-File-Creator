Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Function to display messages ---
function Show-Status($message, $isError=$false) {
    if ($isError) {
        $lblStatus.ForeColor = [System.Drawing.Color]::Red
        $lblStatus.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10,[System.Drawing.FontStyle]::Bold)
    } else {
        $lblStatus.ForeColor = [System.Drawing.Color]::Black
        $lblStatus.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,[System.Drawing.FontStyle]::Regular)
    }
    $lblStatus.Text = $message
}

# --- Helper: extract folder path from drag data ---
function Get-DroppedFolder($data) {
    $files = $data.GetData([System.Windows.Forms.DataFormats]::FileDrop)
    if ($files -and $files.Count -gt 0) {
        $path = $files[0]
        if (Test-Path -Path $path -PathType Container) {
            return $path
        }
    }
    return $null
}

# --- Create the main form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Universal Bootable ISO Creator"
$form.Size = New-Object System.Drawing.Size(600,500)
$form.StartPosition = "CenterScreen"
$form.AllowDrop = $true

# --- Source folder ---
$lblSource = New-Object System.Windows.Forms.Label
$lblSource.Text = "Source Folder:"
$lblSource.Location = New-Object System.Drawing.Point(10,20)
$lblSource.AutoSize = $true
$form.Controls.Add($lblSource)

$txtSource = New-Object System.Windows.Forms.TextBox
$txtSource.Location = New-Object System.Drawing.Point(120,18)
$txtSource.Size = New-Object System.Drawing.Size(350,20)
$txtSource.AllowDrop = $true
$txtSource.Add_DragEnter({
    if ($_.Data.GetDataPresent([System.Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [System.Windows.Forms.DragDropEffects]::Copy
    }
})
$txtSource.Add_DragDrop({
    $folder = Get-DroppedFolder $_.Data
    if ($folder) { $txtSource.Text = $folder; Check-Fields }
})
$form.Controls.Add($txtSource)

$btnBrowseSource = New-Object System.Windows.Forms.Button
$btnBrowseSource.Text = "Browse"
$btnBrowseSource.Location = New-Object System.Drawing.Point(480,15)
$btnBrowseSource.Add_Click({
    $folder = (New-Object System.Windows.Forms.FolderBrowserDialog)
    if($folder.ShowDialog() -eq "OK") { $txtSource.Text = $folder.SelectedPath; Check-Fields }
})
$form.Controls.Add($btnBrowseSource)

# --- Output folder ---
$lblOutput = New-Object System.Windows.Forms.Label
$lblOutput.Text = "Output Folder:"
$lblOutput.Location = New-Object System.Drawing.Point(10,60)
$lblOutput.AutoSize = $true
$form.Controls.Add($lblOutput)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Location = New-Object System.Drawing.Point(120,58)
$txtOutput.Size = New-Object System.Drawing.Size(350,20)
$txtOutput.AllowDrop = $true
$txtOutput.Add_DragEnter({
    if ($_.Data.GetDataPresent([System.Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [System.Windows.Forms.DragDropEffects]::Copy
    }
})
$txtOutput.Add_DragDrop({
    $folder = Get-DroppedFolder $_.Data
    if ($folder) { $txtOutput.Text = $folder; Check-Fields }
})
$form.Controls.Add($txtOutput)

$btnBrowseOutput = New-Object System.Windows.Forms.Button
$btnBrowseOutput.Text = "Browse"
$btnBrowseOutput.Location = New-Object System.Drawing.Point(480,55)
$btnBrowseOutput.Add_Click({
    $folder = (New-Object System.Windows.Forms.FolderBrowserDialog)
    if($folder.ShowDialog() -eq "OK") { $txtOutput.Text = $folder.SelectedPath; Check-Fields }
})
$form.Controls.Add($btnBrowseOutput)

# --- ISO name ---
$lblISO = New-Object System.Windows.Forms.Label
$lblISO.Text = "ISO Name:"
$lblISO.Location = New-Object System.Drawing.Point(10,100)
$lblISO.AutoSize = $true
$form.Controls.Add($lblISO)

$txtISO = New-Object System.Windows.Forms.TextBox
$txtISO.Location = New-Object System.Drawing.Point(120,98)
$txtISO.Size = New-Object System.Drawing.Size(350,20)
$txtISO.Add_TextChanged({Check-Fields})
$form.Controls.Add($txtISO)

# --- Boot sector ---
$lblBoot = New-Object System.Windows.Forms.Label
$lblBoot.Text = "Boot Sector File (optional):"
$lblBoot.Location = New-Object System.Drawing.Point(10,140)
$lblBoot.AutoSize = $true
$form.Controls.Add($lblBoot)

$txtBoot = New-Object System.Windows.Forms.TextBox
$txtBoot.Location = New-Object System.Drawing.Point(180,138)
$txtBoot.Size = New-Object System.Drawing.Size(290,20)
$form.Controls.Add($txtBoot)

$btnBrowseBoot = New-Object System.Windows.Forms.Button
$btnBrowseBoot.Text = "Browse"
$btnBrowseBoot.Location = New-Object System.Drawing.Point(480,135)
$btnBrowseBoot.Add_Click({
    $file = (New-Object System.Windows.Forms.OpenFileDialog)
    $file.Filter = "Boot files|*.*"
    if($file.ShowDialog() -eq "OK") { $txtBoot.Text = $file.FileName }
})
$form.Controls.Add($btnBrowseBoot)

# --- Custom oscdimg.exe path ---
$lblOscdimg = New-Object System.Windows.Forms.Label
$lblOscdimg.Text = "oscdimg.exe Path (optional):"
$lblOscdimg.Location = New-Object System.Drawing.Point(10,180)
$lblOscdimg.AutoSize = $true
$form.Controls.Add($lblOscdimg)

$txtOscdimg = New-Object System.Windows.Forms.TextBox
$txtOscdimg.Location = New-Object System.Drawing.Point(180,178)
$txtOscdimg.Size = New-Object System.Drawing.Size(290,20)
$form.Controls.Add($txtOscdimg)

$btnBrowseOscdimg = New-Object System.Windows.Forms.Button
$btnBrowseOscdimg.Text = "Browse"
$btnBrowseOscdimg.Location = New-Object System.Drawing.Point(480,175)
$btnBrowseOscdimg.Add_Click({
    $file = (New-Object System.Windows.Forms.OpenFileDialog)
    $file.Filter = "Executable|oscdimg.exe|All files|*.*"
    if($file.ShowDialog() -eq "OK") { $txtOscdimg.Text = $file.FileName }
})
$form.Controls.Add($btnBrowseOscdimg)

# --- Status label ---
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(10,220)
$lblStatus.Size = New-Object System.Drawing.Size(560,50)
$lblStatus.Text = ""
$form.Controls.Add($lblStatus)

# --- Progress bar ---
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(10,270)
$progress.Size = New-Object System.Drawing.Size(560,20)
$progress.Style = 'Continuous'
$progress.Value = 0
$form.Controls.Add($progress)

# --- Open Folder button (hidden until completion) ---
$btnOpenFolder = New-Object System.Windows.Forms.Button
$btnOpenFolder.Text = "Open Folder"
$btnOpenFolder.Location = New-Object System.Drawing.Point(230,360)
$btnOpenFolder.Size = New-Object System.Drawing.Size(100,30)
$btnOpenFolder.Visible = $false
$btnOpenFolder.Add_Click({
    Start-Process $txtOutput.Text
})
$form.Controls.Add($btnOpenFolder)

# --- Create ISO button ---
$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Create ISO"
$btnCreate.Location = New-Object System.Drawing.Point(230,310)
$btnCreate.Size = New-Object System.Drawing.Size(100,30)
$btnCreate.BackColor = [System.Drawing.Color]::LightGray
$btnCreate.Enabled = $false
$form.Controls.Add($btnCreate)

# --- Function to check required fields ---
function Check-Fields {
    if ($txtSource.Text.Trim() -ne "" -and $txtOutput.Text.Trim() -ne "" -and $txtISO.Text.Trim() -ne "") {
        $btnCreate.Enabled = $true
        $btnCreate.BackColor = [System.Drawing.Color]::LimeGreen
    } else {
        $btnCreate.Enabled = $false
        $btnCreate.BackColor = [System.Drawing.Color]::LightGray
    }
}

# --- ISO creation ---
$btnCreate.Add_Click({
    $src = $txtSource.Text.Trim()
    $out = $txtOutput.Text.Trim()
    $iso = $txtISO.Text.Trim()
    $boot = $txtBoot.Text.Trim()
    $customOscdimg = $txtOscdimg.Text.Trim()
    $isoPath = Join-Path $out ($iso + ".iso")
    
    # --- Validate folders ---
    if (-not (Test-Path $src)) { Show-Status "Source folder does not exist!" $true; return }
    if (-not (Test-Path $out)) { 
        try { New-Item -ItemType Directory -Path $out | Out-Null } 
        catch { Show-Status "Failed to create output folder!" $true; return }
    }

    # --- Existing ISO check ---
    if (Test-Path $isoPath) {
        $res = [System.Windows.Forms.MessageBox]::Show("ISO already exists. Overwrite?", "Confirm", "YesNo")
        if ($res -ne "Yes") { Show-Status "Operation cancelled."; return }
    }

    # --- Resolve oscdimg.exe path ---
    $oscdimgPath = $null

    # Check custom path first
    if ($customOscdimg -ne "") {
        if (Test-Path $customOscdimg) {
            $oscdimgPath = $customOscdimg
        } else {
            Show-Status "Custom oscdimg.exe path is invalid!" $true
            return
        }
    }

    # Fall back to auto-detection
    if (-not $oscdimgPath) {
        $possiblePaths = @(
            "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe",
            "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\Oscdimg\oscdimg.exe"
        )
        $oscdimgPath = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    }

    if (-not $oscdimgPath) {
        Show-Status "oscdimg.exe not found! Install Windows ADK Deployment Tools or specify a custom path." $true
        return
    }

    # --- Detect boot sector ---
    if ($boot -eq "") {
        $possibleBoot = Join-Path $src "boot\etfsboot.com"
        if (Test-Path $possibleBoot) { $boot = $possibleBoot }
    }

    # --- Disable button during operation ---
    $btnCreate.Enabled = $false
    $btnCreate.BackColor = [System.Drawing.Color]::LightGray
    $btnOpenFolder.Visible = $false

    # --- Start marquee progress ---
    $progress.Style = 'Marquee'
    $progress.MarqueeAnimationSpeed = 30
    Show-Status "Creating ISO..."
    $form.Refresh()

    # --- Run oscdimg ---
    try {
        if ($boot -ne "") {
            & $oscdimgPath -n -m -b$boot $src $isoPath 2>&1 | Out-Null
        } else {
            & $oscdimgPath -n -m $src $isoPath 2>&1 | Out-Null
        }

        # --- Check exit code ---
        if ($LASTEXITCODE -ne 0) {
            $progress.Style = 'Continuous'
            $progress.Value = 0
            Show-Status "oscdimg failed with exit code $LASTEXITCODE. Check your source folder and paths." $true
            $btnCreate.Text = "Create ISO"
            $btnCreate.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8,[System.Drawing.FontStyle]::Regular)
            $btnCreate.Enabled = $true
            $btnCreate.BackColor = [System.Drawing.Color]::LimeGreen
            return
        }

        $progress.Style = 'Continuous'
        $progress.Value = 100
        Show-Status "Bootable ISO created at: $isoPath"
        $btnCreate.Text = "Completed"
        $btnCreate.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10,[System.Drawing.FontStyle]::Bold)
        $btnOpenFolder.Visible = $true
    } catch {
        $progress.Style = 'Continuous'
        $progress.Value = 0
        Show-Status "Failed to create ISO! Error: $($_.Exception.Message)" $true
        $btnCreate.Text = "Create ISO"
        $btnCreate.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8,[System.Drawing.FontStyle]::Regular)
        $btnCreate.Enabled = $true
        $btnCreate.BackColor = [System.Drawing.Color]::LimeGreen
    }
})

# --- Show the form ---
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
