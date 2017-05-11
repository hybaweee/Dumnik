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

Date: 2017-05-07 01:28:14
*/


-- ----------------------------
-- Sequence structure for device_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "smart"."device_id_seq";
CREATE SEQUENCE "smart"."device_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 3
 CACHE 1;
SELECT setval('"smart"."device_id_seq"', 3, true);

-- ----------------------------
-- Sequence structure for device_type_command_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "smart"."device_type_command_id_seq";
CREATE SEQUENCE "smart"."device_type_command_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 7
 CACHE 1;
SELECT setval('"smart"."device_type_command_id_seq"', 7, true);

-- ----------------------------
-- Sequence structure for schedule_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "smart"."schedule_id_seq";
CREATE SEQUENCE "smart"."schedule_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 23
 CACHE 1;
SELECT setval('"smart"."schedule_id_seq"', 23, true);

-- ----------------------------
-- Table structure for communication_type
-- ----------------------------
DROP TABLE IF EXISTS "smart"."communication_type";
CREATE TABLE "smart"."communication_type" (
"communication_type_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for device
-- ----------------------------
DROP TABLE IF EXISTS "smart"."device";
CREATE TABLE "smart"."device" (
"device_id" int4 DEFAULT nextval('"smart".device_id_seq'::regclass) NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL,
"device_type_id" int4 NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for device_communication_config
-- ----------------------------
DROP TABLE IF EXISTS "smart"."device_communication_config";
CREATE TABLE "smart"."device_communication_config" (
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
-- Table structure for device_data
-- ----------------------------
DROP TABLE IF EXISTS "smart"."device_data";
CREATE TABLE "smart"."device_data" (
"device_id" int4 NOT NULL,
"event_time" timestamp(6) DEFAULT now() NOT NULL,
"device_type_command_id" int4 NOT NULL,
"command_result" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for device_schedule
-- ----------------------------
DROP TABLE IF EXISTS "smart"."device_schedule";
CREATE TABLE "smart"."device_schedule" (
"device_id" int4 NOT NULL,
"schedule_id" int4 NOT NULL,
"device_type_command_id" int4 NOT NULL,
"command_param" varchar(50) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for device_type
-- ----------------------------
DROP TABLE IF EXISTS "smart"."device_type";
CREATE TABLE "smart"."device_type" (
"device_type_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for device_type_command
-- ----------------------------
DROP TABLE IF EXISTS "smart"."device_type_command";
CREATE TABLE "smart"."device_type_command" (
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
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS "smart"."schedule";
CREATE TABLE "smart"."schedule" (
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
-- Table structure for schedule_report
-- ----------------------------
DROP TABLE IF EXISTS "smart"."schedule_report";
CREATE TABLE "smart"."schedule_report" (
"device_id" int4 NOT NULL,
"schedule_id" int4 NOT NULL,
"device_type_command_id" int4 NOT NULL,
"done_time" timestamp(6) DEFAULT now() NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for schedule_type
-- ----------------------------
DROP TABLE IF EXISTS "smart"."schedule_type";
CREATE TABLE "smart"."schedule_type" (
"schedule_type_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
ALTER SEQUENCE "smart"."device_id_seq" OWNED BY "device"."device_id";
ALTER SEQUENCE "smart"."device_type_command_id_seq" OWNED BY "device_type_command"."device_type_command_id";
ALTER SEQUENCE "smart"."schedule_id_seq" OWNED BY "schedule"."schedule_id";

-- ----------------------------
-- Primary Key structure for table communication_type
-- ----------------------------
ALTER TABLE "smart"."communication_type" ADD PRIMARY KEY ("communication_type_id");

-- ----------------------------
-- Primary Key structure for table device
-- ----------------------------
ALTER TABLE "smart"."device" ADD PRIMARY KEY ("device_id");

-- ----------------------------
-- Primary Key structure for table device_communication_config
-- ----------------------------
ALTER TABLE "smart"."device_communication_config" ADD PRIMARY KEY ("device_id");

-- ----------------------------
-- Primary Key structure for table device_data
-- ----------------------------
ALTER TABLE "smart"."device_data" ADD PRIMARY KEY ("device_id", "event_time", "device_type_command_id");

-- ----------------------------
-- Primary Key structure for table device_schedule
-- ----------------------------
ALTER TABLE "smart"."device_schedule" ADD PRIMARY KEY ("schedule_id", "device_id", "device_type_command_id");

-- ----------------------------
-- Primary Key structure for table device_type
-- ----------------------------
ALTER TABLE "smart"."device_type" ADD PRIMARY KEY ("device_type_id");

-- ----------------------------
-- Uniques structure for table device_type_command
-- ----------------------------
ALTER TABLE "smart"."device_type_command" ADD UNIQUE ("device_type_id", "command_name");

-- ----------------------------
-- Primary Key structure for table device_type_command
-- ----------------------------
ALTER TABLE "smart"."device_type_command" ADD PRIMARY KEY ("device_type_command_id");

-- ----------------------------
-- Primary Key structure for table schedule
-- ----------------------------
ALTER TABLE "smart"."schedule" ADD PRIMARY KEY ("schedule_id");

-- ----------------------------
-- Primary Key structure for table schedule_report
-- ----------------------------
ALTER TABLE "smart"."schedule_report" ADD PRIMARY KEY ("schedule_id", "device_id", "device_type_command_id", "done_time");

-- ----------------------------
-- Primary Key structure for table schedule_type
-- ----------------------------
ALTER TABLE "smart"."schedule_type" ADD PRIMARY KEY ("schedule_type_id");

-- ----------------------------
-- Foreign Key structure for table "smart"."device"
-- ----------------------------
ALTER TABLE "smart"."device" ADD FOREIGN KEY ("device_type_id") REFERENCES "smart"."device_type" ("device_type_id") MATCH FULL ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "smart"."device_communication_config"
-- ----------------------------
ALTER TABLE "smart"."device_communication_config" ADD FOREIGN KEY ("communication_type_id") REFERENCES "smart"."communication_type" ("communication_type_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "smart"."device_communication_config" ADD FOREIGN KEY ("device_id") REFERENCES "smart"."device" ("device_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "smart"."device_data"
-- ----------------------------
ALTER TABLE "smart"."device_data" ADD FOREIGN KEY ("device_id") REFERENCES "smart"."device" ("device_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "smart"."device_data" ADD FOREIGN KEY ("device_type_command_id") REFERENCES "smart"."device_type_command" ("device_type_command_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "smart"."device_schedule"
-- ----------------------------
ALTER TABLE "smart"."device_schedule" ADD FOREIGN KEY ("schedule_id") REFERENCES "smart"."schedule" ("schedule_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "smart"."device_schedule" ADD FOREIGN KEY ("device_id") REFERENCES "smart"."device" ("device_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "smart"."device_schedule" ADD FOREIGN KEY ("device_type_command_id") REFERENCES "smart"."device_type_command" ("device_type_command_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "smart"."device_type_command"
-- ----------------------------
ALTER TABLE "smart"."device_type_command" ADD FOREIGN KEY ("device_type_id") REFERENCES "smart"."device_type" ("device_type_id") MATCH FULL ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "smart"."schedule"
-- ----------------------------
ALTER TABLE "smart"."schedule" ADD FOREIGN KEY ("schedule_type_id") REFERENCES "smart"."schedule_type" ("schedule_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "smart"."schedule_report"
-- ----------------------------
ALTER TABLE "smart"."schedule_report" ADD FOREIGN KEY ("device_id", "schedule_id", "device_type_command_id") REFERENCES "smart"."device_schedule" ("device_id", "schedule_id", "device_type_command_id") ON DELETE CASCADE ON UPDATE NO ACTION;
