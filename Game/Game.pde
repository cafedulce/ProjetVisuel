float rotationX = 0;
float rotationZ = 0;
float rotateSpeed = 0.4;
int plateLength = 500;
int plateHeight = 10;
int sphereRadius = 40;
int obstacleRadius = 50;
int obstacleHeight = 50;
int obstacleRes = 40;
int windowHeight = 700;
int windowLength = 1100;
int screenCut = 200;


boolean run = true;

Mover mover;
Obstacle obstacle;
PGraphics bigRectangle;
PGraphics myGame;
PGraphics topView;
PGraphics scoreBoard;


void settings() {
  size (windowLength, windowHeight, P3D);
  
}
void setup() {
  scoreBoard = createGraphics(150, 180, P2D);
  topView = createGraphics(180,180,P2D);
  myGame = createGraphics(windowLength, windowHeight-screenCut , P3D);
  bigRectangle = createGraphics(windowLength, screenCut, P2D);

  noStroke();
  mover = new Mover();
  obstacle = new Obstacle(obstacleRadius, obstacleHeight, obstacleRes);
 
}
void draw() {
  drawMyGame();
  image(myGame, 0, 0);
  drawMySurface();
  image(bigRectangle, 0, windowHeight-screenCut);
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
 {     float off = windowLength/2 -plateLength/2;
       if ((mouseX >= off)&&(mouseX <= (windowLength - off))){
         if ((mouseY <= windowHeight-screenCut)){
           
           map(mouseX, 0, -plateLength/2, windowLength, plateLength/2);
           map(mouseY, 0, -plateLength/2, windowHeight - screenCut, plateLength/2);
           PVector position = new PVector(mouseX - windowLength/2, 0  ,mouseY - (windowHeight-screenCut)/2); // on decale selon y de height/2 car l'origine se trouve "dans" la box
           obstacle.positionObstacle.add(position);
         }
       
     }
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
    myGame.translate(windowLength/2, (windowHeight-screenCut)/2, -windowHeight/3);
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
    myGame.translate(windowLength/2, (windowHeight-screenCut)/2, 0); // on retranslate pour avoir le meme origine que pdt run
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