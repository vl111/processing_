class Perceptron {

  float[] ws;
  float rate;
  float bias = 600.0;
  float wb;

  Perceptron(float[] _ws, float _rate) {
    rate = _rate;
    ws = new float[_ws.length];
    for (int i = 0; i < _ws.length; i++) {
      ws[i] = _ws[i];
    }
    wb = random(-1, 1);
  }

  Perceptron(float _rate) {
    rate = _rate;
    ws = new float[2];
    for (int i = 0; i < ws.length; i++) {
      ws[i] = random(-1, 1);
    }
    wb = random(-1, 1);
  }

  void train(float[] inp, int targ) {
    int r = result(inp);
    int err = targ - r;
    for (int i = 0; i < ws.length; i++) {
      ws[i] += err * inp[i] * rate;
    }
    wb += err * bias * rate;
  }

  int result(float[] inp) {
    float sum = 0.0;
    for (int i = 0; i < ws.length; i++) {
      sum += inp[i] * ws[i];
    }
    sum += wb * bias;

    return funcA(sum);
  }

  private int funcA(float s) {
    if (s <= 0)
      return -1;
    else
      return 1;
  }
}
