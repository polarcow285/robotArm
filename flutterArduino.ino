#include <ESP8266WiFi.h>
#include <Servo.h>
//#include <IRremoteESP8266.h>
//#include <IRsend.h>
int counter = 0;

const char* ssid = "Leung";
const char* password = "nathannatalie";
bool dialMode = false;
bool sliderMode = false;

Servo panMotor;
Servo tiltMotor;
Servo tilt2Motor;
Servo rollMotor;
Servo clawMotor;


const uint16_t kIrLed = 4;  // ESP8266 GPIO pin to use. Recommended: 4 (D2).

//IRsend irsend(kIrLed);  // Set the GPIO to be used to sending the message.

uint16_t HaierAC_power[71] = {9024, 4456,  620, 530,  592, 528,  590, 532,  594, 1628,  
                        618, 1632,  616, 532,  592, 530,  590, 1634,  618, 1632,
                        618, 1630,  618, 1632,  618, 1630,  618, 530,  592, 1630,
                        620, 1630,  620, 530,  592, 1630,  618, 532,  592, 526,
                        590, 1632,  620, 1630,  616, 532,  592, 528,  592, 530,
                        592, 528,  592, 1630,  614, 1634,  618, 530,  588, 532,
                        594, 1628,  616, 1632,  622, 1628,  618, 42374,  9028,
                        2218,  622};  // NEC 19F69867

// Haier Temp Up
uint16_t HaierAC_tempUp[71] = {8994, 4486,  588, 560,  556, 564,  558, 564,  558, 1666,  586,
                        1664,  586, 562,  560, 560,  536, 1688,  582, 1666,  584, 1666,
                        586, 1664,  586, 1664,  582, 564,  562, 1662,  586, 1664,  586,
                        562,  556, 1666,  586, 562,  558, 1664,  562, 588,  560, 560,
                        562, 560,  558, 562,  558, 564,  560, 562,  558, 1668,  588, 558,
                        558, 1664,  584, 1664,  586, 1666,  584, 1664,  584, 1664,  586,
                        42406,  8968, 2280,  584};

// Haier Temp Down
uint16_t HaierAC_tempDown[71] = {8990, 4490,  556, 590,  558, 562,  558, 564,  560, 1664,  582, 1670,
                        582, 564,  556, 566,  530, 1660,  590, 1690,  584, 1666,  558, 1692,
                        582, 1668,  580, 564,  558, 1668,  584, 1664,  586, 564,  556, 1666,
                        584, 564,  554, 566,  560, 1666,  584, 562,  558, 564,  556, 566,
                        530, 588,  558, 564,  558, 1664,  584, 1668,  582, 566,  556, 1666,
                        558, 1690,  586, 1666,  582, 1664,  560, 42434,  8994, 2252,  586};

// Haier Fan
uint16_t HaierAC_fan[71] = {9002, 4480,  592, 556,  566, 554,  566, 556,  566, 1656,
                        588, 1660,  590, 560,  590, 532,  566, 1656,  590, 1658,
                        592, 1658,  592, 1658,  592, 1658,  590, 556,  562, 1664,
                        592, 1656,  612, 536,  590, 530,  562, 558,  562, 1660,
                        594, 556,  564, 558,  592, 528,  566, 556,  564, 558,
                        564, 1658,  592, 1656,  592, 558,  564, 1656,  590, 1660,
                        590, 1658,  594, 1658,  590, 1660,  592, 42402,  9026,
                        2222,  592};

// Haier Mode
uint16_t HaierAC_mode[73] = {8990, 4490,  580, 568,  550, 548,  576, 568,  550, 1672,
                        574, 1678,  578, 568,  556, 566,  554, 1668,  554, 1698,
                        604, 1644,  556, 1698,  574, 1672,  578, 568,  554, 1670,
                        580, 1668,  582, 566,  530, 592,  552, 568,  528, 594,
                        554, 1672,  576, 570,  526, 594,  552, 570,  530, 592,
                        528, 1694,  582, 1668,  578, 1670,  582, 564,  554, 1670,
                        584, 1666,  578, 1668,  556, 1698,  576, 42414,  8992, 2256,
                        580, 43920,  100};

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

WiFiServer wifiServer(80);

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(A0, INPUT); 
  pinMode(0, OUTPUT); //panMotor
  pinMode(2, OUTPUT); //tiltMotor
  pinMode(14, OUTPUT); //tilt2Motor
  pinMode(12, OUTPUT); //rollMotor
  pinMode(13, OUTPUT); //clawMotor

  panMotor.attach(0);
  tiltMotor.attach(2);
  tilt2Motor.attach(14);
  rollMotor.attach(12);
  clawMotor.attach(13);
  //irsend.begin();
  Serial.begin(115200);

  delay(1000);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting..");
  }

  Serial.print("Connected to WiFi. IP:");
  Serial.println(WiFi.localIP());

  wifiServer.begin();

}

void loop() {

  WiFiClient client = wifiServer.available();
  String command = "";
  String angle = "";
  if (client) {

    while (client.connected()) {
      if (dialMode == true){
        Serial.println(translateVoltage(analogRead(A0)));
        clawMotor.write(translateVoltage(analogRead(A0)));
        delay(10);
      }
    
      /*if (sliderMode == true){
        while (client.available()>0) {
          delay(100);
          char a = client.read();
          if (a == '\n') {
            break;
          }
          angle += a;
        }
        
        
        Serial.println(client.read());
        panMotor.write(angle.toInt());
        delay(10);
         */ 
        /*if (a == '-') {
          break;
        }
        angle += a;
        //panMotor.write(angle);
        Serial.println(angle);
        delay(10);
        */
        
      //Receive command that is new line terminated
      while (client.available()>0) {
        char c = client.read();
        if (c == '\n' || c  == '@') {
          if (c == '@'){
            Serial.write('\n');
          }
          break;
        }
        
        command += c;
        Serial.write(c);
      }
      //command gets processed 
      if (command == "LED ON") { 
        digitalWrite(LED_BUILTIN, LOW);
        Serial.println("We got the power !!");
        
      }else if (command == "LED OFF") {
        digitalWrite(LED_BUILTIN, HIGH);
        Serial.println("temperaturererrksj");
        
      }else if (command == "Open Claw") {
        clawMotor.write(92);
        Serial.println("Claw: Open");
      }else if (command == "Close Claw") {     
        clawMotor.write(180);
        Serial.println("Claw: Closed");
        
     
      }else if (command == "Robot Home") {
        //irsend.sendRaw(HaierAC_mode, 73, 38);  // Send a raw data capture at 38kHz.
        panMotor.write(90);
        tiltMotor.write(100);
        tilt2Motor.write(123);
        rollMotor.write(111);
        clawMotor.write(180);

        Serial.println("robothomee");
        
      }else if (command == "Activate Slider") {
        
        sliderMode = true;
      }
      else if (command.substring(0,3) == "Pan"){
        if (sliderMode == true){
          int angle = (command.substring(6, command.length()+1)).toInt();
          panMotor.write(angle);
          Serial.println("Move Pan Motor to " + String(angle));
         }
        
      }
      else if (command.substring(0,5) == "Tilt2"){
        if (sliderMode == true){
          int angle = (command.substring(8, command.length()+1)).toInt();
          tilt2Motor.write(angle);
          Serial.println("Move to Tilt2 Motor to" + String(angle));
        } 
      }
      
      else if (command.substring(0,4) == "Tilt"){
        if (sliderMode == true){
          int angle = (command.substring(7, command.length()+1)).toInt();
          tiltMotor.write(angle);
          Serial.println("Move Tilt Motor to " + String(angle));
        }
        
      }
      
      else if (command == "Disable Sliders") {
        sliderMode = false;
        Serial.println("Sliders disabled");
      }
      command = "";
      delay(10);
    }

    client.stop();
    Serial.println("Client disconnected");

  }
}
