import java.awt.event.KeyEvent;

float[][] nums;
float[] rect1x, rect1y, rect1Width, rect1Height, 
  rect2x, rect2y, rect2Width, rect2Height;
int[] onOff1, onOff2;

float rate;
final float stRate = 0.0;
final float dif = 0.0001;

boolean pause = true;

int layers[];
NeuralNetwork nn;

color darkRed, lightRed;

void setup() {
  size(500, 400);

  darkRed = color(70, 0, 0);
  lightRed = color(200, 0, 0);

  rect1x = new float[]{57, 43, 157, 58, 43, 157, 57};
  rect1y = new float[]{50, 58, 57, 157, 165, 165, 257};
  rect1Width = new float[]{100, 15, 15, 100, 15, 15, 100};
  rect1Height = new float[]{15, 100, 100, 15, 100, 100, 15};
  onOff1 = new int[7];
  rect2x = new float[]{207, 193, 307, 208, 193, 307, 207};
  rect2y = new float[]{50, 58, 57, 157, 165, 165, 257};
  rect2Width = new float[]{100, 15, 15, 100, 15, 15, 100};
  rect2Height = new float[]{15, 100, 100, 15, 100, 100, 15};
  onOff2 = new int[7];

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

  rate = stRate;

  layers = new int[]{14, 50, 100};
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
  for (int i = 0; i < rect1x.length; i++) {
    if (onOff1[i] == 0)
      fill(darkRed);
    else
      fill(lightRed);

    rect(rect1x[i], rect1y[i], rect1Width[i], rect1Height[i]);
  }
  for (int i = 0; i < rect2x.length; i++) {
    if (onOff2[i] == 0)
      fill(darkRed);
    else
      fill(lightRed);

    rect(rect2x[i], rect2y[i], rect2Width[i], rect2Height[i]);
  }

  if (!pause)
    for (int i = 0; i < 10; i++) {
      int r1 = (int)random(0, 10);
      int r2 = (int)random(0, 10);
      float[] out = new float[100];
      int r = Integer.parseInt(Integer.toString(r1) + Integer.toString(r2));
      out[r] = 1.0;
      float[] inp = concat(nums[r1], nums[r2]);
      nn.train(inp, out, rate);
    } else {
    fill(200, 0, 0);
    text("paused", 0, 41);
  }

  fill(0, 200, 0);
  for (int i = 0; i < nums.length; i++) {
    for (int i1 = 0; i1 < nums.length; i1++) {
      //println(getMaxI(nn.getResult(concat(nums[i], nums[i1]))));
      if (getMaxI(nn.getResult(concat(nums[i], nums[i1]))) != 
      Integer.parseInt(Integer.toString(i) + Integer.toString(i1))) {
        fill(lightRed);
        break;
      }
    }
  }
  rect(400, 20, 70, 20);

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

    for (int i = 0; i < rect1x.length; i++) {
      if (rect1x[i] - mod < x && rect1x[i] + rect1Width[i] + mod > x 
        && rect1y[i] - mod < y && rect1y[i] + rect1Height[i] + mod > y) {
        onOff1[i] = abs(onOff1[i] - 1);
        return;
      }
    }
    for (int i = 0; i < rect2x.length; i++) {
      if (rect2x[i] - mod < x && rect2x[i] + rect2Width[i] + mod > x 
        && rect2y[i] - mod < y && rect2y[i] + rect2Height[i] + mod > y) {
        onOff2[i] = abs(onOff2[i] - 1);
        return;
      }
    }
  }
  if (mouseButton == RIGHT) {
    float[] inp = new float[onOff1.length + onOff2.length];
    for (int i = 0; i < onOff1.length; i++) {
      inp[i] = (float)onOff1[i];
    }
    for (int i = onOff1.length; i < inp.length; i++) {
      inp[i] = (float)onOff2[i - onOff1.length];
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

float[] makeCopy(float[] arr) {
  float[] res = new float[arr.length];
  for (int i = 0; i < arr.length; i++) {
    res[i] = arr[i];
  }
  return res;
}

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
