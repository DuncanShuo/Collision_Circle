class Ball {
  PVector position;
  PVector velocity;
  float m = 50*.1;
  float colorr = random(360);
  float xx, yy;
  float sxmin, sxmax, symin, symax;

  Ball(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
  }


  void begin() {
    for (int i = 0; i < balls.size(); i ++) {

      sxmin = balls.get(i).position.x - 50;
      sxmax = balls.get(i).position.x + 50;
      symin = balls.get(i).position.y - 50;
      symax = balls.get(i).position.y + 50;

      for (int angle = 0; angle < 360; angle += 9) {
        PVector c = PVector.fromAngle(radians(angle-135));
        c.setMag(50);
        c.add(balls.get(i).position);
        circle.add(c);
        morph.add(new PVector(balls.get(i).position.x, balls.get(i).position.y));
      }

      for (float x = sxmin; x < sxmax; x += 10) {
        square.add(new PVector(x, symin));
      }
      for (float y = symin; y < symax; y += 10) {
        square.add(new PVector(sxmax, y));
      }
      for (float x = sxmax; x > sxmin; x -= 10) {
        square.add(new PVector(x, symax));
      }
      for (float y = symax; y > symin; y -= 10) {
        square.add(new PVector(sxmin, y));
      }
    }
  }


  void update() {
    for (int i = 0; i < balls.size(); i++) {
      for (int j = i*40; j < (i+1)*40; j++) {
        circle.get(j).add(balls.get(i).velocity);
        square.get(j).add(balls.get(i).velocity);
      }
      position.add(velocity);
    }
  }


  void display() {
    for (int i = 0; i < balls.size(); i++) {
      for (int j = i*40; j < (i+1)*40; j++) {
        PVector v1;
        if (state1) {
          v1 = circle.get(j);
        } else {
          v1 = square.get(j);
        }
        PVector v2 = morph.get(j);
        v2.lerp(v1, 0.3);
      }
    }

    for (int i = 0; i < balls.size(); i++) {
      fill(colorr, 100, 100);
      noStroke();
      //noFill();
      //stroke(140);
      beginShape();
      for (int j = i*40; j < (i+1)*40; j++) {
        vertex(morph.get(j).x, morph.get(j).y);
        //point(morph.get(j).x, morph.get(j).y);
      }
      endShape(CLOSE);
    }
  }


  void checkBoundaryCollision() {
    if (position.x > width/2-50) {
      velocity.x *= -1;
      colorr -= random(30, 60);
      if (colorr < 0) colorr += 360;
      state1 = !state1;
    } else if (position.x <-width/2 +  50) {
      velocity.x *= -1;
      colorr -= random(30, 60);
      if (colorr < 0) colorr += 360;
      state1 = !state1;
    } else if (position.y > height/2-50) {
      velocity.y *= -1;
      colorr -= random(30, 60);
      if (colorr < 0) colorr += 360;
      state1 = !state1;
    } else if (position.y < -height/2 + 50) {
      velocity.y *= -1;
      colorr -= random(30, 60);
      if (colorr < 0) colorr += 360;
      state1 = !state1;
    }
  }

  void checkCollision(Ball other) {

    PVector distanceVect = PVector.sub(other.position, position);
    // Get distances between the balls components

    float distanceVectMag = distanceVect.mag();
    // Calculate magnitude of the vector separating the balls

    float minDistance = 100;
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



      //xx = (position.x + other.position.x)/2;
      //yy = (position.y + other.position.y)/2;

      //PVector ao, vv, aoo;
      //float dd, ee = 0;

      //ao = new PVector(position.y - other.position.y, other.position.x - position.x );
      //aoo = ao.setMag(105);

      //vv = new PVector(velocity.y, - velocity.x);

      //for (int i = 0; i < n-1; i++) {
      //  dd = dist(xx + aoo.x, yy + aoo.y, balls.get(i).position.x, balls.get(i).position.y);
      //  if (dd > 105) {
      //    ee += 1;
      //  }
      //}

      //if (xx + aoo.x >-205 && xx + aoo.x < 205) {
      //  if (yy + aoo.y > -205 && yy + aoo.y < 205) {
      //    if (ee == n-1) {
      //      balls.add(new Ball(xx + aoo.x, yy + aoo.y));
      //    }
      //  }
      //}

      //if (balls.size() > 2) {
      //  int nn = balls.size()-1;
      //  sxmin = balls.get(nn).position.x - 50;
      //  sxmax = balls.get(nn).position.x + 50;
      //  symin = balls.get(nn).position.y - 50;
      //  symax = balls.get(nn).position.y + 50;

      //  for (int angle = 0; angle < 360; angle += 9) {
      //    PVector c = PVector.fromAngle(radians(angle-135));
      //    c.setMag(50);
      //    c.add(balls.get(nn).position);
      //    circle.add(c);
      //    morph.add(new PVector(balls.get(nn).position.x, balls.get(nn).position.y));
      //  }

      //  for (float x = sxmin; x < sxmax; x += 10) {
      //    square.add(new PVector(x, symin));
      //  }
      //  for (float y = symin; y < symax; y += 10) {
      //    square.add(new PVector(sxmax, y));
      //  }
      //  for (float x = sxmax; x > sxmin; x -= 10) {
      //    square.add(new PVector(x, symax));
      //  }
      //  for (float y = symax; y > symin; y -= 10) {
      //    square.add(new PVector(sxmin, y));
      //  }
      //}
      
      
      
    }
  }
}
