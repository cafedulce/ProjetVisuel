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
int topViewDim = 180;
float score = 0;
float lastScore = 0;


boolean run = true;

Mover mover;
Obstacle obstacle;
PGraphics bigRectangle;
PGraphics myGame;
PGraphics topView;
PGraphics scoreBoard;
PGraphics barChart; 
HScrollbar hs;
ImageProcessing image;
Movie mov;
PImage img;


void settings() {
  size (windowLength, windowHeight, P3D);

}
void setup() {
  mov = new Movie (this, "/Users/patrik/Documents/GitHub/ProjetVisuel/Game/data/testvideo.mp4");
  mov.loop();
  img = mov.get();
  mov.read();
  image = new ImageProcessing(this);
  image.pre_compute(image.tabSin, image.tabCos);
   
  scoreBoard = createGraphics(150, 180, P2D);
  topView = createGraphics(180,180,P2D);
  myGame = createGraphics(1100, 900 , P3D);
  bigRectangle = createGraphics(1100, 200, P2D);
  barChart = createGraphics(685, 120, P2D);
  hs = new HScrollbar(550,650,300,20);

  noStroke();
  mover = new Mover();
  obstacle = new Obstacle(obstacleRadius, obstacleHeight, obstacleRes);
 
}
void draw() {
  image.process(img);
  rotationX = image.angles.x;
  rotationZ = image.angles.y;
  drawMyGame();
  image(myGame, 0, 0);
  drawMySurface();
  image(bigRectangle, 0, 500);
  drawTopView();
  image(topView, 10, 510);
  drawScoreBoard();
  image(scoreBoard, 200, 510);
  drawBarChart();
  image(barChart, 360, 510);
  hs.update();
  hs.display();
  mov.read();
  img = mov.get();
}

void drawBasics()
{
    myGame.background(50);
    myGame.noStroke();
    myGame.lights();
    myGame.ambientLight(0,0,0);
}
void mouseDragged() {
if(mouseY < 500)
{
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
  int rectangleSize = 160;
  int offTop = 10;
  float factor = (float)rectangleSize / (float)plateLength;
  topView.beginDraw();
  topView.background(10);
  topView.translate (offTop,offTop);
  topView.fill(34,162,176);
  topView.rect(0,0,rectangleSize,rectangleSize);
  topView.translate(topViewDim/2 - offTop, topViewDim/2 - offTop);
  for (int i = 0; i < obstacle.positionObstacle.size() ; ++i){
    topView.fill(100,100,0);
    topView.ellipse( factor*obstacle.positionObstacle.get(i).x, factor*obstacle.positionObstacle.get(i).z, factor*obstacleRadius*2,factor*obstacleRadius*2);
  }
  pushMatrix();
  topView.translate(factor*mover.location.x, factor*mover.location.z);
  topView.fill(244,98,0);
  topView.ellipse(0,0,(factor*sphereRadius)*2,(factor*sphereRadius)*2);
  popMatrix();
  topView.endDraw();
  popMatrix();
}

void drawScoreBoard(){
pushMatrix();
scoreBoard.beginDraw();
fill(0);
//scoreBoard.background(255);
scoreBoard.endDraw();
popMatrix();
text("\n\nTotal Score : "+score+"\n\n\n\nVelocity : "+mover.velocity.mag()+"\n\n\n\nLast Score : "+lastScore+"", topViewDim + 20, (windowHeight-screenCut)+10);
}

void drawBarChart()
{
  pushMatrix();
  barChart.beginDraw();
  scoreBoard.background(255);
  barChart.endDraw();
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