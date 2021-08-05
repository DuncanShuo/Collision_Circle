ArrayList<PVector> circle3 = new ArrayList<PVector>();
ArrayList<PVector> square3 = new ArrayList<PVector>();
ArrayList<PVector> morph3 = new ArrayList<PVector>();

boolean state3 = true;
float colorr3 = random(360);
PVector s3;
PVector aa3 = new PVector(0, 0);

void begin3() {
  s3 = PVector.random2D();
  s3.mult(1.5);
}

void wall3() {

  if (tt == 1 ) {
    for (int angle = 0; angle < 360; angle += 9) {
      PVector c = PVector.fromAngle(radians(angle-135));
      c.setMag(50);
      circle3.add(c);
      morph3.add(new PVector());
    }

    for (int x = -50; x < 50; x += 10) {
      square3.add(new PVector(x, -50));
    }
    for (int y = -50; y < 50; y += 10) {
      square3.add(new PVector(50, y));
    }
    for (int x = 50; x > -50; x -= 10) {
      square3.add(new PVector(x, 50));
    }
    for (int y = 50; y > -50; y -= 10) {
      square3.add(new PVector(-50, y));
    }
  }

  if (circle3.size() > 0) aa3.add(s3);

  if (aa3.x > width/2 - 50) {
    s3.x *= -1;
    state3 = !state3;
    colorr3 -= random(30, 60);
    if (colorr3 < 0) colorr3 += 360;
  } else if (aa3.x < -width/2 + 50) {
    s3.x *= -1;
    state3 = !state3;
    colorr3 -= random(30, 60);
    if (colorr3 < 0) colorr3 += 360;
  } else if (aa3.y > height/2 - 50) {
    s3.y *= -1;
    state3 = !state3;
    colorr3 -= random(30, 60);
    if (colorr3 < 0) colorr3 += 360;
  } else if (aa3.y < -height/2 + 50) {
    s3.y *= -1;
    state3 = !state3;
    colorr3 -= random(30, 60);
    if (colorr3 < 0) colorr3 += 360;
  }

  for (int i = 0; i < square3.size(); i++) {
    square3.get(i).add(s3);
  }

  for (int i = 0; i < circle3.size(); i++) {
    circle3.get(i).add(s3);
  }
}

void display3() {

  for (int i = 0; i < circle3.size(); i++) {
    PVector v1;
    if (state3) {
      v1 = circle3.get(i);
    } else {
      v1 = square3.get(i);
    }
    PVector v2 = morph3.get(i);
    v2.lerp(v1, 0.3);
  }

  beginShape();
  fill(colorr3, 200, 200);
  noStroke();
  //noFill();
  //stroke(150);
  for (PVector v : morph3) {
    vertex(v.x, v.y);
    //point(v.x, v.y);
  }  
  endShape(CLOSE);
}
