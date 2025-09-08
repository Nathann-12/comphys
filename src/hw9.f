           program hw9

      implicit real*8 (a-h,o-z)
      integer n,i
      parameter (n=100)
      real*8 x(n), d3(n), d5(n), exact(n), h, start, stop
      external func

c กำหนดช่วงและ step size
      start = 0.0d0
      stop  = 2.0d0*3.141592653589793d0
      h = (stop-start)/dble(n-1)

c คำนวณค่าอนุพันธ์ที่แต่ละจุด
      do 10 i=1,n
         x(i) = start + dble(i-1)*h
         call deriv3(x(i),h,d3(i))
         call deriv5(x(i),h,d5(i))
         exact(i) = dcos(x(i))
 10   continue

c เขียนผลลัพธ์เป็นไฟล์ CSV 
      open(30,file='hw9_output.csv',status='unknown')
      write(30,'(a)') 'x,deriv3,deriv5,exact'
      do 20 i=1,n
         write(30,'(f12.6,'','',f15.8,'','',f15.8,'','',f15.8)')
     1        x(i), d3(i), d5(i), exact(i)
 20   continue
      close(30)

      stop
      end


c ฟังก์ชัน f(x) = sin(x)
      real*8 function func(x)
      implicit real*8 (a-h,o-z)
      real*8 x
      func = dsin(x)
      return
      end


c-------------------------------------------
c subroutine 3 
      subroutine deriv3(x,h,df)
      implicit real*8 (a-h,o-z)
      real*8 x,h,df, func
      external func
      df = (func(x+h) - func(x-h)) / (2.0d0*h)
      return
      end


c-------------------------------------------
c subroutine 5 
      subroutine deriv5(x,h,df)
      implicit real*8 (a-h,o-z)
      real*8 x,h,df, func
      external func
      df = (func(x-2.0d0*h) - 8.0d0*func(x-h)
     1     + 8.0d0*func(x+h) - func(x+2.0d0*h)) / (12.0d0*h)
      return
      end
