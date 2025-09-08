      program hw6_2
      implicit real*8(a-h,o-z)
      integer n,i
      parameter (n=10)
      real*8 x(n), y(n)
      real*8 xtx(2,2), xty(2), det, inv(2,2), beta(2)

c --- input data ---
      data x /1,3,5,7,10,12,13,16,18,20/
      data y /4,5,6,5, 8, 7, 6, 9,12,11/

c --- build matrices ---
      xtx(1,1)=n
      xtx(1,2)=0.d0
      xtx(2,1)=0.d0
      xtx(2,2)=0.d0
      xty(1)=0.d0
      xty(2)=0.d0

      do i=1,n
         xtx(1,2)=xtx(1,2)+x(i)
         xtx(2,1)=xtx(2,1)+x(i)
         xtx(2,2)=xtx(2,2)+x(i)*x(i)
         xty(1)=xty(1)+y(i)
         xty(2)=xty(2)+x(i)*y(i)
      end do

c --- inverse of 2x2 ---
      det = xtx(1,1)*xtx(2,2)-xtx(1,2)*xtx(2,1)
      inv(1,1)= xtx(2,2)/det
      inv(1,2)=-xtx(1,2)/det
      inv(2,1)=-xtx(2,1)/det
      inv(2,2)= xtx(1,1)/det

c --- beta = inv * xty ---
      beta(1)=inv(1,1)*xty(1)+inv(1,2)*xty(2)
      beta(2)=inv(2,1)*xty(1)+inv(2,2)*xty(2)

      print *,'a0=',beta(1)
      print *,'a1=',beta(2)

      end
