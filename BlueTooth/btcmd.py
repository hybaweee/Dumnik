import bluetooth

def GetResponse(bt):
    timeout = bt.gettimeout()
    bt.settimeout(0.5)
    data = ""
    try:
        while 1:
            data += bt.recv(1)
    except:
        pass
    if timeout is not None:
        bt.settimeout(timeout)
    return data

def SendCommand(mac, port, command):
    bt = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    resp = ""
    try:
        bt.connect((mac, int(port)))
        bt.send(command)
        resp = GetResponse(bt)
    except:
        pass
    finally:
        bt.close()
    return resp

def GetMACByName(name):
    mac = ""
    devices = bluetooth.discover_devices()
    for addr in devices:
        if bluetooth.lookup_name(addr) == name:
            mac = addr
            break
    return addr

def GetDevicesOnline():
    devices = bluetooth.discover_devices()
    return devices
