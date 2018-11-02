class NeuralNetwork {

  Perceptron[][] lrs;
  int lastLr;

  NeuralNetwork(int[] layers) {
    createNN(layers);
  }

  float[] getResult(float[] inp) {
    clearHS();
    for (int i = 0; i < lrs[0].length; i++) {
      lrs[0][i].val = inp[i];
    }
    feedForward();

    float[] res = new float[lrs[lastLr].length];
    for (int i = 0; i < res.length; i++) {
      res[i] = lrs[lastLr][i].val;
    }
    return res;
  }

  private void feedForward() {
    for (int i = 1; i < lrs.length/*lastLr | lrs.length*/; i++) {
      for (int i1 = 0; i1 < lrs[i].length; i1++) {
        lrs[i][i1].resultFun(lrs[i - 1]);
      }
    }
    //if (lrs.length > 1)==========
    //for (int i1 = 0; i1 < lrs[lastLr].length; i1++) {
    //  lrs[lastLr][i1].result(lrs[lastLr - 1]);
    //}
  }

  private void createNN(int[] _lrs) {
    lrs = new Perceptron[_lrs.length][0];
    lrs[0] = new Perceptron[_lrs[0]];
    for (int i1 = 0; i1 < _lrs[0]; i1++) {
      lrs[0][i1] = new Perceptron(0);
    }
    for (int i = 1; i < _lrs.length; i++) {
      lrs[i] = new Perceptron[_lrs[i]];
      for (int i1 = 0; i1 < _lrs[i]; i1++) {
        lrs[i][i1] = new Perceptron(_lrs[i - 1]);
      }
    }
    lastLr = lrs.length - 1;
  }

  private void clearHS() {
    for (int i = 0; i < lrs.length; i++) {
      for (int i1 = 0; i1 < lrs[i].length; i1++) {
        lrs[i][i1].val = 0.0;
        lrs[i][i1].eval = 0.0;
      }
    }
  }

  // =================================================================

  void train(float[] inp, float[] targ, float rate) {
    float[] res = getResult(inp);

    for (int i = 0; i < lrs[lastLr].length; i++) {
      lrs[lastLr][i].eval = targ[i] - res[i];
    }
    for (int i = lastLr - 1; i > 0; i--) {
      for (int i1 = 0; i1 < lrs[i].length; i1++) {
        for (int k = 0; k < lrs[i + 1].length; k++) {
          lrs[i][i1].eval += lrs[i + 1][k].eval * lrs[i + 1][k].ws[i1] * lrs[i][i1].derivativeA(lrs[i][i1].val);
        }
      }
    }

    for (int i = 1; i < lrs.length; i++) {
      for (int i1 = 0; i1 < lrs[i].length; i1++) {
        for (int k = 0; k < lrs[i][i1].ws.length; k++) {          
          lrs[i][i1].ws[k] += rate * lrs[i][i1].eval * lrs[i - 1][k].val;
        }
        lrs[i][i1].wb += rate * lrs[i][i1].eval * lrs[i][i1].bias;
      }
    }
  }

  float valSum(int i) {
    float sum = 0.0;
    for (int i1 = 0; i1 < lrs[i].length; i1++) {
      sum += lrs[i][i1].val;
      println(sum);
    }
    return sum;
  }
}
