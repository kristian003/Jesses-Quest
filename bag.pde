class bag {

  float x;
  float y;
  float diameter;
  
  PImage img;
  boolean active = false;
  
  float yspeed;

  bag(PImage tempImg, float tempD) {
    x = random(width);
    y = height;
    diameter = tempD;
    yspeed = random(.2,8);
    img = tempImg;
  }

  void ascend() {
    y -= yspeed;
    //x = x + random(-2,2);
  }

  void display() {
    imageMode(CENTER);
    image(img,x,y,275,275);
  }

  void top() {
    if (y < -diameter/2) {
      y = height+diameter/2;
    }
  }
}