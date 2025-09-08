c โปรแกรมฟิตโพลิโนเมียล degree 1–4 ด้วย normal equations (Fortran 77)
      program hw7
      implicit real*8(a-h,o-z)
      integer i,deg,n
      integer maxn
      parameter (maxn=1000)

c ข้อมูล
      real*8 x(maxn), y(maxn)
c ค่าสัมประสิทธิ์ (0..4)
      real*8 a(0:4)
c ทำนายและ RSS ของแต่ละดีกรี
      real*8 yfit(maxn), rss(4)

c --- อ่านไฟล์ ---
c บรรทัดแรก n แล้วตามด้วย n บรรทัด: x y
      open(10,file='input.txt',status='old')
      read(10,*) n
      if (n.gt.maxn) then
         print *,'n ใหญ่เกินพี่ชาย' !รอบคอบไว้ก่อนพื้นฐานของคนทำโปรแกรม
         stop
      endif
      do i=1,n
         read(10,*) x(i), y(i)
      enddo
      close(10)

c --- ฟิต degree 1..4 ---
      do deg=1,4
         call polyfit_deg(x,y,n,deg,a,yfit,rss(deg))
         print *,'Degree=',deg,'  RSS=',rss(deg)
         write(*,'(A,I1,A,1X,5(ES14.6,1X))')
     &        'a0..a',deg,':', (a(i), i=0,deg)
      enddo

c --- เลือกตัวที่ดีที่สุดจาก RSS ต่ำสุด ---
      call pick_best(rss,4)

      stop
      end


c================== ฟิตทีละดีกรี ==================
      subroutine polyfit_deg(x,y,n,deg,a,yfit,rss)
      implicit real*8(a-h,o-z)
      integer n,deg,i,j,k
      real*8 x(n), y(n), yfit(n), rss
      real*8 a(0:4)

c ผลรวมกำลัง x
      real*8 SX(0:8)
c ผลรวมผสม
      real*8 SY(0:4)
c เมทริกซ์ 
      real*8 MAT(0:4,0:4), RHS(0:4)
      real*8 tmp

c --- คำนวณ SX ---
      do i=0,2*deg
         SX(i)=0.d0
      enddo
      do i=1,n
         tmp=1.d0
         do k=0,2*deg
            if (k.eq.0) then
               tmp=1.d0
            else
               tmp=tmp*x(i)
            endif
            SX(k)=SX(k)+tmp
         enddo
      enddo

c --- คำนวณ SY ---
      do i=0,deg
         SY(i)=0.d0
      enddo
      do i=1,n
         tmp=1.d0
         do k=0,deg
            if (k.eq.0) then
               tmp=1.d0
            else
               tmp=tmp*x(i)
            endif
            SY(k)=SY(k)+y(i)*tmp
         enddo
      enddo

c --- ประกอบ A (=MAT) และ B (=RHS)
      do i=0,deg
         do j=0,deg
            MAT(i,j)=SX(i+j)
         enddo
         RHS(i)=SY(i)
      enddo

c --- แก้สมการ A*a = B
      call gauss_solve(MAT,RHS,deg+1,a)

c --- คำนวณ yfit และ RSS
      rss=0.d0
      do i=1,n
         tmp=0.d0
         do k=0,deg
            tmp=tmp + a(k)*x(i)**k
         enddo
         yfit(i)=tmp
         rss=rss + (y(i)-tmp)**2
      enddo

      return
      end


c================== Gaussian elimination (มี pivot ง่าย ๆ) ==================
      subroutine gauss_solve(M,B,n,a)
      implicit real*8(a-h,o-z)
      integer n,i,j,k,p
      real*8 M(0:4,0:4), B(0:4), a(0:4)
      real*8 maxv, tmp, fac, s

c pivot + eliminate
      do k=0,n-2
c เลือก pivot แถว p
         p=k
         maxv=dabs(M(k,k))
         do i=k+1,n-1
            if (dabs(M(i,k)).gt.maxv) then
               maxv=dabs(M(i,k))
               p=i
            endif
         enddo
c สลับแถว
         if (p.ne.k) then
            do j=k,n-1
               tmp=M(k,j)
               M(k,j)=M(p,j)
               M(p,j)=tmp
            enddo
            tmp=B(k)
            B(k)=B(p)
            B(p)=tmp
         endif
c กำจัด
         if (M(k,k).eq.0.d0) then
            print *,'เมทริกซ์เอกพันธ์'
            stop
         endif
         do i=k+1,n-1
            fac=M(i,k)/M(k,k)
            do j=k,n-1
               M(i,j)=M(i,j)-fac*M(k,j)
            enddo
            B(i)=B(i)-fac*B(k)
         enddo
      enddo

c back-sub
      do i=n-1,0,-1
         s=B(i)
         do j=i+1,n-1
            s=s - M(i,j)*a(j)
         enddo
         a(i)=s/M(i,i)
      enddo

      return
      end


c================== เลือกดีกรีที่ดีที่สุดด้วย RSS ==================
      subroutine pick_best(rss,m)
      implicit real*8(a-h,o-z)
      integer m,i,ibest
      real*8 rss(m), minv

      minv=rss(1)
      ibest=1
      do i=2,m
         if (rss(i).lt.minv) then
            minv=rss(i)
            ibest=i
         endif
      enddo
      print *,'Best degree =', ibest, '  RSS =', minv
      return
      end
