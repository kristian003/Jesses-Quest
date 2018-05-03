import processing.video.*;
import processing.sound.*;

SoundFile file;

Bubble[] bubbles = new Bubble[100];
PImage[] trash = new PImage[5];
//bag[] bags = new bag[6];

ArrayList<bag> bagsA = new ArrayList<bag>();

int score = 0;

Capture video;
PImage prev;
float threshold = 25;

float motionX = 0;
float motionY = 0;

float lerpX = 0;
float lerpY = 0;

int numFrames = 24;
int currentFrame = 0;
PImage[] jellyfishGiphy = new PImage[numFrames];

int prevMillis = 0;
int interval = 5000;
int jbThreshold = 150;

void setup() {
  size(1280, 720);
  
  

  for (int i = 0; i < trash.length; i ++) {
    trash[i] = loadImage("bag"+i+".png");
  }

  //for (int i = 0; i < bags.length; i++) {
  //  int index = int(random(0, trash.length));
  //  bags [i] = new bag(trash[index], 64);
  //}

  for (int i = 0; i < 1; i++) {
    int index = int(random(0, trash.length));
    bagsA.add(new bag(trash[index], 64)) ;
  }
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, width, height, 30);
  video.start();

  prev = createImage(video.width, video.height, RGB);

  for (int i = 0; i < numFrames; i++) {
    String imageName = "jellyfishGiphy" + nf(i, 3) + ".png";
    jellyfishGiphy[i] = loadImage(imageName);
  }

  for (int i = 0; i < bubbles.length; i++) {
    //different display options
    //bubbles[i] = new Bubble(i*4);
    bubbles[i] = new Bubble(random(64));
    //bubbles[i] = new Bubble(64);
  }
}

void captureEvent(Capture video) {
  prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
  prev.updatePixels();
  video.read();
}

void draw() {

  background(27, 45, 65);

  video.loadPixels();
  prev.loadPixels();

  threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  int count = 0;

  float avgX = 0;
  float avgY = 0;


  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);


      float d = distSq(r1, g1, b1, r2, g2, b2);


      if (d > threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);

        //Revert to original camera view.
        //avgX += x;

        //Flip Video
        avgX += video.width-x;

        avgY += y;
        count++;


        //  pixels[loc] = color (255);
        //}  else {
        //  pixels[loc] = color (0);
      }
    }
  }

  updatePixels();
  // We only consider the color found if its color distance is less than 10.
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 200) {
    motionX = avgX / count;
    motionY = avgY / count;
    // Draw a circle at the tracked pixel
  }
  lerpX = lerp(lerpX, motionX, 0.1);
  lerpY = lerp(lerpY, motionY, 0.1);
  fill(0, 0, 255, 90);
  //strokeWeight(2.0);
  //stroke(0);
  //ellipse(lerpX, lerpY, 150, 150);

  currentFrame = (currentFrame+1) % numFrames;

  //CHANGES GIPHY SIZE

  int offset = 0;
  for (int x = 0; x < width; x += jellyfishGiphy[0].width) {
    imageMode(CENTER);
    image(jellyfishGiphy[(currentFrame+offset) % numFrames], lerpX, lerpY, 400, 300);
    offset+=2;
  }

  for (int i = 0; i < bubbles.length; i++) {
    bubbles[i].ascend();
    bubbles[i].display();
    bubbles[i].top();
  }
  //for (int i = 0; i < bags.length; i++) {
  //  bags[i].ascend();
  //  bags[i].display();
  //  bags[i].top();
  //}
if(bagsA.size() > 0){
  for (int i = 0; i < bagsA.size(); i++) {
    bag curBag = bagsA.get(i);
    curBag.ascend();
    curBag.display();
    curBag.top();
    
    float jellyDist = dist(lerpX,lerpY, curBag.x, curBag.y);
    //println(jellyDist);
    if(jellyDist < jbThreshold){    
      bagsA.remove(i);
      score += 1;
      file = new SoundFile(this, "bubblePop.wav");
      file.play();
    }

  }
}
  
  if(millis() - prevMillis >= interval){
    int index = int(random(0, trash.length));
    bagsA.add(new bag(trash[index], 64));
    prevMillis = millis();
  }
  
  

  textSize(32);
  fill(255);
  text("Jesse's Quest: "+ score, 30, 60);
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}