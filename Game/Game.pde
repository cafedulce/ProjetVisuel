float rotationX = 0;
float rotationZ = 0;
float rotateSpeed = 0.4;
int plateLength = 500;
int plateHeight = 10;
int sphereRadius = 40;
int obstacleRadius = 50;
int obstacleHeight = 50;
int obstacleRes = 40;
int window = 2*plateLength;



boolean run = true;

Mover mover;
Obstacle obstacle;
PGraphics bigRectangle;
PGraphics myGame;
PGraphics topView;


void settings() {
  size (window, window, P3D);
  
}
void setup() {
  topView = createGraphics(180,180,P2D);
  bigRectangle = createGraphics(window, 200, P2D); 
  myGame = createGraphics(window, window-200, P3D);
  noStroke();
  mover = new Mover();
  obstacle = new Obstacle(obstacleRadius, obstacleHeight, obstacleRes);
 
}
void draw() {
  drawMyGame();
  image(myGame, 0, 0);
  drawMySurface();
  image(bigRectangle, 0, 500);
  drawTopView();
  image(topView, 10, 510);
}

void drawBasics()
{
    myGame.background(50);
    myGame.noStroke();
    myGame.lights();
    myGame.ambientLight(0,0,0);
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
       PVector position = new PVector(mouseX - plateLength, 0  ,mouseY - plateLength); // on decale selon y de height/2 car l'origine se trouve "dans" la box
       map(mouseX, -window/2, -plateLength/2, window/2, plateLength/2);
       map(mouseY, -window/2, -plateLength/2, window/2, plateLength/2);
       obstacle.positionObstacle.add(position);   
 }
}

void drawMySurface(){
  pushMatrix();
  bigRectangle.beginDraw();
  bigRectangle.background(120);
  bigRectangle.endDraw();
  popMatrix();
}
void drawTopView(){
  pushMatrix();
  bigRectangle.beginDraw();
  bigRectangle.background(0);
  bigRectangle.endDraw();
  popMatrix();
}
void drawMyGame(){
  pushMatrix();
  myGame.beginDraw();
  
  if (run == true){
    drawBasics();
    //myGame.camera(width/4, -150 ,width/2, width/2,width/2,-width/2,0,0,1);
    myGame.translate(width/2, width/2, -width/2);
    myGame.rotateX(rotationX);
    myGame.rotateZ(rotationZ);
    
    myGame.fill(34,162,176);
    myGame.box (plateLength, plateHeight, plateLength);

    pushMatrix();
    myGame.translate(0,-(plateHeight/2 + sphereRadius),0);
    mover.drawMover();
    obstacle.obstaclesDrawer();
    popMatrix();
    }
    
    else if(run == false) {
    myGame.pushMatrix();
    myGame.translate(width/2, width/2, 0); // on retranslate pour avoir le meme origine que pdt run
    myGame.rotateX(-PI/2);
    drawBasics();
    myGame.fill(34,162,136);
    myGame.box (plateLength, plateHeight, plateLength);

    mover.display();

    obstacle.obstaclesDrawer();
    
    myGame.popMatrix();
    }
    myGame.endDraw();
    popMatrix();

}