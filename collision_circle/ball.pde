class Ball {
  PVector position;
  PVector velocity;
  float colorR= random(360);
  float m = 50*.1;

  Ball(PVector pos, PVector v) {
    position = pos;
    velocity = v;
  }

  void display() {
    noStroke();
    fill(250, 100, 100);
    ellipse(position.x, position.y, 100, 100);
    position.add(velocity);
  }

  void wall() {
    if (position.x>(width/2-50) || position.x<-(width/2-50) ) {
      velocity.x *= -1;
    } else if (position.y>(height/2-50) || position.y<-(height/2-50)) {
      velocity.y *= -1;
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

      PVector newPosition, newVelocity, Distance;

      Distance = new PVector(75, 75);

      newPosition = PVector.add(position, other.position);
      newPosition.div(2).add(Distance);

      newVelocity = new PVector(newPosition.y, -newPosition.x);
      newVelocity.setMag(1);

      if (newPosition.x<(width/2-75) || newPosition.x>-(width/2-75)) {
        if (newPosition.y<(height/2-75) || newPosition.y>-(height/2-75)) { 
          ballArrayList.add(new Ball(newPosition, newVelocity));
        }
      }
    }
  }
}
