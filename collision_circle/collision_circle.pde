int tt = 0, ttt = 0;

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
  boom1();
  boom2();
  boom3();
}
