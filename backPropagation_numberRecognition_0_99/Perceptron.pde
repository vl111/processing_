class Perceptron {

  float val;
  float eval;
  float[] ws;
  float bias = 1.0;
  float wb;

  Perceptron(int wsN) {
    ws = new float[wsN];
    for (int i = 0; i < ws.length; i++) {
      ws[i] = random(-1, 1);
    }
    wb = random(-1, 1);
  }

  void resultFun(Perceptron[] inp) {
    val = funcA(countSum(inp));
  }

  void result(Perceptron[] inp) {
    val = countSum(inp);
  }

  private float countSum(Perceptron[] inp) {
    float sum = 0.0;
    for (int i = 0; i < ws.length; i++) {
      sum += inp[i].val * ws[i];
    }
    sum += wb * bias;

    return sum;
  }

  private float funcA(float s) {
    if (s < 0)
      return 0;
    //else if (s > 1)
    //  return 1;
    else
      return s/* 0 | s */;

    // tanh
    //return (float)((2/(1 + Math.pow(Math.E, -2 * s))) - 1) ;
  }

  float derivativeA(float x) {
    if (x < 0)
      return 0;
    else
      return 1;

    // tanh
    //return (float) (1 - Math.pow(funcA(x), 2));
  }
}
