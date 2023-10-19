class Projectile {
  float rad;
  String shape;
  int side;
  PVector location;
  color c;
  String direction;
  
  Projectile(String shape, String direction) {
    this.rad = random(15, 45);
    this.shape = shape;
    this.side = (int) random(20, 40);
    this.direction = direction;
    if (direction.equals("left")) {
      this.location = new PVector(random(0, width/2), height - 50);
    } else if (direction.equals("right")){
      this.location = new PVector(random(width/2, width), height - 50);
    }
    this.c = color(random(256), random(256), random(256));
  }
  
  
  void showShape(String shape) {
    fill(c);
    if (shape.equals("Circle")) {
      circle(location.x, location.y, rad);
    } else if (shape.equals("Square")) {
      square(location.x, location.y, side);
    }
  }
  
  void shootShape() {
     location.y -= 10;
  }
  
}
