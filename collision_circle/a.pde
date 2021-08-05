class Ball {
  PVector position;
  PVector velocity;
  float m = 50*.1;

  Ball(float px, float py, float vx, float vy) {
    position = new PVector(px, py);
    velocity = new PVector(vx, vy);
  }

  void display() {
    position.add(velocity);

    if (position.x > width/2 - 50) {
      velocity.x *= -1;
    } else if (position.x < -width/2 + 50) {
      velocity.x *= -1;
    } else if (position.y > height/2 - 50) {
      velocity.y *= -1;
    } else if (position.y < -height/2 + 50) {    
      velocity.y *= -1;
    }
  }

  void boom(Ball other) {

    PVector distanceVect = PVector.sub(other.position, position);

    float distanceVectMag = distanceVect.mag();

    float minDistance = 100;

    if (distanceVectMag < minDistance ) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      float theta = distanceVect.heading();
      float sine = sin(theta);
      float cosine = cos(theta);

      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      vFinal[0].x = ((m - m) * vTemp[0].x + 2 * m * vTemp[1].x) / (m + m);
      vFinal[0].y = vTemp[0].y;

      vFinal[1].x = ((m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + m);
      vFinal[1].y = vTemp[1].y;

      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;

      tt += 1 ;
      ttt += 2;
    } else {
      tt = ttt ;
    }
  }
}
