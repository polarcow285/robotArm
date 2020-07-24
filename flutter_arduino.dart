import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import "dart:async";
double _panValue = 0;
double _tiltValue = 0;
double _tilt2Value = 0;
double _rollValue = 0;
double _clawValue = 0;


List <Map> positionsList = [];
int mapIndex = -1;
int targetPosition = 0;

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
  String _selectedNumber;

  List <int> numberList = new List();
  List<DropdownMenuItem<String>> _dropdownMenuItems; 

  @override
  void initState() {
    for (int i = 0; i<10; i++){
      numberList.add(i);
    }
    
    _dropdownMenuItems = buildDropdownMenuItems(numberList);
   
    
    //isVisible = false;
    _selectedNumber = _dropdownMenuItems[0].value;

    super.initState();
  }
  List<DropdownMenuItem<String>> buildDropdownMenuItems(numberList) {
    List<DropdownMenuItem<String>> items = List();
    for(int n in numberList){
      items.add(
        DropdownMenuItem(
          child: Text(n.toString()),
          value: n.toString(),
        ),
      );
    }
     
    return items;
      
  } 
  
  onChangeDropdownItem(String selectedNumber) {
    setState(() {
      _selectedNumber = selectedNumber;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        //child: Center(
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
                  Slider(
                    min: 0,
                    max: 180,
                    value: _rollValue,
                    onChanged: (value) {  
                          setState(() {
                          
                            _rollValue = value;
                            widget.channel.write("Roll = ${_rollValue.round()}@");
                            print("${_rollValue.round()}");
                          });                       
                    },
                  ),
                  Slider(
                    min: 0,
                    max: 180,
                    value: _clawValue,
                    onChanged: (value) {  
                          setState(() {
                          
                            _clawValue = value;
                            widget.channel.write("Claw = ${_clawValue.round()}@");
                            print("${_clawValue.round()}");
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
                  RaisedButton(
                    child: Text("Record Sliders",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: _recordSliders,
                  ),
                  RaisedButton(
                    child: Text("Playback",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: _playback,
                  ),

                  DropdownButton(
                    value: _selectedNumber,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),

                  RaisedButton(
                    child: Text("Records",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecordsScreen(
                          title: "title",
                          channel: widget.channel,
                        )),
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text("Go to target position",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: (){
                      playbackHelper(targetPosition);
                    }
                  ),
                  
              
            ],
          ),
        //)
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
  void _recordSliders(){
    widget.channel.write("Position ${++mapIndex}\n");
    var armPositionMap = new Map();

    armPositionMap["Pan"] = (_panValue.round());
    armPositionMap["Tilt"] = (_tiltValue.round());
    armPositionMap["Tilt2"] = (_tilt2Value.round());
    armPositionMap["Roll"] = (_rollValue.round());
    armPositionMap["Claw"] = (_clawValue.round());

    positionsList.add(armPositionMap);
    widget.channel.write(armPositionMap);
  }
  void playbackHelper(int positionNumber){
    widget.channel.write("Pan = ${positionsList[positionNumber]["Pan"]}@");
    widget.channel.write("Tilt = ${positionsList[positionNumber]["Tilt"]}@");
    widget.channel.write("Tilt2 = ${positionsList[positionNumber]["Tilt2"]}@");
    widget.channel.write("Roll = ${positionsList[positionNumber]["Roll"]}@");
    widget.channel.write("Claw = ${positionsList[positionNumber]["Claw"]}@");
  }
  
  void _playback(){
    int i = 0;
    print(mapIndex);
    
    Timer.periodic(Duration(seconds: int.parse(_selectedNumber)), (timer) {
      if (i > mapIndex){
        timer.cancel();
      }
      else{
        playbackHelper(i);
        i++;
        print(i);
      }
      
      
    });
      /*Future.delayed(const Duration(milliseconds: 3000), () {
        playbackHelper(0);
      });
      Future.delayed(const Duration(milliseconds: 6000), () {
        playbackHelper(1);
      });
      Future.delayed(const Duration(milliseconds: 9000), () {
        playbackHelper(2);
      });
      */
  }

  @override
  void dispose() {
    widget.channel.close();
    super.dispose();
  }
}

class RecordsScreen extends StatefulWidget {
  final String title;
  final Socket channel;

  RecordsScreen({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {

  List <Widget> _children = [];

  @override
  void initState() {
    _add();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Screen"),
      ),
      body: Column(
        children:[
          Expanded(
            child: ListView(children: _children), 
          ),
          //buttonRow(5),
          Text("$mapIndex"),
 
        ]
      ,)
     
         
      
    );
  }
  Widget buttonRow(int positionIndex){
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Text('Positon $positionIndex'),
          Text(positionsList[positionIndex].values.toString()),
        ],
      )
    );
  }

  void _add() {
      for (int i = 0; i <= mapIndex; i++){
        _children = List.from(_children)
          ..add(new Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          
              Text('Positon $i'),
              Text(positionsList[i].values.toString()),
              RaisedButton(
                    child: Text("Go",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: (){
                      playbackHelper(i);
                      //targetPosition = i;
                    },
                  ),
            ],
          ),
        ));
        
      } 
  }

  void playbackHelper(int positionNumber){
    widget.channel.write("Pan = ${positionsList[positionNumber]["Pan"]}@");
    widget.channel.write("Tilt = ${positionsList[positionNumber]["Tilt"]}@");
    widget.channel.write("Tilt2 = ${positionsList[positionNumber]["Tilt2"]}@");
    widget.channel.write("Roll = ${positionsList[positionNumber]["Roll"]}@");
    widget.channel.write("Claw = ${positionsList[positionNumber]["Claw"]}@");
  }
  
     
}


  
