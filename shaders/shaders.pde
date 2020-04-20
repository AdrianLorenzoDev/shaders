PShader shader;
int noiseType = 0;

void setup() {
  size(1080, 720, P2D);
  noStroke();
  fill(204);
  shader = loadShader("shader.glsl");
}

void setShader() {
  shader(shader);
  shader.set("u_resolution", float(width), float(height));
  shader.set("u_mouse", float(mouseX), float(mouseY));
  shader.set("u_time", float(millis())/float(1000));
  shader.set("noiseType", noiseType); 
}

void setInstructions() {
  text("Click - Change noise", 30, 30);
  text("Move mouse - Change color tone", 30, 60); 
}

void draw() {
  setShader();
  
  background(0);
  fill(255);
  rect(0, 0, width, height);
  textSize(15);
  
  setInstructions();
}

void changeNoise() {
  noiseType = noiseType >= 2 ? 0 : noiseType + 1;
}

void mousePressed() {
  changeNoise();
}
