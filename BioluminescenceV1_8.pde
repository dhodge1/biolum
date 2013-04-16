/*Bioluminescence attempts to simulate bioluminescent communication exhibited by certain fish and micro-organisms.
  The creatures move with translational velocity as a function of oscillating angular movement. In the proximity of other creatures
  they glow blue to indicate that the area is safe for others of their kind. Groups of creatures behave differently depending upon the
  number of creatures in the group and the anglular trajectory of new additions. If coalesced at nearly parallel angles, a group of two creatures 
  will rotate more slowly about their center points causing their visual representation to change and translate forward until contact with 
  another group. A group of three that converge at  angles offset by about 120 degrees will create a whirlpool effect and rotate about a point
  until more creatures join. As the group gets larger, the inner rotation of each creatures increases resulting in yet another visual change and the larger the group
  becomes the more likely it is to explode and repel the creatures outward. When in the proximity of the hunter, creatures glow red and attempt to evade. The hunters velocity is 
  affected by proximity to the creatures, close to the creatures the hunter will begin to change angular position (and thus affect translational velocity) in a counter clock-wise
  motion and will pulse yellow. If far away it will only rotate ever so slightly in a clock-wise motion and will scan white rings in search of creatures. 
*/
//import necessary  libraries
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import java.util.*;

//declare variables
int creatureCount = 20;
int boidCount = 20;
ArrayList<Creature> creatures; 
ArrayList<Pulse> pul;
Hunter hunt; 
hunterPulse pH;

Flock flock;
float bX, bY;

Minim minim;

ArrayList<ParticleSystem> systems;
ParticleSystem ps;

void setup()
{
  size(800, 600); 
  smooth();
  
  minim = new Minim(this);
  flock = new Flock();
  
  //make array lists to hold everything
  creatures = new ArrayList<Creature>();
  pul = new ArrayList<Pulse>();
  systems = new ArrayList<ParticleSystem>();
  
  //create the hunter and assign a hunter pulse to it
  hunt = new Hunter();
  pH = new hunterPulse(hunt.location.x, hunt.location.y, hunt.theta);
  
  //populate the creature array list, assign creature pulses
  for (int i = 0; i < creatureCount; i++) 
  {
    creatures.add(new Creature());
    Creature cR = creatures.get(i);
    
    //pass the creature location and theta(which controls its movement)
    //to its respective pulse so that the behave in the same way
    creaturePulse pC = new creaturePulse(cR.location.x, cR.location.y, cR.theta, 0); 
  
    pul.add(pC);
  }
  
  //populate the flock
  for (int i = 0; i < boidCount; i++)
  {
    Boid b = new Boid(random(0, width), random(0, height), 3.0, #FF00FF);
    flock.addBoid(b);
  }
}

void draw()
{
  fill(0, 30, 40, 40);
  rect(0,0, width*2, height*2);
  
  flock.run(creatures);
  
  hunt.display(creatures);
  pH.display(pul, creatures, hunt);
  
  Iterator<Creature> itC = creatures.iterator();
  Iterator<Pulse> itP = pul.iterator();
  
  //display all creatures, check for death
  //if dead, explode and remove pulse and creature from array lists
  while(itC.hasNext()) 
  {
    Creature crE = itC.next();
    Pulse puL = itP.next();
    
    crE.display(creatures, hunt);
    puL.display(pul, creatures, hunt);
    
    PVector loc = crE.location;
    
    if (crE.isDead())
    {
      //this part is cool! handles a system of particle systems
      //placement within the conditionals is what differentiates this from a normal particle system
      //rather than expanding all at once, the particles increase in radius once per death
      //this creates a slowly expanding lava like effect that I use to show a 'history' of creature death
      //the end goal is to have this lava affect the environment and thus the behavior of the creatures
      systems.add(new ParticleSystem(50, loc));
      Iterator<ParticleSystem> itPS = systems.iterator();
      while (itPS.hasNext())
      {
        ParticleSystem ps = itPS.next();
        ps.run();
        if (ps.dead())
        {
          itPS.remove();
        }
      }
      itC.remove();
      creatureCount -= 1;
    }
    
    if (puL.isDead())
    {
      itP.remove();
    }
    
    //if the hunter 'eats' the creature, kill it
    if (hunt.location == crE.location)
    {
      itC.remove();
      creatureCount -= 1;
      itP.remove();
    }
  }
  
  //if the creatures get lucky, make babies and add a pulse to each baby
  for (int i = 0; i < creatureCount; i++)
    {
      Creature creA = creatures.get(i);
      Pulse pulS = pul.get(i);
    
      if (creA.sex())
      {
        creatures.add(new Creature());
        //need to move this outside of the for loop
        //creatureCount += 1;
        int newb = creatures.size()-1;
        Creature creaT = creatures.get(newb);
        Pulse pL = new creaturePulse(creaT.location.x, creaT.location.y, creaT.theta, 0);
        pul.add(pL);
      }
    }

  //println(creatures.size());
}

//add boids if the mouse is dragged
void mouseDragged() 
{
  flock.addBoid(new Boid(mouseX, mouseY, 3.0, #FF00FF));
}
  
