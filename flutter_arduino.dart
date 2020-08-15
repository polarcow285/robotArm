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
List <List> programsList = [];
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
  String _selectedResolution;
  int interpolateIndex = 0;

  bool stopFlag = false;
 

  List <int> numberList = new List();
  List <int> resolutionList = new List();
  List<DropdownMenuItem<String>> _dropdownMenuItems; 
  List<DropdownMenuItem<String>> _resolutionDropdownMenuItems;

  @override
  void initState() {
    for (int i = 0; i<11; i++){
      numberList.add(i);
    }
    for (int i = 1; i<11; i++){
      numberList.add(i*100);
    }
    for (int i = 0; i<11; i++){
      resolutionList.add(i);
    }
    for (int i = 2; i<11; i++){
      resolutionList.add(i*10);
    }
    _dropdownMenuItems = buildDropdownMenuItems(numberList);
    _resolutionDropdownMenuItems = buildResolutionDropdownMenuItems(resolutionList);
    
    //isVisible = false;
    _selectedNumber = _dropdownMenuItems[0].value;
    _selectedResolution = _resolutionDropdownMenuItems[0].value;
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
  List<DropdownMenuItem<String>> buildResolutionDropdownMenuItems(resolutionList) {
    List<DropdownMenuItem<String>> items = List();
    for(int n in resolutionList){
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
  onChangeResolutionDropdownItem(String selectedResolution) {
    setState(() {
      _selectedResolution = selectedResolution;
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
                  timeIntervalRow(),
                  resolutionRow(),
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
                  interpolateRow(),
                  RaisedButton(
                    child: Text("Clear Records",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: clearRecords,
                  ),
                  RaisedButton(
                    child: Text("Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: saveAs,
                  ),
                  RaisedButton(
                    child: Text("Water Pump",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0
                        )
                    ),
                    color: Colors.red,
                    onPressed: _waterPump,
                  ),
            ],
          ),
        //)
      )
    );
  }
  Widget timeIntervalRow(){
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Time Interval: '),
          DropdownButton(
            value: _selectedNumber,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
          ),
          Text('ms'),
        ],
      )
    );
  }
  Widget resolutionRow(){
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Resolution: '),
          DropdownButton(
            value: _selectedResolution,
            items: _resolutionDropdownMenuItems,
            onChanged: onChangeResolutionDropdownItem,
          ),
          Text('moves/segment'),
        ],
      )
    );
  }
  Widget interpolateRow(){
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            child: Text("Interpolate",
              style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 20.0
              )
            ),
            color: Colors.red,
            onPressed: (){
              stopFlag = false;
              interpolateAll(50);
            }
          ),
          RaisedButton(
            child: Text("Stop",
              style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 20.0
              )
            ),
            color: Colors.red,
            onPressed: (){
              stopFlag = true;
            }
          ),          
        ],
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
  void _waterPump() {
    widget.channel.write("Water Pump\n");
  }
  void playbackHelper(int positionNumber, List listOfPositions){
    widget.channel.write("Pan = ${listOfPositions[positionNumber]["Pan"]}@");
    widget.channel.write("Tilt = ${listOfPositions[positionNumber]["Tilt"]}@");
    widget.channel.write("Tilt2 = ${listOfPositions[positionNumber]["Tilt2"]}@");
    widget.channel.write("Roll = ${listOfPositions[positionNumber]["Roll"]}@");
    widget.channel.write("Claw = ${listOfPositions[positionNumber]["Claw"]}@");
    
    print(listOfPositions[positionNumber]);
  }
  
  void _playback(){
    int i = 0;
    print(mapIndex);
    
    Timer.periodic(Duration(seconds: int.parse(_selectedNumber)), (timer) {
      if (i > mapIndex){
        timer.cancel();
      }
      else{
        playbackHelper(i, positionsList);
        i++;
        print(i);
      }
      
      
    });
      
  }
  Map inBetweensMapConstructor(int resolution){
    //generates a list for each inbetween point
    var inBetweensMap = new Map();
    for (int i = 0; i < resolution-1; i++){
      inBetweensMap[i] = new List();
      
    }
    return inBetweensMap;
  }

  Map round(Map inBetweens){
  for (int p = 0; p < inBetweens.length; p++){
    for (int i = 0; i < 5; i ++){
      inBetweens[p][i] = inBetweens[p][i].round();
    }
  }
  return inBetweens;
    
  }

  List convertMapToList(Map inBetweens){
    List <List>inBetweensList = [];
    List <Map> inBetweensListOfMaps = [];
    
    for (int p = 0; p < inBetweens.length; p++){
      inBetweensList.add(inBetweens[p]);
    }
    
    for (int i = 0; i < inBetweensList.length; i++){
      var inBetweensMap = new Map();
      inBetweensMap["Pan"] = inBetweens[i][0];
      inBetweensMap["Tilt"] = inBetweens[i][1];
      inBetweensMap["Tilt2"] = inBetweens[i][2];
      inBetweensMap["Roll"] = inBetweens[i][3];
      inBetweensMap["Claw"] = inBetweens[i][4];
      inBetweensListOfMaps.add(inBetweensMap);
    }
    return inBetweensListOfMaps;
  }
  //helper function that takes in positionIndex and resolution, outcomes list of inBetweens
  List interpolateHelper(int initialPositionIndex, int resolution){
    List <int> position1List = [];
    List <int> position2List = [];
    List <double> incrementList = [];
    
  
    var inBetweensMap = inBetweensMapConstructor(resolution);
    double increment = 0;
    
    //puts all angles of each position into its own list
    positionsList[initialPositionIndex].forEach((k,v) => position1List.add(v));
    positionsList[initialPositionIndex + 1].forEach((k,v) => position2List.add(v));
    
    //calculates the increment from position1 to position2 for each angle and puts it into incrementList
    for (int i = 0; i<5; i++){
        int difference = position2List[i] - position1List[i];    
        increment = (difference/resolution);
        incrementList.add(increment);
    }
    //calculates the inBetweens positions and puts them into a Map (inBetweensMap)
    for (int j = 0; j < inBetweensMap.length; j++){
      for(int k = 0; k < 5; k++){
        
        if(j == 0){
          double angle = position1List[k] + incrementList[k];
          inBetweensMap[j].add(angle);
        }
        else{
          double angle = inBetweensMap[j-1][k] + incrementList[k];
          
          //if the inBetween point is greater than position2, then it stops at position2
          if (incrementList[k] > 0 && angle >= position2List[k]){ 
            inBetweensMap[j].add(position2List[k]);
          }
          //if the inBetween point is less than position2, then it stops at position2
          else if (incrementList[k] < 0 && angle <= position2List[k]){
            inBetweensMap[j].add(position2List[k]);
          }
          else{
            inBetweensMap[j].add(angle);
          }
          
         
        }

      }
    }

    //rounds every angle to the closest integer
    round(inBetweensMap);
    return(convertMapToList(inBetweensMap));

  }
  void interpolateAll(int resolution){
    int positionIndex = 0;
    print("HELLO");
    interpolateIndex = -1;
    List inBetweensList = [];

    Timer.periodic(Duration(milliseconds: int.parse(_selectedNumber)), (timer) {
      
      //print(inBetweensMap.length);
      print(interpolateIndex);
      if(stopFlag == true){
        timer.cancel();
      }
      if (interpolateIndex == -1){
        //runs first position of the segment
        print(positionsList[positionIndex]);
        playbackHelper(positionIndex, positionsList);
        interpolateIndex++;
        inBetweensList = interpolateHelper(positionIndex, resolution);
      }
      else if (interpolateIndex == inBetweensList.length){
        //runs final position of the segment
        playbackHelper(positionIndex + 1, positionsList);
        print(positionsList[positionIndex + 1]);
        interpolateIndex = -1;
        if(++positionIndex == positionsList.length-1){
          timer.cancel();
        }
    
      }
      else if(interpolateIndex >= 0){
        playbackHelper(interpolateIndex, inBetweensList);
        print(inBetweensList[interpolateIndex]);
        interpolateIndex++; 
      }      

    });
    
  }
  void saveAs(){
    programsList.clear();
    programsList.add(new List());
    for (int i = 0; i < positionsList.length; i++){
      programsList[0].add(positionsList[i]);
    }
    print(programsList);
  }
  void clearRecords(){
    positionsList.clear();
    print(programsList);
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
      //for (int i = 0; i <= mapIndex; i++){
      for (int i = 0; i < positionsList.length; i++){
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


  
