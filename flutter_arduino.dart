import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import "dart:async";
double _panValue = 0;
double _tiltValue = 0;
double _tilt2Value = 0;
bool isVisible = false;
void main() async {
  // modify with your true address/port
  Socket sock = await Socket.connect('192.168.1.189', 80);
  runApp(MyApp(sock));
}

class MyApp extends StatelessWidget {
  Socket socket;

  MyApp(Socket s) {
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {
    final title = 'TcpSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: socket,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Socket channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("LED ON",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0
                  )
                ),
                color: Colors.red,
                onPressed: _ledOn,
              ),
              RaisedButton(
                child: Text("LED OFF",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0
                    )
                ),
                color: Colors.red,
                onPressed: _ledOff,
              ),
              RaisedButton(
                child: Text("Pan 0",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0
                    )
                ),
                color: Colors.red,
                onPressed: _openClaw,
              ),
              RaisedButton(
                child: Text("Pan 90",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0
                    )
                ),
                color: Colors.red,
                onPressed: _closeClaw,
              ),
              RaisedButton(
                child: Text("Robot Home",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0
                    )
                ),
                color: Colors.red,
                onPressed: _robotHome,
              ),
              RaisedButton(
                child: Text("Activate Slider",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0
                    )
                ),
                color: Colors.red,
                onPressed: _activateSlider,
              ),
              Slider(
                    min: 0,
                    max: 180,
                    value: _panValue,
                    onChanged: (value) {
                          setState(() {
                            
                            _panValue = value;
                            widget.channel.write("Pan = ${_panValue.round()}@");
                            print("${_panValue.round()}");
                          });

              
                                                
           
                    },
                  ),
                  Slider(
                    min: 0,
                    max: 180,
                    value: _tiltValue,
                    onChanged: (value) {
                        

                          setState(() {
                          
                            _tiltValue = value;
                            widget.channel.write("Tilt = ${_tiltValue.round()}@");
                            print("${_tiltValue.round()}");
                          });

            
                                                
           
                    },
                  ),
                  Slider(
                    min: 0,
                    max: 180,
                    value: _tilt2Value,
                    onChanged: (value) {
                        
                          setState(() {
                          
                            _tilt2Value = value;
                            widget.channel.write("Tilt2 = ${_tilt2Value.round()}@");
                            print("${_tilt2Value.round()}");
                          });

                                                
           
                    },
                  ),
                  RaisedButton(
                    child: Text("Disable Sliders",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: _disableSliders,
                  ),
              
            ],
          ),
        )
      )
    );
  }

  void _ledOn() {
    widget.channel.write("LED ON\n");
    isVisible = false;
  }

  void _ledOff() {
    widget.channel.write("LED OFF\n");
  }

  void _openClaw() {
    widget.channel.write("Open Claw\n");
  }

  void _closeClaw() {
    widget.channel.write("Close Claw\n");
  }

  void _robotHome() {
    widget.channel.write("Robot Home\n");
  }
  void _activateSlider() {
    isVisible = true;
    widget.channel.write("Activate Slider\n");
  }
  void _disableSliders(){
    widget.channel.write("Disable Sliders\n");
  }

  @override
  void dispose() {
    widget.channel.close();
    super.dispose();
  }
}
