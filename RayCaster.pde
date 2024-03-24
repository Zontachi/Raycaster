//Raycasting system V1.0
//Made by Pascal Schippers

import netP5.*;
import oscP5.*;
import java.util.Random;
import java.util.Arrays;
import java.util.Stack;
import java.util.*;

OscP5 oscP5;

//Variables
String sMapType = "Seed";
boolean bDrawMap = false, bMouseClicked = false, bDebugMode = true;
int iTimerMin = 0, iTimerMax = 1, iEnemySize = 20, iEnemyCount, iPlayerStartX = 320, iPlayerStartY = 320, iPlayerStartSize = 20, iEnemiesStillAlive, iScreenSize = 1280;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
String sDeath = "You died.", sReset = "Press 'R' to reset.", sEnemiesLeft = "Enemies left: ", sWin = "You win!";
String sSeed = "Silky"; //Input level seed here
public int iSeed;

//OSC Variables
public int songposition = 0;
public int patternnr = 0;
public int patternrow = 0;
public int channel1instr = 0;
public int channel2instr = 0;
public int channel3instr = 0;
public int channel4instr = 0;
public int channel1note = 0;
public int channel2note = 0;
public int channel3note = 0;
public int channel4note = 0;
public char channel1effect;
public char channel2effect;
public char channel3effect;
public char channel4effect;
public String channel1effect_param = "00";
public String channel2effect_param = "00";
public String channel3effect_param = "00";
public String channel4effect_param = "00";
public String feedback_formatted = "";

//Objects
Map map;
Ray caster = new Ray();
Player P1 = new Player(iPlayerStartX, iPlayerStartY, iPlayerStartSize);

void setup(){
  size(640,640);
  background(0);
  frameRate(60);
  oscP5 = new OscP5(this,6200);
  iSeed = convertStringToInteger(sSeed, 3);
  println("Numeric seed: " + iSeed);
  
  //Create the correct map
  switch(sMapType){
    case "Small":
      println("Creating small map.");
      map = new Map(10, 10, 64, "Small");
      map.mapInitialize();
      break;
    case "Medium":
      println("Creating medium map.");
      map = new Map(20, 20, 32, "Medium");
      map.mapInitialize();
      break;
    case "Large":
      println("Creating large map.");
      map = new Map(40, 40, 16, "Large");
      map.mapInitialize();
      break;
    case "Seed":
      println("Creating seeded map.");
      map = new Map(20, 20, 32, "Seed");
      map.mapInitialize();
      break;
  }
 addEnemies();
}

void draw(){
  //Timer to slow down ray traces per second
  iTimerMin++;
  if (iTimerMin > iTimerMax){iTimerMin = 0;}
  
  P1.updatePlayer();
  map.drawMap(0); //Draw an invisible map to hide some visual overlaps
  
  //Flashlight mode for debugging
  if (bDrawMap || bPlayerAlive == false){
    map.drawMap(60); 
    drawEnemies();
  }
  
  if (iTimerMin == iTimerMax){bMouseClicked = false;} //Reset mouse clicked status
  if (iTimerMin == iTimerMax){drawLoS();} //Slowed down LoS checks for enemies
  
  //drawText();
}

void drawText(){
  textSize(20); fill(255, 0, 0); text(sEnemiesLeft + iEnemiesStillAlive, 480, 23); //Text to show how many enemies are still alive
  
  if (iEnemiesStillAlive < 4){
    textSize(20); fill(255, 0, 0); text("Radar Active", 50, 23); //Text to show that the radar is active
  }
  
  if (bPlayerAlive == false){ //Draw death screen
    textSize(128); fill(255, 0, 0); text(sDeath, 80, 260);
    textSize(20); fill(255, 0, 0); text(sReset, 240, 330);
  }
  
  if (iEnemiesStillAlive == 0){ //Draw win screen
    textSize(128); fill(0, 255, 0); text(sWin, 90, 260);
    textSize(20); fill(0, 255, 0); text(sReset, 240, 330);
  }
}

void drawLoS(){ //Call line of sight calculations for all enemies
  for (int ii = 0; ii < iEnemyCount; ii++){
    Enemy currentEnemy = enemies.get(ii);
    currentEnemy.checkLoS();
  }
}

void addEnemies(){ //Add enemies to the game based on map type
  switch (sMapType){
    case "Small":
      break;
    case "Medium":
      //Add enemies to the game
      addEnemy(2, 1);
      addEnemy(4, 1);
      addEnemy(15, 1);
      addEnemy(7, 3);
      addEnemy(18, 4);
      addEnemy(9, 5);
      addEnemy(2, 10);
      addEnemy(16, 8);
      addEnemy(15, 11);
      addEnemy(13, 14);
      addEnemy(17, 18);
      addEnemy(1, 18);
      addEnemy(8, 17);
      addEnemy(11, 15);
      addEnemy(17, 9);
      iEnemyCount = enemies.size();
      iEnemiesStillAlive = iEnemyCount;
      println(iEnemyCount + " enemies have been created.");
      break;
    case "Large":
      break;
  }
}

void addEnemy(int x, int y){ //Add a single new enemy on a certain point on the map
  x = x * iTileSize + iTileSize/2;
  y = y * iTileSize + iTileSize/2;
  enemies.add(new Enemy(x, y, iEnemySize));
}

void drawEnemies(){ //Draw visible enemies in case of flashlight mode
  for (int ii = 0; ii < iEnemyCount; ii++){
    Enemy currentEnemy = enemies.get(ii);
    currentEnemy.drawEnemy();
  }
}

void gameReset(){
  for (int ii = 0; ii < iEnemyCount; ii++){
    Enemy currentEnemy = enemies.get(ii);
    currentEnemy.bAlive = true;
  }
  iEnemiesStillAlive = iEnemyCount;
  fPlayerX = iPlayerStartX;
  fPlayerY = iPlayerStartY;
  bPlayerAlive = true;
}

public int convertStringToInteger(String input, int limit) {
    StringBuilder sb = new StringBuilder();
    int count = 0; // Counter to keep track of the length
    for (char c : input.toCharArray()) {
        if (count >= limit) {
            break; // Break if the limit is reached
        }
        sb.append((int) c); // Append ASCII value of each character
        count++;
    }
    return Integer.parseInt(sb.toString()); // Parse the resulting string to integer
}

public float viewAngle(float fAX, float fAY, float fBX, float fBY){ //Calculates the angle between 2 points in a circle
  float fAngle = atan2(fBY - fAY, fBX - fAX);
  return fAngle;
}
  
public float distanceToWall(float fAX, float fAY, float fBX, float fBY){ //Calculates the distance of a line between 2 points using pythagoras
  return sqrt((fBX - fAX) * (fBX - fAX) + (fBY - fAY) * (fBY - fAY));
}

void keyPressed(){ //Change values based on keys pressed
  if (key == 'w' || key == 'W'){iMoveY = -1;}
  if (key == 'a' || key == 'A'){iMoveX = -1;}
  if (key == 's' || key == 'S'){iMoveY =  1;}
  if (key == 'd' || key == 'D'){iMoveX =  1;}
  if ((key == 'f' || key == 'F') && bDebugMode){bDrawMap = true;}
  if (key == 'r' || key == 'R'){gameReset();}
}
  
void keyReleased(){ //Change values based on keys released
  if (key == 'w' || key == 'W'){iMoveY = 0;}
  if (key == 'a' || key == 'A'){iMoveX = 0;}
  if (key == 's' || key == 'S'){iMoveY = 0;}
  if (key == 'd' || key == 'D'){iMoveX = 0;}
  if ((key == 'f' || key == 'F') && bDebugMode){bDrawMap = false;}
}

void mouseClicked(){ //Check for mouse left clicks
  bMouseClicked = true;
}

void oscEvent(OscMessage message) 
{
  if (message.checkAddrPattern("/patternevent" ) )
  {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(" addrpattern: "+message.addrPattern());
    println(" typetag: "+message.typetag());
    
    songposition = message.get(0).intValue();
    patternnr = message.get(1).intValue();
    patternrow = message.get(2).intValue();
    
    channel1note = message.get(3).intValue();
    channel1instr = message.get(4).intValue();
    channel1effect = message.get(5).charValue();
    channel1effect_param = message.get(6).stringValue();
    channel2note = message.get(7).intValue();
    channel2instr = message.get(8).intValue();
    channel2effect = message.get(9).charValue();
    channel2effect_param = message.get(10).stringValue();    
    channel3note = message.get(11).intValue();
    channel3instr = message.get(12).intValue();
    channel3effect = message.get(13).charValue();
    channel3effect_param = message.get(14).stringValue();
    channel4note = message.get(15).intValue();;
    channel4instr = message.get(16).intValue();
    channel4effect = message.get(17).charValue();
    channel4effect_param = message.get(18).stringValue();


    feedback_formatted = String.format("%02d:%02d | %03d:%02d:%c%s | %03d:%02d:%c%s | %03d:%02d:%c%s | %03d:%02d:%c%s |" , 
                                      patternnr, patternrow, 
                                      channel1note, channel1instr, channel1effect, channel1effect_param, 
                                      channel2note, channel2instr, channel2effect, channel2effect_param, 
                                      channel3note, channel3instr, channel3effect, channel3effect_param,
                                      channel4note, channel4instr, channel4effect, channel4effect_param
                                      );
    println( feedback_formatted );
    //caster.drawRays(patternrow, 6, fPlayerX, fPlayerY, -fPlayerAngle, 1, "Procedural", 4, false);
  }
}
