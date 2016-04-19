class Mover {
  float gravityConstant = 0.9;
  float normalForce = 1;
  float mu = 0.1;
  float frictionMagnitude = mu*normalForce;
  float bouncingFactor = 1.8;
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
lastScore = score;
score = score - (velocity.mag()*0.01);
}
if (location.x < -plateLength/2) {
  location.x = -plateLength/2;
velocity.x = -velocity.x*0.5;
lastScore = score;
score = score - (velocity.mag()*0.01);
}
if (location.z > plateLength/2) {
  location.z = plateLength/2;
velocity.z = -velocity.z*0.5;
lastScore = score;
score = score - (velocity.mag()*0.01);
}
if (location.z < -plateLength/2) {
  location.z = -plateLength/2;
velocity.z = -velocity.z*0.5;
lastScore = score;
score = score - (velocity.mag()*0.01);
}
}

void drawMover()
{
  mover.checkEdges();
  mover.checkCylinderCollision();
  mover.update();
  mover.display();
}


void checkCylinderCollision() {
  for(int i = 0; i < obstacle.positionObstacle.size(); i++)
  {
    float distance = PVector.dist(location, obstacle.positionObstacle.get(i));
    float distanceMin = sphereRadius + obstacleRadius;
    
    if(distance <= distanceMin){
      
      PVector normal = PVector.sub(location, obstacle.positionObstacle.get(i));
      normal = normal.normalize();
      PVector calcul1 = PVector.mult(normal, (distanceMin));
      location = PVector.add(obstacle.positionObstacle.get(i), calcul1);
      
      float calcul2 = PVector.dot(normal, velocity);
      velocity.sub(normal.mult(2*calcul2));
      velocity.mult(bouncingFactor);
      lastScore = score;
      score = score + (velocity.mag()*0.01);
    }
  }
}
}