//Test Git2
import processing.serial.*;

Serial myPort;
int state; // 0 = menu, 1 = car control
int portChoice;
int distance;
String ports[];
boolean upKey = false, downKey = false, leftKey = false, rightKey = false;
Wheel w1, w2;


void setup() {
  size(600, 600);
  background(200);
  state = 0;
  distance = 0;
  ports = Serial.list();
  portChoice = 0;
  w1 = new Wheel(200.0);
  w2 = new Wheel(400.0);
}

void draw() {
  background(200);
  switch(state) {
    case 0:
      drawMenu();
      break;
    case 1:
      sendDirection();
      drawDistance();
      w1.display();
      w2.display();
      break;
  }
}

void keyPressed() {
  switch(state) {
    case 0:
      menuKeyPressed();
      break;
    case 1:
      carKeyPressed();
      break;
  }
}

void keyReleased() {
  switch(state) {
    case 0:
      break;
    case 1:
      carKeyReleased();
      break;
  }
}

void serialEvent(Serial p) {
  distance = int(p.readString());
}

void drawMenu() {
  float x = 20.0, y = 25.0;
  textSize(20);
  
  for(int i = 0; i < ports.length; i++) {
    if(i == portChoice) {
      fill(0);
    } else {
      fill(0, 102, 153);
    }
    
    text(i, x, y);
    text(ports[i], x + 15.0, y);
    
    y += 20.0;
  }
}

void menuKeyPressed() {
  if(key == CODED) {
    if(keyCode == UP) {
      if(portChoice > 0) {
        portChoice -= 1;
      } else {
        portChoice = ports.length - 1;
      }
    } else if(keyCode == DOWN) {
      if(portChoice < ports.length - 1) {
        portChoice += 1;
      } else {
        portChoice = 0;
      }
    }
  } else if(key == 10) {
    println("Connecting to port");
    myPort = new Serial(this, Serial.list()[portChoice], 9600);
    println("Connection on");
    myPort.bufferUntil(10);
    state = 1;
  }
}

void carKeyPressed() {
  if(key == CODED) {
    switch(keyCode) {
      case UP:
        upKey = true;
        break;
      case DOWN:
        downKey = true;
        break;
      case LEFT:
        leftKey = true;
        break;
      case RIGHT:
        rightKey = true;
        break;
    }
  } else {
    if(key == 27) {
      println("Stopping serial connection");
      myPort.stop();
    }
  }
}

void carKeyReleased() {
  if(key == CODED) {
    switch(keyCode) {
      case UP:
        upKey = false;
        println("UP");
        break;
      case DOWN:
        downKey = false;
        println("DOWN");
        break;
      case LEFT:
        leftKey = false;
        println("LEFT");
        break;
      case RIGHT:
        rightKey = false;
        println("RIGHT");
        break;
    }
  }
}

void sendDirection() {
  char direction = '0';
  boolean left, right;
  
  left = upKey || leftKey;
  right = upKey || rightKey;
  
  if(left && right) {
    direction = '0';
    w1.goForward();
    w2.goForward();
  } else if(left) {
    direction = '2';
    w1.goBackward();
    w2.goForward();
  } else if(right) {
    direction = '3';
    w2.goBackward();
    w1.goForward();
  } else if(downKey) {
    direction = '1';
    w1.goBackward();
    w2.goBackward();
  } else {
    direction = '4';
    w1.goStop();
    w2.goStop();
  }
  
  myPort.write(direction);
}

void drawDistance() {
  String text = "Distance = ";
  text += distance;
  float textWidth = textWidth(text);
  textSize(20);
  fill(0);
  text(text, width/2 - textWidth/2, 20);
}
