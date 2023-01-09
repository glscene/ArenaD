{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAITurtle.pas,v 1.20 2003/09/03 00:14:14 aidave Exp $

  Learning turtle
}
unit cAITurtle;

interface

uses System.Classes, cAIBaseObject, cAIThings, cAIThingReferenceList,
     cAIPosition, cAILife, cAILink, cAICreature, cAILearningCreature;

type

// ============================================================================
// an individual Turtle
AITurtle = Class(AILearningCreature)
private
  procedure FindAndGrab(aSpeed: single);
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Babble;
  function IsPredator: boolean; override;
  procedure Fuel; override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AITurtle.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cTurtle;
  Desire := cDesireFood;
  Size := 32;
  Health := 5000;
  Position.SetSize(1.5, 1.5, 0.5, true);
  Position.SetProperties(4, 0.2, 3);
end;

// ----------------------------------------------------------------------------
destructor AITurtle.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AITurtle.Fuel;
begin
  inherited Fuel;

  if Health < 10000 then
    Desire := cDesireFood
  else
    Desire := cDesireWander;

  Health := Health - 2;

  if Grabber.Holding then
  begin
    if Eat(64) then Noise(cNoiseEat, 1);
    Eyes.InvalidateTarget;
  end;

  if Random(512) = 0 then Babble;

  if (desire = cDesireFood) and not Grabber.Holding then
  begin
    if Age mod 32 = 0 then
    begin
      LookForSomethingToEat;
      if Eyes.ValidTarget and (Random(2)=0) then
        Talk('"That ' + ThingName(Eyes.Target.Kind) + ' looks tasty."', 10, 32);
    end;
    if Eyes.ValidTarget then
      FindAndGrab(0.02*Position.Mass);
  end;

  // just sit around and look at tasty things
  if (desire = cDesireWander) then
  begin
    // look at something to eat
    if Age mod 64 = 0 then
    begin
      LookForSomethingToEat;
      if Eyes.ValidTarget and (Random(4)=0) then
        Talk('"That ' + ThingName(Eyes.Target.Kind) + ' looks interesting."', 10, 32);
    end;
    // watch it
    if Eyes.ValidTarget then
      Position.TurnTowardsTarget(Eyes.Target.Position);
  end;
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AITurtle.FindAndGrab(aSpeed: single);
var
  myThing: AIThing;
begin
  // check how long we've been chasing
  if (Timer - gReality.Time) > 512 then
  begin
    GiveUp;
  end;

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
      Grab(myThing);
    Position.TurnTowardsTarget(myThing.Position, ca15);
    if Position.Velocity.XYStrength < aSpeed then
      Position.Acceleration.ApplyAngularForce(Position.DirectionXY, aSpeed);
    if Position.Height > myThing.Position.Height then
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight - aSpeed
    else
    if (Position.Height < myThing.Position.Height) and (Position.Underwater) then
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight + aSpeed;
  end;
end;

// ----------------------------------------------------------------------------
function AITurtle.IsPredator: boolean;
begin
  result := true;
end;

// ----------------------------------------------------------------------------
procedure AITurtle.Babble;
begin
  case Random(2) of
    0: Talk('"I hope I can find another ' + ThingName(FavoriteFood) + ', those are yummy."', 10, 64);
    1: Talk('"You know what I hate? ' + ThingNamePlural(YuckiestFood) + '."', 10, 64);
  end;
end;

end.

