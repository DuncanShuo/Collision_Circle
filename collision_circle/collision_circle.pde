import java.util.concurrent.*;
import java.util.LinkedList;

ConcurrentHashMap<String, LinkedList<Ball>> grid;
LinkedList<Ball> balls;
LinkedList<Ball> newBalls;
ExecutorService executor;
float radius=30;
float gridSize=2*radius;
int MAX_BALLS=20;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  grid=new ConcurrentHashMap<String, LinkedList<Ball>>();
  balls = new LinkedList<Ball>();
  newBalls = new LinkedList<Ball>();
  balls.add(new Ball(150, 150, random(-1, 1)*5, random(-1, 1)*5));
  balls.add(new Ball(450, 450, random(-1, 1)*5, random(-1, 1)*5));
  executor = Executors.newFixedThreadPool(4);
}

void draw() {
  background(360);
  grid.clear();
  //if(radius>5) radius=50-((int)(balls.size()/5)*5);

  for (Ball ball : balls) {
    String key=getGridkey(ball.position);
    if (!grid.containsKey(key)) {
      grid.put(key, new LinkedList<Ball>());
    }
    grid.get(key).add(ball);
  }

  ArrayList<Thread> threads = new ArrayList<Thread>();

  for (final Ball ball : balls) {
    Thread t = new Thread(new Runnable() {
      public void run() {
        ball.update();
        checkCollisions(ball);
      }
    }
    );
    threads.add(t);
    t.start();
  }

  for (Thread t : threads) {
    try {
      t.join();
    } 
    catch (InterruptedException e) {
      e.printStackTrace();
    }
  }
  
  for(Ball ball:balls){
    ball.checkBoundaryCollision();
    ball.display();
  }
  
  balls.addAll(newBalls);
  newBalls.clear();
  
  if (balls.size()>MAX_BALLS) {
    for(int i=0;i<balls.size();i++){
      balls.remove(i);
    }
  }
}

String getGridkey(PVector i) {
  int gx=(int)(i.x/gridSize);
  int gy=(int)(i.y/gridSize);
  return gx+","+gy;
}

void checkCollisions(Ball b) {
  int gx=(int)(b.position.x/gridSize);
  int gy=(int)(b.position.y/gridSize);

  for (int dx=-1; dx<=1; dx++) {
    for (int dy=-1; dy<=1; dy++) {
      String neighborkey=(gx+dx)+","+(gy+dy);
      if (grid.containsKey(neighborkey)) {
        for (Ball other : grid.get(neighborkey)) {
          if (b!=other&&dist(b.position.x, b.position.y, other.position.x, other.position.y)<(radius*2)) {
            checkCollision(b, other);
          }
        }
      }
    }
  }
}

void checkCollision(Ball b, Ball other) {
  PVector distanceVect = PVector.sub(other.position, b.position);
  float distanceVectMag = distanceVect.mag();
  float minDistance = radius*2;

  if (distanceVectMag < minDistance ) {
    float distanceCorrection = (minDistance-distanceVectMag)/2.0;
    PVector d = distanceVect.copy();
    PVector correctionVector = d.normalize().mult(distanceCorrection);
    other.position.add(correctionVector);
    b.position.sub(correctionVector);

    float theta  = distanceVect.heading();
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

    vTemp[0].x  = cosine * b.velocity.x + sine * b.velocity.y;
    vTemp[0].y  = cosine * b.velocity.y - sine * b.velocity.x;
    vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
    vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

    PVector[] vFinal = {  
      new PVector(), new PVector()
    };

    vFinal[0].x = vTemp[1].x;
    vFinal[0].y = vTemp[0].y;
    vFinal[1].x = vTemp[0].x;
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

    other.position.x = b.position.x + bFinal[1].x;
    other.position.y = b.position.y + bFinal[1].y;

    b.position.add(bFinal[0]);

    b.velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
    b.velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
    other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
    other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;

    float cposX = (b.position.x + other.position.x)/2;
    float cposY = (b.position.y + other.position.y)/2;

    PVector cVel=new PVector(b.position.y-other.position.y, -b.position.x+other.position.x);
    PVector cPos=cVel.copy();
    cVel.setMag(5);
    cPos.setMag(radius*2);

    PVector newBallPos = new PVector(cposX + cPos.x, cposY + cPos.y);
    
    if (isGridOccupied(newBallPos)) {
      newBalls.add(new Ball(newBallPos.x, newBallPos.y, cVel.x, cVel.y));
    }
  }
}

boolean isGridOccupied(PVector newBall) {
  int gx=floor(newBall.x/gridSize);
  int gy=floor(newBall.y/gridSize);

  if(newBall.x<radius||newBall.x>width-radius||newBall.y<radius||newBall.y>height-radius){
    return false;
  }

  for (int dx=-1; dx<=1; dx++) {
    for (int dy=-1; dy<=1; dy++) {
      String neighborkey=(gx+dx)+","+(gy+dy);
      if (grid.containsKey(neighborkey)) {
        for (Ball other : grid.get(neighborkey)) {
          if (dist(newBall.x, newBall.y, other.position.x, other.position.y)<(radius*2)) {
            return false;
          }
        }
      }
    }
  }
  return true;
}
