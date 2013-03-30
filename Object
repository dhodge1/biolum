class Object
{
  PVector location, velocity, acceleration, size;
  float radius, theta, r, lifespan;
  color col;
  
  //main constructor
  Object(float x, float y, float w, float h, boolean isDynamic, boolean isBoid)
  {
    size = new PVector(w, h);
    if (isDynamic && isBoid)
    {
      location = new PVector(x,y);
      velocity = new PVector(random(-1,1),random(-1,1));
      acceleration = new PVector(0,0);
    }
    else if (isDynamic && !(isBoid))
    {
      location = new PVector(x, y);
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
    }   
    else
    {
      location = new PVector(x, y);
    }
    lifespan = 255.00;
  }
  
  //pulse constructor
  Object(float x, float y, float w, float h, float rad, float thet) 
  {
    this(x, y, w, h, true, false);
    radius = rad;
    theta = thet;
  }
  
  //animal constructor
  Object(float x, float y, float rB, float rad, float thet, color c)
  {
    this(x, y, 2*rB, 4*rB, true, false);
    r = rB;
    radius = rad;
    theta = thet;
    col = c;
  }
  
  //flock constructor
  Object(float x, float y, float ra, color c)
  {
    this(x, y, 2*ra, 4*ra, true, true);
    r = ra;
    col = c;
  }
  
  //handle the display
  //provide an option to specify the angle to rotate about for creatures/boids
  //and a traditional one for normal linear translation
  void display(float ang) 
  {
    float rotation = ang;
 
    rectMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(rotation);
    show();    
    popMatrix();
  }
  
  void display() 
  {
    float rotation = velocity.heading2D() + PI/2;
 
    rectMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(rotation);
    show();    
    popMatrix();
  }
  
  void show() 
  {
      rect(0,0,size.x,size.y);
  }
  
  //wrap-around
  void checkEdges() 
  {
    if (location.x > width)
    {
      location.x = 0;
    }

    if (location.x < 0)
    {
      location.x = width;
    }

    if (location.y > height)
    {
      location.y = 0;
    }

    if (location.y < 0)
    {
      location.y = height;
    }
  }
  
  void update()
  {
    checkEdges();
  }
  
  //check for object death
  boolean isDead() 
  {
    if (lifespan <= 0) 
    {
      return true;
    }
    return false;
  }
  
}
    
  
    
