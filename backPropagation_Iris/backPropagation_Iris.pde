import java.awt.event.KeyEvent;

float[][] inp, outp;

float rate;
final float stRate = 0.00005;
final float step = 0.000005;
String[] flowers;
float[] minValues, maxValues;

int layers[];
NeuralNetwork nn;

int batchSize;
int numOfBatches;
int numIter;

boolean pause;

void setup() {
  pause = true;
  size(600, 600);

  rate = stRate;

  layers = new int[]{4, 60, 3};
  nn = new NeuralNetwork(layers);

  numIter = 100;
  flowers = new String[]{"Iris-setosa", "Iris-versicolor", "Iris-virginica"};
  minValues = new float[]{4.3, 2.0, 1.0, 0.1};
  maxValues = new float[]{7.9, 4.4, 6.9, 2.5};
  parseFile();

  fill(0);
  frameRate(30);
}

void draw() {
  background(255);

  fill(200, 0, 0);
  textSize(20);
  text(Float.toString(rate), 0, 20);

  if (!pause) {
    shuffleData(0);
    numOfBatches = 1;
    divideOnBatches();
    for (int n = 0; n < numOfBatches; n++) {
      float [][] inp1 = new float[batchSize][inp[0].length];
      float [][] outp1 = new float[batchSize][outp[0].length];
      for (int i = 0; i < inp1.length; i++) {
        inp1[i] = inp[i + n * batchSize];
        outp1[i] = outp[i + n * batchSize];
      }
      for (int i = 0; i < numIter; i++) {
        for (int i1 = 0; i1 < inp1.length; i1++) {
          nn.train(inp1[i1], outp1[i1], rate);
        }
      }
    }
  } else {
    fill(200, 0, 0);
    text("paused", 0, 41);
  }
}

void divideOnBatches() {
  batchSize = (inp.length - (inp.length % numOfBatches))/numOfBatches;
  //println(batchSize);
}

void shuffleData(int shuffles) {
  for (int sh = 0; sh < shuffles; sh++) {
    int r1 = int(random(inp.length));
    int r2 = int(random(inp.length));
    float[] c = inp[r1];
    inp[r1] = inp[r2];
    inp[r2] = c;
    c = outp[r1];
    outp[r1] = outp[r2];
    outp[r2] = c;
  }
}


void parseFile() {
  ArrayList <String[]> arr = new ArrayList<String[]>();
  BufferedReader reader = createReader("irisData.txt");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pice = split(line, ",");
      arr.add(pice);
    }
    reader.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  ////============================
  //for (int i = 0; i < arr.size(); i++) {
  //  println();
  //  for (int i1 = 0; i1 < arr.get(i).length; i1++) {
  //    print(arr.get(i)[i1] + " ");
  //  }
  //}
  //println(arr.size());

  inp = new float[arr.size()][arr.get(0).length - 1];
  outp = new float[arr.size()][flowers.length];

  for (int i = 0; i < inp.length; i++) {
    println();
    for (int i1 = 0; i1 < inp[i].length; i1++) {
      float val = (Float.parseFloat(arr.get(i)[i1]) - minValues[i1]) 
      / (maxValues[i1] - minValues[i1]);
      inp[i][i1] = val;//Float.parseFloat(arr.get(i)[i1]);
    }
  }
  for (int i = 0; i < outp.length; i++) {
    for (int i1 = 0; i1 < outp[i].length; i1++) {
      if (arr.get(i)[arr.get(i).length - 1].contains(flowers[i1])) {
        outp[i][i1] = 1.0;
      } else {
        outp[i][i1] = 0.0;
      }
    }
  }

  ////==========================
  //for (int i = 0; i < outp.length; i++) {
  //  println();
  //  for (int i1 = 0; i1 < outp[i].length; i1++) {
  //    print(outp[i][i1] + " ");
  //  }
  //}
  //for (int i = 0; i < inp.length; i++) {
  //  println();
  //  for (int i1 = 0; i1 < inp[i].length; i1++) {
  //    print(inp[i][i1] + " ");
  //  }
  //}
} 

float getAvgErr() {
  float sum = 0.0;
  for (int i = 0; i < inp.length; i++) {
    float[] res = nn.getResult(inp[i]);
    //println();
    for (int i1 = 0; i1 < res.length; i1++) {
      sum += abs(outp[i][i1] - res[i1]);
      //print(abs(outp[i][i1] - res[i1]) + " ");
    }
  }
  return sum;
}

void mouseWheel(MouseEvent e) {
  if (e.getCount() < 0) {
    rate += step;
  } else
    rate = rate - step;

  if (rate < 0.0)
    rate = 0.0;
}

void keyPressed() {
  if (keyPressed) {
    if (keyCode == KeyEvent.VK_SPACE) {
      rate = stRate;
      nn = new NeuralNetwork(layers);
    }
    if (key == 'p') {
      pause = !pause;
    }
    if (key == 'c') {
      println(getAvgErr());
    }
  }
}
