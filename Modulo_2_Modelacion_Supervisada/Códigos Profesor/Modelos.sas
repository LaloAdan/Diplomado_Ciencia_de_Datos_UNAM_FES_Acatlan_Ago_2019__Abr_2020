Data X;
	Set Work.Import;
	tgt_success = shares >= 6000;
	Rename
		n_tokens_title=v_n_tokens_title
		n_tokens_content=v_n_tokens_content
		n_unique_tokens=v_n_unique_tokens
		n_non_stop_words=v_n_non_stop_words
		n_non_stop_unique_tokens=v_n_non_stop_unique_tokens
		num_hrefs=v_num_hrefs
		num_self_hrefs=v_num_self_hrefs
		num_imgs=v_num_imgs
		num_videos=v_num_videos
		average_token_length=v_average_token_length
		num_keywords=v_num_keywords
		kw_min_min=v_kw_min_min
		kw_max_min=v_kw_max_min
		kw_avg_min=v_kw_avg_min
		kw_min_max=v_kw_min_max
		kw_max_max=v_kw_max_max
		kw_avg_max=v_kw_avg_max
		kw_min_avg=v_kw_min_avg
		kw_max_avg=v_kw_max_avg
		kw_avg_avg=v_kw_avg_avg
		self_reference_min_shares=v_self_reference_min_shares
		self_reference_max_shares=v_self_reference_max_shares
		self_reference_avg_sharess=v_self_reference_avg_sharess
		LDA_00=v_LDA_00
		LDA_01=v_LDA_01
		LDA_02=v_LDA_02
		LDA_03=v_LDA_03
		LDA_04=v_LDA_04
		global_subjectivity=v_global_subjectivity
		global_sentiment_polarity=v_global_sentiment_polarity
		global_rate_positive_words=v_global_rate_positive_words
		global_rate_negative_words=v_global_rate_negative_words
		rate_positive_words=v_rate_positive_words
		rate_negative_words=v_rate_negative_words
		avg_positive_polarity=v_avg_positive_polarity
		min_positive_polarity=v_min_positive_polarity
		max_positive_polarity=v_max_positive_polarity
		avg_negative_polarity=v_avg_negative_polarity
		min_negative_polarity=v_min_negative_polarity
		max_negative_polarity=v_max_negative_polarity
		title_subjectivity=v_title_subjectivity
		title_sentiment_polarity=v_title_sentiment_polarity
		abs_title_subjectivity=v_abs_title_subjectivity
		abs_title_sentiment_polarity=v_abs_title_sentiment_polarity
		shares=tgt_shares;
Run;

Proc Means 
	Data=X;
Run;

Proc Univariate 
	Data=X;
Run;

/* Regresión Lineal */

Proc Reg
	Data=X;
	Model tgt_shares = v_:;
Run;

/* Regresión Logística*/

Ods Graphics ON;
Proc Logistic Data=X
	Plots (Only)=ROC;
	Model tgt_success (Event = '1')= v_: / Selection=Stepwise
	 SLE=0.1
	 SLS=0.05
	 INCLUDE=0
	 LINK=LOGIT
	 ALPHA=0.05
	 CLPARM=WALD
	 TECHNIQUE=NEWTON;
	 OUTPUT OUT=SALIDA
	 PREDPROBS=INDIVIDUAL;
RUN;
QUIT;
Ods Graphics OFF; 

/* Regresión LARS */

Ods Graphics ON;
Proc GLMSelect 
	Data=X
	Plots=All;
	Model tgt_shares = v_: / Selection = LAR (Choose = CV Stop = None);
Run;
Ods Graphics OFF;

/* Regresión Lasso */

Ods Graphics ON;
Proc GLMSelect 
	Data=X
	Plots=All;
	Model tgt_shares = v_: / Selection = LASSO (Choose = CV Stop = None);
Run;
Ods Graphics OFF;

/* Regresión de Cresta */

Proc Reg
	Data=X 
	Outest=b
	Ridge=0 to 0.02 by .002;
	Model tgt_shares = v_:;
Run;

/* Red Elástica */

Ods Graphics ON;
Proc GLMSelect 
	Data=X
	Plots=All;
	Model tgt_shares = v_: / Selection = Elasticnet (Choose = CV Stop = None);
Run;

/* Análisis discriminante */

Proc Discrim
	Data = X;
	Class tgt_success;
	Var v_:;
run;

/* Support Vector Machines */

Proc SVMachine
	Data=X;
	Input v_: / Level=interval; 
	Target tgt_success / Desc;
Run;

/* KNN */

Proc Discrim
	Data = X method=Npar K=40;
	Class tgt_success;
	Var v_:;
run;

%Macro HyperLogistic(mysle);
	Ods Graphics ON;
	Proc Logistic Data=X
		Plots (Only)=ROC;
		Model tgt_success (Event = '1')= v_: / Selection=Stepwise
		 SLE=&mysle
		 SLS=0.05
		 INCLUDE=0
		 LINK=LOGIT
		 ALPHA=0.05
		 CLPARM=WALD
		 TECHNIQUE=NEWTON;
		 OUTPUT OUT=SALIDA
		 PREDPROBS=INDIVIDUAL;
	RUN;
	QUIT;
	Ods Graphics OFF;
%Mend;

%HyperLogistic(0.1);
	
