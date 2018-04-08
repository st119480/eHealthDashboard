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
			  city_village character varying,
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
		select c.id as user_id,a.id test_id, c.first_name, c.last_name, c.province, c.city_village, a.pulse_rate, a.body_temperature, a.respiratory_rate, a.bp_systolic, a.bp_diastolic, a.blood_oxygen_saturation,
		a.blood_sugar_pp, a.blood_sugar_fasting, a.bmi, a.test_date
		from tests a
		join patients b
		on a.patient_id = b.id
		join users c
		on b.user_id = c.id
		order by province, city_village,user_id, test_id, first_name, last_name;


		-- high BP
		-- drop table high_bp
		DROP TABLE IF EXISTS high_bp;
		
		create table high_bp as
		select user_id, test_id, first_name, last_name, test_date, province, city_village, bp_systolic, bp_diastolic from agg_test
		where bp_systolic > 130
		or bp_diastolic > 80
		order by province, city_village,user_id,test_id , first_name, last_name;

		-- low BP
		-- drop table low_bp
		DROP TABLE IF EXISTS low_bp;
		
		create table low_bp as
		select user_id, test_id, first_name, last_name, test_date, province, city_village, bp_systolic, bp_diastolic from agg_test
		where bp_systolic < 90
		or bp_diastolic < 60
		order by province, city_village,user_id,test_id , first_name, last_name;

		-- low blood oxygen saturatio

		-- drop table low_oxygen_saturation
		DROP TABLE IF EXISTS low_oxygen_saturation;
		
		create table low_oxygen_saturation as
		select user_id, test_id, first_name, last_name, test_date, province, city_village, blood_oxygen_saturation from agg_test
		where blood_oxygen_saturation < 90
		order by province, city_village,user_id,test_id , first_name, last_name;

		-- low blood sugar mg/dL
		-- drop table low_blood_sugar
		DROP TABLE IF EXISTS low_blood_sugar;
		
		create table low_blood_sugar as
		select user_id, test_id, first_name, last_name, test_date, province, city_village, blood_sugar_fasting, blood_sugar_pp from agg_test
		where blood_sugar_fasting < 100
		or blood_sugar_pp < 140
		order by province, city_village,user_id,test_id , first_name, last_name;

		-- high blood sugar mg/dL
		-- drop table high_blood_sugar
		DROP TABLE IF EXISTS high_blood_sugar;
		
		create table high_blood_sugar as
		select user_id, test_id, first_name, last_name, test_date, province, city_village, blood_sugar_fasting, blood_sugar_pp from agg_test
		where blood_sugar_fasting > 100
		order by province, city_village,user_id,test_id , first_name, last_name;
		RETURN NULL;
	END;
$BODY$
language plpgsql;

CREATE TRIGGER create_aggregate_tables_after_insert
AFTER INSERT OR UPDATE OR DELETE
ON tests
FOR EACH ROW
EXECUTE PROCEDURE sp_aggregate_table(); 

