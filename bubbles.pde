class Bubble {

  float x;
  float y;
  float diameter;
  
  boolean active = false;
  
  float yspeed;

  Bubble(float tempD) {
    x = random(width);
    y = height;
    diameter = tempD;
    yspeed = random(0.2,6);
  }

  void ascend() {
    y -= yspeed;
    x = x + random(-2,2);
  }

  void display() {
    stroke(255,20);
    fill(255,20);
    ellipse(x, y, diameter, diameter);
  }

  void top() {
    if (y < -diameter/2) {
      y = height+diameter/2;
    }
  }
}