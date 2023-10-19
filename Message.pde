import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress address;
NetAddress other = new NetAddress("127.0.0.1", 5000);
NetAddress other2 = new NetAddress("127.0.0.1", 7000);

String[] shapes = {"Circle", "Square"};
Projectile p;
boolean on = false;
String leftOrRight = "left";
Target blocker;
Target blocker2;
int points = 0;
int lives = 10;

void setup() {
  oscP5 = new OscP5(this, 12000);
  address = new NetAddress("127.0.0.1", 12000);
  size(800,800);
  background(0);
  int index = (int) random(0, shapes.length);
  p = new Projectile(shapes[index], leftOrRight);
  blocker = new Target(new PVector(100,100));
  blocker2 = new Target(new PVector(200, 300));
}

void draw() {
  background(0);
  if (blocker != null) {
    blocker.setupPerson();
    blocker.move();
  }
  if (blocker2 != null) {
    blocker2.setupPerson();
    blocker2.move();
  }
  if (on && p != null && blocker != null && blocker2 != null) {
    goShape();
  }
  
  gameStatus();
  displayStats();
}

void addPoints() {
  points += 3;
}

void subtractLives() {
  lives -= 1;
}

void displayStats() {
  textSize(50);
  fill(138,213,159);
  text("Points: " + Integer.toString(points), 30, height - 20);
  text("Lives: " + Integer.toString(lives), 380, height - 20);
}

void gameStatus() {
  if (lives < 0) {
    blocker = null;
    blocker2 = null;
    p = null;
    textSize(100);
    fill(250, 0, 0);
    text("You Lose", 200, 350);
  }
  if (points > 45) {
    blocker = null;
    blocker2 = null;
    p = null;
    textSize(100);
    fill(0, 250, 0);
    text("You Win", 200, 350);
  }
}

Projectile resetProjectile() {
  int index = (int) random(0, shapes.length);
  return new Projectile(shapes[index], leftOrRight);
}

void goShape() {
  p.showShape(p.shape);
  p.shootShape();
  if (p.location.y < 0) {
    subtractLives();
    p = resetProjectile();
    on = false;
  }
  if (checkCollision()) {
    p = resetProjectile();
    on = false;
  }
}

boolean checkCollision() {
  //if x is in between the location.x - 40 and the location.x - 40 + 80
  //if it's a circle, if y - rad <= location.y - 15 + 115
  //if it's a square, if y <= location.y - 15 + 115
  
  if (p.location.x >= blocker.location.x - 40 && p.location.x <= blocker.location.x + 40) {
    if (p.shape.equals("Circle")) {
      if (p.location.y - p.rad <= blocker.location.y + 100) {
        //collision
        addPoints();
        OscMessage play = new OscMessage("/send");
        oscP5.send(play, other2);
        return true;
      }
    } else if (p.shape.equals("Square")) {
      if (p.location.y <= blocker.location.y + 100) {
        //collision
        addPoints();
        OscMessage play = new OscMessage("/send");
        oscP5.send(play, other2);
        return true;
      }
    }
  }
  
  if (p.location.x >= blocker2.location.x - 40 && p.location.x <= blocker2.location.x + 40) {
    if (p.shape.equals("Circle")) {
      if (p.location.y - p.rad <= blocker2.location.y + 100) {
        //collision
        addPoints();
        OscMessage play = new OscMessage("/send");
        oscP5.send(play, other2);
        return true;
      }
    } else if (p.shape.equals("Square")) {
      if (p.location.y <= blocker2.location.y + 100) {
        //collision
        addPoints();
        OscMessage play = new OscMessage("/send");
        oscP5.send(play, other2);
        return true;
      }
    }
  }
  return false;
  
}

void oscEvent(OscMessage theOscMessage) {
  
  if (!on) {
   //turn the sound on in Pd
    OscMessage onOff = new OscMessage("/bang");
    oscP5.send(onOff, other); 
    //the sound will turn off now
    //these numbers are from the 2 different mics
    String num1 = theOscMessage.get(0).stringValue().substring(0,theOscMessage.get(0).stringValue().length() - 1);
    Float num1f = Float.valueOf(num1);
    String num2 = theOscMessage.get(1).stringValue().substring(0,theOscMessage.get(1).stringValue().length() -1);
    Float num2f = Float.valueOf(num2);
    //print(num1f, num2f);
    if (num1f > num2f) {
      //shoot from the left
      leftOrRight = "left";
    } else if (num2f > num1f) {
      //shoot from the right
      leftOrRight = "right";
    }
    //print(leftOrRight);
    int index = (int) random(0, shapes.length);
    p = new Projectile(shapes[index], leftOrRight);
    on = true;
  }
    //else don't shoot
}
