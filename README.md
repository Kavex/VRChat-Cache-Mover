# VRChat-Cache-Mover (PowerShell GUI)
A simple GUI tool that creates a symbolic link from your local VRChat folder (in `AppData\LocalLow`) to a custom location. Perfect for moving VRChat data to another drive without breaking expected file paths.

![image](https://github.com/user-attachments/assets/0c3c253d-3f7d-42a6-9053-b65ee1a2a53d)

---

## 📦 Features

- ✅ Easy-to-use Windows Forms GUI
- 📁 Automatically creates missing target folders
- 🗑️ Removes existing source folders or symlinks
- 🔗 Uses `mklink /D` to create a symbolic directory link
- 🧾 Real-time logging and status feedback

---

## 📂 Default Paths

| Type     | Path |
|----------|------|
| **Source** (replaced) | `C:\Users\<YourName>\AppData\LocalLow\VRChat` |
| **Target** (destination) | `D:\Steam\steamapps\common\VRChat\AppData\VRChat` |

> You can modify both paths in the GUI before creating the link.

---

Note: This will delete the folder in `C:\Users\<YourName>\AppData\LocalLow\VRChat` so if you want to keep your current cache then back it up.

## 🚀 How to Use

1. **Open PowerShell as Administrator**  
   Symbolic link creation requires elevated permissions.

2. **Run the script**
   Save the script as `VRChat_MoveCacheLocation.ps1` and run it with:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\VRChat_MoveCacheLocation.ps1
   ```
