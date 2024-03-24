//Public variables
public int iMapSizeX, iMapSizeY, iTileSize, iBitShift = 6;
float Dens = 0.69;

//Map layouts
int[] mapCurrentLayout;
int[] mapLayoutSmall = {
    1,1,1,1,1,1,1,1,1,1,
    1,0,0,1,0,0,0,0,0,1,
    1,0,0,1,0,0,0,1,1,1,
    1,0,0,1,0,0,0,1,0,1,
    1,0,0,1,0,0,1,1,0,1,
    1,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,1,
    1,0,1,0,0,0,1,1,1,1,
    1,0,0,0,0,0,0,0,0,1,
    1,1,1,1,1,1,1,1,1,1 
  };
int[] mapLayoutMedium = {
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,0,0,1,0,0,0,1,0,1,0,0,0,0,1,0,0,1,0,1,
    1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,1,0,0,1,0,1,1,1,0,0,1,1,1,1,0,1,1,
    1,0,0,1,0,0,0,1,1,0,1,0,0,1,0,0,0,0,0,1,
    1,0,0,1,0,0,0,1,0,0,1,0,1,1,0,0,1,0,0,1,
    1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1,1,0,1,
    1,0,1,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,1,
    1,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,1,1,
    1,0,1,0,1,0,0,1,1,1,1,1,0,0,0,0,1,0,0,1,
    1,0,0,1,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,1,
    1,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,1,1,0,1,
    1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,
    1,0,1,1,1,1,1,1,0,1,0,1,1,0,0,0,1,0,0,1,
    1,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,
    1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,
    1,0,0,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,
    1,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  };
int[] mapLayoutLarge = {
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
    1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  };  

class Map{
  Map(int x, int y, int s, String str){
    iMapSizeX = x;
    iMapSizeY = y;
    iTileSize = s;
    sMapType = str;
  }
  
  void mapInitialize(){ //Load the correct map
    switch(sMapType){
      case "Small":
        println("Loading small map.");
        mapCurrentLayout = mapLayoutSmall;
        iBitShift = 6;
        break;
      case "Medium":
        println("Loading medium map.");
        mapCurrentLayout = mapLayoutMedium;
        iBitShift = 5;
        break;
      case "Large":
        println("Loading large map.");
        mapCurrentLayout = mapLayoutLarge;
        iBitShift = 4;
        break;
      case "Seed":
        println("Loading seeded map.");
        mapCurrentLayout = generateGrid(iSeed, iMapSizeX, iMapSizeY, Dens);
        displayGrid(mapCurrentLayout, iMapSizeX, iMapSizeY);
        iBitShift = 5;
        break;
    }
  }
  
  void drawMap(int iC){ //Draw the tileset
    fill(iC);
    stroke(0);
    strokeWeight(1);
    for (int yy = 0; yy < iMapSizeX; yy++){
      for (int xx = 0; xx < iMapSizeY; xx++){
        if (mapCurrentLayout[yy*iMapSizeX+xx] == 1)
        rect(xx * iTileSize, yy * iTileSize, iTileSize, iTileSize);
      }
    }
  }
  
  public int[] generateGrid(int seed, int width, int height, double wallDensity) {
      int[] grid = new int[width * height];
      Random random = new Random(seed);

      //Fill the grid with walls
      Arrays.fill(grid, 1);

      //Generate random starting points for filling areas
      int numStartPoints = 5; //Adjust this number as needed
      int minDistanceBetweenStartPoints = 5; //Adjust this distance as needed
      for (int i = 0; i < numStartPoints; i++) {
          //Choose random starting points with minimum distance constraint
          int startX = random.nextInt(width);
          int startY = random.nextInt(height);
          for (int j = 0; j < minDistanceBetweenStartPoints; j++) {
              int xDir = random.nextInt(3) - 1; // -1, 0, or 1
              int yDir = random.nextInt(3) - 1; // -1, 0, or 1
              startX = (startX + xDir + width) % width;
              startY = (startY + yDir + height) % height;
          }

          //Set the starting point to empty space
          grid[startY * width + startX] = 0;
          
          //Ensure that the player does not spawn in a wall
          grid[(height/2 * width) + (width/2) - 1] = 0;
          grid[(height/2 * width) + (width/2)] = 0;
          grid[(height/2 * width) + (width/2) - 1 - width] = 0;
          grid[(height/2 * width) + (width/2) - width] = 0;
          
          //Recursively fill the area
          fillArea(grid, startX, startY, width, height, random, wallDensity);
          
          //Ensure outer edges are walls
          for (int x = 0; x < width; x++) {
            grid[x] = 1;
            grid[(height - 1) * width + x] = 1;
          }
          for (int y = 0; y < height; y++) {
            grid[y * width] = 1;
            grid[y * width + (width - 1)] = 1;
          }
         
      }

      return grid;
  }

  private void fillArea(int[] grid, int x, int y, int width, int height, Random random, double wallDensity) {
      int[] directions = {1, -1, 0, 0, 0, 0, 1, -1}; //Up, down, left, right
      shuffleArray(directions, random);
      for (int i = 0; i < directions.length; i += 2) {
          int newX = x + directions[i];
          int newY = y + directions[i + 1];
          if (newX >= 0 && newX < width && newY >= 0 && newY < height) {
              int index = newY * width + newX;
              if (grid[index] == 1 && random.nextDouble() < wallDensity) { //Adjust density here
                  grid[index] = 0;
                  fillArea(grid, newX, newY, width, height, random, wallDensity);
              }
          }
      }
  }

  private void shuffleArray(int[] array, Random random) {
      for (int i = array.length - 1; i > 0; i--) {
          int index = random.nextInt(i + 1);
          int temp = array[index];
          array[index] = array[i];
          array[i] = temp;
      }
  }
  
  public void displayGrid(int[] grid, int width, int height) {
      for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
              int cell = grid[y * width + x];
              System.out.print(cell + " ");
          }
          System.out.println();
      }
  }

}
