class hunterPulse extends Pulse
{
  //class to initialize hunter pulse-specific variables and pass info to display
  hunterPulse(float x, float y, float thetaH)
  {
    super(x, y, 50, 50, 1, thetaH, 1);
    col = #FFFFDD;
    dim = 50;
  }
  
  void display(ArrayList<Pulse> y, ArrayList<Creature> u, Hunter i)
  {
    super.display(y, u, i);
  }
}
