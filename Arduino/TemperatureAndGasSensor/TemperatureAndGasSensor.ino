// #include "..\Libraries\SoftwareSerial.h"
// #include "..\Libraries\Wire.h"
// #include "..\Libraries\Adafruit_BMP085.h"
#include "SoftwareSerial.h"
#include "Wire.h"
#include "Adafruit_BMP085.h"

const int pinRx = 8;
const int pinTx = 9;

const char BT_SEPARATOR = ';';
const String BT_COMMAND_GETTEMPERATURE = "GetTemperature";
const String BT_COMMAND_GETPRESSURE = "GetPressure";
const String BT_COMMAND_RESULT_OK = "OK";
const String BT_COMMAND_RESULT_ERROR = "ERROR";

SoftwareSerial bt(pinRx, pinTx);
Adafruit_BMP085 bmp;

void setup() 
{
  Init();
}

void loop() 
{
  if (bt.available() > 0) 
  {
    String btCommandName = "";
    String btCommandArgument = "";
  
    CommandGet(&btCommandName, &btCommandArgument);

    Serial.println("Recieved command '" + btCommandName + "' with argument '" + btCommandArgument + "'");
    
    String btCommandResult = CommandDo(btCommandName, btCommandArgument);

    CommandSendConfirmation(btCommandResult);
  }
}

void Init()
{
  Serial.begin(9600);
  bt.begin(9600);
  bmp.begin();
}

String BTGetData()
{
  String input = "";
  while(bt.available() > 0) input = input + char(bt.read());
  return input;
}

void BTSendData(String message)
{
  bt.write(message.c_str());
  Serial.println("Sent message to blooetooth: " + message);
}

void CommandGet(String *btCommandName, String *btCommandArgument)
{
  String btInput = BTGetData();

  if (btInput.length() > 0)
  {
    int ixSep = btInput.indexOf(BT_SEPARATOR);
    if (ixSep > 0) 
    {
      *btCommandName = btInput.substring(0, ixSep);
      
      if (btInput.length() > ixSep) 
      {
        *btCommandArgument = btInput.substring(ixSep + 1,btInput.length());
      }
    }
    else
    {
      *btCommandName = btInput;
    }
  }
}

String CommandDo(String btCommandName, String btCommandArgument)
{
  String result = "";
  
  if (btCommandName == BT_COMMAND_GETTEMPERATURE)
  {
    result = CommandDoGetTemperature();
  }
  else if (btCommandName == BT_COMMAND_GETPRESSURE)
  {
    result = CommandDoGetPressure();
  }
  else
  {
    result = BT_COMMAND_RESULT_ERROR + ";Command '" + btCommandName + "' is unrecognized";
  }

  return result;
}

String CommandDoGetTemperature()
{
  String stat = "";
  
  stat = bmp.readTemperature();
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETTEMPERATURE + ";" + stat;
}

String CommandDoGetPressure()
{
  String stat = "";
  
  stat = bmp.readPressure() / 133.3;
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETPRESSURE + ";" + stat;
}

void CommandSendConfirmation(String btCommandResult)
{
  BTSendData(btCommandResult);
}

void PinEnable(int pin)
{
  digitalWrite(pin, HIGH);
}

void PinDisable(int pin)
{
  digitalWrite(pin, LOW);
}
