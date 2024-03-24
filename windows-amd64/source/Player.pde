//Public variables
public int iMoveX, iMoveY;
public float fPlayerX, fPlayerY;
public boolean bPlayerAlive = true;

class Player{
  //Variables
  int iPlayerCornerX, iPlayerCornerX2, iPlayerCornerY, iPlayerCornerY2, iPlayerR;
  int fLX, fLX2, fLX3, fLX4, fLY, fLY2, fLY3, fLY4;
  int iPlayerSize, iSpeedX = 2, iSpeedY = 2;
  float fPlayerDX, fPlayerDY, fPlayerAngle;
  
  Player(int x, int y, int size){
    fPlayerX = x;
    fPlayerY = y; 
    iPlayerSize = size;
    iPlayerR = size/2;
  }

  void updatePlayer(){
    if (bPlayerAlive){ //Only allow actions when the player is alive
      playerMovement();
      rotatePlayer();
      if (iTimerMin == iTimerMax){
        background(0);
        caster.drawRays(60, 6, fPlayerX, fPlayerY, fPlayerAngle, 1, "White", 4, false); //Draw white player vision rays with 1 bounce
        caster.drawRays(1, 1, fPlayerX, fPlayerY, viewAngle(fPlayerX, fPlayerY, mouseX, mouseY), 1, "LightGreen" , 3, true); //Draw a single ray to indicate where the player is looking
      }
    }
    drawPlayer();
    remainingEnemies();
  }
  
  boolean checkPixel(float x, float y){ //Check for overlapping areas between a line and the player
    float fCP  = pow(x - fPlayerX, 2) + pow(y - fPlayerY, 2);
    if (fCP == pow(iPlayerR, 2)){return true;}
    if (fCP < pow(iPlayerR, 2)){return true;}
    return false;
  }
  
  void remainingEnemies(){ //Draw rays to the remaining enemies to help with the last few kills
    for (int ii = 0; ii < iEnemyCount; ii++){
      Enemy currentEnemy = enemies.get(ii);
      if (currentEnemy.bAlive == true){
        float fAngleToEnemy = viewAngle(fPlayerX, fPlayerY, currentEnemy.iEnemyX, currentEnemy.iEnemyY);
        caster.drawRays(1, 1, fPlayerX, fPlayerY, fAngleToEnemy, 0, "LightRed", 2, false);
      }
    }
  }
  
  void rotatePlayer(){ //Rotate the player angle towards the cursor
   fPlayerAngle = viewAngle(fPlayerX, fPlayerY, mouseX, mouseY) + (f1DgrRad * 30);
  }

  void drawPlayer(){ //Draw the player
    fill(125, 255, 0);
    strokeWeight(1);
    stroke(125, 255, 0);
    circle(fPlayerX, fPlayerY, iPlayerSize);
  }
  
  void playerMovement(){ //Collision checks between the player and the map walls
    collisionCalc(); //Update the player corner location for hitbox calculations
    
    //Handle movement collisions to the left
    leftMovement(fLX);
    leftMovement(fLX2);
    
    //Handle movement collisions to the right
    rightMovement(fLX3);
    rightMovement(fLX4);
    
    //Handle movement collisions upwards
    upMovement(fLY);
    upMovement(fLY4);
    
    //Handle movement collisions downwards
    downMovement(fLY2);
    downMovement(fLY3);
    
    //Move the player
    fPlayerX += iMoveX * iSpeedX;
    fPlayerY += iMoveY * iSpeedY;
  }
  
  void collisionCalc(){
    //Calculate corners for hitbox checks
    iPlayerCornerX  = int(fPlayerX) - iPlayerSize/2;
    iPlayerCornerY  = int(fPlayerY) - iPlayerSize/2;
    iPlayerCornerX2 = int(fPlayerX) + iPlayerSize/2;
    iPlayerCornerY2 = int(fPlayerY) + iPlayerSize/2;
    
    //Check tiles adjacent to playerX
    fLX  = (int(iPlayerCornerY)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX)>>iBitShift) - 1;
    fLX2 = (int(iPlayerCornerY2)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX)>>iBitShift) - 1;
    fLX3 = (int(iPlayerCornerY)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX2)>>iBitShift) + 1;
    fLX4 = (int(iPlayerCornerY2)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX2)>>iBitShift) + 1;
    
    //Check tiles adjacent to playerY
    fLY  = (int(iPlayerCornerY)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX)>>iBitShift) - iMapSizeY;
    fLY2 = (int(iPlayerCornerY2)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX)>>iBitShift) + iMapSizeY;
    fLY3 = (int(iPlayerCornerY)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX2)>>iBitShift) + iMapSizeY;
    fLY4 = (int(iPlayerCornerY2)>>iBitShift)*iMapSizeY + (int(iPlayerCornerX2)>>iBitShift) - iMapSizeY;
  }
  
  void leftMovement(int i){ //Check movement collisions for going left
    if (mapCurrentLayout[i] == 1){
      if (iPlayerCornerX - iSpeedX < ((int(iPlayerCornerX)>>iBitShift)<<iBitShift)){
        fPlayerX = ((int(fPlayerX)>>iBitShift)<<iBitShift) + iSpeedX + iPlayerSize/2;
      }
    }
  }
  
  void rightMovement(int i){ //Check movement collisions for going right
    if (mapCurrentLayout[i] == 1){
      if (iPlayerCornerX2 + iSpeedX >= ((int(iPlayerCornerX2)>>iBitShift)<<iBitShift) + iTileSize){
        fPlayerX = ((int(iPlayerCornerX2)>>iBitShift)<<iBitShift) + iTileSize - iSpeedX*2 - iPlayerSize/2;
      }
    }
  }
  
  void upMovement(int i){ //Check movement collisions for going up
    if (mapCurrentLayout[i] == 1){
      if (iPlayerCornerY - iSpeedY < ((int(iPlayerCornerY)>>iBitShift)<<iBitShift)){
        fPlayerY = ((int(fPlayerY)>>iBitShift)<<iBitShift) + iSpeedY + iPlayerSize/2;
      }
    }
  }
  
  void downMovement(int i){ //Check movement collisions for going down
    if (mapCurrentLayout[i] == 1){
      if (iPlayerCornerY2 + iSpeedY >= ((int(iPlayerCornerY2)>>iBitShift)<<iBitShift) + iTileSize){
        fPlayerY = ((int(iPlayerCornerY2)>>iBitShift)<<iBitShift) + iTileSize - iSpeedY*2 - iPlayerSize/2;
      }
    }
  }
}
