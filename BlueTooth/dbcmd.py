import psycopg2

def BTDeviceGetConfig(cnnString, deviceID):
    cnn = psycopg2.connect(dsn=cnnString)
    mac = ""
    port = 0
    
    try:
        if cnn <> None:
            cur = cnn.cursor()
            cur.execute("""SELECT param1 AS mac, param2 AS port
                            FROM smart.device_communication_config
                            WHERE communication_type_id = 1 -- bluetooth
                                AND device_id = %s""", (deviceID,))
            mac, port = cur.fetchone()
            cur.close()
    finally:
        cnn.close()
    return mac, port

def ScheduleGetActiveCommands(cnnString, time, deviceType):
    cnn = psycopg2.connect(dsn=cnnString)
    rows = ""
    
    try:
        if cnn <> None:
            cur = cnn.cursor()
            cur.callproc("smart.schedule_get_active_commands", (time, deviceType))
            rows = cur.fetchall()
            cur.close()
    finally:
        cnn.close()
    return rows

def ScheduleSaveReport(cnnString, deviceID, scheduleID, commandID, time):
    cnn = psycopg2.connect(dsn=cnnString)
    
    try:
        if cnn <> None:
            cur = cnn.cursor()
            cur.callproc("smart.schedule_save_report", (deviceID, scheduleID, commandID, time))
            cnn.commit()
            cur.close()
    finally:
        cnn.close()
    return True

def DeviceSaveData(cnnString, deviceID, time, commandID, data):
    cnn = psycopg2.connect(dsn=cnnString)
    
    try:
        if cnn <> None:
            cur = cnn.cursor()
            cur.callproc("smart.device_save_data", (deviceID, time, commandID, data))
            cnn.commit()
            cur.close()
    finally:
        cnn.close()
    return True

    