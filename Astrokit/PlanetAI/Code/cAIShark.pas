{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIShark.pas,v 1.14 2003/08/31 17:15:33 aidave Exp $
}
unit cAIShark;

interface

uses System.Classes, cAIBaseObject, cAISpace, cAIThings, cAILife,
  cAICreature;

const
  cSharkBaby = 0;
  cSharkAdult = 512;

type

// ============================================================================
AIShark = Class(AICreature)
protected
  procedure Swim;
  procedure Dart;
public
  Constructor Create(aParent: pointer);
  procedure Fuel; override;
  function IsPredator: boolean; override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAIGrid, cAIPosition, cGlobals,
  cAIVibes, cUtilities, cAITrees;

// ----------------------------------------------------------------------------
Constructor AIShark.Create(aParent: pointer);
begin
  inherited Create(aParent);
  Kind := cShark;

  Size := 32;
  Health := 5024;
  Position.SetSize(2.5, 0.75, 0.5, true);
  Position.SetProperties(1, 0.5, 0.5);
end;

// ----------------------------------------------------------------------------
procedure AIShark.Fuel;
var
  myThing: AIThing;
  targetHeight: single;
begin
  inherited Fuel;

  desire := cDesireNone;
  if (Health < 4096) and not Grabber.Holding then
    desire := cDesireFood
  else
    desire := cDesireWander;

  targetHeight := Position.Water - 4;

  // find food
  if desire = cDesireFood then
  begin
    // has food in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // turn towards food
      Position.TurnTowardsTarget(myThing.Position, ca30);
//      Position.FaceTarget(myThing.Position);
      // stay under water until close to food
      if Position.DistanceTo(myThing.Position) < 5 then
        targetHeight := myThing.Position.Height;
      // if close to food, then pick it up
      if (Position.DistancePlusHeightTo(myThing.Position) < 2) then
      begin
        // put food in mouth
        if not myThing.Position.Carried then
          Grab(myThing)
        else
          Bonk;
      end;
    end
    else
    begin
      // find a fish, or a duck
      if Random(16) <> 0 then
        Eyes.AssignTarget(gThings.Tables[cFish].NearestAvailableUnderwaterThing(Position, cShark))
      else
        Eyes.AssignTarget(gThings.Tables[cDuck].NearestAvailableUnderwaterThing(Position, cShark));
    end;
  end;

  if desire = cDesireWander then
  begin
    if Age mod 16 = 0 then
      Position.DirectionXY := Position.DirectionXY + RandomSwing * SixteenthPi;
  end;

  // move
  if Position.UnderWater and (Age mod 4 = 0) then
  begin
    if targetHeight < Position.Land + 1 then
      targetHeight := Position.Land + 1;

    if Position.Height > targetHeight then
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight - 0.1
    else
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight + 0.1;

    if Desire = cDesireFood then Dart;
    Swim;
  end;

  if not Position.UnderWater then
  begin
    Health := Health - 32;
    Position.DirectionXY := Position.DirectionXY + RandomSwing * QuarterPi/2;
    if Position.Binding = bindLand then
      Position.Acceleration.ApplyForce(0, 0, 0.05);
  end;

  // eat
  if Grabber.Holding then
  begin
    Eat(64);
    if Grabber.Empty and (Size < 1024) then
    begin
//      Size := Size + 1;
      Noise(cNoiseEat, 1);
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIShark.Swim;
begin
  Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.09);
end;

// ----------------------------------------------------------------------------
procedure AIShark.Dart;
begin
  Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.12);
end;

// ----------------------------------------------------------------------------
function AIShark.IsPredator: boolean;
begin
  result := true;
end;

end.

