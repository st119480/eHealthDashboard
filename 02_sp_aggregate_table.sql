CREATE OR REPLACE FUNCTION sp_aggregate_table() RETURNS TRIGGER --SET client_min_messages = error
AS
$BODY$
DECLARE 
i integer;
	BEGIN
		-- create table if not exists
		-- drop table public.agg_test

		SELECT  into i 1
			   FROM   information_schema.tables 
			   WHERE  table_schema = 'public'
			   AND    table_name = 'agg_test';

		raise notice 'Value: %', i;

		if i is null  then
			execute 'CREATE TABLE agg_test
			(
			  user_id bigint,
			  test_id bigint,
			  first_name character varying,
			  last_name character varying,
			  province character varying,
			  district  character varying,
			  pulse_rate integer,
			  body_temperature double precision,
			  respiratory_rate integer,
			  bp_systolic integer,
			  bp_diastolic integer,
			  blood_oxygen_saturation integer,
			  blood_sugar_pp integer,
			  blood_sugar_fasting integer,
			  bmi double precision,
			  test_date date
			)';
		end if;

		-- create backup
		DROP TABLE IF EXISTS agg_test_bkup;
		CREATE TABLE agg_test_bkup AS SELECT * FROM agg_test;
		
		DROP TABLE IF EXISTS agg_test;
		create table agg_test as
		select c.id as user_id,a.id test_id, c.first_name, c.last_name, c.province_id, e.name as province, c.district_id, d.district_name as district , a.pulse_rate, 
		a.body_temperature, a.respiratory_rate, a.bp_systolic, a.bp_diastolic, a.blood_oxygen_saturation, a.blood_sugar_pp, a.blood_sugar_fasting, a.bmi, a.test_date
		from tests a
		join patients b
		on a.patient_id = b.id
		join users c
		on b.user_id = c.id
		join districts d
		on c.district_id = d.id
		join provinces e
		on c.province_id = e.id
		order by province_id, province, district_id, district ,user_id, test_id, first_name, last_name;


		-- high BP
		-- drop table high_bp
		DROP TABLE IF EXISTS high_bp;
		
		create table high_bp as
		select user_id, test_id, first_name, last_name, test_date, province_id, province, district_id, district , bp_systolic, bp_diastolic from agg_test
		where bp_systolic > 130
		or bp_diastolic > 80
		order by province_id, province, district_id, district ,user_id,test_id , first_name, last_name;

		-- low BP
		-- drop table low_bp
		DROP TABLE IF EXISTS low_bp;
		
		create table low_bp as
		select user_id, test_id, first_name, last_name, test_date, province_id, province, district_id, district , bp_systolic, bp_diastolic from agg_test
		where bp_systolic < 90
		or bp_diastolic < 60
		order by province_id, province, district_id, district ,user_id,test_id , first_name, last_name;

		-- low blood oxygen saturatio

		-- drop table low_oxygen_saturation
		DROP TABLE IF EXISTS low_oxygen_saturation;
		
		create table low_oxygen_saturation as
		select user_id, test_id, first_name, last_name, test_date, province_id, province, district_id, district , blood_oxygen_saturation from agg_test
		where blood_oxygen_saturation < 90
		order by province_id, province, district_id, district ,user_id,test_id , first_name, last_name;

		-- low blood sugar mg/dL
		-- drop table low_blood_sugar
		DROP TABLE IF EXISTS low_blood_sugar;
		
		create table low_blood_sugar as
		select user_id, test_id, first_name, last_name, test_date, province_id, province, district_id, district , blood_sugar_fasting, blood_sugar_pp from agg_test
		where blood_sugar_fasting < 100
		or blood_sugar_pp < 140
		order by province_id, province, district_id, district ,user_id,test_id , first_name, last_name;

		-- high blood sugar mg/dL
		-- drop table high_blood_sugar
		DROP TABLE IF EXISTS high_blood_sugar;
		
		create table high_blood_sugar as
		select user_id, test_id, first_name, last_name, test_date, province_id, province, district_id, district , blood_sugar_fasting, blood_sugar_pp from agg_test
		where blood_sugar_fasting > 100
		order by province_id, province, district_id, district ,user_id,test_id , first_name, last_name;

		-- drop table condition_by_num_of_patient
		DROP TABLE IF EXISTS condition_by_num_of_patient;

		CREATE TABLE condition_by_num_of_patient AS
		SELECT 'High BP' as condition, count(distinct user_id) num_of_patient FROM high_bp UNION
		SELECT 'Low BP' as condition, count(distinct user_id) num_of_patient FROM low_bp UNION
		SELECT 'Low Blood Oxygen Saturation' as condition, count(distinct user_id) num_of_patient FROM low_oxygen_saturation UNION
		SELECT 'High Blood Sugar' as condition, count(distinct user_id) num_of_patient FROM high_blood_sugar UNION
		SELECT 'Low Blood Sugar' as condition, count(distinct user_id) num_of_patient FROM low_blood_sugar;
		
		
		RETURN NULL;
	END;
$BODY$
language plpgsql;

DROP TRIGGER IF EXISTS create_aggregate_tables_after_insert on tests;
CREATE TRIGGER create_aggregate_tables_after_insert
AFTER INSERT OR UPDATE OR DELETE
ON tests
FOR EACH ROW
EXECUTE PROCEDURE sp_aggregate_table(); 





