/*********************************************************************
   Returns the imcomplete gamma functions P(a,x) and Q(a,x).
   C.A. Bertulani        May/15/2000
*********************************************************************/

typedef double Number;

#include <math.h>
#include<iostream.h>

int main(){
	Number gammp(Number , Number );
	Number gammq(Number , Number );
	Number a, x;
	int j;
	j=1;
	cout << "\n Enter a and x. To stop, enter a<0\n";
	cout << "\n Wanna check? Note that P(a,0) = 0, and P(a, infnity) = 1 \n";
	cin >> a >> x;
    while(a>=0){
		if(j>10){ cout << "\n My patience is over. Stop, please!\n";
			break;
		}
		if(j!=1){
			cout << "\n\n Enter a and x. To stop, enter x<0.\n";
			cin >> a >> x;
		}
		cout << "\n P(a,x): " << gammp(a,x);
		cout << "\n Q(a,x): " << gammq(a,x);
		j=j+1;
	}
	return 0;
}
/*********************************************************************
   Returns the imcomplete gamma function
   P(a,x) = (int_0^x e^{-t} t^{a-1} dt)/Gamma(a) ,      (a > 0).
   C.A. Bertulani        May/15/2000
*********************************************************************/
Number gammp(Number a, Number x)
{
	void gcf(Number *gammcf, Number a, Number x, Number *gln);
	void gser(Number *gamser, Number a, Number x, Number *gln);
	Number gamser,gammcf,gln;

	if (x < 0.0 || a <= 0.0) cerr<< "Invalid arguments in routine gammp";
	if (x < (a+1.0)) {
		gser(&gamser,a,x,&gln);
		return gamser;
	} else {			/* Use the continued fraction representation */
		gcf(&gammcf,a,x,&gln);  /* and take its complement. */
		return 1.0-gammcf;
	}
}
/*********************************************************************
   Returns the imcomplete gamma function 
   Q(a,x) = 1-P(a,x)
		  = (int_x^infinity e^{-t} t^{a-1} dt)/Gamma(a) ,      (a > 0). 
   C.A. Bertulani        May/15/2000
*********************************************************************/
Number gammq(Number a, Number x)
{
	void gcf(Number *gammcf, Number a, Number x, Number *gln);
	void gser(Number *gamser, Number a, Number x, Number *gln);
	Number gamser,gammcf,gln;

	if (x < 0.0 || a <= 0.0) cerr << "Invalid arguments in routine gammq";
	if (x < (a+1.0)) {		/* Use the series representation */
		gser(&gamser,a,x,&gln);
		return 1.0-gamser;	  /* and take its complement. */
	} else {			/* Use the continued fraction representation. */
		gcf(&gammcf,a,x,&gln);
		return gammcf;
	}
}
/*********************************************************************
   Returns the imcomplete gamma function P(a,x) evaluated by its series
   representation as gamser.
   Also returns ln(Gamma(a)) as gln.
   C.A. Bertulani        May/15/2000
*********************************************************************/
#define ITMAX 100
#define EPS 3.0e-7

void gser(Number *gamser, Number a, Number x, Number *gln)
{
	Number gamma_ln(Number xx);
	int n;
	Number sum,del,ap;

	*gln=gamma_ln(a);
	if (x <= 0.0) {
		if (x < 0.0) cerr << "x less than 0 in routine gser";
		*gamser=0.0;
		return;
	} else {
		ap=a;
		del=sum=1.0/a;
		for (n=1;n<=ITMAX;n++) {
			++ap;
			del *= x/ap;
			sum += del;
			if (fabs(del) < fabs(sum)*EPS) {
				*gamser=sum*exp(-x+a*log(x)-(*gln));
				return;
			}
		}
		cerr << "a too large, ITMAX too small in routine gser";
		return;
	}
}
#undef ITMAX
#undef EPS
/*********************************************************************
   Returns the imcomplete gamma function Q(a,x) evaluated by its 
   continued fraction representation as gammcf.
   Also returns ln(Gamma(a)) as gln.
   C.A. Bertulani        May/15/2000
*********************************************************************/
#define ITMAX 100			/* Maximum allowed number of iterations. */
#define EPS 3.0e-7			/* Relative accuracy */
#define FPMIN 1.0e-30		/* Number near the smallest representable */
							/* floating point number. */

void gcf(Number *gammcf, Number a, Number x, Number *gln)
{
	Number gamma_ln(Number xx);
	int i;
	Number an,b,c,d,del,h;

	*gln=gamma_ln(a);
	b=x+1.0-a;		/* etup fr evaluating continued fracion by modified Lent'z */
	c=1.0/FPMIN;	/* method with b_0 = 0. */
	d=1.0/b;
	h=d;
	for (i=1;i<=ITMAX;i++) {   /* Iterate to convergence. */
		an = -i*(i-a);
		b += 2.0;
		d=an*d+b;
		if (fabs(d) < FPMIN) d=FPMIN;
		c=b+an/c;
		if (fabs(c) < FPMIN) c=FPMIN;
		d=1.0/d;
		del=d*c;
		h *= del;
		if (fabs(del-1.0) < EPS) break;
	}
	if (i > ITMAX) cerr << "a too large, ITMAX too small in gcf";
	*gammcf=exp(-x+a*log(x)-(*gln))*h;		/* Put factors in front.  */
}
#undef ITMAX
#undef EPS
#undef FPMIN
/********************************************************************
   Returns the value of ln[Gamma(xx)] for xx > 0
********************************************************************/

Number gamma_ln(Number xx)
{
	Number x,y,tmp,ser;
	static Number cof[6]={76.18009172947146,-86.50532032941677,
		24.01409824083091,-1.231739572450155,
		0.1208650973866179e-2,-0.5395239384953e-5};
	int j;

	y=x=xx;
	tmp=x+5.5;
	tmp -= (x+0.5)*log(tmp);
	ser=1.000000000190015;
	for (j=0;j<=5;j++) ser += cof[j]/++y;
	return -tmp+log(2.5066282746310005*ser/x);
}
/*********************************************************************/


