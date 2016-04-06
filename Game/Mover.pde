class Mover {
  float gravityConstant = 0.9;
  float normalForce = 1;
  float mu = 0.1;
  float frictionMagnitude = mu*normalForce;
PVector location;

PVector velocity;
PVector friction;
PVector grav = new PVector(0,0,0);
Mover() {
friction = new PVector(0, 0, 0);
location = new PVector(0, 0, 0);

velocity = new PVector(0, 0, 0);
}
void update() {
  grav.x = sin(rotationZ) * gravityConstant;
  grav.z = -(sin(rotationX) * gravityConstant);
  velocity.add(grav);
  friction.add(velocity);
  friction.mult(-1);
  friction.normalize();
  friction.mult(frictionMagnitude);
  velocity.add(friction);
  location.add(velocity);
  
}
void display() {
myGame.pushMatrix();
myGame.translate(location.x,location.y,location.z);
myGame.fill(244,98,0);
myGame.sphere(sphereRadius);

myGame.popMatrix();
}

void checkEdges() {
if (location.x > plateLength/2) {
  location.x = plateLength/2;
velocity.x = -velocity.x*0.5;
}
if (location.x < -plateLength/2) {
  location.x = -plateLength/2;
velocity.x = -velocity.x*0.5;
}
if (location.z > plateLength/2) {
  location.z = plateLength/2;
velocity.z = -velocity.z*0.5;
}
if (location.z < -plateLength/2) {
  location.z = -plateLength/2;
velocity.z = -velocity.z*0.5;
}
}

void drawMover()
{
  mover.update();
  mover.display();
  mover.checkEdges();
}
/*void checkCylinderCollision(){
  for (int i = 0; i < obstacle.positionObstacle.size(); ++i){
    if (location.dist(obstacle.positionObstacle.get(i)) < (sphereRadius + 50)){
      velocity.sub(velocity);
    }
  }
}*/
void checkCylinderCollision() {
  for(int i = 0; i < obstacle.positionObstacle.size(); i++)
  {
    float distance = PVector.dist(location, obstacle.positionObstacle.get(i));
    float distanceMin = sphereRadius + obstacleRadius;
    
    if(distance <= distanceMin){
      
      PVector normal = PVector.sub(location, obstacle.positionObstacle.get(i)); 
      location = PVector.add(obstacle.positionObstacle.get(i), normal);
      //PVector normal = new PVector(0,0,0);  
      //normal.x = location.x - (obstacle.positionObstacle.get(i).x);
      //normal.z = location.z - (obstacle.positionObstacle.get(i).z);
      normal.normalize();
      float calcul = PVector.dot(normal, velocity);
      velocity.sub(normal.mult(2*calcul));
  
    }
  }
}
}