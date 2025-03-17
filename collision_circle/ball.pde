class Ball {
  PVector position;
  PVector velocity;
  float colorr;

  Ball(float x, float y, float vx, float vy) {
    position=new PVector(x, y);
    velocity=new PVector(vx, vy);
    colorr=random(360);
  }

  void update() {
    position.add(velocity);
  }

  void display() {
    noStroke();
    fill(colorr, 100, 100);
    ellipse(position.x, position.y, radius*2, radius*2);
  }

  void checkBoundaryCollision() {
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
    }
  }
}
