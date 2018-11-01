private float dotx[];
private float doty[];

private int step;

Perceptron p1;

void setup() {
  size(600, 600);
  //fullScreen();
  p1 = new Perceptron(0.000001);

  step = 30;

  dotx = new float[200];
  doty = new float[dotx.length];
  for (int i = 0; i <dotx.length; i++) {
    dotx[i] = random(-width, width);
    doty[i] = random(-height, height);
  }

  frameRate(20);
}

void draw() {
  background(255);

  stroke(0);
  strokeWeight(1);
  //noStroke();
  //noSmooth();
  for (int i = 0; i < dotx.length; i++) {
    if (mousePressed) {
      if (func(dotx[i]) > doty[i])
        p1.train(new float[]{dotx[i], doty[i]}, -1);
      else if (func(dotx[i]) < doty[i])
        p1.train(new float[]{dotx[i], doty[i]}, 1);
    }

    if ((func(dotx[i]) > doty[i] && p1.result(new float[]{dotx[i], doty[i]}) == -1)
      || (func(dotx[i]) < doty[i] && p1.result(new float[]{dotx[i], doty[i]}) == 1)) 
      fill(0, 160, 0);
    else 
    fill(160, 0, 0);


    ellipse(map(dotx[i], -width, width, 0, width), 
      map(doty[i], -height, height, height, 0), 10, 10);
  }
  strokeWeight(2);
  for (int i = -width; i < width; i += step) {
    float x1 = map(i, -width, width, 0, width);
    float x2 = map(i + step, -width, width, 0, width);
    float y1 = map(func(i), -height, height, height, 0);
    float y2 = map(func(i + step), -height, height, height, 0);
    //line(i, func(i), i + step, func(i + step));
    line(x1, y1, x2, y2);
  }

  float x1 = 0, x2 = 0, y1 = 0, y2 = 0;
  int prew = p1.result(new float[]{-width, -height});
  for (int i = -height; i < height; i += 2) {
    if (p1.result(new float[]{-width, i}) != prew) {
      x1 = map(-width, -width, width, 0, width);
      y1 = map(i, -height, height, height, 0);
      break;
    }
  }
  prew = p1.result(new float[]{width, -height});
  for (int i = -height; i < height; i += 2) {
    if (p1.result(new float[]{width, i}) != prew) {
      x2 = map(width, -width, width, 0, width);
      y2 = map(i, -height, height, height, 0);
      break;
    }
  }

  prew = p1.result(new float[]{-width, -height});
  for (int i = -width; i < width; i += 2) {
    if (p1.result(new float[]{i, -height}) != prew) {
      x1 = map(i, -width, width, 0, width);
      y1 = map(-height, -height, height, height, 0);
      break;
    }
  }
  prew = p1.result(new float[]{-width, height});
  for (int i = -width; i < width; i += 2) {
    if (p1.result(new float[]{i, height}) != prew) {
      x2 = map(i, -width, width, 0, width);
      y2 = map(height, -height, height, height, 0);
      break;
    }
  }
  stroke(200, 0, 200);
  line(x1, y1, x2, y2);
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    p1 = new Perceptron(0.000001);
  }
}

float func(float x) {
  //return x * x / 80 ;
  return x / 2 + 200;
}
