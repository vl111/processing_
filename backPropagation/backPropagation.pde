import java.awt.event.KeyEvent;

float dotx[];
float doty[];

float step;

float rate;
final float stRate = 0.005;
final float dif = 0.0005;

boolean fl = false;

int layers[];
NeuralNetwork nn;

void setup() {
  size(600, 600);

  dotx = new float[0];
  doty = new float[0];

  step = 0.01;
  rate = stRate;

  layers = new int[]{1, 30, 40, 20, 1};
  nn = new NeuralNetwork(layers);

  fill(0);
  frameRate(70);
}

void draw() {
  background(255);

  fill(200, 0, 0);
  textSize(20);
  text(Float.toString(rate), 0, 20);

  if (fl || (mousePressed && mouseButton == LEFT)) {
    fl = true;
    for (int i = 0; i < dotx.length; i++) {
      //randomise(dotx, doty);
      nn.train(new float[]{dotx[i]}, new float[]{doty[i]}, rate);
    }
  }

  stroke(180, 0, 180);
  strokeWeight(2);
  for (float i = -1.0; i < 1.0; i += step) {
    line(map(i, 0, 1, 0, width),  
      map(nn.getResult(new float[]{i})[0], 0, 1, height, 0),  
      map(i + step, 0, 1, 0, width),  
      map(nn.getResult(new float[]{i + step})[0], 0, 1, height, 0)); 
  }

  stroke(0);
  fill(0);
  strokeWeight(1);
  for (int i = 0; i < dotx.length; i++) {
    ellipse(map(dotx[i], 0, 1, 0, width), map(doty[i], 0, 1, height, 0), 6, 6); 
  }
}

void randomise(float[] arr1, float[] arr2) {
  float val;
  int pos;
  for (int i = 0; i < arr1.length / 2; i++) {
    pos = int(random(arr1.length));
    val = arr1[pos];
    arr1[pos] = arr1[i];
    arr1[i] = val;

    val = arr2[pos];
    arr2[pos] = arr2[i];
    arr2[i] = val;
  }
}

void mouseClicked() {
  if (mouseButton == RIGHT) {    
    dotx = append(dotx, map(mouseX, 0, width, 0, 1)); 
    doty = append(doty, map(mouseY, height, 0, 0, 1)); 
    println("X:" + dotx[dotx.length - 1] + "  Y:" + doty[doty.length - 1]);
  }
}

void mouseWheel(MouseEvent e) {
  if (e.getCount() < 0) {
    rate += dif;
  } else
    rate = rate - dif;

  if (rate < 0.0)
    rate = 0.0;
}

void keyPressed() {
  if (keyPressed) {
    if (keyCode == KeyEvent.VK_SPACE) {
      rate = stRate;
      nn = new NeuralNetwork(layers);
    }
    if (key == 'c') {
      dotx = new float[0];
      doty = new float[0];
    }
  }
}
