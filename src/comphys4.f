      program comphys4

      implicit none

c ขบวนประกาศอิสระภาพตัวแปรในตำนาน เยอะเกินพี่ชาย
      integer :: a_mass, npoints, i
      real*8 :: v, w, a_ws, ap_ws, r_ws, rp_ws, rc, e2
      real*8 :: r, fr, frp, ureal, uimag, uc
      real*8 :: utot_real, utot_imag, utot_abs
      real*8 :: z1, z2, step
      character*64 :: fout

c ตั้งค่าข้อมูลนิวเคลียสที่ควรจะเป็ฯ 58Ni 
      a_mass = 58
      z2 = 28.0d0
      z1 = 1.0d0

c ค่าคงที่ e^2
      e2 = 1.44d0    ! หน่วย MeV·fm

c Woods–Saxon parameters (เอามาจากตำรา ไม่ใช่หวย)
      v     = 50.0d0   ! ศักย์จริง
      w     = 5.0d0    ! ศักย์หลอน
      a_ws  = 0.7d0    ! ความชันจริง
      ap_ws = 0.6d0    ! ความชันหลอน
      r_ws  = 1.2d0  * a_mass**(1.0d0/3.0d0)
      rp_ws = 1.32d0 * a_mass**(1.0d0/3.0d0)
      rc    = 1.465d0* a_mass**(1.0d0/3.0d0)

c ช่วง r = 0 → 10 fm ก้าว 0.1 fm (เดินเล่นในนิวเคลียส)
      step = 0.1d0
      npoints = int(10.0d0/step)

c ให้ผลลัพธ์เป็นไฟล์ csv 
      fout = 'opot.csv'
      open(unit=20, file=fout, status='unknown')
      write(20,*) 'r,Ureal,Uimag,Uabs'

c loop หลัก: คำนวณทีละจุด
      do i=0,npoints
         r = step * dble(i)

c Woods–Saxon shape functions (เหมือนกำแพงเบลอ ๆ)
         fr  = 1.0d0/(1.0d0 + dexp((r-r_ws)/a_ws))
         frp = 1.0d0/(1.0d0 + dexp((r-rp_ws)/ap_ws))

c nuclear potential (ของจริง + ของหลอก)
         ureal = -v * fr
         uimag = -w * frp

c Coulomb potential (ผลักกันแบบไฟฟ้า)
         if (r .lt. rc .and. r .gt. 1.0d-12) then
            uc = (z1*z2*e2/(2.0d0*rc)) * (3.0d0 - (r/rc)**2)
         else if (r .ge. rc) then
            uc = (z1*z2*e2)/r
         else
            uc = (z1*z2*e2)/rc   ! กันหารศูนย์ตอน r=0
         end if

c รวมร่างทั้งหมด
         utot_real = ureal + uc
         utot_imag = uimag
         utot_abs  = dsqrt(utot_real**2 + utot_imag**2)

c เขียนลงไฟล์ csv (เวอร์ชันแก้แล้ว ไม่มี 1H,, error)
         write(20,100) r, utot_real, utot_imag, utot_abs
 100     format(F8.3,',',F12.6,',',F12.6,',',F12.6)
      end do

      close(20)
      end
