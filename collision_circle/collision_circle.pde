ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<PVector> circle = new ArrayList<PVector>();
ArrayList<PVector> square = new ArrayList<PVector>();
ArrayList<PVector> morph = new ArrayList<PVector>();

boolean state1 = true;;
int n;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  frameRate(60);
  balls.add(new Ball(-150, 0));
  balls.add(new Ball(150, 0));


  Ball ball = balls.get(0);
  ball.begin();
}

void draw() {
  translate(width/2, height/2);
  background(360);

  for (int i = balls.size() - 1; i>=0; i--) {
    Ball ball = balls.get(i);
    ball.update();
    ball.display();
    ball.checkBoundaryCollision();
  }

  n = balls.size();
  for (int i = 0; i<n-1; i++) {
    for (int j = i+1; j<n; j++) {
      balls.get(i).checkCollision(balls.get(j));
    }
  }
}
