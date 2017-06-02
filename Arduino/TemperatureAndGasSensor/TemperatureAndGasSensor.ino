#include "SoftwareSerial.h"
#include "Wire.h"
#include "Adafruit_BMP085.h"

////////////////////////////////////////// F O R   G A S  S E N S O R ////////////////////////////

#define         GAS_LPG                      (0)
#define         GAS_CO                       (1)
#define         GAS_SMOKE                    (2)
#define         RL_VALUE                     (1)     //define the load resistance on the board, in kilo ohms

float           LPGCurve[3]  =  {2.3,0.21,-0.47};   //two points are taken from the curve. 
                                                    //with these two points, a line is formed which is "approximately equivalent"
                                                    //to the original curve. 
                                                    //data format:{ x, y, slope}; point1: (lg200, 0.21), point2: (lg10000, -0.59) 
float           COCurve[3]  =  {2.3,0.72,-0.34};    //two points are taken from the curve. 
                                                    //with these two points, a line is formed which is "approximately equivalent" 
                                                    //to the original curve.
                                                    //data format:{ x, y, slope}; point1: (lg200, 0.72), point2: (lg10000,  0.15) 
float           SmokeCurve[3] ={2.3,0.53,-0.44};    //two points are taken from the curve. 
                                                    //with these two points, a line is formed which is "approximately equivalent" 
                                                    //to the original curve.
                                                    //data format:{ x, y, slope}; point1: (lg200, 0.53), point2: (lg10000,  -0.22)                                                     
float           Ro           =  0.55;               //Ro is initialized to 10 kilo ohms
                                                    //Значение по умолчанию было 10. После калибровки 0.54-0.56

//////////////////////////////////////////////////////////////////////////////////////////////////


const int pinMQA = A0;
const int pinMQD = 4;
const int pinBuzzer = 5;
const int pinRx = 8;
const int pinTx = 9;

const char BT_SEPARATOR = ';';
const String BT_COMMAND_GETTEMPERATURE = "GetTemperature";
const String BT_COMMAND_GETPRESSURE = "GetPressure";
const String BT_COMMAND_GETGAS_RAWDATA = "GetGasRawData";
const String BT_COMMAND_GETGAS_LPG = "GetGasLPG";
const String BT_COMMAND_GETGAS_CO = "GetGasCO";
const String BT_COMMAND_GETGAS_SMOKE = "GetGasSmoke";
const String BT_COMMAND_GETGAS_HASALARM = "GetGasHasAlarm";
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

  if (HasAlarm(pinMQD))
  {
    //tone(pinBuzzer, 1000);
    digitalWrite(pinBuzzer, LOW);
  }
  else
  {
    //noTone(pinBuzzer);
    digitalWrite(pinBuzzer, HIGH);
  }
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
  pinMode(pinMQA, INPUT);
  pinMode(pinMQD, INPUT);
  pinMode(pinBuzzer, OUTPUT);
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
  else if (btCommandName == BT_COMMAND_GETGAS_RAWDATA)
  {
    result = CommandDoGetGasRawData();
  }
  else if (btCommandName == BT_COMMAND_GETGAS_LPG)
  {
    result = CommandDoGetGasLPG();
  }
  else if (btCommandName == BT_COMMAND_GETGAS_CO)
  {
    result = CommandDoGetGasCO();
  }
  else if (btCommandName == BT_COMMAND_GETGAS_SMOKE)
  {
    result = CommandDoGetGasSmoke();
  }
  else if (btCommandName == BT_COMMAND_GETGAS_HASALARM)
  {
    result = CommandDoGetGasHasAlarm();
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

String CommandDoGetGasRawData()
{
  String stat = "";
  
  stat = (String)analogRead(pinMQA);
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETGAS_RAWDATA + ";" + stat;
}

String CommandDoGetGasLPG()
{
  String stat = "";
  
  stat = (String)MQGetGasPercentage(MQRead(pinMQA)/Ro, GAS_LPG);
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETGAS_LPG + ";" + stat;
}

String CommandDoGetGasCO()
{
  String stat = "";
  
  stat = (String)MQGetGasPercentage(MQRead(pinMQA)/Ro, GAS_CO);
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETGAS_CO + ";" + stat;
}

String CommandDoGetGasSmoke()
{
  String stat = "";
  
  stat = (String)MQGetGasPercentage(MQRead(pinMQA)/Ro, GAS_SMOKE);
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETGAS_SMOKE + ";" + stat;
}

String CommandDoGetGasHasAlarm()
{
  String stat = "";
  
  stat = (String)HasAlarm(pinMQD);
      
  return BT_COMMAND_RESULT_OK + ";" + BT_COMMAND_GETGAS_HASALARM + ";" + stat;
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


/*****************************  MQGetGasPercentage **********************************
Input:   rs_ro_ratio - Rs divided by Ro
         gas_id      - target gas type
Output:  ppm of the target gas
Remarks: This function passes different curves to the MQGetPercentage function which 
         calculates the ppm (parts per million) of the target gas.
************************************************************************************/ 
int MQGetGasPercentage(float rs_ro_ratio, int gas_id)
{
  if ( gas_id == GAS_LPG ) {
     return MQGetPercentage(rs_ro_ratio, LPGCurve);
  } else if ( gas_id == GAS_CO ) {
     return MQGetPercentage(rs_ro_ratio, COCurve);
  } else if ( gas_id == GAS_SMOKE ) {
     return MQGetPercentage(rs_ro_ratio, SmokeCurve);
  }    
 
  return 0;
}

/*****************************  MQGetPercentage **********************************
Input:   rs_ro_ratio - Rs divided by Ro
         pcurve      - pointer to the curve of the target gas
Output:  ppm of the target gas
Remarks: By using the slope and a point of the line. The x(logarithmic value of ppm) 
         of the line could be derived if y(rs_ro_ratio) is provided. As it is a 
         logarithmic coordinate, power of 10 is used to convert the result to non-logarithmic 
         value.
************************************************************************************/ 
int  MQGetPercentage(float rs_ro_ratio, float *pcurve)
{
  return (pow(10,( ((log(rs_ro_ratio)-pcurve[1])/pcurve[2]) + pcurve[0])));
}

/****************** MQResistanceCalculation ****************************************
Input:   raw_adc - raw value read from adc, which represents the voltage
Output:  the calculated sensor resistance
Remarks: The sensor and the load resistor forms a voltage divider. Given the voltage
         across the load resistor and its resistance, the resistance of the sensor
         could be derived.
************************************************************************************/ 
float MQResistanceCalculation(int raw_adc)
{
  return ( ((float)RL_VALUE*(1023-raw_adc)/raw_adc));
}

/*****************************  MQRead *********************************************
Input:   pinMQA - analog channel
Output:  Rs of the sensor
Remarks: This function use MQResistanceCalculation to caculate the sensor resistenc (Rs).
         The Rs changes as the sensor is in the different consentration of the target
         gas. The sample times and the time interval between samples could be configured
         by changing the definition of the macros.
************************************************************************************/ 
float MQRead(int pinMQA)
{
  int i;
  float rs=0;
 
  for (i=0; i<5; i++) {
    rs += MQResistanceCalculation(analogRead(pinMQA));
    delay(50);
  }
 
  rs = rs/5;
 
  return rs;  
}

bool HasAlarm(int pin)
{
  return digitalRead(pin) == 0;
}


