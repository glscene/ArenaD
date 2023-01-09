{
  ai.planet
  http://aiplanet.sourceforge.net
  $Id: cAIRabbit.pas,v 1.12 2003/08/31 17:15:33 aidave Exp $
}
unit cAIRabbit;

interface

uses System.Classes, cAIBaseObject, cAIThings, cAICreature,
     cAIPosition, cAILife, cAILink, cAIGeneticCreature;

type

// ============================================================================
// an individual Rabbit
AIRabbit = Class(AIGeneticCreature)
protected
  procedure DevelopIntoBaby; override;
  procedure FindFood(aKind: integer; aSpeed: single);
  procedure Move;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Fuel; override;
  function IsPrey: boolean; override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities;

// ----------------------------------------------------------------------------
Constructor AIRabbit.Create(aParent: pointer);
begin
  Kind := cRabbit;

  inherited Create(aParent);

  Size := 1;
  Position.SetSize(0.8, 0.8, 0.8, true);
  Position.SetProperties(2, 0.5, 0.6);

  Health := 512;
  Desire := cDesireWander;
end;

// ----------------------------------------------------------------------------
destructor AIRabbit.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIRabbit.Fuel;
begin
  inherited Fuel;

//  desire := cDesireNone;
  if (Health < 2048) and not Grabber.Holding then
    desire := cDesireFood
  else
    desire := cDesireMate;

  if Age > 3000 then Die;

  // eat
  if Grabber.Holding then
  begin
    Eat(64);
    if Grabber.Empty then
      Noise(cNoiseEat, 1);
  end;

  // find food
  case desire of
    cDesireFood:
    begin
      FindFood(DNA.PreferredFood, 0.1);
    end;
    cDesireMate:
    begin
      MatingBehaviour;
      if Partner.ValidTarget then
        Move;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIRabbit.IsPrey: boolean;
begin
  result := true;
end;

// ----------------------------------------------------------------------------
procedure AIRabbit.Move;
begin
  if Position.Velocity.XYStrength < 0.1 then
    Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.05);
end;

// ----------------------------------------------------------------------------
procedure AIRabbit.DevelopIntoBaby;
begin
  Size := 1;
  Position.SetSize(Size, Size, Size);
  Position.Buoyancy := DNA.Buoyancy;
  Position.Bounce := DNA.Bounce;
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AIRabbit.FindFood(aKind: integer; aSpeed: single);
var
  myThing: AIThing;
begin
  if not Grabber.Holding then
  begin
    // check validity of sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // see if another creature got it
      if myThing.Position.Carried then
        Eyes.InvalidateTarget;
    end;

    // an apple is in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // grab the apple
      if CloseEnoughToGrab(myThing) then
        Grab(myThing)
      else // go to it
      begin
        Position.TurnTowardsTarget(myThing.Position, ca30);
        if Position.Velocity.XYStrength < aSpeed then
          Position.Acceleration.ApplyAngularForce(Position.DirectionXY, aSpeed);
      end;
    end
    else // dont see an apple, try to find an apple
    begin
      Eyes.AssignTarget(gEnvironment.Things.Fruits.NearestAvailableThing(Position));
    end;
  end;
end;

end.

