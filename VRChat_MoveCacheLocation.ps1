Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === Create the Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "VRChat Symbolic Link Creator"
$form.Size = New-Object System.Drawing.Size(600, 320)
$form.StartPosition = "CenterScreen"

# === Labels and TextBoxes ===
$labelSource = New-Object System.Windows.Forms.Label
$labelSource.Text = "Source (will be replaced):"
$labelSource.Location = New-Object System.Drawing.Point(10, 20)
$labelSource.AutoSize = $true
$form.Controls.Add($labelSource)

$textSource = New-Object System.Windows.Forms.TextBox
$textSource.Size = New-Object System.Drawing.Size(550, 20)
$textSource.Location = New-Object System.Drawing.Point(10, 40)
$textSource.Text = "$([Environment]::GetFolderPath('LocalApplicationData').Replace('Local','LocalLow'))\VRChat"
$form.Controls.Add($textSource)

$labelTarget = New-Object System.Windows.Forms.Label
$labelTarget.Text = "Target Folder (where to link):"
$labelTarget.Location = New-Object System.Drawing.Point(10, 70)
$labelTarget.AutoSize = $true
$form.Controls.Add($labelTarget)

$textTarget = New-Object System.Windows.Forms.TextBox
$textTarget.Size = New-Object System.Drawing.Size(550, 20)
$textTarget.Location = New-Object System.Drawing.Point(10, 90)
$textTarget.Text = "D:\Steam\steamapps\common\VRChat\AppData\VRChat"
$form.Controls.Add($textTarget)

# === Log Output Box ===
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.Size = New-Object System.Drawing.Size(550, 100)
$logBox.Location = New-Object System.Drawing.Point(10, 120)
$logBox.ReadOnly = $true
$form.Controls.Add($logBox)

# === Create Link Button ===
$buttonLink = New-Object System.Windows.Forms.Button
$buttonLink.Text = "Create Symbolic Link"
$buttonLink.Size = New-Object System.Drawing.Size(200, 30)
$buttonLink.Location = New-Object System.Drawing.Point(10, 230)

$buttonLink.Add_Click({
    $OriginalPath = $textSource.Text
    $TargetPath = $textTarget.Text

    $logBox.AppendText("🔧 Creating target folders if needed...`r`n")
    try {
        if (-not (Test-Path -Path $TargetPath)) {
            New-Item -Path $TargetPath -ItemType Directory -Force | Out-Null
            $logBox.AppendText("✅ Created target folder.`r`n")
        } else {
            $logBox.AppendText("ℹ️ Target folder already exists.`r`n")
        }
    } catch {
        $logBox.AppendText("❌ Failed to create target folder: $_`r`n")
        return
    }

    if (Test-Path $OriginalPath) {
        $attr = (Get-Item $OriginalPath).Attributes
        if (-not ($attr -match "ReparsePoint")) {
            try {
                Remove-Item -Path $OriginalPath -Recurse -Force
                $logBox.AppendText("🗑️ Removed existing folder at source path.`r`n")
            } catch {
                $logBox.AppendText("❌ Failed to remove existing source folder: $_`r`n")
                return
            }
        } else {
            $logBox.AppendText("ℹ️ Source path is already a symbolic link. Removing it...`r`n")
            try {
                Remove-Item -Path $OriginalPath -Force
                $logBox.AppendText("✅ Removed existing symlink.`r`n")
            } catch {
                $logBox.AppendText("❌ Failed to remove symlink: $_`r`n")
                return
            }
        }
    }

    try {
        cmd /c "mklink /D `"$OriginalPath`" `"$TargetPath`"" | Out-Null
        $logBox.AppendText("✅ Symbolic link created successfully:`r`n$OriginalPath → $TargetPath`r`n")
    } catch {
        $logBox.AppendText("❌ Failed to create symbolic link: $_`r`n")
    }
})

$form.Controls.Add($buttonLink)

# === Show the Form ===
[void]$form.ShowDialog()
