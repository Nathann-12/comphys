      program taylortrigdeg
      implicit real*8(a-h,o-z)
      integer n,k,fact
      parameter (n=10)
      real*8 pi,xdeg,xrad,sums,term,sumc,eps
      pi=3.141592653589793d0
      eps=1.0d-8   ! เกณฑ์หยุด

      print *,'enter angle in degrees:'
      read *,xdeg
      xrad=xdeg*pi/180.d0

c --- sin ---
      sums=0.d0
      do k=0,n-1
         term=(( -1.d0 )**k)*(xrad**(2*k+1))/dble(fact(2*k+1))
         if (dabs(term) .lt. eps) then
            print *,'sin stopped at term',k+1
            exit
         end if
         sums=sums+term
         print *,'sin term',k+1,'=',term,' sum=',sums
      end do
      print *,'final sin(',xdeg,'deg)=',sums

c --- cos ---
      sumc=0.d0
      do k=0,n-1
         term=(( -1.d0 )**k)*(xrad**(2*k))/dble(fact(2*k))
         if (dabs(term) .lt. eps) then
            print *,'cos stopped at term',k+1
            exit
         end if
         sumc=sumc+term
         print *,'cos term',k+1,'=',term,' sum=',sumc
      end do
      print *,'final cos(',xdeg,'deg)=',sumc
      end

      integer function fact(n)
      integer n,i
      fact=1
      do i=2,n
         fact=fact*i
      end do
      return
      end
