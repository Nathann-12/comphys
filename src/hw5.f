      program sincos_stop_on_eps
c     simple taylor series for sin, cos (input in degree)
c     print term 1..k and stop when change <= eps

      implicit real*8(a-h,o-z)
      integer k, ks, kc
      real*8 pi, deg, x, eps
      real*8 s_sum, s_prev, s_term, s_delta
      real*8 c_sum, c_prev, c_term, c_delta

      pi  = 3.141592653589793d0
      eps = 1.0d-8

      print *,'enter degree:'
      read  *, deg

c     degree -> rad, keep in [-pi, pi] for faster converge
      x = deg*pi/180.d0
      x = dmod(x + pi, 2.d0*pi) - pi

c-------------------- sin --------------------
      print *,'eps =', eps
      print *,'sin series:'
      print *,' k   term                 sum'

      k     = 0
      s_sum = 0.d0
      s_prev= 0.d0
      s_term= x

   10 continue
      s_sum  = s_sum + s_term
      write(*,'(i3,1x,1pe18.10,1x,1pe18.10)') k+1, s_term, s_sum
      s_delta = dabs(s_sum - s_prev)
      if (s_delta .le. eps) then
         ks = k+1
         goto 20
      endif
c     next term: -term*x^2/[(2k+2)(2k+3)]
      s_prev = s_sum
      s_term = -s_term * x * x / dble((2*k+2)*(2*k+3))
      k = k + 1
      goto 10

   20 continue
      print *,'sin stop at term:', ks
      print *,'sin value       :', s_sum

c-------------------- cos --------------------
      print *,'cos series:'
      print *,' k   term                 sum'

      k     = 0
      c_sum = 0.d0
      c_prev= 0.d0
      c_term= 1.d0

   30 continue
      c_sum  = c_sum + c_term
      write(*,'(i3,1x,1pe18.10,1x,1pe18.10)') k+1, c_term, c_sum
      c_delta = dabs(c_sum - c_prev)
      if (c_delta .le. eps) then
         kc = k+1
         goto 40
      endif
c     next term: -term*x^2/[(2k+1)(2k+2)]
      c_prev = c_sum
      c_term = -c_term * x * x / dble((2*k+1)*(2*k+2))
      k = k + 1
      goto 30

   40 continue
      print *,'cos stop at term:', kc
      print *,'cos value       :', c_sum

c-------------------- ref values --------------------
      print *,'ref sin (dsin):', dsin(x)
      print *,'ref cos (dcos):', dcos(x)
      end
