class Target {
  PVector location;
  color c;
  float speed;
  boolean direction;
  
  Target(PVector location) {
    this.location = location;
    this.c = color(random(256), random(256), random(256));
    this.speed = random(2, 4);
    this.direction = false;
  }
  
  void setupPerson() {
    noStroke();
    fill(0);
    rect(location.x - 40, location.y - 15, 80, 115);
    fill(c);
    ellipse(location.x, location.y, 30, 30);
    rect(location.x - 12, location.y + 12, 25, 50);
    ellipse(location.x - 20, location.y + 15, 40, 10);
    ellipse(location.x + 20, location.y + 15, 40, 10);
    ellipse(location.x - 7, location.y + 70, 10, 60);
    ellipse(location.x + 8, location.y + 70, 10, 60);
  }
  
  void move() {
    if (outOfBounds()) {
      if (location.x > width) {
        location.x = width;
      } else {
        location.x = 0;
      }
      //location.x = random(20, width - 20);
      direction = !direction;
      speed = random(2, 7);
      c = color(random(256), random(256), random(256));
    } else {
      if (direction) {
         location.x -= speed;
      } else {
         location.x += speed;
      }
    }
  }
  
  boolean outOfBounds() {
    if (location.x > width || location.x < 0) {
      return true;
    }
    return false;
  }
}
