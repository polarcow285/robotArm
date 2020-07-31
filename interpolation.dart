void main(){
  
  var armPositionMap = new Map();
  armPositionMap["Pan"] = (90);
  armPositionMap["Tilt"] = (60);
  armPositionMap["Tilt2"] = (79);
  armPositionMap["Roll"] = (84);
  armPositionMap["Claw"] = (32);
  
  var armPositionMap2 = new Map();
  armPositionMap2["Pan"] = (90);
  armPositionMap2["Tilt"] = (60);
  armPositionMap2["Tilt2"] = (79);
  armPositionMap2["Roll"] = (84);
  armPositionMap2["Claw"] = (32);
  
 interpolation(armPositionMap, armPositionMap2, 10);
  //List <int> numberList = [1,2,3,4,5];
  
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

void interpolation(Map position1, Map position2, int resolution){
  List <int> position1List = [];
  List <int> position2List = [];
  List <double> incrementList = [];
  
 
  var inBetweensMap = inBetweensMapConstructor(resolution);
  double increment = 0;
  
  //puts all angles of each position into its own list
  position1.forEach((k,v) => position1List.add(v));
  position2.forEach((k,v) => position2List.add(v));
  
  for (int i = 0; i<5; i++){
      int difference = position2List[i] - position1List[i];    
      increment = (difference/resolution);
      incrementList.add(increment);
  }
  
  
 
  for (int j = 0; j < inBetweensMap.length; j++){
    for(int k = 0; k < 5; k++){
      
      
    
      if(j == 0){
        double angle = position1List[k] + incrementList[k];
        inBetweensMap[j].add(angle);
      }
      else{
        double angle = inBetweensMap[j-1][k] + incrementList[k];
        
        if (incrementList[k] > 0 && angle >= position2List[k]){ 
          inBetweensMap[j].add(position2List[k]);
        }
        else if (incrementList[k] < 0 && angle <= position2List[k]){
          inBetweensMap[j].add(position2List[k]);
        }
        else{
          inBetweensMap[j].add(angle);
        }
        
        /*if (inBetweensMap[j-1][k] == position2List[k]){
          inBetweensMap[j].add(position2List[k]);
        }
        else{
          double angle = inBetweensMap[j-1][k] + incrementList[k];
          inBetweensMap[j].add(angle.round());
        }
        */
      }

    }
  }
  
  round(inBetweensMap);
  
  
  
 print(position1List);
 for (int p = 0; p < inBetweensMap.length; p++){
   print(inBetweensMap[p]);
 }
 print(position2List);
 
}
