ArrayList<PVector> circle1 = new ArrayList<PVector>();
ArrayList<PVector> square1 = new ArrayList<PVector>();
ArrayList<PVector> morph1 = new ArrayList<PVector>();

boolean state1 = true;
float colorr1 = random(360);
PVector s1;
PVector aa1 = new PVector(-150, 0);

void begin1() {
  s1 = PVector.random2D();
  s1.mult(1.5);

  for (int angle = 0; angle < 360; angle += 9) {
    PVector c = PVector.fromAngle(radians(angle-135));
    c.setMag(50);
    c.add(-150, 0);
    circle1.add(c);
    morph1.add(new PVector(-150, 0));
  }

  for (int x = -200; x < -100; x += 10) {
    square1.add(new PVector(x, -50));
  }
  for (int y = -50; y < 50; y += 10) {
    square1.add(new PVector(-100, y));
  }
  for (int x = -100; x > -200; x -= 10) {
    square1.add(new PVector(x, 50));
  }
  for (int y = 50; y > -50; y -= 10) {
    square1.add(new PVector(-200, y));
  }
}

void wall1() {
  for (int i = 0; i < square1.size(); i++) {
    square1.get(i).add(s1);
  }

  for (int i = 0; i < circle1.size(); i++) {
    circle1.get(i).add(s1);
  }
  
  aa1.add(s1);

  if (aa1.x > width/2 - 50) {
    s1.x *= -1;
    state1 = !state1;
    colorr1 -= random(30, 60);
    if (colorr1 < 0) colorr1 += 360;
  } else if (aa1.x < -width/2 + 50) {
    s1.x *= -1;
    state1 = !state1;
    colorr1 -= random(30, 60);
    if (colorr1 < 0) colorr1 += 360;
  } else if (aa1.y > height/2 - 50) {
    s1.y *= -1;
    state1 = !state1;
    colorr1 -= random(30, 60);
    if (colorr1 < 0) colorr1 += 360;
  } else if (aa1.y < -height/2 + 50) {    
    s1.y *= -1;
    state1 = !state1;
    colorr1 -= random(30, 60);
    if (colorr1 < 0) colorr1 += 360;
  }
}

void display1() {

  for (int i = 0; i < circle1.size(); i++) {
    PVector v1;
    if (state1) {
      v1 = circle1.get(i);
    } else {
      v1 = square1.get(i);
    }
    PVector v2 = morph1.get(i);
    v2.lerp(v1, 0.3);
  }

  beginShape();
  fill(colorr1, 100, 100);
  noStroke();
  //noFill();
  //stroke(140);
  //for (PVector v : morph1) {
  //  vertex(v.x, v.y); 
  for (int j = 0; j < 40; j++) {
        vertex(morph1.get(j).x, morph1.get(j).y);
  }  
  endShape(CLOSE);
  println(morph1.size());
}
