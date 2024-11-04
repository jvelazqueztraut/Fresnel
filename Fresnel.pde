PShape svg;

MovingBackground mb;
MovingShape ms;

void setup(){
  size(1280, 720);
  smooth(2);
  //fullScreen();
  
  PFont font = loadFont("Dialog-48.vlw");
  textFont(font, 12);
  
  mb = new MovingBackground();
  ms = new MovingShape();
}


float time = 0;

void draw(){
  float t = millis() / 1000.0f;
  float dt = t - time;
  time = t;
  
  mb.update(dt);
  ms.update(dt);
  
  int close = (int)constrain(map(ms.getDist(), 0, 25, 255, 0),0,255);
  
  background(close);
  mb.draw();
  ms.draw();
}

void keyPressed(){
  mb.keyPressed(key);
  ms.keyPressed(key);
  
  if(key == 's'){
    save("frame.jpg");
  }
}
