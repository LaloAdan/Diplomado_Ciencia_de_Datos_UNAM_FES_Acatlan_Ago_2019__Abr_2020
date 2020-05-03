Data X;
	Set Work.Titanic;
Run;

Proc Univariate
	Data=X; HIST/NORMAL;
Run;

Proc Means
	N
	Min
	Max
	Mean
	Nmiss
	Data = Work.Titanic;
Run;

Proc Freq
	Data=Work.Titanic;
	Tables Embarked;
Run;

/* Missings */

Proc Stdize 
	Data=Work.Titanic
	Out=Imputed 
	oprefix=Orig_Mean_     /* Prefijo de la nueva variable */
    Reponly               /* Solo remplazar; No estandarizar */
    Method=Mean;          /* Mean, Median, Minimum, Midrange, etc. */
	var Age;              /* Se pueden listar multiples variables */
run;

Proc Stdize 
	Data=Work.Titanic
	Out=Imputed 
	oprefix=Orig_Median        /* Prefijo de la nueva variable */
    Reponly               /* Solo remplazar; No estandarizar */
    Method=Mode;          /* Mean, Median, Minimum, Midrange, etc. */
	var Age;              /* Se pueden listar multiples variables */
run;