float rotationX = 0;
float rotationZ = 0;
float rotateSpeed = 0.4;
int plate = 450;
boolean run = true;
Mover mover;
Obstacle obstacle;
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
    mover.drawMover();
    }
    else if(run == false) {
    pushMatrix();
    camera(width/2, -300 ,-width/2, width/2,width/2,-width/2,0,0,1);
    background(0);
    noStroke();
    lights();
    ambientLight(50,150,0);
    translate(width/2, width/2, -width/2);
    box (plate, 10, plate);
    translate(0,-(5+16),0);
    mover.display();
    
   /* obstacle.setObstacle();
    obstacle.drawObstacle();
   */
    popMatrix();
    }
}

void drawBasics()
{
  background(0);
    noStroke();
    lights();
    ambientLight(50,150,0);
    translate(width/2, width/2, -width/2);
    rotateX(rotationX);
    rotateZ(rotationZ);
    box (plate, 10, plate);
    translate(0,-(5+16),0);
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

    