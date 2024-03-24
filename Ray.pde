//Public variables
public float f1DgrRad = 0.0174533; //1 degree in radians

class Ray{

  void drawRays(int count, int dens, float fOriginX, float fOriginY, float fOriginAngle, int bounces, String colour, int weight, boolean dangerous){
    //Variables
    int iDepth, iMX, iMY, iMP, iBounces, iRayCount, iDensity, iHorizontalBounce;
    float fRayY = 0, fRayX = 0, fRayAngle, fOffsetX = 0, fOffsetY = 0, fAngleOffset;
    
    //Calculate the amount of rays and the offset
    iRayCount = count;
    iDensity = dens;
    iRayCount = count * iDensity;
    fAngleOffset = f1DgrRad/iDensity; //Calculate offset in case of multiple rays
    fRayAngle = fOriginAngle - fAngleOffset * iRayCount; //Apply the offset calculated above
    
    //Set angle limits
    if (fRayAngle < 0){
      fRayAngle += 2*PI;
    }
    if (fRayAngle > 2*PI){
      fRayAngle -= 2*PI;
    }
    
    for (int rr = 0; rr < iRayCount; rr++){
      iBounces = bounces;
      
      //Horizontal collision check
      iDepth = 0;
      float fExtremeH = 9999999, fHorizontalX = fOriginX, fHorizontalY = fOriginY;
      float aTangent = -1/tan(fRayAngle);
      if (fRayAngle > PI){
        fRayY = ((int(fOriginY)>>iBitShift)<<iBitShift)-0.0001; //bit shift to get nearest 64/32/16
        fRayX = (fOriginY - fRayY) * aTangent + fOriginX;
        fOffsetY = -iTileSize;
        fOffsetX = -fOffsetY * aTangent;
      }
      if (fRayAngle < PI){
        fRayY = ((int(fOriginY)>>iBitShift)<<iBitShift) + iTileSize; //bit shift to get nearest 64/32/16
        fRayX = (fOriginY - fRayY) * aTangent + fOriginX;
        fOffsetY =  iTileSize;
        fOffsetX = -fOffsetY * aTangent;
      }
      if (fRayAngle == 0 || fRayAngle == PI) { //In case the line has no angle or PI angle
        fRayX = fOriginX;
        fRayY = fOriginY;
        iDepth = iMapSizeX;
      }
      
      //Check for collisions with walls
      while (iDepth < iMapSizeX){
        iMX = int(fRayX)>>iBitShift;
        iMY = int(fRayY)>>iBitShift;
        iMP = iMY * iMapSizeX + iMX;
        if (iMP > 0 && iMP < iMapSizeX * iMapSizeY && mapCurrentLayout[iMP] == 1){
          fHorizontalX = fRayX;
          fHorizontalY = fRayY;
          fExtremeH = distanceToWall(fOriginX, fOriginY, fHorizontalX, fHorizontalY);
          iDepth = iMapSizeX; //Finish upon collision
        }
        else{ //Continue the line
          fRayX += fOffsetX;
          fRayY += fOffsetY;
          iDepth++;
        }
      }
      
      //Vertical collision check
      iDepth = 0;
      float fExtremeV = 9999999, fVerticalX = fOriginX, fVerticalY = fOriginY;
      float nTangent = -tan(fRayAngle);
      if (fRayAngle > PI/2 && fRayAngle < 3*PI/2){
        fRayX = ((int(fOriginX)>>iBitShift)<<iBitShift)-0.0001; //bit shift to get nearest 64/32/16
        fRayY = (fOriginX - fRayX) * nTangent + fOriginY;
        fOffsetX = -iTileSize;
        fOffsetY = -fOffsetX * nTangent;
      }
      if (fRayAngle < PI/2 || fRayAngle > 3*PI/2){
        fRayX = ((int(fOriginX)>>iBitShift)<<iBitShift) + iTileSize; //bit shift to get nearest 64/32/16
        fRayY = (fOriginX - fRayX) * nTangent + fOriginY;
        fOffsetX =  iTileSize;
        fOffsetY = -fOffsetX * nTangent;
      }
      if (fRayAngle == 0 || fRayAngle == PI) { //In case the line has no angle or PI angle
        fRayX = fOriginX;
        fRayY = fOriginY;
        iDepth = iMapSizeY;
      }
      
      //Check for collisions with walls
      while (iDepth < iMapSizeY){
        iMX = int(fRayX)>>iBitShift;
        iMY = int(fRayY)>>iBitShift;
        iMP = iMY * iMapSizeX + iMX;
        if (iMP > 0 && iMP < iMapSizeX * iMapSizeY && mapCurrentLayout[iMP] == 1){
          fVerticalX = fRayX;
          fVerticalY = fRayY;
          fExtremeV = distanceToWall(fOriginX, fOriginY, fVerticalX, fVerticalY);
          iDepth = iMapSizeY; //Finish upon collision
        }
        else{ //Continue the line
          fRayX += fOffsetX;
          fRayY += fOffsetY;
          iDepth++;
        }
      }
      
      //Check which line is shorter, horizontal or vertical. Then, pick the values of that line for the Ray
      if (fExtremeV < fExtremeH){
        fRayX = fVerticalX;
        fRayY = fVerticalY;
        iHorizontalBounce = 0;
      }
      else{
        fRayX = fHorizontalX;
        fRayY = fHorizontalY;
        iHorizontalBounce = 1;
      }
      
      //Pick a colour for the line
      switch(colour){
        case "LightGreen":
          stroke(50, 255, 50);
          break;
        case "Red":
          if (bPlayerAlive){stroke(255, 0, 0, 0);}
          else{stroke(255, 0, 0, 255);}
          break;
        case "LightRed":
          stroke(255, 0, 0, 0);
          break;
        case "Yellow":
          stroke(255, 255, 0);
          break;
        case "Purple":
          stroke(255, 0, 255);
          break;
        case "White":
          stroke(200);
          break;
        case "Blue":
          stroke(0, 0, 255);
          break;
        case "Procedural":
          int red = channel1note/2;
          int green = channel2note/2;
          int blue = channel4note/2;
          int normal = 40;
          //println(channel1note + " " + channel2note + " " + channel3note + " " + channel4note);
          if (red > 255 - normal)
          {
            red = 255 - normal;
          }
          if (green > 255 - normal)
          {
            green = 255 - normal;
          }
          if (blue > 255 - normal)
          {
            blue = 255 - normal;
          }
          stroke(normal + red, normal + green, normal + blue);
          break;
        case "Experimental":
          int total = channel4note;
          if (total > 215)
          {
            total = 215;
          }
          stroke(total + 40);
          break;
      }
      
      //Draw a visible line to represent the ray
      strokeWeight(weight);
      line(fOriginX, fOriginY, fRayX, fRayY);
      
      
      //Check bounce angle
      float fBounceAngle = 0;
      switch(iHorizontalBounce){
        case 1:
          if (fRayAngle < PI/2){fBounceAngle = PI/2 - fRayAngle; fBounceAngle = fBounceAngle + PI*1.5;}
          if (fRayAngle > PI/2 && fRayAngle < PI){fBounceAngle = fRayAngle - PI/2; fBounceAngle = PI*1.5 - fBounceAngle;}
          if (fRayAngle > PI && fRayAngle < PI*1.5){fBounceAngle = PI/2 - (fRayAngle - PI); fBounceAngle = fBounceAngle - PI*1.5;}
          if (fRayAngle > PI*1.5 && fRayAngle < PI*2){fBounceAngle = fRayAngle - PI*1.5; fBounceAngle = PI*2.5 - fBounceAngle;}
          break;
        case 0:
          if (fRayAngle < PI/2){fBounceAngle = fRayAngle; fBounceAngle = PI - fBounceAngle;}
          if (fRayAngle > PI/2 && fRayAngle < PI){fBounceAngle = PI/2 - (fRayAngle - PI/2); fBounceAngle = fBounceAngle - PI*2;}
          if (fRayAngle > PI && fRayAngle < PI*1.5){fBounceAngle = fRayAngle - PI; fBounceAngle = 2*PI - fBounceAngle;}
          if (fRayAngle > PI*1.5 && fRayAngle < PI*2){fBounceAngle = PI/2 - (fRayAngle - PI*1.5); fBounceAngle = PI + fBounceAngle;}
          break;
      }
      
      //Bounce a new ray if there are any bounces left
      if (iBounces > 0){
        iBounces--;
        drawRays(1, 1, fRayX, fRayY, fBounceAngle, iBounces, colour, weight, dangerous);
      }
      
      //Increase the angle for the next line
      fRayAngle += fAngleOffset;
      
      //Reset angle limit
      if (fRayAngle < 0){
        fRayAngle += 2*PI;
      }
      if (fRayAngle > 2*PI){
        fRayAngle -= 2*PI;
      }
      
      //Convert the points of the ray into a line equation
      float fDiffX = fOriginX - fRayX;
      float fDiffY = fOriginY - fRayY;
      float fEqM = fDiffY/fDiffX;
      float fEqC = fEqM * fRayX - fRayY;
      fEqC *= -1;
      
      //Reset enemy vulnerability status
      for (int ii = 0; ii < iEnemyCount; ii++){
        Enemy currentEnemy = enemies.get(ii);
        currentEnemy.bVulnerable = false;
      }
      
      //Check for ray overlap with enemies
      for (float i = fOriginX; i < fRayX; i++){
        float fCoordY = fEqM * i + fEqC;
        if (colour == "Red" && P1.checkPixel(i, fCoordY) && bPlayerAlive == true){
          bPlayerAlive = false; //Kill the player if an enemy has LoS
        }
        if (colour == "LightRed" && P1.checkPixel(i, fCoordY) && iEnemiesStillAlive < 4){
          stroke(255, 0, 0);
          point(i, fCoordY); //Draw a radar in case there are less then 4 enemies left
        }
        for (int ii = 0; ii < iEnemyCount; ii++){
          Enemy currentEnemy = enemies.get(ii);
          if ((colour == "White" || colour == "LightGreen" || colour == "Procedural") && currentEnemy.checkPixel(i, fCoordY) && currentEnemy.bAlive == true){
            stroke(255, 0, 0);
            point(i, fCoordY); //Colour the pixel red if your vision overlaps with the enemy
            if (dangerous){currentEnemy.bVulnerable = true;} //Make enemies you aim at vulnerable
            currentEnemy.checkDeath();
          }
        }
      }
      for (float i = fOriginX; i >= fRayX; i--){
        float fCoordY = fEqM * i + fEqC;
        if (colour == "Red" && P1.checkPixel(i, fCoordY) && bPlayerAlive == true){
          bPlayerAlive = false; //Kill the player if an enemy has LoS
        }
        if (colour == "LightRed" && P1.checkPixel(i, fCoordY) && iEnemiesStillAlive < 4){
          stroke(255, 0, 0);
          point(i, fCoordY); //Draw a radar in case there are less then 4 enemies left
        }
        for (int ii = 0; ii < iEnemyCount; ii++){
          Enemy currentEnemy = enemies.get(ii);
          if ((colour == "White" || colour == "LightGreen") && currentEnemy.checkPixel(i, fCoordY) && currentEnemy.bAlive == true){
            stroke(255, 0, 0);
            point(i, fCoordY); //Colour the pixel red if your vision overlaps with the enemy
            if (dangerous){currentEnemy.bVulnerable = true;} //Make enemies you aim at vulnerable
            currentEnemy.checkDeath();
          }
        }
      }
      for (float i = fOriginY; i < fRayY; i++){
        float fCoordX = (i/fEqM) - (fEqC/fEqM);
        if (colour == "Red" && P1.checkPixel(fCoordX, i) && bPlayerAlive == true){
          bPlayerAlive = false; //Kill the player if an enemy has LoS
        }
        if (colour == "LightRed" && P1.checkPixel(fCoordX, i) && iEnemiesStillAlive < 4){
          stroke(255, 0, 0);
          point(fCoordX, i); //Draw a radar in case there are less then 4 enemies left
        }
        for (int ii = 0; ii < iEnemyCount; ii++){
          Enemy currentEnemy = enemies.get(ii);
          if ((colour == "White" || colour == "LightGreen") && currentEnemy.checkPixel(fCoordX, i) && currentEnemy.bAlive == true){
            stroke(255, 0, 0);
            point(fCoordX, i); //Colour the pixel red if your vision overlaps with the enemy
            if (dangerous){currentEnemy.bVulnerable = true;} //Make enemies you aim at vulnerable
            currentEnemy.checkDeath();
          }
        }
      }
      for (float i = fOriginY; i >= fRayY; i--){
        float fCoordX = (i/fEqM) - (fEqC/fEqM);
        if (colour == "Red" && P1.checkPixel(fCoordX, i) && bPlayerAlive == true){
          bPlayerAlive = false; //Kill the player if an enemy has LoS
        }
        if (colour == "LightRed" && P1.checkPixel(fCoordX, i) && iEnemiesStillAlive < 4){
          stroke(255, 0, 0);
          point(fCoordX, i); //Draw a radar in case there are less then 4 enemies left
        }
        for (int ii = 0; ii < iEnemyCount; ii++){
          Enemy currentEnemy = enemies.get(ii);
          if ((colour == "White" || colour == "LightGreen") && currentEnemy.checkPixel(fCoordX, i) && currentEnemy.bAlive == true){
            stroke(255, 0, 0);
            point(fCoordX, i); //Colour the pixel red if your vision overlaps with the enemy
            if (dangerous){currentEnemy.bVulnerable = true;} //Make enemies you aim at vulnerable
            currentEnemy.checkDeath();
          }
        }
      }
    }
  }
}
