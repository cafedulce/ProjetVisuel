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
stroke(120);
strokeWeight(2);
fill(180);
pushMatrix();
translate(location.x,location.y,location.z);
sphere(16);
popMatrix();
}

void checkEdges() {
if (location.x > plate/2) {
  location.x = plate/2;
velocity.x = -velocity.x;
}
if (location.x < -plate/2) {
  location.x = -plate/2;
velocity.x = -velocity.x;
}
if (location.z > plate/2) {
  location.z = plate/2;
velocity.z = -velocity.z;
}
if (location.z < -plate/2) {
  location.z = -plate/2;
velocity.z = -velocity.z;
}
}
}