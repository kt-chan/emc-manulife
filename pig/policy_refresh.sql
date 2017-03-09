use stg;
truncate table policy_master1;
truncate table agent_master1;
truncate table policy_client_linkage1;
truncate table client_master1;

--Get 10 policy_master records which not yet processed and put in temp table
create table pol_new as select p.pol_id from policy_master_min p where p.pol_id not in (select t.pol_id from pol_tmp t) limit 10;

--get the policy_master records 
insert into policy_master1(pol_id,no_of_coverage,prem_paid_total,crcy_code,agt_code)
select pol_id,no_of_coverage,prem_paid_total,crcy_code,agt_code from policy_master_min p where p.pol_id in (select t.pol_id from pol_new t);

--get the records where agent_code exist in the policy_master temp table
insert into agent_master1(agent_code,agent_name,agent_status_desc,rank_code_sdesc,district_name,branch_name)
select agent_code,agent_name,agent_status_desc,rank_code_sdesc,district_name,branch_name from agent_master_min a where a.agent_code in (select p.agt_code from policy_master_min p inner join pol_new t on t.pol_id=p.pol_id);

--get the records where agent_code exist in the policy_master temp table
insert into policy_client_linkage1(pol_id,client_id,active_status)
select pol_id,client_id,active_status from policy_client_linkage_min l where l.pol_id in (select t.pol_id from pol_new t);

--get the records where agent_code exist in the policy_master temp table
insert into client_master1(client_id,surname,given_name,gender,dob)
select client_id,surname,given_name,gender,dob from client_master_min c where c.client_id in (select l.client_id from policy_client_linkage_min l inner join pol_new t on t.pol_id=l.pol_id);

--store the pol_id in the pol_tmp table so it won't be processed in next run
--insert into pol_tmp select pol_id from pol_new;
drop table if exists pol_new;

--Data masking
--update policy_master1 set crcy_code='HKD';
--update agent_master1 set district_name='Hong Kong', branch_name='Hong Kong';
--update client_master1 set surname='CHAN', given_name='TAI MAN';

--transfer data to ddw 
use ddw;
truncate table ddw.policy_master;
truncate table ddw.agent_master;
truncate table ddw.client_master;
truncate table ddw.policy_client_linkage;

insert into policy_master(pol_id,no_of_coverage,prem_paid_total,crcy_code,agt_code)
select pol_id,no_of_coverage,prem_paid_total,crcy_code,agt_code from stg.policy_master1;

insert into agent_master(agent_code,agent_name,agent_status_desc,rank_code_sdesc,district_name,branch_name)
select agent_code,agent_name,agent_status_desc,rank_code_sdesc,district_name,branch_name from stg.agent_master1;

insert into policy_client_linkage(pol_id,client_id,active_status)
select pol_id,client_id,active_status from stg.policy_client_linkage1;

insert into client_master(client_id,surname,given_name,gender,dob)
select client_id,surname,given_name,gender,dob from stg.client_master1;

