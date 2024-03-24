class Enemy{
  //Variables
  int iEnemyX, iEnemyY, iEnemySize, iEnemyR;
  boolean bVulnerable = false, bAlive = true;
  
  Enemy(int x, int y, int size){
    iEnemyX = x;
    iEnemyY = y; 
    iEnemySize = size; //Diameter
    iEnemyR = size/2; //Radius
  }
  
  void checkVisibility(float a, float b ,float c){ //Check whether a line touches, intersects or does not collide with the enemy
    float fDist = abs(a * iEnemyX + b * iEnemyY + c) / sqrt(a * a + b * b);
    if (iEnemyR == fDist){println("Touch");}
    if (iEnemyR > fDist){println("Intersect");}
    if (iEnemyR < fDist){println("Nope");}
  }
  
  boolean checkPixel(float x, float y){ //Check for overlapping areas between a line this enemy
    float fCP  = pow(x - iEnemyX, 2) + pow(y - iEnemyY, 2);
    if (fCP == pow(iEnemyR, 2)){return true;}
    if (fCP < pow(iEnemyR, 2)){return true;}
    return false;
  }
  
  float checkDiscriminant(float A, float B, float C){ //Calculate the discriminant to check the amount of intersections
    float fDelta = (B*B) - 4 * A * C;
    if (fDelta == 0) {return 1;}
    if (fDelta < 0) {return 0;}
    if (fDelta > 0) {return 2;}
    println("Error");
    return 0;
  }
  
  void checkLoS(){ //Draw a ray from the enemy to the player
    if (bAlive){
      float fAngleToPlayer = viewAngle(iEnemyX, iEnemyY, fPlayerX, fPlayerY);
      caster.drawRays(1, 1, iEnemyX, iEnemyY, fAngleToPlayer, 0, "Red", 1, false);
    }
  }
  
  void checkDeath(){ //Check whether this instance of enemy should get killed or not
    for (int ii = 0; ii < iEnemyCount; ii++){
      Enemy currentEnemy = enemies.get(ii);
      if (currentEnemy.bVulnerable == true && bMouseClicked == true){currentEnemy.bAlive = false; iEnemiesStillAlive--;}
    }
  }
  
  void drawEnemy(){ //Draw the enemy
    if (bAlive){
      fill(125, 0, 0);
      strokeWeight(1);
      stroke(125, 0, 0);
      circle(iEnemyX, iEnemyY, iEnemySize);
    }
  }
}
