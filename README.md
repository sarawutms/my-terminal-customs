# 🪟 Windows Terminal & PowerShell Tokyo Night Setup

[![OS - Windows](https://img.shields.io/badge/OS-Windows%2011%20%2F%2010-0078D6?logo=windows&logoColor=white)](#)
[![Shell - PowerShell 7](https://img.shields.io/badge/Shell-PowerShell%207-5391FE?logo=powershell&logoColor=white)](#)
[![Theme - Tokyo Night](https://img.shields.io/badge/Theme-Tokyo%20Night-7AA2F7?logo=visual-studio-code&logoColor=white)](#)
[![Prompt - Oh My Posh](https://img.shields.io/badge/Prompt-Oh%20My%20Posh-E65C00?logo=powershell&logoColor=white)](https://ohmyposh.dev)
[![Terminal - Windows Terminal](https://img.shields.io/badge/Terminal-Windows%20Terminal-4D4D4D?logo=windows-terminal&logoColor=white)](#)
[![Maintenance - Active](https://img.shields.io/badge/Maintenance-Active-brightgreen)](#)

ชุดติดตั้งสภาพแวดล้อม **Windows Terminal + PowerShell 7** สไตล์ **Tokyo Night Storm** แบบอัตโนมัติ (**1-Click Installer**) พร้อม Fastfetch, Oh My Posh, PSReadLine, Nerd Font, ไอคอน และสีสันในตาราง `dir` สำหรับนำไปติดตั้งในเครื่อง Windows เครื่องอื่นได้ทันทีในคลิกเดียว

---

## ✨ ไฮไลท์และฟีเจอร์เด่น (Features)

- ⚡ **1-Click Auto Installer:** ติดตั้งทุกอย่างอัตโนมัติผ่าน `install.bat` หรือ `install.ps1` (โหลดแอป, โมดูล, คอนฟิก และฟอนต์เสร็จสรรพ)
- 🎨 **Tokyo Night Storm Theme:** ธีมสีคุมโทนทั่วทั้ง Windows Terminal, Prompt, และ Syntax Highlighting
- 🚀 **Smart Prompt Cache (<100ms):** ใช้ระบบแคชสำหรับ Oh My Posh ทำให้เปิด Terminal ขึ้นมาได้ทันที ไม่หน่วง
- 💡 **PSReadLine Predictive IntelliSense:** แนะนำคำสั่งอัตโนมัติจาก History พร้อมแสดง Syntax Highlight สี Tokyo Night
- 📁 **Enhanced Directory Listing:** แสดงผลคำสั่ง `dir` / `ls` แบบดั้งเดิม 4 คอลัมน์ แต่เพิ่มสีสิทธิ์ไฟล์ `Mode` และไอคอนโฟลเดอร์/ไฟล์สวยงาม
- 🐧 **WSL Bridge Shortcut:** รองรับการพิมพ์ `wsl ~` เพื่อเปิดเข้าสู่ Linux Home Directory (`/home/username`) ได้ทันที ไม่ติดขัด Error
- 🔄 **Safe Reset Support:** มีสคริปต์ `reset.bat` / `reset.ps1` สำหรับคืนค่าดั้งเดิมของ Windows ได้ 100%

---

## 📦 เครื่องมือที่ติดตั้งในระบบ (Included Tools)

| เครื่องมือ | คำสั่ง / สิ่งที่ได้รับ | คำอธิบายและความสามารถ |
| :--- | :--- | :--- |
| **PowerShell 7** | `pwsh` | PowerShell รุ่นใหม่ล่าสุด เร็วกว่า เสถียรกว่า และรองรับฟีเจอร์สมัยใหม่ |
| **Oh My Posh** | `oh-my-posh` | Engine แสดงผล Terminal Prompt สไตล์ WSL พร้อมแสดง Git Branch, ตัวจับเวลา และสถานะ Admin |
| **Fastfetch** | `fastfetch` | แสดงข้อมูลสเปกเครื่อง OS, Hardware, Memory และการ์ด Badge Box สีขาวเรียบหรู |
| **Bat** | `bat`, `cat` | แสดงเนื้อหาไฟล์พร้อมหมายเลขบรรทัด และ Syntax Highlighting หลากภาษา |
| **Terminal-Icons** | `dir`, `ls` | แสดงไอคอน Nerd Font ตามประเภทและนามสกุลไฟล์ |
| **PSReadLine** | Prediction / Complete | แนะนำคำสั่งเก่าอัตโนมัติ (Inline Prediction) และกด Tab แสดงเมนูแบบตาราง |
| **JetBrainsMono NF** | Font | Nerd Font คมชัดพร้อมสัญลักษณ์และไอคอนครบถ้วน |

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)

```text
my-terminal-customs/
├── configs/
│   ├── fastfetch/
│   │   ├── config.jsonc                 # การตั้งค่าการแสดงผล Fastfetch แบบ Badge Box
│   │   ├── logo.txt                     # โลโก้ตัวละคร ASCII
│   │   └── logo2.txt
│   ├── ColoredMode.format.ps1xml        # สีสันในตารางสิทธิ์ Mode ของคำสั่ง dir
│   ├── Microsoft.PowerShell_profile.ps1 # Profile พร้อมชอร์ตคัต 'wsl ~' และระบบ Smart Cache
│   ├── tokyonight_storm.omp.json        # ธีม Oh My Posh Tokyo Night Storm
│   └── wt-tokyonight-scheme.json        # Color Scheme สำหรับ Windows Terminal
├── install.bat                          # ดับเบิลคลิกเพื่อติดตั้งอัตโนมัติ (1-Click Run)
├── install.ps1                          # สคริปต์หลักดาวน์โหลดและตั้งค่าระบบผ่าน PowerShell
├── reset.bat                            # ดับเบิลคลิกเพื่อคืนค่าเริ่มต้นของ Windows
├── reset.ps1                            # สคริปต์รีเซ็ตระบบ
├── .gitignore                           # ละเว้นไฟล์ zip และไฟล์ระบบ
└── README.md                            # คู่มือการติดตั้งและใช้งาน
```

---

## ⚡ วิธีติดตั้งบนเครื่องใหม่

### วิธีที่ 1: ติดตั้งผ่าน Git Clone (แนะนำสำหรับ Developer ⭐)
เปิด PowerShell แล้วรันคำสั่ง:
```powershell
git clone https://github.com/sarawutms/my-terminal-customs.git
cd my-terminal-customs
.\install.bat
```

### วิธีที่ 2: ใช้ไฟล์ ZIP พกพา
1. ดาวน์โหลดหรือคัดลอกไฟล์ `terminal-setup.zip` ไปยังเครื่องใหม่
2. แตกไฟล์ ZIP ออกมา
3. **ดับเบิลคลิกที่ไฟล์ `install.bat`** (ระบบจะขอสิทธิ์ Administrator ให้อัตโนมัติ)
4. รอระบบจัดการดาวน์โหลดเครื่องมือ, ติดตั้งโมดูล, คัดลอกคอนฟิก และตั้งค่า Windows Terminal ให้เสร็จสรรพ
5. ปิดแล้วเปิด Windows Terminal ใหม่อีกครั้งเพื่อเริ่มใช้งาน

---

## 🔄 วิธีรีเซ็ตคืนค่าเดิม (Reset / Uninstall)

หากต้องการคืนค่าเดิมของระบบ Windows ทั้งหมด:
* ดับเบิลคลิก **`reset.bat`** (หรือรัน `.\reset.ps1` ใน PowerShell)
* สคริปต์จะลบไฟล์ตั้งค่าทั้งหมดและคืนค่าเดิมของ Windows Terminal ให้อัตโนมัติ ปลอดภัย 100%

---

## 🔗 โปรเจกต์ที่เกี่ยวข้อง (Related Projects)

* 🐧 **[sarawutms/my-linux-customs](https://github.com/sarawutms/my-linux-customs)**: ชุดติดตั้งสภาพแวดล้อมสำหรับ Linux / Debian / WSL (Bash, Starship, Fastfetch, Btop, Eza)

---

## 👤 Author

- **GitHub:** [@sarawutms](https://github.com/sarawutms)
- **Repository:** [my-terminal-customs](https://github.com/sarawutms/my-terminal-customs)
