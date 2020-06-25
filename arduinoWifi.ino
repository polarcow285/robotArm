#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <Servo.h>
Servo panMotor;
Servo tiltMotor;
Servo rollMotor;
/* Set these to your desired credentials. */
const char *ssid = "Leung"; //Enter your WIFI ssid
const char *password = "nathannatalie"; //Enter your WIFI password
int panMotorPosition = 90;
int tiltMotorPosition = 90;
int rollMotorPosition = 90;
bool dialMode = false;
ESP8266WebServer server(80);
//buttonName = "LED_BUILTIN_on"
//formNumber = "formX"
String buttonHelper(String buttonName, String formNumber){
  String code = "";
  code += "<form action=\"/" + buttonName + "\""; 
  code += " method=\"get\"";
  code += " id=\"" + formNumber + "\"></form>";
  code += "<button type=\"submit\"";
  code += "form=\"" + formNumber + "\"";
  code += "value=\"" + buttonName +"\"";
  code += ">" + buttonName + "</button>";
  return code;  
}

void handleRoot() {
 String buttons = "";
 buttons += buttonHelper("LED_BUILTIN_on", "form1");
 buttons += buttonHelper("LED_BUILTIN_off", "form2");
 buttons += buttonHelper("OtherLED_on", "form3");
 buttons += buttonHelper("Pan", "form4");
 buttons += buttonHelper("Pan90", "form5");
 buttons += buttonHelper("Pan+", "form6");
 buttons += buttonHelper("Pan-", "form7");
 buttons += buttonHelper("Tilt+", "form8");
 buttons += buttonHelper("Tilt-", "form9");
 buttons += buttonHelper("Roll+", "form10");
 buttons += buttonHelper("Roll-", "form11");
 buttons += buttonHelper("RGBGreen", "form12");
 buttons += buttonHelper("RGBRed", "form13");
 buttons += buttonHelper("RGBBlue", "form14");
 buttons += buttonHelper("RGBRaspberry", "form15");
 buttons += buttonHelper("DialMode", "form16");
 buttons += buttonHelper("SwitchDialMode", "form17");
 
 
 server.send(200, "text/html", buttons );
}
void handleSave() {
 if (server.arg("pass") != "") {
   Serial.println(server.arg("pass"));
 }
}
void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
 {
  analogWrite(12, red_light_value);
  analogWrite(4, green_light_value);
  analogWrite(16, blue_light_value);
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

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(A0, INPUT); 
  pinMode(0, OUTPUT); //panMotor
  pinMode(2, OUTPUT); //rollMotor
  pinMode(4, OUTPUT); //RGB Green
  pinMode(5,OUTPUT); //LED
  pinMode(14, OUTPUT); //tiltMotor
  pinMode(12, OUTPUT); //RGB Red
  pinMode(16, OUTPUT); //RGB Blue
  panMotor.attach(0);
  tiltMotor.attach(14);
  rollMotor.attach(2);
    
  delay(3000);
  Serial.begin(115200);
  Serial.println();
  Serial.print("Configuring access point...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  server.on ( "/", handleRoot );
  server.on ("/save", handleSave);
  server.begin();
  Serial.println ( "HTTP server started" );

  panMotor.write(panMotorPosition);
  server.on("/LED_BUILTIN_on", []() {
    for(int i = 0; i<10; i++){
      digitalWrite(LED_BUILTIN, 0);
      Serial.println("on");
      delay(1000);
      digitalWrite(LED_BUILTIN, 1);
      Serial.println("off");
      delay(1000); 
    }
    Serial.println(LED_BUILTIN);  
  });
  server.on("/OtherLED_on", [](){
   digitalWrite(4,1);
   handleRoot();
  });
 
  server.on("/LED_BUILTIN_off", []() {
    //digitalWrite(LED_BUILTIN, 1);
    Serial.println("off");
    digitalWrite(4,0);
    handleRoot();
  });
 
  server.on("/Pan", [](){
    if (dialMode == false){
      panMotor.write(0);
      handleRoot();
    }
  });
 
  server.on("/Pan90", [](){
    if (dialMode == false){
      panMotor.write(90);
      handleRoot();
    }
  });
 
  server.on("/Pan+", [](){
    if (dialMode == false){
      panMotorPosition += 5;
      panMotor.write(panMotorPosition);
      handleRoot();
    }
  
  });
 
  server.on("/Pan-", [](){
    if (dialMode == false){
      panMotorPosition -= 5;
      panMotor.write(panMotorPosition);
      handleRoot();
    }
  });
 
  server.on("/Tilt+", [](){
    tiltMotorPosition += 5;
    tiltMotor.write(tiltMotorPosition);
    handleRoot();
  });
 
  server.on("/Tilt-", [](){
    tiltMotorPosition -= 5;
    tiltMotor.write(tiltMotorPosition);
    handleRoot();
  });
 
  server.on("/Roll+", [](){
    rollMotorPosition += 5;
    rollMotor.write(rollMotorPosition);
    handleRoot();
  });
 
  server.on("/Roll-", [](){
    rollMotorPosition -= 5;
    rollMotor.write(rollMotorPosition);
    handleRoot();
  });
 
  server.on("/RGBGreen", [](){
    digitalWrite(5, 1);
    handleRoot();
  });
 
  server.on("/RGBRed", [](){
    RGB_color(255, 0, 0);
    handleRoot();
  });
 
  server.on("/RGBBlue", [](){
    digitalWrite(16, 1);
    handleRoot();
  });
 
  server.on("/RGBRaspberry", [](){
    RGB_color(255, 255, 125); // Raspberry
    delay(1000);
    handleRoot();
  });
 
  server.on("/DialMode", [](){
    /*while (dialMode == true){
      Serial.println(translateVoltage(analogRead(A0)));
      panMotor.write(translateVoltage(analogRead(A0)));
      delay(100);
      handleRoot();
      if (dialMode == false){
        break;
      }
    }*/
   });
  server.on("/SwitchDialMode", [](){
    dialMode = !dialMode;
    (dialMode == true) ? Serial.println("Dial Mode: On") : Serial.println("Dial Mode: Off");
    handleRoot();
  });
 
}
void loop() {
  server.handleClient();
  //Serial.println("Hello");
  //delay(1000);
  /*if (dialMode == true){
    Serial.println(translateVoltage(analogRead(A0)));
  }
  */
  
  /*panMotor.write(translateVoltage(analogRead(A0)));
  delay(100);
 */
 /*RGB_color(255, 255, 125); // Raspberry
 delay(1000);
 RGB_color(0, 255, 255); // Cyan
 delay(1000);
 RGB_color(255, 255, 0); // Yellow
 delay(1000);
 RGB_color(80,0,80); //purple
 delay(1000);
 */
 /*panMotor.write(90);
 delay(1000);
 panMotor.write(0);
 delay(1000);
 tiltMotor.write(90);
 delay(1000);
 tiltMotor.write(0);
 delay(1000);
 */
} 
