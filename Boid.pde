class Boid extends Object
{
  float maxforce;    // maximum steering force
  float maxspeed;    // maximum speed

  Boid(float x, float y, float rr, color co) 
  {
    super(x, y, rr, co);
    maxspeed = 3;
    maxforce = 0.05;
  }

  void run(ArrayList<Boid> boids, ArrayList<Creature> creats) 
  {
    flock(boids, creats);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) 
  {
    // we could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // we accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, ArrayList<Creature> c) 
  {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    PVector avo = avoid(c);
    // arbitrarily weight these forces
    sep.mult(1.4);
    ali.mult(1.2);
    coh.mult(1.1);
    avo.mult(3.5);
    // add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(avo);
  }

  // method to update location
  void update() 
  {
    // update velocity
    velocity.add(acceleration);
    // limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) 
  {
    PVector desired = PVector.sub(target,location);  // vector pointing from the location to the target
    // normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // steering = Desired - Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // limit to maximum steering force
    return steer;
  }
  
  void render() 
  {
    // draw a triangle rotated in the direction of velocity
    float ang = random(0, 360);
    float theta = velocity.heading2D() + radians(90);
    fill(col);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(ang);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // wraparound
  void borders() 
  {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  PVector avoid (ArrayList<Creature> cs) 
  {
    float desiredseparation = 50;
    PVector move = new PVector(0,0,0);
    int count = 0;
    // for every boid in the system, check if it's too close
    for (Creature other : cs) 
    {
      float d = PVector.dist(location,other.location);
      // if the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) 
      {
        // calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location,other.location);
        diff.normalize();
        diff.div(d);        // weight by distance
        move.add(diff);
        count++;            // keep track of how many
      }
    }
    // average -- divide by how many
    if (count > 0) 
    {
      move.div((float)count);
    }

    // as long as the vector is greater than 0
    if (move.mag() > 0) 
    {
      // implement Reynolds: Steering = Desired - Velocity
      move.normalize();
      move.mult(maxspeed);
      move.sub(velocity);
      move.limit(maxforce);
    }
    return move;
  }
  
  // separation
  // method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) 
  {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // for every boid in the system, check if it's too close
    for (Boid other : boids) 
    {
      float d = PVector.dist(location,other.location);
      // if the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) 
      {
        // calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location,other.location);
        diff.normalize();
        diff.div(d);        // weight by distance
        steer.add(diff);
        count++;            // keep track of how many
      }
    }
    // average -- divide by how many
    if (count > 0) 
    {
      steer.div((float)count);
    }

    // as long as the vector is greater than 0
    if (steer.mag() > 0) 
    {
      // implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // alignment
  // for every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) 
  {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Boid other : boids) 
    {
      float d = PVector.dist(location,other.location);
      if ((d > 0) && (d < neighbordist)) 
      {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxforce);
      return steer;
    } else 
    {
      return new PVector(0,0);
    }
  }

  // cohesion
  // for the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) 
  {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);   // start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) 
    {
      float d = PVector.dist(location,other.location);
      if ((d > 0) && (d < neighbordist)) 
      {
        sum.add(other.location); // add location
        count++;
      }
    }
    if (count > 0) 
    {
      sum.div(count);
      return seek(sum);  // steer towards the location
    } else 
    {
      return new PVector(0,0);
    }
  }
}
