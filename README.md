# ComPhysProject — Nuclear Optical Model (Fortran 77, มือใหม่)

โค้ดตัวอย่างสไตล์มือใหม่ (คอมเมนต์ไทย) สำหรับคำนวณศักย์เชิงซ้อนแบบ Optical Model ของโปรตอนกระทบแกน 58Ni และบันทึกผลเป็น CSV เพื่อพล็อตด้วย Excel ได้ทันที

- ภาษา: Fortran 77 (fixed-form)
- คอมไพล์: `gfortran -std=legacy -ffixed-line-length-132 src/comphys.f -o comphys.exe`
- ผลลัพธ์: `out/opot.csv` (หัวคอลัมน์: `r,Ureal,Uimag,Uabs`)
- ช่วง r: 0.1 → 10.0 fm, ก้าว 0.1 fm

## โครงสร้าง

```
ComPhysProject/
  .vscode/
    tasks.json
    launch.json
  src/
    comphys.f
  out/
  scripts/
    build.bat
    run.bat
  README.md
  .gitignore
```

## วิธิใช้งาน

- VS Code: กด Run “Run comphys.exe” (จะ Build ก่อนอัตโนมัติ)
- หรือ Windows CMD/PowerShell:
  - `scripts\build.bat`
  - `scripts\run.bat`

ไฟล์ `out/opot.csv` จะถูกสร้างขึ้น พร้อมหัวคอลัมน์ `r,Ureal,Uimag,Uabs` นำเข้า Excel แล้วเลือกตัวคั่นเป็น Comma เพื่อพล็อตกราฟได้เลย

## ฟิสิกส์ที่ใช้ (ย่อ)

- Nuclear potential: Woods–Saxon เชิงซ้อน
  - Re[U] = −V f(r,R,a) + UC(r)
  - Im[U] = −W f(r,R',a')
  - |U| = sqrt(Re[U]^2 + Im[U]^2)
- Coulomb (ทรงกลมสม่ำเสมอ, โปรตอนกับ 58Ni):
  - e^2 = 1.44 MeV·fm, Z = 28
  - RC = 1.465 A^(1/3), A=58
  - UC(r) = Ze^2/(2RC) (3 − (r/RC)^2) เมื่อ r<RC, และ UC(r)=Ze^2/r เมื่อ r≥RC

พารามิเตอร์ที่ใส่ในโค้ด: V=50 MeV, a=0.7 fm, R=1.2 A^(1/3); W=5 MeV, a'=0.6 fm, R'=1.32 A^(1/3)

## หมายเหตุ

- โค้ดตั้งใจให้เรียบง่าย อ่านง่ายสำหรับผู้เริ่มต้น Fortran 77
- ใช้ `REAL*8`, หลีกเลี่ยงฟีเจอร์ขั้นสูง เช่น module/derived type
- หากโฟลเดอร์ `out/` ไม่มีอยู่ สคริปต์จะสร้างให้ก่อนรัน

