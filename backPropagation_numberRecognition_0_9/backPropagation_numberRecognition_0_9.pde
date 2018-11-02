import java.awt.event.KeyEvent;

float[][] nums;
float[] rectx, recty, rectWidth, rectHeight;
int[] onOff;

float step;

float rate;
final float stRate = 0.005;
final float dif = 0.0005;

boolean pause = true;

int layers[];
NeuralNetwork nn;

color darkRed, lightRed;

void setup() {
  size(400, 400);

  darkRed = color(70, 0, 0);
  lightRed = color(200, 0, 0);

  rectx = new float[]{57, 43, 157, 58, 43, 157, 57};
  recty = new float[]{50, 58, 57, 157, 165, 165, 257};
  rectWidth = new float[]{100, 15, 15, 100, 15, 15, 100};
  rectHeight = new float[]{15, 100, 100, 15, 100, 100, 15};
  onOff = new int[7];

  nums = new float[][]{{1, 1, 1, 0, 1, 1, 1}, 
    {0, 0, 1, 0, 0, 1, 0}, 
    {1, 0, 1, 1, 1, 0, 1}, 
    {1, 0, 1, 1, 0, 1, 1}, 
    {0, 1, 1, 1, 0, 1, 0}, 
    {1, 1, 0, 1, 0, 1, 1}, 
    {1, 1, 0, 1, 1, 1, 1}, 
    {1, 0, 1, 0, 0, 1, 0}, 
    {1, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 0, 1, 1}, };

  step = 0.01;
  rate = stRate;

  layers = new int[]{7, 50, 10};
  nn = new NeuralNetwork(layers);

  fill(0);
  frameRate(70);
}

void draw() {
  background(0);

  fill(200, 0, 0);
  textSize(20);
  text(Float.toString(rate), 0, 20);

  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < rectx.length; i++) {
    if (onOff[i] == 0)
      fill(darkRed);
    else
      fill(lightRed);

    rect(rectx[i], recty[i], rectWidth[i], rectHeight[i]);
  }

  if (!pause)
    for (int i = 0; i < 10; i++) {
      int r = (int)random(0, 10);
      float[] out = new float[10];
      out[r] = 1.0;
      nn.train(nums[r], out, rate);
    } else {
    fill(200, 0, 0);
    text("paused", 0, 41);
  }

  fill(0, 200, 0);
  for (int i = 0; i < nums.length; i++) {
    if (getMaxI(nn.getResult(nums[i])) != i) {
      fill(lightRed);
      break;
    }
  }
  rect(200, 20, 70, 20);

  //stroke(0);
  //fill(0);
  //strokeWeight(1);
}

int getMaxI(float[] arr) {
  int maxI = -1;
  float max = Float.NEGATIVE_INFINITY;

  for (int i = 0; i < arr.length; i++) {
    if (arr[i] > max) {
      maxI = i;
      max = arr[i];
    }
  }

  return maxI;
}

void click() {
  if (mouseButton == LEFT) {
    int x = mouseX;
    int y = mouseY;
    int mod = 10;

    for (int i = 0; i < rectx.length; i++) {
      if (rectx[i] - mod < x && rectx[i] + rectWidth[i] + mod > x 
        && recty[i] - mod < y && recty[i] + rectHeight[i] + mod > y) {
        onOff[i] = abs(onOff[i] - 1);
        return;
      }
    }
  }
  if (mouseButton == RIGHT) {
    float[] inp = new float[onOff.length];
    for (int i = 0; i < inp.length; i++) {
      inp[i] = (float)onOff[i];
    }
    clearConsole(10);
    println(getMaxI(nn.getResult(inp)));
  }
}

void clearConsole(int a) {
  for (int i = 0; i < a; i++) {
    println();
  }
};

void mousePressed() {
  click();
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
      pause = !pause;
    }
    if (key == 'c') {
    }
  }
}
