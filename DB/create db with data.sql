/*
Navicat PGSQL Data Transfer

Source Server         : localhost
Source Server Version : 90602
Source Host           : localhost:5432
Source Database       : smart_home
Source Schema         : smart

Target Server Type    : PGSQL
Target Server Version : 90602
File Encoding         : 65001

Date: 2017-05-11 15:23:30
*/


-- ----------------------------
-- Sequence structure for device_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "device_id_seq";
CREATE SEQUENCE "device_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 2
 CACHE 1;
SELECT setval('"smart"."device_id_seq"', 2, true);

-- ----------------------------
-- Sequence structure for device_type_command_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "device_type_command_id_seq";
CREATE SEQUENCE "device_type_command_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 7
 CACHE 1;
SELECT setval('"smart"."device_type_command_id_seq"', 7, true);

-- ----------------------------
-- Sequence structure for schedule_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "schedule_id_seq";
CREATE SEQUENCE "schedule_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 9
 CACHE 1;
SELECT setval('"smart"."schedule_id_seq"', 9, true);

-- ----------------------------
-- Table structure for communication_type
-- ----------------------------
DROP TABLE IF EXISTS "communication_type";
CREATE TABLE "communication_type" (
"communication_type_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of communication_type
-- ----------------------------
BEGIN;
INSERT INTO "communication_type" VALUES ('1', 'Bluetooth');
COMMIT;

-- ----------------------------
-- Table structure for device
-- ----------------------------
DROP TABLE IF EXISTS "device";
CREATE TABLE "device" (
"device_id" int4 DEFAULT nextval('"smart".device_id_seq'::regclass) NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL,
"device_type_id" int4 NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device
-- ----------------------------
BEGIN;
INSERT INTO "device" VALUES ('1', 'Розетка мобильная тестовая', '1');
COMMIT;

-- ----------------------------
-- Table structure for device_communication_config
-- ----------------------------
DROP TABLE IF EXISTS "device_communication_config";
CREATE TABLE "device_communication_config" (
"device_id" int4 NOT NULL,
"communication_type_id" int4 NOT NULL,
"param1" varchar(50) COLLATE "default",
"param2" varchar(50) COLLATE "default",
"param3" varchar(50) COLLATE "default",
"param4" varchar(50) COLLATE "default",
"param5" varchar(50) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device_communication_config
-- ----------------------------
BEGIN;
INSERT INTO "device_communication_config" VALUES ('1', '1', '98:D3:31:FC:1D:D2', '1', null, null, null);
COMMIT;

-- ----------------------------
-- Table structure for device_data
-- ----------------------------
DROP TABLE IF EXISTS "device_data";
CREATE TABLE "device_data" (
"device_id" int4 NOT NULL,
"event_time" timestamp(6) DEFAULT now() NOT NULL,
"device_type_command_id" int4 NOT NULL,
"command_result" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device_data
-- ----------------------------
BEGIN;
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:13:41.903', '4', 'Disabled');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:18:46.806', '4', 'Disabled');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:18:52.888', '7', '11819');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:24:44.428', '4', 'Disabled');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:24:50.321', '7', '12176');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:30:08.895', '4', 'Disabled');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:30:10.37', '6', '0');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:30:11.922', '7', '17');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:42:22.035', '4', 'Enabled');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:42:23.549', '6', '0');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 16:42:25.036', '7', '4');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 17:05:59.849', '4', 'Enabled');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 17:06:01.325', '6', '0');
INSERT INTO "device_data" VALUES ('1', '2017-05-03 17:06:02.779', '7', '5');
COMMIT;

-- ----------------------------
-- Table structure for device_schedule
-- ----------------------------
DROP TABLE IF EXISTS "device_schedule";
CREATE TABLE "device_schedule" (
"device_id" int4 NOT NULL,
"schedule_id" int4 NOT NULL,
"device_type_command_id" int4 NOT NULL,
"command_param" varchar(50) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device_schedule
-- ----------------------------
BEGIN;
INSERT INTO "device_schedule" VALUES ('1', '1', '1', null);
INSERT INTO "device_schedule" VALUES ('1', '7', '4', null);
INSERT INTO "device_schedule" VALUES ('1', '7', '6', null);
INSERT INTO "device_schedule" VALUES ('1', '7', '7', null);
INSERT INTO "device_schedule" VALUES ('1', '8', '2', null);
INSERT INTO "device_schedule" VALUES ('1', '9', '4', null);
COMMIT;

-- ----------------------------
-- Table structure for device_type
-- ----------------------------
DROP TABLE IF EXISTS "device_type";
CREATE TABLE "device_type" (
"device_type_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device_type
-- ----------------------------
BEGIN;
INSERT INTO "device_type" VALUES ('1', 'Розетка');
COMMIT;

-- ----------------------------
-- Table structure for device_type_command
-- ----------------------------
DROP TABLE IF EXISTS "device_type_command";
CREATE TABLE "device_type_command" (
"device_type_id" int4 NOT NULL,
"command_name" varchar(50) COLLATE "default" NOT NULL,
"command" varchar(50) COLLATE "default" NOT NULL,
"has_param" bit(1) DEFAULT (0)::bit(1) NOT NULL,
"device_type_command_id" int4 DEFAULT nextval('"smart".device_type_command_id_seq'::regclass) NOT NULL,
"has_result" bit(1) DEFAULT (0)::bit(1) NOT NULL,
"create_time" timestamp(6) DEFAULT (now())::timestamp without time zone NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device_type_command
-- ----------------------------
BEGIN;
INSERT INTO "device_type_command" VALUES ('1', 'Включить', 'Enable', E'0', '1', E'0', '2017-05-11 15:10:56.687652');
INSERT INTO "device_type_command" VALUES ('1', 'Выключить', 'Disable', E'0', '2', E'0', '2017-05-11 15:10:56.687652');
INSERT INTO "device_type_command" VALUES ('1', 'Включить на (мин)', 'Enable', E'1', '3', E'0', '2017-05-11 15:10:56.687652');
INSERT INTO "device_type_command" VALUES ('1', 'Получить статус', 'GetStatus', E'0', '4', E'1', '2017-05-11 15:10:56.687652');
INSERT INTO "device_type_command" VALUES ('1', 'Получить установленное время до отключения (мсек)', 'GetTotalDuration', E'0', '6', E'1', '2017-05-11 15:10:56.687652');
INSERT INTO "device_type_command" VALUES ('1', 'Получить прошедшее время после включения (мсек)', 'GetCurrentDuration', E'0', '7', E'1', '2017-05-11 15:10:56.687652');
COMMIT;

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS "schedule";
CREATE TABLE "schedule" (
"schedule_id" int4 DEFAULT nextval('"smart".schedule_id_seq'::regclass) NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL,
"start_time" timestamp(6),
"end_time" timestamp(6),
"active" bit(1) DEFAULT (0)::bit(1) NOT NULL,
"schedule_type_id" int4 NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of schedule
-- ----------------------------
BEGIN;
INSERT INTO "schedule" VALUES ('1', 'Включить розетку', '2017-05-02 12:00:00', null, E'1', '2');
INSERT INTO "schedule" VALUES ('7', 'Получить статус', '2017-05-03 11:25:49', null, E'1', '2');
INSERT INTO "schedule" VALUES ('8', 'Выключить розетку', '2017-05-03 16:31:52', null, E'1', '3');
INSERT INTO "schedule" VALUES ('9', 'Запуск в 02:00', '2017-05-01 02:00:00', null, E'1', '11');
COMMIT;

-- ----------------------------
-- Table structure for schedule_report
-- ----------------------------
DROP TABLE IF EXISTS "schedule_report";
CREATE TABLE "schedule_report" (
"device_id" int4 NOT NULL,
"schedule_id" int4 NOT NULL,
"device_type_command_id" int4 NOT NULL,
"done_time" timestamp(6) DEFAULT now() NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of schedule_report
-- ----------------------------
BEGIN;
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-02 15:19:24');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-02 17:32:30.038455');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 10:03:43.689888');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 10:09:22.344787');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 10:20:26.768');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 10:29:14.966');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 10:57:28.667615');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 11:01:30.779');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 16:42:20.594');
INSERT INTO "schedule_report" VALUES ('1', '1', '1', '2017-05-03 17:05:58.329');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:10:01.37');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:11:35.124');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:12:55.173');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:18:46.806');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:24:44.428');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:30:08.895');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 16:42:22.035');
INSERT INTO "schedule_report" VALUES ('1', '7', '4', '2017-05-03 17:05:59.849');
INSERT INTO "schedule_report" VALUES ('1', '7', '6', '2017-05-03 16:30:10.37');
INSERT INTO "schedule_report" VALUES ('1', '7', '6', '2017-05-03 16:42:23.549');
INSERT INTO "schedule_report" VALUES ('1', '7', '6', '2017-05-03 17:06:01.325');
INSERT INTO "schedule_report" VALUES ('1', '7', '7', '2017-05-03 16:18:52.888');
INSERT INTO "schedule_report" VALUES ('1', '7', '7', '2017-05-03 16:24:50.321');
INSERT INTO "schedule_report" VALUES ('1', '7', '7', '2017-05-03 16:30:11.922');
INSERT INTO "schedule_report" VALUES ('1', '7', '7', '2017-05-03 16:42:25.036');
INSERT INTO "schedule_report" VALUES ('1', '7', '7', '2017-05-03 17:06:02.779');
INSERT INTO "schedule_report" VALUES ('1', '8', '2', '2017-05-03 16:42:26.539');
INSERT INTO "schedule_report" VALUES ('1', '8', '2', '2017-05-03 17:06:04.175');
COMMIT;

-- ----------------------------
-- Table structure for schedule_type
-- ----------------------------
DROP TABLE IF EXISTS "schedule_type";
CREATE TABLE "schedule_type" (
"schedule_type_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of schedule_type
-- ----------------------------
BEGIN;
INSERT INTO "schedule_type" VALUES ('1', 'Один раз');
INSERT INTO "schedule_type" VALUES ('2', '1 мин');
INSERT INTO "schedule_type" VALUES ('3', '5 мин');
INSERT INTO "schedule_type" VALUES ('4', '10 мин');
INSERT INTO "schedule_type" VALUES ('5', '15 мин');
INSERT INTO "schedule_type" VALUES ('6', '30 мин');
INSERT INTO "schedule_type" VALUES ('7', '1 час');
INSERT INTO "schedule_type" VALUES ('8', '3 час');
INSERT INTO "schedule_type" VALUES ('9', '6 час');
INSERT INTO "schedule_type" VALUES ('10', '12 час');
INSERT INTO "schedule_type" VALUES ('11', '1 день');
INSERT INTO "schedule_type" VALUES ('12', '1 нед');
COMMIT;

-- ----------------------------
-- Function structure for device_save_data
-- ----------------------------
CREATE OR REPLACE FUNCTION "device_save_data"("p_device_id" int4, "p_time" timestamp, "p_command_id" int4, "p_command_result" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
	INSERT INTO smart.device_data (device_id, event_time, device_type_command_id, command_result)
	VALUES (p_device_id, p_time, p_command_id, p_command_result);
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for schedule_get_active_commands
-- ----------------------------
CREATE OR REPLACE FUNCTION "schedule_get_active_commands"(IN "p_time" timestamp, IN "p_communication_type_id" int4)
  RETURNS TABLE("device_id" int4, "schedule_id" int4, "device_type_command_id" int4, "mac" varchar, "port" varchar, "command" varchar, "has_param" bit, "has_result" bit, "command_param" varchar, "start_time" timestamp, "end_time" timestamp)  AS $BODY$
BEGIN
	RETURN QUERY 
	SELECT cfg.device_id, sch.schedule_id, dsch.device_type_command_id, cfg.param1 AS mac, cfg.param2 AS "port", cmd.command, cmd.has_param, cmd.has_result, dsch.command_param, sch.start_time, sch.end_time
	FROM smart.schedule sch
		INNER JOIN smart.device_schedule dsch ON dsch.schedule_id = sch.schedule_id
		INNER JOIN smart.device_type_command cmd ON cmd.device_type_command_id = dsch.device_type_command_id
		INNER JOIN smart.device_communication_config cfg ON cfg.device_id = dsch.device_id
		LEFT JOIN
			(
				SELECT r.device_id, r.schedule_id, r.device_type_command_id, MAX(r.done_time) AS done_time
				FROM smart.schedule_report r
				GROUP BY r.device_id, r.schedule_id, r.device_type_command_id
			) sch_rep ON sch_rep.device_id = dsch.device_id AND sch_rep.schedule_id = dsch.schedule_id AND sch_rep.device_type_command_id = dsch.device_type_command_id
	WHERE cfg.communication_type_id = p_communication_type_id
		AND sch.active = CAST(1 AS BIT)
		AND p_time >= sch.start_time AND (sch.end_time IS NULL OR p_time <= sch.end_time)
		AND (
			(sch.schedule_type_id = 1 AND sch_rep.done_time IS NULL)

			OR (sch.schedule_type_id = 2 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 1)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 1)))
			
			OR (sch.schedule_type_id = 3 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 5)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 5)))
			
			OR (sch.schedule_type_id = 4 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 10)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 10)))
			
			OR (sch.schedule_type_id = 5 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 15)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 15)))
			
			OR (sch.schedule_type_id = 6 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 30)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 30)))
			
			OR (sch.schedule_type_id = 7 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 60)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 60)))
			
			OR (sch.schedule_type_id = 8 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 180)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 180)))
			
			OR (sch.schedule_type_id = 9 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 360)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 360)))
			
			OR (sch.schedule_type_id = 10 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 720)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 720)))
			
			OR (sch.schedule_type_id = 11 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 1440)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 1440)))
			
			OR (sch.schedule_type_id = 12 AND (COALESCE(sch_rep.done_time, cmd.create_time) NOT BETWEEN 
				smart.schedule_get_left_edge_of_interval(sch.start_time, p_time, 10080)
				AND
				smart.schedule_get_right_edge_of_interval(sch.start_time, p_time, 10080))))
			
ORDER BY sch.start_time;
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for schedule_get_data
-- ----------------------------
CREATE OR REPLACE FUNCTION "schedule_get_data"(IN "p_schedule_id" int4, IN "p_active" bit)
  RETURNS TABLE("schedule_id" int4, "schedule_name" varchar, "active" bit, "start_time" timestamp, "end_time" timestamp, "schedule_type" varchar, "device_name" varchar, "command_name" varchar, "command_param" varchar)  AS $BODY$
BEGIN
	RETURN QUERY 

	SELECT sch.schedule_id,
		sch."name" AS "schedule_name", 
		sch.active,
		sch.start_time,
		sch.end_time,
		scht."name" AS "schedule_type",
		d."name" AS "device_name",
		cmd.command_name,
		dsch.command_param
	FROM smart.schedule sch
		INNER JOIN smart.schedule_type scht ON scht.schedule_type_id = sch.schedule_type_id
		INNER JOIN smart.device_schedule dsch ON dsch.schedule_id = sch.schedule_id
		INNER JOIN smart.device d ON d.device_id = dsch.device_id
		INNER JOIN smart.device_type_command cmd ON cmd.device_type_id = d.device_type_id
	WHERE dsch.device_type_command_id = cmd.device_type_command_id
		AND (p_schedule_id IS NULL OR p_schedule_id = sch.schedule_id)
		AND (p_active IS NULL OR p_active = sch.active)
	ORDER BY sch.schedule_id, d.device_id, cmd.command_name;

END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for schedule_get_left_edge_of_interval
-- ----------------------------
CREATE OR REPLACE FUNCTION "schedule_get_left_edge_of_interval"("p_start_time" timestamp, "p_curr_time" timestamp, "p_interval_minute" int4)
  RETURNS "pg_catalog"."timestamp" AS $BODY$BEGIN
	
	RETURN p_start_time + trunc((date_part('day', p_curr_time - p_start_time) * 1440 + date_part('hour', p_curr_time - p_start_time) * 60 + date_part('minute', p_curr_time - p_start_time)) / p_interval_minute) * p_interval_minute * INTERVAL '1 minute';
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for schedule_get_right_edge_of_interval
-- ----------------------------
CREATE OR REPLACE FUNCTION "schedule_get_right_edge_of_interval"("p_start_time" timestamp, "p_curr_time" timestamp, "p_interval_minute" int4)
  RETURNS "pg_catalog"."timestamp" AS $BODY$BEGIN
	
	RETURN p_start_time + trunc((date_part('day', p_curr_time - p_start_time) * 1440 + date_part('hour', p_curr_time - p_start_time) * 60 + date_part('minute', p_curr_time - p_start_time)) / p_interval_minute + 1) * p_interval_minute * INTERVAL '1 minute';
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for schedule_save_report
-- ----------------------------
CREATE OR REPLACE FUNCTION "schedule_save_report"("p_device_id" int4, "p_schedule_id" int4, "p_device_type_command_id" int4, "p_time" timestamp)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
	INSERT INTO smart.schedule_report (device_id, schedule_id, device_type_command_id, done_time)
	VALUES (p_device_id, p_schedule_id, p_device_type_command_id, p_time);
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
ALTER SEQUENCE "device_id_seq" OWNED BY "device"."device_id";
ALTER SEQUENCE "device_type_command_id_seq" OWNED BY "device_type_command"."device_type_command_id";
ALTER SEQUENCE "schedule_id_seq" OWNED BY "schedule"."schedule_id";

-- ----------------------------
-- Primary Key structure for table communication_type
-- ----------------------------
ALTER TABLE "communication_type" ADD PRIMARY KEY ("communication_type_id");

-- ----------------------------
-- Primary Key structure for table device
-- ----------------------------
ALTER TABLE "device" ADD PRIMARY KEY ("device_id");

-- ----------------------------
-- Primary Key structure for table device_communication_config
-- ----------------------------
ALTER TABLE "device_communication_config" ADD PRIMARY KEY ("device_id");

-- ----------------------------
-- Primary Key structure for table device_data
-- ----------------------------
ALTER TABLE "device_data" ADD PRIMARY KEY ("device_id", "event_time", "device_type_command_id");

-- ----------------------------
-- Primary Key structure for table device_schedule
-- ----------------------------
ALTER TABLE "device_schedule" ADD PRIMARY KEY ("schedule_id", "device_id", "device_type_command_id");

-- ----------------------------
-- Primary Key structure for table device_type
-- ----------------------------
ALTER TABLE "device_type" ADD PRIMARY KEY ("device_type_id");

-- ----------------------------
-- Uniques structure for table device_type_command
-- ----------------------------
ALTER TABLE "device_type_command" ADD UNIQUE ("device_type_id", "command_name");

-- ----------------------------
-- Primary Key structure for table device_type_command
-- ----------------------------
ALTER TABLE "device_type_command" ADD PRIMARY KEY ("device_type_command_id");

-- ----------------------------
-- Primary Key structure for table schedule
-- ----------------------------
ALTER TABLE "schedule" ADD PRIMARY KEY ("schedule_id");

-- ----------------------------
-- Primary Key structure for table schedule_report
-- ----------------------------
ALTER TABLE "schedule_report" ADD PRIMARY KEY ("schedule_id", "device_id", "device_type_command_id", "done_time");

-- ----------------------------
-- Primary Key structure for table schedule_type
-- ----------------------------
ALTER TABLE "schedule_type" ADD PRIMARY KEY ("schedule_type_id");

-- ----------------------------
-- Foreign Key structure for table "device"
-- ----------------------------
ALTER TABLE "device" ADD FOREIGN KEY ("device_type_id") REFERENCES "device_type" ("device_type_id") MATCH FULL ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "device_communication_config"
-- ----------------------------
ALTER TABLE "device_communication_config" ADD FOREIGN KEY ("communication_type_id") REFERENCES "communication_type" ("communication_type_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "device_communication_config" ADD FOREIGN KEY ("device_id") REFERENCES "device" ("device_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "device_data"
-- ----------------------------
ALTER TABLE "device_data" ADD FOREIGN KEY ("device_type_command_id") REFERENCES "device_type_command" ("device_type_command_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "device_data" ADD FOREIGN KEY ("device_id") REFERENCES "device" ("device_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "device_schedule"
-- ----------------------------
ALTER TABLE "device_schedule" ADD FOREIGN KEY ("device_type_command_id") REFERENCES "device_type_command" ("device_type_command_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "device_schedule" ADD FOREIGN KEY ("device_id") REFERENCES "device" ("device_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "device_schedule" ADD FOREIGN KEY ("schedule_id") REFERENCES "schedule" ("schedule_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "device_type_command"
-- ----------------------------
ALTER TABLE "device_type_command" ADD FOREIGN KEY ("device_type_id") REFERENCES "device_type" ("device_type_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "schedule"
-- ----------------------------
ALTER TABLE "schedule" ADD FOREIGN KEY ("schedule_type_id") REFERENCES "schedule_type" ("schedule_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "schedule_report"
-- ----------------------------
ALTER TABLE "schedule_report" ADD FOREIGN KEY ("device_id", "schedule_id", "device_type_command_id") REFERENCES "device_schedule" ("device_id", "schedule_id", "device_type_command_id") ON DELETE CASCADE ON UPDATE NO ACTION;
