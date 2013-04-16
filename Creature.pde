class Creature extends Object
{
  float fade, generation;
  AudioSnippet sound;
  AudioSnippet sound2;
  ArrayList<String> notes;
  
  Creature()
  {
    super(random(0, width), random(0, height), 4, 1, random(0,360), #66FF00);
    fade = .2;
    generation = 1;
    String[] files = {"1.wav","2.wav","3.wav","4.wav","5.wav","6.wav","7.wav","8.wav","9.wav"};
    notes = new ArrayList<String>(Arrays.asList(files));
    sound = minim.loadSnippet(notes.get((int)random(7)));
    sound2 = minim.loadSnippet(notes.get(8));
  }
  
  //controls the propagation of the creatures
  //if the time is right (generation is a multiple of 15.5)
  //and if the time is right (frameCount is a multiple of 60)
  //give the go-ahead for a new creature
  Boolean sex()
  {
    if (generation % 15.5 == 0 )
    {
      //generation -= 400;
      if (frameCount % 60 == 0) 
      {
        return(true);
      }
      return(false);
    }
    else 
    {
      return(false);
    }
  }
  
  void update(ArrayList<Creature> t, Hunter p)
  {
    super.update();
    
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
    velocity.x = cos(radians(theta))*radius;
    velocity.y = sin(radians(theta))*radius;
    
    location.add(velocity);
    
    lifespan -= fade;
    
    if (lifespan <= 0.0 ) 
    {
      lifespan = 0.0;
    }
    
    Iterator<Creature> it = t.iterator();
    
    //limit the creatures perception of it's environment via the sensible distance
    //if creature is near hunters be scared, if the creature is near friends be happy
    while (it.hasNext()) 
    {
      Creature friend = it.next();
      float friendDist = dist(location.x, location.y, friend.location.x, friend.location.y);
      float huntDist = dist(location.x, location.y, p.location.x, p.location.y);
      
      //if comparing this creature against itself skip
      if (this != friend)
      {
        if (huntDist<25)
        {
          lifespan -= 200;
        }
        else if (huntDist<50) 
        {
          radius = -2;
          sound2.play();
          //if the hunter is near, play a dissodant chord
          if (frameCount % 60 == 0)
          {
            sound2.rewind();
          }
          //lifespan -= 50;
        }
        else if (huntDist<50 && friendDist<50) 
        {
          radius = -2;
          theta -= 2;
          //lifespan = 205.0;
          lifespan = 255.0;
          //generation += .5;
        }
        else if (friendDist<50)
        {
          stroke(255);
          theta -= 2;
          lifespan = 255.0;
          //if near friends and the time is right, increment the generation which is the baby-making threshold
          if (frameCount % 60 == 0)
          {
            generation += 1;
          }
          sound.unmute();
          /*give the sound a random interval for a bit of swing
          the idea is to make it sound like the creatures are talking to each other
          not every encounter with a creature should result in a conversation just like
          in real life
          */
          int interval = int(random(28,480));
          sound.play();
          if (frameCount % interval == 0)
          {
            sound.rewind();
          }
          //every once in a while shuffle the notes that the creature is associated with
          if (frameCount % interval == 0)
          {
            long seed = System.nanoTime();
            Collections.shuffle(notes, new Random(seed));
          }
        }
        if (friendDist>50)
        {
          stroke(255);
          theta += .1;
        }
        if (huntDist>75) 
        {
          radius = 1;
        }
      }
    }
  }
  
  void display(ArrayList<Creature> y, Hunter u)
  {
    update(y, u);
    super.display(theta);
  }
  
  void show()
  {
    fill(col, lifespan);
    noStroke();
    fill(col, lifespan);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
  }
    
    
}
