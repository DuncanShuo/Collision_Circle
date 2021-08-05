void boom1() {
  float m = 50*.1;
  
  PVector distanceVect = PVector.sub(aa2, aa1);

  float distanceVectMag = distanceVect.mag();

  float minDistance = 100;

  if (distanceVectMag < minDistance ) {
    float distanceCorrection = (minDistance-distanceVectMag)/2.0;
    PVector d = distanceVect.copy();
    PVector correctionVector = d.normalize().mult(distanceCorrection);
    aa2.add(correctionVector);
    aa1.sub(correctionVector);

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

    vTemp[0].x  = cosine * s1.x + sine * s1.y;
    vTemp[0].y  = cosine * s1.y - sine * s1.x;
    vTemp[1].x  = cosine * s2.x + sine * s2.y;
    vTemp[1].y  = cosine * s2.y - sine * s2.x;

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
    
    aa2.x = aa1.x + bFinal[1].x;
    aa2.y = aa1.y + bFinal[1].y;

    aa1.add(bFinal[0]);

    s1.x = cosine * vFinal[0].x - sine * vFinal[0].y;
    s1.y = cosine * vFinal[0].y + sine * vFinal[0].x;
    s2.x = cosine * vFinal[1].x - sine * vFinal[1].y;
    s2.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    
    tt += 1 ;
    ttt += 2;
  } else {
    tt = ttt ;
  }
}
