/*
Navicat PGSQL Data Transfer

Source Server         : prod
Source Server Version : 90410
Source Host           : localhost:5432
Source Database       : smart_home
Source Schema         : smart

Target Server Type    : PGSQL
Target Server Version : 90410
File Encoding         : 65001

Date: 2017-05-08 22:20:09
*/


-- ----------------------------
-- Sequence structure for device_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "device_id_seq";
CREATE SEQUENCE "device_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 3
 CACHE 1;
SELECT setval('"smart"."device_id_seq"', 3, true);

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
 START 23
 CACHE 1;
SELECT setval('"smart"."schedule_id_seq"', 23, true);

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
"has_result" bit(1) DEFAULT (0)::bit(1) NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of device_type_command
-- ----------------------------
BEGIN;
INSERT INTO "device_type_command" VALUES ('1', 'Включить', 'Enable', E'0', '1', E'0');
INSERT INTO "device_type_command" VALUES ('1', 'Выключить', 'Disable', E'0', '2', E'0');
INSERT INTO "device_type_command" VALUES ('1', 'Включить на (мин)', 'Enable', E'1', '3', E'0');
INSERT INTO "device_type_command" VALUES ('1', 'Получить статус', 'GetStatus', E'0', '4', E'1');
INSERT INTO "device_type_command" VALUES ('1', 'Получить установленное время до отключения (мсек)', 'GetTotalDuration', E'0', '6', E'1');
INSERT INTO "device_type_command" VALUES ('1', 'Получить прошедшее время после включения (мсек)', 'GetCurrentDuration', E'0', '7', E'1');
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
			OR (sch.schedule_type_id = 2 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '1 minute')))
			OR (sch.schedule_type_id = 3 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '5 minutes')))
			OR (sch.schedule_type_id = 4 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '10 minutes')))
			OR (sch.schedule_type_id = 5 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '15 minutes')))
			OR (sch.schedule_type_id = 6 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '30 minutes')))
			OR (sch.schedule_type_id = 7 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '1 hour')))
			OR (sch.schedule_type_id = 8 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '3 hours')))
			OR (sch.schedule_type_id = 9 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '6 hours')))
			OR (sch.schedule_type_id = 10 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '12 hours')))
			OR (sch.schedule_type_id = 11 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '1 day')))
			OR (sch.schedule_type_id = 12 AND (sch_rep.done_time IS NULL OR p_time >= (date_trunc('minute', sch_rep.done_time) + INTERVAL '7 days'))))
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
-- Primary Key structure for table schedule_type
-- ----------------------------
ALTER TABLE "schedule_type" ADD PRIMARY KEY ("schedule_type_id");

-- ----------------------------
-- Foreign Key structure for table "device_type_command"
-- ----------------------------
ALTER TABLE "device_type_command" ADD FOREIGN KEY ("device_type_id") REFERENCES "device_type" ("device_type_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
