ArrayList<PVector> circle2 = new ArrayList<PVector>();
ArrayList<PVector> square2 = new ArrayList<PVector>();
ArrayList<PVector> morph2 = new ArrayList<PVector>();

boolean state2 = true;
float colorr2 = random(360);
PVector s2;
PVector aa2 = new PVector(150, 0);

void begin2() {
  s2 = PVector.random2D();
  s2.mult(1.5);

  for (int angle = 0; angle < 360; angle += 9) {
    PVector c = PVector.fromAngle(radians(angle-135));
    c.setMag(50);
    c.add(150, 0);
    circle2.add(c);
    morph2.add(new PVector(150, 0));
  }

  for (int x = 100; x < 200; x += 10) {
    square2.add(new PVector(x, -50));
  }
  for (int y = -50; y < 50; y += 10) {
    square2.add(new PVector(200, y));
  }
  for (int x = 200; x > 100; x -= 10) {
    square2.add(new PVector(x, 50));
  }
  for (int y = 50; y > -50; y -= 10) {
    square2.add(new PVector(100, y));
  }
}

void wall2() {
  for (int i = 0; i < square2.size(); i++) {
    square2.get(i).add(s2);
  }

  for (int i = 0; i < circle2.size(); i++) {
    circle2.get(i).add(s2);
  }
  
  aa2.add(s2);

  if (aa2.x > width/2 - 50) {
    s2.x *= -1;
    state2 = !state2;
    colorr2 -= random(30, 60);
    if (colorr2 < 0) colorr2 += 360;
  } else if (aa2.x < -width/2 + 50) {
    s2.x *= -1;
    state2 = !state2;
    colorr2 -= random(30, 60);
    if (colorr2 < 0) colorr2 += 360;
  } else if (aa2.y > height/2 - 50) {
    s2.y *= -1;
    state2 = !state2;
    colorr2 -= random(30, 60);
    if (colorr2 < 0) colorr2 += 360;
  } else if (aa2.y < -height/2 + 50) {
    s2.y *= -1;
    state2 = !state2;
    colorr2 -= random(30, 60);
    if (colorr2 < 0) colorr2 += 360;
  }
}

void display2() {

  for (int i = 0; i < circle2.size(); i++) {
    PVector v1;
    if (state2) {
      v1 = circle2.get(i);
    } else {
      v1 = square2.get(i);
    }
    PVector v2 = morph2.get(i);
    v2.lerp(v1, 0.3);
  }

  beginShape();
  fill(colorr2, 100, 100);
  noStroke();
  //noFill();
  //stroke(140);
  for (PVector v : morph2) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);
}
