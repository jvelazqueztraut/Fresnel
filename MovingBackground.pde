class MovingBackground {
  float offset = 0;
  final int totalGap = 8;
  final int interGap = 2;
  float speed = 10.0f; //Pixels per second
  
  boolean showBG = false;

  MovingBackground() {
  }

  void update(float dt) {
    offset += dt * speed;
    speed = map(mouseY, 0, height, 1, 50);
  }

  void draw() {
    if(!showBG) return;
    
    strokeWeight(1);
  
    stroke(204,0,0);
    for(int i = 0 ; i < height; i+=totalGap){
      int y = (i + int(offset)) % height;
      line(0, y, width, y);
    }
    
    stroke(0,204,0);
    for(int i = interGap ; i < height+interGap; i+=totalGap){
      int y = (i + int(offset)) % height;
      line(0, y, width, y);
    }
    
    stroke(0,0,204);
    for(int i = interGap * 2 ; i < height+interGap*2; i+=totalGap){
      int y = (i + int(offset)) % height;
      line(0, y, width, y);
    }
  }
  
  void keyPressed(char key){
    if(key == 'b') showBG = !showBG;
  }
}
