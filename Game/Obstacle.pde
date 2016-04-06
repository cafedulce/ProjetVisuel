class Obstacle {
float cylinderBaseSize;
float cylinderHeight;
int cylinderResolution;
PShape openCylinder = new PShape();
PShape triangle = new PShape();
ArrayList<PVector> positionObstacle = new ArrayList<PVector>();
/**
*Constructeur d'Obstacle
*/
Obstacle(float cylinderBaseSize, float cylinderHeight, int cylinderResolution) {
  this.cylinderBaseSize = cylinderBaseSize;
  this.cylinderHeight = cylinderHeight;
  this.cylinderResolution = cylinderResolution;
}
/**
*Construit un cylindre
*/
void setObstacle() {
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;

    //get the x position and the y position of the 3 vertices to create a single triangle
    triangle.vertex(0, 0);
    triangle.vertex(x[i], y[i]);
    triangle.vertex(x[(i+1)%x.length], y[(i+1)%x.length]);
  
  }
  //decalaration of the complex forms that we're going to create
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  triangle = createShape();
  triangle.beginShape(TRIANGLES);
  
  //draw the border of the cylinder and the top/bottom of the cylinder
  for (int i = 0; i < x.length; i++) {
    //border of the cylinder
    openCylinder.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
    
    //bottom of the cylinder (Z=0)
    triangle.vertex(0, 0, 0);
    triangle.vertex(x[i], y[i], 0);
    triangle.vertex(x[(i+1)%x.length], y[(i+1)%x.length], 0);
    //top of the cylinder (Z=heigth)
    triangle.vertex(0, 0, cylinderHeight);
    triangle.vertex(x[i], y[i], cylinderHeight);
    triangle.vertex(x[(i+1)%x.length], y[(i+1)%x.length], cylinderHeight);
    
  }
 
 //finish the complex forms
  triangle.endShape();
  openCylinder.endShape();
  
}

/**
*Dessine un cylindre
*/
void drawObstacle(float x, float y, float z) {
  myGame.pushMatrix();
  myGame.translate(x, y + sphereRadius, z);
  myGame.rotateX(PI/2);
  myGame.shape(openCylinder);
  myGame.shape(triangle);
  myGame.popMatrix();
  
}
void obstaclesDrawer(){
  for(int i = 0; i < positionObstacle.size(); i++)
    {
      setObstacle();
      drawObstacle(positionObstacle.get(i).x, positionObstacle.get(i).y, positionObstacle.get(i).z); 
    }
}
}