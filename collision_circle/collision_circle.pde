ArrayList<Ball> ballArrayList = new ArrayList<Ball>();
PVector p1, p2, v1, v2;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  frameRate(240);

  p1= new PVector(-150, 0);
  p2= new PVector(150, 0);
  v1 = PVector.random2D();
  v2 = PVector.random2D();

  ballArrayList.add(new Ball(p1, v1));
  ballArrayList.add(new Ball(p2, v2));
}

void draw() {
  translate(width/2, height/2);
  background(360);

  for (int i=0; i<ballArrayList.size(); i++) {
    ballArrayList.get(i).display();
    ballArrayList.get(i).wall();
    for (int j=0; j<ballArrayList.size(); j++) {
      if (j!=i) {
        ballArrayList.get(i).checkCollision(ballArrayList.get(j));
      }
    }
  }
}
