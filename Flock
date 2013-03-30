class Flock 
{
  ArrayList<Boid> boids; // an ArrayList for all the boids

  Flock() 
  {
    boids = new ArrayList<Boid>(); // initialize the ArrayList
  }

  void run(ArrayList<Creature> cs) 
  {
    for (Boid b : boids) 
    {
      b.run(boids, cs);  // passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) 
  {
    boids.add(b);
  }

}
