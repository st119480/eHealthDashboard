CREATE OR REPLACE FUNCTION sp_create_aggregate_table() RETURNS VOID
AS
$BODY$
	BEGIN
		-- create tables for initial setup
		DROP TABLE IF EXISTS public.agg_test;
		CREATE TABLE public.agg_test
		(
		  user_id bigint,
		  test_id bigint,
		  first_name character varying,
		  last_name character varying,
		  province_id bigint,
		  province character varying,
		  district_id bigint,
		  district character varying,
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
		);

		DROP TABLE IF EXISTS public.condition_by_num_of_patient;
		CREATE TABLE public.condition_by_num_of_patient
		(
		  condition text,
		  num_of_patient bigint
		);

		DROP TABLE IF EXISTS public.high_blood_sugar;
		CREATE TABLE public.high_blood_sugar
		(
		  user_id bigint,
		  test_id bigint,
		  first_name character varying,
		  last_name character varying,
		  test_date date,
		  province_id bigint,
		  province character varying,
		  district_id bigint,
		  district character varying,
		  blood_sugar_fasting integer,
		  blood_sugar_pp integer
		);

		DROP TABLE IF EXISTS public.high_bp;
		CREATE TABLE public.high_bp
		(
		  user_id bigint,
		  test_id bigint,
		  first_name character varying,
		  last_name character varying,
		  test_date date,
		  province_id bigint,
		  province character varying,
		  district_id bigint,
		  district character varying,
		  bp_systolic integer,
		  bp_diastolic integer
		);

		DROP TABLE IF EXISTS public.low_blood_sugar;
		CREATE TABLE public.low_blood_sugar
		(
		  user_id bigint,
		  test_id bigint,
		  first_name character varying,
		  last_name character varying,
		  test_date date,
		  province_id bigint,
		  province character varying,
		  district_id bigint,
		  district character varying,
		  blood_sugar_fasting integer,
		  blood_sugar_pp integer
		);

		DROP TABLE IF EXISTS public.low_bp;
		CREATE TABLE public.low_bp
		(
		  user_id bigint,
		  test_id bigint,
		  first_name character varying,
		  last_name character varying,
		  test_date date,
		  province_id bigint,
		  province character varying,
		  district_id bigint,
		  district character varying,
		  bp_systolic integer,
		  bp_diastolic integer
		);

		DROP TABLE IF EXISTS public.low_oxygen_saturation;
		CREATE TABLE public.low_oxygen_saturation
		(
		  user_id bigint,
		  test_id bigint,
		  first_name character varying,
		  last_name character varying,
		  test_date date,
		  province_id bigint,
		  province character varying,
		  district_id bigint,
		  district character varying,
		  blood_oxygen_saturation integer
		);


	END;
$BODY$
language plpgsql;

select sp_create_aggregate_table();
