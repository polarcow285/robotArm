/*
 * Sketch: ESP8266_LED_Control_02
 * Control an LED from a web browser
 * Intended to be run on an ESP8266
 * 
 * connect to the ESP8266 AP then
 * use web broswer to go to 192.168.4.1
 * 
 */
//update when you add a button
#define NUMBER_OF_BUTTONS 14
#include <ESP8266WiFi.h>
#include <Servo.h>
const char WiFiPassword[] = "12345678";
const char AP_NameChar[] = "LEDControl" ;
const int sizeOfWebPage = NUMBER_OF_BUTTONS + 3;
int dialMode = 0;
int formIndex = 0;
int panMotorPosition = 90;
int tiltMotorPosition = 90;
int rollMotorPosition = 90;
Servo panMotor;
Servo tiltMotor;
Servo tilt2Motor;
Servo rollMotor;
Servo clawMotor;


WiFiServer server(80);
String webPage[sizeOfWebPage];


String request = "";
int LED_Pin = 5;
//buttonName = LEDON
//formNumber = Fx

String buttonHelper(String buttonName, int formNumber){
  String code = "";
  String formString = formHelper(formNumber);
  code += "<form id='" + formString + "' action='" + buttonName + "'>";
  code += "<input class='button' type='submit' value='" + buttonName + "' ></form><br>";
  return code;  
}

String formHelper(int index){
  String formNumber;
  formNumber = "F" + String(index);
  return formNumber;
}

float translateA0(int analogValue){
  float voltage;
  voltage = (float)(5.0/1024.0) * (float)analogValue;
  return voltage;
}
float translateVoltage(int analogValue){
  float motorPosition;
  motorPosition = (float)(180/5) * (float)translateA0(analogValue);
  motorPosition = round(motorPosition);
  return(motorPosition);
}

void setup() 
{
    pinMode(LED_BUILTIN, OUTPUT);
    pinMode(A0, INPUT); 
    pinMode(5,OUTPUT); //LED
    pinMode(0, OUTPUT); //panMotor
    pinMode(2, OUTPUT); //tiltMotor
    pinMode(14, OUTPUT); //tilt2Motor
    pinMode(12, OUTPUT); //rollMotor
    pinMode(13, OUTPUT); //clawMotor
    pinMode(LED_Pin, OUTPUT); 
    
    panMotor.attach(0);
    tiltMotor.attach(2);
    tilt2Motor.attach(14);
    rollMotor.attach(12);
    clawMotor.attach(13);
    
    int index = 0;
    
    webPage[index] = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
    webPage[++index] = "<!DOCTYPE html><html><head><title>LED Control</title></head><body><div id='main'><h2>LED Control</h2>";
    webPage[++index] = buttonHelper("LEDON", ++formIndex);
    webPage[++index] = buttonHelper("LEDOFF", ++formIndex);
    webPage[++index] = buttonHelper("LedBuiltInOn", ++formIndex);
    webPage[++index] = buttonHelper("LedBuiltInOff", ++formIndex);
    webPage[++index] = buttonHelper("Pan0", ++formIndex);
    webPage[++index] = buttonHelper("Pan90", ++formIndex);
    webPage[++index] = buttonHelper("Pan+", ++formIndex);
    webPage[++index] = buttonHelper("Pan-", ++formIndex);
    //webPage[++index] = buttonHelper("SwitchDialMode", ++formIndex);
    webPage[++index] = buttonHelper("Tilt+", ++formIndex);
    webPage[++index] = buttonHelper("Tilt-", ++formIndex);
    webPage[++index] = buttonHelper("PanDialMode", ++formIndex);
    webPage[++index] = buttonHelper("TiltDialMode", ++formIndex);
    webPage[++index] = buttonHelper("DisableAll", ++formIndex);
    webPage[++index] = buttonHelper("EnableAll", ++formIndex);
    
    webPage[sizeOfWebPage-1] = "</div></body></html>";
    
    boolean conn = WiFi.softAP(AP_NameChar, WiFiPassword);
    Serial.begin(115200);
    server.begin();
    Serial.println("Initiating the loop");
    delay(1000);
} // void setup()


void loop() 
{

    // Check if a client has connected
    WiFiClient client = server.available();
    if (!client)  {
      //This needs to be here because this part loops as the site is waiting for a button press.
      if (dialMode == 1 || dialMode == 3){
        Serial.println(translateVoltage(analogRead(A0)));
        tiltMotor.write(translateVoltage(analogRead(A0)));
      } 
      if (dialMode == 2 || dialMode == 3){
        Serial.println(translateVoltage(analogRead(A0)));
        tilt2Motor.write(translateVoltage(analogRead(A0)));
      } 
      //Serial.println("returning from loop");
      return;  
    }
    

    // Read the first line of the request
    //This will wait here until a button is pressed
    request = client.readStringUntil('\r');
    
    if       ( request.indexOf("LEDON") > 0 )  { digitalWrite(LED_Pin, HIGH);  }
    else if  ( request.indexOf("LEDOFF") > 0 ) { digitalWrite(LED_Pin, LOW);   }
    else if  ( request.indexOf("LedBuiltInOn") > 0 )  { digitalWrite(LED_BUILTIN, LOW);  }
    else if  ( request.indexOf("LedBuiltInOff") > 0 )  { digitalWrite(LED_BUILTIN, HIGH);  }
    
    else if  ( request.indexOf("Pan0") > 0 )  { 
      if (dialMode == 0){
        tiltMotor.write(0);
      }
       
    }
    else if  ( request.indexOf("Pan90") > 0 )  { 
      if (dialMode == 0){
        tiltMotor.write(180);
      }
        
    }
    else if  ( request.indexOf("Pan+") > 0 )  { 
      if (dialMode == 0) {
        panMotorPosition += 5;
        panMotor.write(panMotorPosition);  
      }
      
    }
    else if  ( request.indexOf("Pan-") > 0 )  { 
      if (dialMode == 0){
        panMotorPosition -= 5;
        panMotor.write(panMotorPosition);  
      }
      
    }
    /*else if  ( request.indexOf("SwitchDialMode") > 0 )  { 
      dialMode = !dialMode;
      (dialMode == true) ? Serial.println("Dial Mode: On") : Serial.println("Dial Mode: Off");
    }*/
    else if  ( request.indexOf("Tilt+") > 0 )  { 
       tiltMotorPosition += 5;
       tiltMotor.write(tiltMotorPosition);      
    }
    else if  ( request.indexOf("Tilt-") > 0 )  { 
        tiltMotorPosition -= 5;
        tiltMotor.write(tiltMotorPosition);    
    }
    else if  ( request.indexOf("PanDialMode") > 0 )  { 
        dialMode = 1;   
        Serial.println("Pan Dial Mode: On");
    }
    else if  ( request.indexOf("TiltDialMode") > 0 )  { 
        dialMode = 2;  
        Serial.println("Tilt Dial Mode: On"); 
    }
    else if  ( request.indexOf("DisableAll") > 0 )  { 
        dialMode = 0; 
        Serial.println("All dial modes are disabled");
    }
    else if  ( request.indexOf("EnableAll") > 0 )  { 
        dialMode = 3 ;   
        Serial.println("All dial modes are enabled");
    }
    
    client.flush();
    
    
    for (int i = 0; i < sizeOfWebPage; i++){
      client.print(webPage[i]);
    }
    
    delay(5);
  // The client will actually be disconnected when the function returns and 'client' object is detroyed
  
}
