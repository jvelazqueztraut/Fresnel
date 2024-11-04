class MovingShape {
  float x = 0.001f , y = 0.0f, z = 0.0f;
  
  //final float A = 5, B = 40, C = 8.0f/3.0f; // Dos forma concentricas simples
  float a, b;
  float aOff = 0.0f, bOff = 0.0f;
  float perlinStep = 0.0f;
  final int SEEDA = 0, SEEDB = 12345;
  final int MINA = 4, MAXA = 15, MINB = 20, MAXB = 50;
  final float C = 8.0f/3.0f;
  
  final int ARRAY_SIZE = 5000;
  final float STEP = 0.005f;
  PVector[] points = new PVector[ARRAY_SIZE];
  int arrayStart = 0, arrayEnd = 0;
  
  float autoScale = 1.0f;
  boolean negative = true;
  
  float rotation = 0.0f;
  float rotationSpeed = 1.0f;
  boolean first = true;
  
  MovingShape() {
  }

  void update(float dt) {
    float dtt = STEP;
    
    for(int i=0; i<1; i++){ // Drawing acceleration
      // Perlin noise to move around parameters A and B
      aOff = aOff + perlinStep;//PERLIN_STEP;
      noiseSeed(SEEDA);
      a = map(noise(aOff), 0, 1, MINA, MAXA);
  
      bOff = bOff + perlinStep;//PERLIN_STEP;
      noiseSeed(SEEDB);
      b = map(noise(bOff), 0, 1, MINB, MAXB);
    
      float dx = (a * (y - x)) * dtt;
      float dy = (x * (b - z) - y) * dtt;
      float dz = (x * y - C * z) * dtt;
      x = x + dx;
      y = y + dy;
      z = z + dz;
      
      if(!first && arrayStart == arrayEnd){
        arrayStart = (arrayStart+1) % ARRAY_SIZE;
      }
      
      points[arrayEnd] = new PVector(x,y,z);
      arrayEnd = (arrayEnd+1) % ARRAY_SIZE;
      first = false;
    }
    
    rotation += rotationSpeed * dt;
    rotationSpeed = map(mouseX, 0, width, -1, 1);
  }

  void draw() {
    pushStyle();
    noFill();
    strokeWeight(negative ? 2 : 4);
    stroke(negative ? 220 : 0);
    pushMatrix();
    translate(width/2, height/2);
    rotate(rotation);
    beginShape();
    float scale = width * height / 50000;
    int n = arrayEnd - arrayStart;
    if( n <= 0 ) n = ARRAY_SIZE;
    for (int i = 0; i < n ; i++) {
      //stroke(hu, 255, 255);
      int index = (arrayStart + i) % ARRAY_SIZE;
      PVector vec = points[index];
      vertex(vec.x*scale, vec.y*scale);//, vec.z);
      
      if(autoScale < 1 || vec.magSq()<width*height)
        points[index] = vec.mult(autoScale); // Automatic scaling
      //PVector offset = PVector.random3D();
      //offset.mult(0.1);
      //v.add(offset);
    }
    endShape();
    fill(200);
    noStroke();
    PVector start = points[arrayStart];
    ellipse(start.x*scale, start.y*scale,5,5);//,start.z);
    PVector end = points[(arrayEnd - 1 + ARRAY_SIZE) % ARRAY_SIZE];
    ellipse(end.x*scale, end.y*scale,5,5);//,end.z);
    popMatrix();
    popStyle();
    
    fill(0);
    rect(0,0,100,90);
    fill(255);
    text("s: " + autoScale, 10, 15);
    text("p: " + perlinStep, 10, 30);
    text("A: " + a, 10, 45);
    text("B: " + b, 10, 60);
    text("C: " + C, 10, 75);
    /*
    strokeWeight(5);
    stroke(0);
    
    float drawX = x * width;
    line(drawX, 0, drawX, height);
    
    float drawY = y * height;
    line(0, drawY, width, drawY);
    */
  }
  
  float getDist() {
    PVector start = points[arrayStart];
    PVector end = points[(arrayEnd - 1 + ARRAY_SIZE) % ARRAY_SIZE];
    return end.dist(start);
  }
  
  void reset(){
    x = 0.001f;
    y = 0.0f;
    z = 0.0f;
    arrayStart = 0;
    arrayEnd = 0;
    first = true;
  }
  
  void keyPressed(char key){
    if(key == 'r') reset();
    
    if(key == 'b') negative = !negative;
    
    if(key == 'p'){
      perlinStep += 0.001f;
    }
    if(key == 'P'){
      perlinStep -= 0.001f;
    }
    
    if(key == 's'){
      autoScale += 0.001f;
    }
    if(key == 'S'){
      autoScale -= 0.001f;
    }
  }
}
