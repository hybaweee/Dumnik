#include <SoftwareSerial.h>
#include <Chrono.h>

const int pinRele = 2;
const int pinLedRed = 3;
const int pinLedGreen = 4;
const int pinLedBlue = 5;
const int pinRx = 8;
const int pinTx = 9;

const char BT_SEPARATOR = ';';
const String BT_COMMAND_ENABLE = "Enable";
const String BT_COMMAND_DISABLE = "Disable";
const String BT_COMMAND_GETSTATUS = "GetStatus";
const String BT_COMMAND_GETCURRENTDURATION = "GetCurrentDuration";
const String BT_COMMAND_GETTOTALDURATION = "GetTotalDuration";
const String BT_COMMAND_RESULT_OK = "OK";
const String BT_COMMAND_RESULT_ERROR = "ERROR";

const String RELE_STATUS_ENABLED = "Enabled";
const String RELE_STATUS_DISABLED = "Disabled";

int timeToDisable = 0; // in seconds. 0 - unlimited
bool releEnabled = false;

Chrono timer(Chrono::SECONDS);
SoftwareSerial bt(pinRx, pinTx);

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
  
  if (timer.hasPassed(timeToDisable) && timeToDisable > 0 && releEnabled)
  {
    Serial.print("Timer has passed '");
    Serial.print(timeToDisable);
    Serial.println("' seconds");

    ReleDisable();
    TimerStop();
  }
 
}

void Init()
{
  Serial.begin(9600);
  bt.begin(9600);
  
  pinMode(pinRele, OUTPUT);
  pinMode(pinLedRed, OUTPUT);
  pinMode(pinLedGreen, OUTPUT);
  pinMode(pinLedBlue, OUTPUT);

  LedDisable();
  ReleDisable();
}

String BTGetData()
{
  LedDisable();
  LedEnableBlue();
  
  String input = "";
  while(bt.available() > 0) input = input + char(bt.read());
  
  LedDisable();
  if (releEnabled)
    LedEnableRed();
  else
    LedEnableGreen();
  
  return input;
}

void BTSendData(String message)
{
  LedDisable();
  LedEnableBlue();
  
  bt.write(message.c_str());
  Serial.println("Sent message to blooetooth: " + message);
  
  LedDisable();
  if (releEnabled)
    LedEnableRed();
  else
    LedEnableGreen();
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
  
  if (btCommandName == BT_COMMAND_ENABLE)
  {
    result = CommandDoEnable(btCommandArgument);
  }
  else if (btCommandName == BT_COMMAND_DISABLE)
  {
    result = CommandDoDisable();
  }
  else if (btCommandName == BT_COMMAND_GETSTATUS)
  {
    result = CommandDoGetStatus();
  }
  else if (btCommandName == BT_COMMAND_GETCURRENTDURATION)
  {
    result = CommandDoGetCurrentDuration();
  }
  else if (btCommandName == BT_COMMAND_GETTOTALDURATION)
  {
    result = CommandDoGetTotalDuration();
  }
  else
  {
    result = BT_COMMAND_RESULT_ERROR + ";Command '" + btCommandName + "' is unrecognized";
  }

  return result;
}

String CommandDoEnable(String btCommandArgument)
{
  int argument = 0;
  
  if (btCommandArgument.length() > 0)
  {
    argument = btCommandArgument.toInt();
  }

  ReleEnable();
  TimerStart(argument);
  
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_ENABLE;
}

String CommandDoDisable()
{
  ReleDisable();
  TimerStop();
  
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_DISABLE;
}

String CommandDoGetStatus()
{
  String stat = "";
  
  if (releEnabled)
  {
    stat = RELE_STATUS_ENABLED;
  }
   else
   {
    stat = RELE_STATUS_DISABLED;
   }
    
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETSTATUS + ";" + stat;
}

String CommandDoGetCurrentDuration()
{    
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETCURRENTDURATION + ";" + timer.elapsed();
}

String CommandDoGetTotalDuration()
{ 
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETTOTALDURATION + ";" + timeToDisable;
}

void CommandSendConfirmation(String btCommandResult)
{
  BTSendData(btCommandResult);
}

void TimerStart(int minutes)
{
  timeToDisable = minutes * 60;
  timer.restart();
}

void TimerStop()
{
  timer.stop();
  timeToDisable = 0;
}

void PinEnable(int pin)
{
  digitalWrite(pin, HIGH);
}

void PinDisable(int pin)
{
  digitalWrite(pin, LOW);
}

void ReleEnable()
{
  PinEnable(pinRele);
  releEnabled = true;
  LedDisable();
  LedEnableRed();
}

void ReleDisable()
{
  PinDisable(pinRele);
  releEnabled = false;
  LedDisable();
  LedEnableGreen();
}

void LedDisable()
{
  PinDisable(pinLedRed);
  PinDisable(pinLedGreen);
  PinDisable(pinLedBlue);
}

void LedEnableRed()
{
  LedDisable();
  PinEnable(pinLedRed);
}

void LedEnableGreen()
{
  LedDisable();
  PinEnable(pinLedGreen);
}

void LedEnableBlue()
{
  LedDisable();
  PinEnable(pinLedBlue);
}
