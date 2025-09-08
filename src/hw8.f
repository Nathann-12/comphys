      program hw8

      implicit real*8 (a-h,o-z)
      integer nmax, n, i, ios
      parameter (nmax=10000)
      real*8 x(nmax), y(nmax), dydx(nmax), h
      character*128 infile, outfile

c --- ตั้งชื่อไฟล์ -
      infile  = 'input2.txt'
      outfile = 'outputhw8.csv'

c --- อ่านไฟล์อินพุต: บรรทัดแรกต้องเป็น n ---
      open(10, file=infile, status='old', iostat=ios)
      if (ios .ne. 0) then
         print *, 'error: ', infile
         stop
      end if
      read(10,*,iostat=ios) n
      if (ios .ne. 0 .or. n .lt. 5 .or. n .gt. nmax) then
         print *, 'error'
         stop
      end if
      do i=1,n
         read(10,*,iostat=ios) x(i), y(i)
         if (ios .ne. 0) then
            print *, 'error'
            stop
         end if
      end do
      close(10)

c --- ระยะห่าง เท่ากัน
      h = x(2) - x(1)


      do i=3, n-2
         dydx(i) = ( -y(i+2) + 8d0*y(i+1) - 8d0*y(i-1) + y(i-2) )
     &             / (12d0*h)
      end do


c     x1
      dydx(1) = ( -25d0*y(1) + 48d0*y(2) - 36d0*y(3)
     &            + 16d0*y(4) - 3d0*y(5) ) / (12d0*h)
c     x2
      dydx(2) = ( -3d0*y(1) -10d0*y(2) + 18d0*y(3)
     &            - 6d0*y(4) + y(5) ) / (12d0*h)

c     xn
      dydx(n) = ( 25d0*y(n) - 48d0*y(n-1) + 36d0*y(n-2)
     &            - 16d0*y(n-3) + 3d0*y(n-4) ) / (12d0*h)
c     x_{n-1}
      dydx(n-1) = ( -y(n-4) + 6d0*y(n-3) - 18d0*y(n-2)
     &               + 10d0*y(n-1) + 3d0*y(n) ) / (12d0*h)

c --- เขียน CSV 
      open(20, file=outfile, status='replace', iostat=ios)
      if (ios .ne. 0) then
         print *, 'error: ', outfile
         stop
      end if
      write(20,'(A)') 'x,f(x),f''(x)'
      do i=1,n

         write(20,'(ES24.16,1H,,ES24.16,1H,,ES24.16)')
     &         x(i), y(i), dydx(i)
      end do
      close(20)

c --- จบโปรแกรม ---
      stop
      end
