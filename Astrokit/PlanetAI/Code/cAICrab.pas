{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAICrab.pas,v 1.19 2003/09/25 19:46:18 uid105088 Exp $
}
unit cAICrab;

interface

uses System.Classes, cAIBaseObject, cAIThings,
     cAIPosition, cAILife, cAILink, cAICreature, cAILearningCreature;

const
  cCrabBaby = 0;
  cCrabAdult = 256;

  cCrabSpeed = 0.05;

type

// ============================================================================
// an individual Crab
// the happiest crabs are the crabs that play with alot of balls
AICrab = Class(AILearningCreature)
protected
  procedure FindAndGrab;
  function HoldingFood: boolean;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Fuel; override;
  procedure Hop;
  procedure Scuttle;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities;

// ----------------------------------------------------------------------------
Constructor AICrab.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cCrab;

  Position.SetPosition(Random * 10.0, Random * -10.0, 5);
  Position.SetSize(0.8, 0.8, 2, true);
  Position.SetProperties(1, 0.25, 0.1);

  Health := 500;
  Desire := cDesireFood;
end;

// ----------------------------------------------------------------------------
destructor AICrab.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AICrab.Fuel;
begin
  inherited Fuel;

  // calculate desire
  case desire of
    cDesireFood: if (Health>=5000) then
    begin
      desire := cDesirePlay;
      Talk('"I wanna play with a ball!"', 10, 32);
      if HoldingFood then Throw;
      Eyes.AssignTarget(gThings.Tables[cBall].NearestThing(Position));
    end;
    cDesirePlay: if (Health<3000) then
    begin
      desire := cDesireFood;
      Talk('"Damn I am hungry!"', 10, 32);
      if not HoldingFood then Throw;
      Eyes.InvalidateTarget;
    end;
  end;

  // enact desire
  case desire of
    cDesireFood:
    begin
      if Grabber.Holding then
        if Eat(128) then Noise(cNoiseEat, 1);
      if Age mod 8 = 0 then
        LookForSomethingToEat;
      if Eyes.ValidTarget then
        FindAndGrab;
    end;
    cDesirePlay:
    begin
      if Grabber.Holding then
      begin
        // find a crab
        if not Eyes.ValidTarget then
          Eyes.AssignTarget(gThings.Tables[cCrab].NearestThing(Position));
        // move towards a crab and jump over it
        if Eyes.ValidTarget then
          Position.TurnTowardsTarget(Eyes.Target.Position);
        Scuttle;
        Hop;
      end
      else
      begin
        if not Eyes.ValidTarget then
          Eyes.AssignTarget(gThings.Tables[cBall].NearestThing(Position));
        if Eyes.ValidTarget then
        begin
          Position.TurnTowardsTarget(Eyes.Target.Position);
//          if Eyes.Target.Position.Carried then
//            Bonk(Eyes.Target.
          Scuttle;
        end;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AICrab.Hop;
begin
  if Position.Binding = bindLand then
    Position.Acceleration.ApplyForce(0, 0, 0.4);
end;

// ----------------------------------------------------------------------------
procedure AICrab.Scuttle;
begin
  if Position.Binding = bindLand then
    Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.1);
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AICrab.FindAndGrab;
var
  myThing: AIThing;
begin
  // check how long we've been chasing
  if (Timer - gReality.Time) > 512 then
    GiveUp;

  // check validity of sight
  if Eyes.ValidTarget then
  begin
    myThing := Eyes.Target;
    // see if another creature got the apple
    if myThing.Position.Carried then
      Eyes.InvalidateTarget;
  end;

  if Eyes.ValidTarget then
  begin
    myThing := Eyes.Target;
    // grab the apple
    if CloseEnoughToGrab(myThing) then
      Grab(myThing)
    else // go to it
    begin
      // if its in the air, try to jump and grab it
      if (myThing.Position.Binding <> bindLand) and (Position.Height < myThing.Position.Height-1) and (Position.SimpleDistanceToXY(myThing.Position) < 2) then
        Hop;
      Position.TurnTowardsTarget(myThing.Position, ca15);
      if Position.Velocity.XYStrength < cCrabSpeed then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, cCrabSpeed);
      // jump to grab if above
    end;
  end;
end;

function AICrab.HoldingFood: boolean;
begin
  result := Grabber.Holding
    and (Grabber.Target.IsFruit or Grabber.Target.IsPrey);
end;

end.

