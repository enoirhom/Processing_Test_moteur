class Wheel {
  float x;
  int state;      // = 0 rest, = 1 forward, = 2 backward
  
  
  Wheel(float x) {
    this.x = x;
    state = 0;
  }
  
  void goStop() {
    state = 0;
  }
  
  void goForward() {
    state = 1;
  }
  
  void goBackward() {
    state = 2;
  }
  
  void display() {
    rectMode(CENTER);
    
    switch(state) {
      case 0:
        fill(0.0, 0.0, 0.0);
        break;
      case 1:
        fill(50.0, 200.0, 50.0);
        break;
      case 2:
        fill(200.0, 50.0, 50.0);
        break;
    }
    
    rect(x, height/3, 100.0, 150.0);
    rect(x, 2*height/3, 100.0, 150.0);
  }
}
