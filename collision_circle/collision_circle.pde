ArrayList<Ball> balls = new ArrayList<Ball>();
int tt = 0, ttt = 0;
int n;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  frameRate(120);
  begin1();
  begin2();
  begin3();
}

void draw() {
  translate(width/2, height/2);
  background(360);
  wall1();
  wall2();
  wall3();
  display1();
  display2();
  display3();
  
  for (int i = balls.size() - 1; i>=0; i--) {
    Ball ball = balls.get(i);
    ball.display();
  }
  
  n = balls.size();
  for (int i = 0; i < n-1; i++) {
    for (int j = i + 1; j < n; j++) {
      balls.get(i).boom(balls.get(j));
    }
  }
}
