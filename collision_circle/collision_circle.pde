int a=100, b=100, c=0;
float f=random(1, 4), g=random(-4, -1);

Ball[] ball = new Ball[3];


void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  ball[0] = new Ball(200, 100, 50);
  ball[1] = new Ball(500, 500, 75);
  //ball[2] = new Ball(100, 100, c+1);
  //for (int i = 2; i <ball.length ;i++) {
  //  ball[i] = new Ball(100*(i-1), 100, 50);
  //}
}

void draw() {
  background(360);

  ball[2] = new Ball(a, b, c);
  if (c >= 50) {
    a += f;
    b += g;
    if (a >= (600-c)) {
      f = -f;
      a = 600-c;
    } else if (a<=c) {
      f = -f;
      a = c;
    } else if (b >=(600-c)) {
      g = -g;
      b = 600-c;
    } else if (b<=c) {
      g = -g;
      b = c;
    }
  }

  for (Ball ball : ball) {
    ball.move();
    ball.display();
    ball.checkBoundaryCollision();
  }

  for (int i=0; i<ball.length; i++) {
    for (int j=i+1; j<ball.length; j++) {
      ball[i].checkCollision(ball[j]);
    }
  }
  //if (ball[0].boom(ball[1])) {
  //  e += 1;
  //}
  //println(e);
}


class Ball {
  PVector position;
  PVector velocity;
  float radius, m;
  float colorr;

  Ball(float x, float y, float r_) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.mult(4);
    radius = r_;
    m = radius*.1;
  }

  void move() {
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
      colorr -= random(60, 90);
      if (colorr<0) colorr += 360;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
      colorr -= random(60, 90);
      if (colorr<0) colorr += 360;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
      colorr -= random(40, 70);
      if (colorr<0) colorr += 360;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
      colorr -= random(40, 70);
      if (colorr<0) colorr += 360;
    }
  }

  void checkCollision(Ball other) {

    PVector distanceVect = PVector.sub(other.position, position);// Get distances between the balls components
    float distanceVectMag = distanceVect.mag(); // Calculate magnitude of the vector separating the balls
    float minDistance = radius + other.radius; // Minimum distance before they are touching

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;

      c = 50;
    }
    //if (distanceVectMag <= minDistance) {
    //  e += 2;
    //  for (int i=2; i<ball.length; i++) {

    //  }
    //} else  {
    //  e =0;
    //}
  }

  //boolean boom(Ball other) {
  //  PVector distanceVect = PVector.sub(other.position, position);// Get distances between the balls components
  //  float distanceVectMag = distanceVect.mag(); // Calculate magnitude of the vector separating the balls
  //  float minDistance = radius + other.radius; // Minimum distance before they are touching

  //  if (distanceVectMag < minDistance+1) {
  //    return true;
  //  } else {
  //    return false;
  //  }
  //}
}
