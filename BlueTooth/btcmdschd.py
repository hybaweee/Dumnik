# -*- coding: cp1251 -*-
import btcmd
import dbcmd
from datetime import datetime

def GetResultValue(okCommand, response):
    indexStart = len(okCommand) + 1
    indexEnd = len(response)
    return response[indexStart:indexEnd]

DSN = "host=localhost user=py_user password=qwerty!2345 dbname=smart_home"
DEVICE_TYPE_BLUETOOTH = 1

schedules = dbcmd.ScheduleGetActiveCommands(DSN, datetime.now(), DEVICE_TYPE_BLUETOOTH)

for schedule in schedules:
    try:
        deviceID = int(schedule[0])
        scheduleID = int(schedule[1])
        commandID = int(schedule[2])
        mac = schedule[3]
        port = schedule[4]
        command = schedule[5]
        hasParam = int(schedule[6])
        hasResult = int(schedule[7])
        param = schedule[8]

        fullCommand = command
        okCommand = "OK;" + command

        if (hasParam == 1):
            fullCommand += ";" + str(param)

        for i in range(3):
            resp = btcmd.SendCommand(mac, port, fullCommand)
            if (resp.find(okCommand) == 0):
                time = datetime.now()
                dbcmd.ScheduleSaveReport(DSN, deviceID, scheduleID, commandID, time)
                if (hasResult):
                    data = GetResultValue(okCommand, resp)
                    dbcmd.DeviceSaveData(DSN, deviceID, time, commandID, data)
                break
    finally:
        pass
