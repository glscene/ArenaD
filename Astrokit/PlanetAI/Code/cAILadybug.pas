{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAILadybug.pas,v 1.19 2003/08/30 08:16:15 aidave Exp $
}
unit cAILadybug;

interface

uses System.Classes, cAIBaseObject, cAIThings, cAIMating,
     cAIPosition, cAILife, cAILink, cAICreature, cAIGeneticCreature;

type

// ============================================================================
// an individual Ladybug
AILadybug = Class(AIGeneticCreature)
protected
  procedure DevelopIntoBaby; override;
  procedure FindFood(aKind: integer; aSpeed: single);
  procedure Move;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Die; override;
  function IsPrey: boolean; override;

  function OneLineDisplay: string; override;
  procedure Fuel; override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AILadybug.Create(aParent: pointer);
begin
  Kind := cLadybug;

  inherited Create(aParent);

  Health := 2000;
  Position.SetSize(0.3, 0.3, 0.3);
  Position.SetProperties(1, DNA.Bounce, DNA.Buoyancy);
end;

// ----------------------------------------------------------------------------
destructor AILadybug.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AILadybug.Fuel;
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
    Eat(16);
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
procedure AILadyBug.Move;
begin
  if Position.Velocity.XYStrength < 0.1 then
    Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.025);
end;

// ----------------------------------------------------------------------------
procedure AILadyBug.DevelopIntoBaby;
begin
  Size := 0.1;
  Position.SetSize(Size, Size, Size);
  Position.Buoyancy := DNA.Buoyancy;
  Position.Bounce := DNA.Bounce;

  // preferred food
{  if Random*1.0 < DNA.Mutation then
  begin
    if DNA.PreferredFood = cOrange then DNA.PreferredFood := cApple
      else DNA.PreferredFood := cOrange;
  end;
  }
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AILadyBug.FindFood(aKind: integer; aSpeed: single);
var
  myThing: AIThing;
begin
  if not Grabber.Holding then
  begin
    // check validity of sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;

      // see if another creature got the apple
      if myThing.Position.Carried
      // make sure we are looking at an apple
//      or not (myThing.Kind = aKind)
      then
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
      Eyes.AssignTarget(gEnvironment.Things.Tables[aKind].NearestAvailableOfKind(aKind, Position, 10000));
      if not Eyes.ValidTarget then
        Eyes.AssignTarget(gEnvironment.Things.Fruits.NearestAvailableThing(Position));
    end;
  end;
end;


// ----------------------------------------------------------------------------
function AILadyBug.OneLineDisplay: string;
begin
  result := Format('Ladybug b=%0.2f ', [DNA.Buoyancy]) + inherited OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AILadybug.Die;
begin
  inherited Die;

  Position.Buoyancy := 1.0; // float when dead
end;

// ----------------------------------------------------------------------------
function AILadyBug.IsPrey: boolean;
begin
  result := true;
end;

end.

