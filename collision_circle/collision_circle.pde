ArrayList<Ball> balls;
int n;
int a=2;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  balls = new ArrayList<Ball>();
  balls.add(new Ball(150, 150, 35, random(-1, 1) * 2.5, random(-1, 1) * 2.5));
  balls.add(new Ball(450, 450, 35, random(-1, 1) * 2.5, random(-1, 1) * 2.5));
  rectMode(CENTER);
}

void draw() {
  background(360);

  for (int i = balls.size() - 1; i>=0; i--) {
    Ball ball = balls.get(i);
    ball.update();
    ball.display();
    ball.checkBoundaryCollision();
    if (balls.size() > 10) {
      if (ball.finish()) {
        balls.remove(i);
      }
    }
  }

  n = balls.size();
  for (int i = 0; i<n-1; i++) {
    for (int j = i+1; j<n; j++) {
      balls.get(i).checkCollision(balls.get(j));
    }
  }
}


class Ball {
  PVector position;
  PVector velocity;
  float radius, m;
  float colorr = random(360);
  float xx, yy;
  float ccc = 35;
  int life;

  Ball(float x, float y, float rr, float vx, float vy) {
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
    radius = rr;
    m = radius*.1;
  }

  void update() {
    position.add(velocity);
  }

  void display() {
    noStroke();
    fill(colorr, 100, 100);
    rect(position.x, position.y, radius*2, radius*2, ccc);
  }

  void checkBoundaryCollision() {
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
      a += 1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
      a += 1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
      a += 1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
      colorr -= random(30, 60);
      if (colorr<0) colorr += 360;
      a += 1;
    }


    if (a % 2 == 1 && ccc > 1) {
      ccc --;
    }
    if (a % 2 == 0 && ccc < 34) {
      ccc ++;
    }
    println(a);
  }


  void checkCollision(Ball other) {

    PVector distanceVect = PVector.sub(other.position, position);
    // Get distances between the balls components

    float distanceVectMag = distanceVect.mag();
    // Calculate magnitude of the vector separating the balls

    float minDistance = radius + other.radius;
    // Minimum distance before they are touching

    if (distanceVectMag < minDistance ) {
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

      life += 1;

      xx = (position.x + other.position.x)/2;
      yy = (position.y + other.position.y)/2;

      PVector ao, vv, aoo;
      float dd, ee = 0;

      ao = new PVector(position.y - other.position.y, other.position.x - position.x );
      aoo = ao.setMag(72);
      
      vv = new PVector(velocity.y, - velocity.x);

      for (int i = 0; i < n-1; i++) {
        dd = dist(xx + aoo.x, yy + aoo.y, balls.get(i).position.x, balls.get(i).position.y);
        if (dd > 75) {
          ee += 1;
        }
      }

      if (xx + aoo.x >72 && xx + aoo.x < 528) {
        if (yy + aoo.y > 72 && yy + aoo.y < 528) {
          if (ee == n-1) {
            balls.add(new Ball(xx + aoo.x, yy + aoo.y, 35, vv.x, vv.y));
          }
        }
      }
      
      
    }
  }

  boolean finish() {
    if (life >= 1 ) {
      return true;
    } else {
      return false;
    }
  }
}
