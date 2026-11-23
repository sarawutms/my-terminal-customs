# 🚀 Windows Terminal & PowerShell Tokyo Night Setup

ชุดติดตั้งสภาพแวดล้อม Windows Terminal + PowerShell สไตล์ Tokyo Night พร้อม Fastfetch, Oh My Posh, ไอคอน และสีสันในตาราง `dir` สำหรับนำไปติดตั้งในเครื่องอื่นได้ทันที

---

## 📦 สิ่งที่รวมอยู่ในชุดนี้

1. **PowerShell Profile (`Microsoft.PowerShell_profile.ps1`)**:
   - รองรับการแสดงผล Emoji (UTF-8)
   - Oh My Posh Prompt สไตล์ WSL พร้อมระบบ Smart Cache (เปิดเร็ว <100ms)
   - PSReadLine แนะนำคำสั่งอัตโนมัติ (Inline Prediction) สี Tokyo Night
   - เมนูตัวเลือกเมื่อกด Tab (MenuComplete)
   - คำสั่ง `cat` แสดงสีโค้ดด้วย `bat`
   - ตาราง `dir` / `ls` แบบดั้งเดิมของ Windows 4 คอลัมน์ แต่มีสีที่สิทธิ์ `Mode` และมีไอคอนจาก `Terminal-Icons`
2. **Oh My Posh Config (`tokyonight_storm.omp.json`)**:
   - พาธโฟลเดอร์ `📂`
   - Git Branch `(🌱 main)` พร้อมแสดงจำนวนไฟล์ที่แก้ไข
   - ตัวจับเวลาคำสั่ง `⏱` (เมื่อทำงานเกิน 2 วินาที)
   - สถานะ Admin `⚡Admin` (เมื่อเปิดแบบ Run as Administrator)
3. **Fastfetch Config & Logo (`config.jsonc`, `logo2.txt`)**:
   - กรอบการ์ดสไตล์ Badge Box สีขาวเรียบหรู
   - แสดงสถานะระบบ: OS, Host, Kernel, Uptime, Memory, Local IP, Wi-Fi, ฯลฯ
   - ใช้โลโก้ตัวละคร ASCII เฉพาะตัว
4. **Colored Mode XML (`ColoredMode.format.ps1xml`)**:
   - ตกแต่งสีให้คอลัมน์ `Mode` ในคำสั่ง `dir`: โฟลเดอร์สีฟ้า, ไฟล์สีเขียว, อ่านอย่างเดียวสีเหลือง, อื่นๆ สีเทา
5. **Windows Terminal Scheme (`wt-tokyonight-scheme.json`)**:
   - โค้ดสี Tokyo Night สำหรับ Windows Terminal
6. **WSL Shortcut (`wsl ~`)**:
   - รองรับการพิมพ์ `wsl ~` เพื่อเปิดเข้าสู่ Linux Home Directory (`/home/username`) ทันที ป้องกัน Error `command not found` ใน PowerShell 7

---

## ⚡ วิธีติดตั้งบนเครื่องใหม่ (ง่ายที่สุด)

### วิธีที่ 1: ดับเบิลคลิกไฟล์ `install.bat` (แนะนำ ⭐ ง่ายที่สุด)
1. คัดลอกโฟลเดอร์ `terminal-setup` (หรือบีบอัดเป็น `.zip`) ไปวางที่เครื่องใหม่
2. **ดับเบิลคลิกที่ไฟล์ `install.bat`** (ระบบจะขอสิทธิ์ Administrator ให้อัตโนมัติ)
3. ระบบจะจัดการดาวน์โหลดแพ็กเกจ (PowerShell 7, Oh My Posh, Fastfetch, Bat, Font), ติดตั้งโมดูล, คัดลอกคอนฟิก และตั้งค่า Windows Terminal ให้เสร็จสรรพในคลิกเดียว

---

### วิธีที่ 2: รันผ่าน PowerShell (ทางเลือก)
เปิด **PowerShell** (Run as Administrator) แล้วพิมพ์:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
cd C:\Path\To\terminal-setup
.\install.ps1
```

---

## 🔄 วิธีรีเซ็ตคืนค่าเดิม (Reset / Uninstall)

หากต้องการคืนค่าเดิมของ Windows ทั้งหมด:
* ดับเบิลคลิก **`reset.bat`** (หรือรัน `.\reset.ps1` ใน PowerShell)
* สคริปต์จะลบไฟล์ปรับแต่งทั้งหมดและคืนค่าเดิมของระบบให้อัตโนมัติ ปลอดภัย 100%

---

## 🔤 การตรวจสอบหลังติดตั้งเสร็จ:

ระบบจะตั้งค่าฟอนต์ **JetBrainsMono NF** และสลับ Default Profile เป็น **PowerShell 7** ใน Windows Terminal ให้อัตโนมัติแล้ว

> **หมายเหตุ:** ปิดแล้วเปิด Windows Terminal ใหม่อีกครั้งเพื่อโหลดการตั้งค่าทั้งหมด เพียงเท่านี้ก็จะได้ Terminal สไตล์ Tokyo Night ที่สวยงามและเร็วแรง 100% ทันที! 🎉
