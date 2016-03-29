float rotationX = 0;
float rotationZ = 0;
float rotateSpeed = 0.4;
int plateLength = 450;
int plateHeight = 10;
int sphereDiameter = 25;
boolean run = true;
Mover mover;
Obstacle obstacle;
ArrayList<PVector> positionObstacle = new ArrayList<PVector>();
void settings() {
  size (500, 500, P3D);
}
void setup() {
  noStroke();
  mover = new Mover();
  obstacle = new Obstacle(50, 50, 40);
  
}
void draw() {
  if (run == true){
    drawBasics();
    translate(width/2, width/2, -width/2);
    rotateX(rotationX);
    rotateZ(rotationZ);
    box (plateLength, plateHeight, plateLength);
    translate(0,-(plateHeight/2 + sphereDiameter),0);
    mover.drawMover();
    }
    else if(run == false) {
    pushMatrix();
    camera(width/2, -300 ,-width/2, width/2,width/2,-width/2,0,0,1);
    drawBasics();
    translate(width/2, width/2, -width/2);
    box (plateLength, plateHeight, plateLength);
    translate(0,-(plateHeight/2 + sphereDiameter),0);
    mover.display();
    for(int i = 0; i < positionObstacle.size() - 1; i++)
    {
      println(" "+positionObstacle.get(i)+" i :"+i+"\n");
      obstacle.setObstacle();
      obstacle.drawObstacle(positionObstacle.get(i).x, positionObstacle.get(i).y);
      
    }
    
    popMatrix();
    
    
    
    }
}

void drawBasics()
{
    background(0);
    noStroke();
    lights();
    ambientLight(50,150,0);
}
void mouseDragged() {
  float speed = PI/30;
  if ((mouseY - pmouseY)<0) {
    if (rotationX < PI/3) {
      rotationX += (speed)*rotateSpeed;
    }
  }
  if ((mouseY - pmouseY)>0) {
    if (rotationX > -PI/3) {
      rotationX -= (speed)*rotateSpeed;
    }
  }
  if ((mouseX - pmouseX)>0) {
    if (rotationZ < PI/3) {
      rotationZ += (speed)*rotateSpeed;
    }
  }
  if ((mouseX - pmouseX)<0) {
    if (rotationZ > -PI/3) {
      rotationZ -= (speed)*rotateSpeed;
    }
  }
}
void mouseWheel (MouseEvent event) {
  float e = event.getAmount();
  if (e < 0) {
    if (rotateSpeed <= 1.4) {
      rotateSpeed += 0.1;
    }
  }
  if (e > 0) {
    if (rotateSpeed >= 0.1 ) {
      rotateSpeed -= 0.1;
    }
  }
}
void keyPressed(){
  if (keyCode == SHIFT){
   run = false;
  }
}
void keyReleased(){
  run = true;
}

void mouseClicked(){
  if(run == false)
 {
     PVector position = new PVector(pmouseX, pmouseY,0);
     positionObstacle.add(position);
    
 }
}
    