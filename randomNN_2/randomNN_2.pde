import java.awt.event.KeyEvent;

private float dotx[];
private float doty[];

boolean fl = false;

float bestFit;

NeuralNetwork nn;
float rate = 1.0;
float dif = 0.01;

final float step = 0.01;

void setup() {
  size(600, 600);
  //fullScreen();

  //nn = new NeuralNetwork(new int[]{1, 5, 2}, -100000.0, 1);
  //float[] res1 = nn.getResult(new float[]{2});
  //println(res1[0] + " " + res1[1]);
  //for (int i = 0; i < 10000; i++) {
  //  res1 = nn.getResult(new float[]{2});
  //  float sum = -Math.abs(3.0 - res1[0]) - Math.abs(4.0 - res1[1]);
  //  nn.train(sum);
  //}
  //nn.restoreNN();
  //res1 = nn.getResult(new float[]{2});
  //println(res1[0] + " " + res1[1]);
  //println();
  //exit();

  newNN();

  dotx = new float[0];
  doty = new float[0];

  frameRate(70);
}

void draw() {
  background(255);

  fill(200, 0, 0);
  textSize(20);
  text(Float.toString(rate), 0, 20);
  text(Integer.toString(nn.cycles), 0, 41);

  if (fl || (mousePressed && mouseButton == LEFT)) {
    fl = true;
    for (int c = 0; c < 10; c++) {
      float sum = 0.0;
      for (int i = 0; i < dotx.length; i++) {
        sum += -Math.abs(doty[i] - nn.getResult(new float[]{dotx[i]})[0]);
      }
      nn.train(sum);
    }
  }


  nn.restoreNN();
  if (nn.bestFit != bestFit) {
    println(nn.bestFit);
    bestFit = nn.bestFit;
  }

  stroke(180, 0, 180);
  strokeWeight(2);
  for (float i = -1.0; i < 1.0; i += step) {
    line(map(i, 0, 1, 0, width), 
      map( nn.getResult(new float[]{i})[0], 0, 1, height, 0), 
      map(i + step, 0, 1, 0, width), 
      map( nn.getResult(new float[]{i + step})[0], 0, 1, height, 0));
  }

  stroke(0);
  fill(0);
  strokeWeight(1);
  for (int i = 0; i < dotx.length; i++) {
    ellipse(map( dotx[i], 0, 1, 0, width), map( doty[i], 0, 1, height, 0), 6, 6);
  }
}

void newNN() {
  bestFit = -100000.0;
  nn = new NeuralNetwork(new int[]{1, 30, 20, 10, 1}, -100000.0, 3, 1.0);
}

void mouseClicked() {
  if (mouseButton == RIGHT) {    
    dotx = append(dotx, map(mouseX, 0, width, 0, 1));
    doty = append(doty, map(mouseY, height, 0, 0, 1));
    nn.bestFit = -100000.0;
    println("X:" + dotx[dotx.length - 1] + "  Y:" + doty[doty.length - 1]);
  }
}

void keyPressed() {
  if (keyPressed) {
    if (keyCode == KeyEvent.VK_SPACE) {
      newNN();
    } else if (key == 'c') {
      dotx = new float[0];
      doty = new float[0];
    } else if (key == '+') {
      nn.cycles++;
    } else if (key == '-') {
      nn.cycles--;
    }

    if (nn.cycles < 1)
      nn.cycles = 1;
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
