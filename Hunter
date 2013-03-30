class Hunter extends Object
{
  Hunter()
  {
  super(random(0, width), random(0, height), 8, 1, random(0,360), #981414);
  }
    
  //experimental
  //testing this to assign pulses upon hunter creation rather than current method
  void makePulse() 
  {
    float pX = this.location.x;
    float pY = this.location.y;
    float pT = this.theta;
    //hunterPulse hP = new hunterPulse(pX, pY, pT, 1);
  }
  
  /*
    Working in polar coordinates to make translational velocity
    a function of the rate of change of angular position(equivalend to angular velocity). 
    Remember from the text that the cos(theta) = x/r and sin(theta) = y/r which equates to x = r*cos(theta)
    and y = r*sin(theta). Working in polar coordinates with unit vectors I assume an
    initial radius of 1 and I can think in terms of angle as the direction of the vector and the radius as the
    magnitude. Since I am assuming a unit vector this can be easily scaled as the position is updated. Now with the
    trig functions described above I can find the x and y components of the rate of change of angular position and apply
    them to the translational velocity. Yay!
  */
  
  void update(ArrayList<Creature> t)
  {
    super.update();
    
    velocity.x = cos(radians(theta))*radius;
    velocity.y = sin(radians(theta))*radius;

    location.add(velocity);
    
    Iterator<Creature> it = t.iterator();
    
    while (it.hasNext())  
    {
      Creature other = it.next();
      float huntDist = dist(location.x, location.y, other.location.x, other.location.y);
      
      if (huntDist < 100) 
      { 
        theta -= .2;
      }
      if (huntDist > 100) 
      {
        theta += .005;
      }
    }
  }
  
  void display(ArrayList<Creature> y)
  {
    update(y);
    super.display();
  }
  
  void show()
  {
    fill(col);
    noStroke();
    fill(col);
    beginShape(TRIANGLES);
    //vertex(r, r*5);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
  }
  
  
}
