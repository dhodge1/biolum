class Pulse extends Object
{
  int type;
  float dim, lifespan2, lifespan3, fade;
  color col;
  ArrayList<Pulse> lA;
  ArrayList<Creature> mA;
  Hunter zA;
  
  //0 for creature pulse
  //1 for hunter pulse
  //pulType is used to determine what type of pulse to create and update
  //these types differ in color, size and behavior
  //hunter pulses are larger, can be yellow or white and flash about once per second
  //creature pulses are smaller, can be blue or red and are triggered via proximity to an object
  Pulse(float x, float y, float w, float h, float pulRad, float pulTheta, int pulType)
  {
    super(x, y, w, h, pulRad, pulTheta);
    type = pulType;
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
  
  void update(ArrayList<Pulse> rA, ArrayList<Creature> tA, Hunter pA)
  {
    super.update();
    
    velocity.x = cos(radians(theta))*radius;
    velocity.y = sin(radians(theta))*radius;

    location.add(velocity);
    
    //map the array lists to member variables so that they can be used in other methods within the class
    lA = rA;
    mA = tA;
    zA = pA;
    
    //create a different creature or hunter pulse based upon type
    //0 is a creature pulse
    if (type == 0)
    {
      Iterator<Pulse> it = rA.iterator();
    
      //while there are other creature pulses
      while (it.hasNext())
      {
        Pulse friend = it.next();
        float friendDist = dist(location.x, location.y, friend.location.x, friend.location.y);
        float huntDist = dist(location.x, location.y, pA.location.x, pA.location.y);
      
        //since this is a creature pulse it should move and behave exactly the same and in/to the same locations
        //as its host creature
        //each creature pulse gets overlaid over its host, is given the same initial conditions (location, theta, etc.) 
        //and follows the same rule-set
        if (this != friend)
        {
          if (huntDist<50) 
          {
            radius = -2;
          }
          else if (huntDist<50 && friendDist<=50) 
          {
            radius = -2;
            theta -= 2;
          }
          else if (friendDist<=50)
          {
            theta -= 2;
          }
          if (huntDist>75) 
          {
            radius = 1;
          }
          if (friendDist>50)
          {
            theta += .1;
          }
        }
      }
    }
    
    //type 1 is a hunter pulse
    //this gets assigned the same initial conditions as the hunter
    else if (type == 1)
    {
      Iterator<Creature> it = tA.iterator();
    
      while (it.hasNext())  
      {
        Creature other = it.next();
        float huntDist = dist(location.x, location.y, other.location.x, other.location.y);
      
        if (huntDist<100) 
        { 
          theta -= .2;
        }
        if (huntDist>100) 
        {
          theta += .005;
        }
      }
    }
  }
  
  void display(ArrayList<Pulse> l, ArrayList<Creature> m, Hunter z)
  {
    update(l, m, z);
    show();
  }
  
  //once again type is checked to determine how the pulse should be displayed
  //lifespan should decrement at the same rate as the host creatures
  //separate lifespan for each ring in pulse of varying transparency
  void show()
  {
    if (type == 0)
    {
      lifespan -= fade;
      lifespan2 -= fade;
      lifespan3 -= fade;
      
      if (lifespan <= 0.0 ) 
      {
        lifespan = 0.0;
      }
    
      if (lifespan2 <= 0.0 ) 
      {
        lifespan2 = 0.0;
      }
    
      if (lifespan3 <= 0.0 ) 
      {
        lifespan3 = 0.0;
      }
      
      Iterator<Pulse> it = lA.iterator();
    
      //lifespan rule-set is identical to the creatures
      //if near a friend, full health pulse blue
      //if isolated, loose health at some rate until you die
      //if near an enemy, loose a big chunk of health and pulse red
      //if eaten, die
      while (it.hasNext())
      {
        Pulse friend = it.next();
        float friendDist = dist(location.x, location.y, friend.location.x, friend.location.y);
        float huntDist = dist(location.x, location.y, zA.location.x, zA.location.y);
      
        if (this != friend)
        {
          if (huntDist<25)
          {
            lifespan -= 200;
            lifespan2 -= 125;
            lifespan3 -= 50;
          }
          else if (huntDist<50) 
          {
            noFill();
            stroke( #981414, lifespan);
            strokeWeight(2);
            ellipse( location.x, location.y, dim, dim);
            stroke( #981414, lifespan2);
            ellipse( location.x, location.y, dim*2, dim*2);
            stroke( #981414, lifespan3);
            ellipse( location.x, location.y, dim*3, dim*3);
          }
          else if (huntDist<50 && friendDist<=50) 
          {
            noFill();
            stroke( #981414, lifespan);
            strokeWeight(2);
            ellipse( location.x, location.y, dim, dim);
            stroke( #981414, lifespan2);
            ellipse( location.x, location.y, dim*2, dim*2);
            stroke( #981414, lifespan3);
            ellipse( location.x, location.y, dim*3, dim*3);
            lifespan = 255.0;
            lifespan2 = 150.0;
            lifespan3 = 50.0;
          }
          else if (friendDist<=50)
          {
            noFill();
            stroke( col, lifespan);
            strokeWeight(2);
            ellipse( location.x, location.y, dim, dim);
            stroke( col, lifespan2);
            ellipse( location.x, location.y, dim*2, dim*2);
            stroke( col, lifespan3);
            ellipse( location.x, location.y, dim*3, dim*3);
            lifespan = 255.0;
            lifespan2 = 150.0;
            lifespan3 = 50.0;
          }
          if (friendDist>50)
          {
            stroke(255);
          }
        }
      }
    }
    //if it is a hunter pulse 
    //if alone, flash white once per second
    //if sensing prey, flash yellow once per second
    else if (type == 1)
    {
      if( frameCount % 60 == 0) 
      {
        noFill();
        stroke( col, 200);
        strokeWeight(2);
        ellipse( location.x, location.y, dim, dim);
        stroke( col, 100);
        //strokeWeight(1);
        ellipse( location.x, location.y, 2*dim, 2*dim);
      }
      
      Iterator<Creature> it = mA.iterator();
    
      while (it.hasNext())  
      {
        Creature other = it.next();
        float huntDist = dist(location.x, location.y, other.location.x, other.location.y);
      
        if (huntDist<100 && frameCount % 60 == 0) 
        {
          noFill();
          stroke( #FFFF00, 200);
          strokeWeight(2);
          ellipse( location.x, location.y, dim, dim);
          stroke( #FFFF00, 100);
          ellipse( location.x, location.y, 2*dim, 2*dim);
        }
      }
    }
  }
      
  
}
      
      
