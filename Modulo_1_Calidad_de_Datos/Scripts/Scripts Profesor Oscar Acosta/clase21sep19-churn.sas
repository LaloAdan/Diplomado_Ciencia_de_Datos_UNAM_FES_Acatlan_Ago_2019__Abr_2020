DATA X;
	Set Work.Import;
	format state_2 $15.;
	if state in ('OR', 'RI', 'IN', 'MI', 'OK') Then state_2="Bloque 1";
if state in ('WV', 'ID', 'NV', 'PA', 'LA') Then state_2="Bloque 2";
if state in ('KY', 'NE', 'SD', 'NJ', 'WI')  Then state_2="Bloque 3";
if state in ('AZ', 'KS', 'UT', 'DC', 'MS') Then state_2="Bloque 4";
if state in ('TN', 'CT', 'CO', 'MT', 'VT') Then state_2="Bloque 5";
if state in ('FL', 'NC', 'NY', 'OH', 'NM') Then state_2="Bloque 6";
if state in ('DE', 'ND', 'IA', 'CA', 'GA') Then state_2="Bloque 7";
if state in ('MO', 'ME', 'IL', 'WA', 'WY') Then state_2="Bloque 8";
if state in ('AK', 'VA', 'AL', 'MN', 'SC') Then state_2="Bloque 9";
if state in ('NH', 'MD', 'AR', 'TX', 'HI', 'MA') Then state_2="Bloque 10";
Run;

Proc Freq
	Data = X;
	Tables State_2;
Run;
