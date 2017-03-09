 truncate table ddw.fxrate;
 
 insert into ddw.fxrate 
 select 
	 substring(id, 1, 3) as base,  
	 substring(id, 4, 3) as quote, 
	 rate, 
	 to_date(from_unixtime(UNIX_TIMESTAMP(`date` , 'dd/MM/yyyy'))) as `date`
 from stg.exchange_rates;

 truncate table stg.exchange_rates;
