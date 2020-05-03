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
		data_channel_is_lifestyle = c_data_channel_is_lifestyle
		data_channel_is_entertainment = c_data_channel_is_entertainment
		data_channel_is_bus = c_data_channel_is_bus
		data_channel_is_socmed = c_data_channel_is_socmed
		data_channel_is_tech = c_data_channel_is_tech
		data_channel_is_world = c_data_channel_is_world
		weekday_is_monday = c_weekday_is_monday
		weekday_is_tuesday = c_weekday_is_tuesday
		weekday_is_wednesday = c_weekday_is_wednesday
		weekday_is_thursday = c_weekday_is_thursday
		weekday_is_friday = c_weekday_is_friday
		weekday_is_saturday = c_weekday_is_saturday
		weekday_is_sunday = c_weekday_is_sunday
		is_weekend = c_is_weekend
		shares=tgt_shares;
Run;

Proc Means 
	Data=X;
Run;

Proc Univariate 
	Data=X;
Run;

Ods Graphics ON;
Proc HPSPLIT 
	Data=X maxdepth=6 leafsize=0.05 maxbranch=10;
	class c_: tgt_success;
	model tgt_shares = v_: c_:;
	output out=hpsplout;
	RULES FILE='/home/oscaracostamac0/sasuser.v94/reglas.sas';
	partition fraction(validate=0.3 seed=123);
run;
Ods Graphics OFF;