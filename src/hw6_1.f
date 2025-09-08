      program hw5
      implicit real*8(a-h,o-z)
      integer n,i
      parameter (n=10)
      real*8 x(n), y(n)
      real*8 sumx, sumy, sumxy, sumx2, a0, a1

c --- input data ---
      data x /1,3,5,7,10,12,13,16,18,20/
      data y /4,5,6,5, 8, 7, 6, 9,12,11/

      sumx=0.d0
      sumy=0.d0
      sumxy=0.d0
      sumx2=0.d0

      do i=1,n
         sumx = sumx + x(i)
         sumy = sumy + y(i)
         sumxy= sumxy+ x(i)*y(i)
         sumx2= sumx2+ x(i)*x(i)
      end do

      a1 = (n*sumxy - sumx*sumy)/(n*sumx2 - sumx*sumx)
      a0 = (sumy - a1*sumx)/n

      print *,'a0=',a0
      print *,'a1=',a1

      end
