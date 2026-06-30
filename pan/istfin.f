      subroutine istfin(ntot,subj,m,ist,ifin,ierr)
C
C ierr = 0 : success
C ierr = 1 : more subject blocks than expected
C
      integer ntot,m,ierr
      integer subj(ntot),ist(m),ifin(m)
      integer scur,icur,i
      ierr = 0
      scur = -999
      icur = 0
      do 100 i=1,ntot
         if (subj(i).ne.scur) then
            icur = icur + 1
            if (icur.gt.m) then
               ierr = 1
               return
            endif
            ist(icur) = i
            scur = subj(i)
         endif
100   continue
      do 200 i=1,m-1
         ifin(i)=ist(i+1)-1
200   continue
      ifin(m)=ntot
      return
      end
