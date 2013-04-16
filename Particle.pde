class Particle 
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color col;

  Particle(PVector l) 
  {
    acceleration = new PVector(0,0.05);
    float theta = random(0,360);
    velocity = new PVector(cos(radians(theta))*random(4,5),sin(radians(theta))*random(4,5));
    location = l.get();
    lifespan = 255.0;
    col = #66FF00;
  }

  void run() 
  {
    update();
    display();
  }

  // method to update location
  void update() 
  {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;
  }

  // method to display
  void display() 
  {
    stroke(#981414,lifespan);
    fill(col, lifespan);
    ellipse(location.x,location.y, 4, 4);
  }
  
  // is the particle still useful?
  boolean isDead() 
  {
    if (lifespan < 0.0) 
    {
      return true;
    } else 
    {
      return false;
    }
  }
}
