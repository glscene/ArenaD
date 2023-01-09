{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIFish.pas,v 1.41 2003/08/31 17:15:33 aidave Exp $
}
unit cAIFish;

interface

uses System.Classes, cAIBaseObject, cAISpace, cAIThings, cAILife,
  cAICreature, cAICommunity, cAIMating;

const
  cFishBaby = 0;
  cFishAdult = 512;

type

// ============================================================================
AIFish = Class(AIMatingCreature)
protected
  procedure Swim;
  procedure Flop;
  procedure FindFood;
  procedure DevelopIntoBaby; override;
  procedure Grow(aAmount: single); override;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Die; override;
  function IsPrey: boolean; override;

  procedure Fuel; override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAIGrid, cAIPosition, cGlobals,
  cAIVibes, cUtilities, cAITrees;

// ----------------------------------------------------------------------------
Constructor AIFish.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cFish;

  Size := Random * 0.3 + 0.3;
  Health := 3100;
  Position.SetSize(Size, Size/4, Size/4, true);
  Position.SetProperties(1, 0.5, 0.5);
end;

// ----------------------------------------------------------------------------
Destructor AIFish.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIFish.Fuel;
begin
  inherited Fuel;

  if (Size < 1) and (Health > 1536) then
  begin
    Grow(0.0002);
  end;

  desire := cDesireNone;
  if (Health < 2048) and not Grabber.Holding then
    desire := cDesireFood
  else
  begin
    case Stage of
      cCreatureBaby:  desire := cDesireWander;
      cCreatureAdult: desire := cDesireMate;
      cCreatureElder: desire := cDesireWander;
    end;
  end;

  // eat
  if Grabber.Holding then
  begin
    Eat(16);
    if Grabber.Empty then
    begin
      if (Size < 1) then
        Grow(0.001);
      Noise(cNoiseEat, 1);
    end;
  end;

  // if not underwater, try to get in water, and quit
  if not Position.UnderWater then
  begin
    if Position.Binding = bindLand then
      Flop;
    exit;
  end;

  // find food
  case desire of
    cDesireFood:    FindFood;
    cDesireWander:  SwimWithCommunity;
    cDesireMate:
    begin
      SwimWithCommunity;
      MatingBehaviour;
      if Partner.ValidTarget then
        Swim;
      Position.TurnTowardsVelocity(ca30);
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIFish.Swim;
begin
  Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.075);
  Position.Velocity.LimitSpeed(0.1);
end;

// ----------------------------------------------------------------------------
procedure AIFish.Flop;
begin
  Position.Acceleration.ApplyAngularForce(Random*TwoPi, 0.9, 0.1);
end;

// ----------------------------------------------------------------------------
procedure AIFish.FindFood;
var
  myThing: AIThing;
  targetHeight: single;
begin
  targetHeight := Position.Water - 2;
    // has food in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // turn towards food
      Position.TurnTowardsTarget(myThing.Position, ca45);
      // stay under water until close to food
      if Position.SimpleDistanceToXY(myThing.Position) < 5 then
//      if Position.DistanceTo(myThing.Position) < 5 then
        targetHeight := myThing.Position.Height;
      // if close to food, then pick it up
      if CloseEnoughToGrab(myThing) then
      begin
        // put food in mouth
        if not myThing.Position.Carried then
          Grab(myThing)
        else
          if Age mod 16 = 0 then
          begin
            Bonk(AIThing(myThing.Position.Carrier));
            Eyes.InvalidateTarget;
          end;
      end;
    end
    else
    begin
      // find a fruit
      if Random(8) <> 0 then
        myThing := gThings.Fruits.NearestAvailableUnderwaterThing(Position, cFish)
      else
        myThing := gThings.Prey.NearestAvailableUnderwaterThing(Position, cFish);

      if myThing <> nil then
      begin
        if myThing.Position.UnderWater then
          Eyes.AssignTarget(myThing);
      end;
      Position.DirectionXY := Position.DirectionXY + RandomSwing * QuarterPi;
    end;

  // move
  if Position.UnderWater and (Age mod 4 = 0) then
  begin
    if Position.Height > targetHeight then
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight - 0.1
    else
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight + 0.1;

    if Bump then
      AvoidNeighbour;
    Swim;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIFish.Die;
begin
  inherited Die;

  // when the fish dies, it floats
  Position.Buoyancy := 0.6;
end;

// ----------------------------------------------------------------------------
procedure AIFish.DevelopIntoBaby;
begin
  Size := 0.1;
  Position.SetSize(Size, Size, Size/4);
end;

// ----------------------------------------------------------------------------
procedure AIFish.Grow(aAmount: single);
begin
  Size := Size + aAmount;
  Position.SetSize(Size, Size/4, Size/4);
end;

// ----------------------------------------------------------------------------
function AIFish.IsPrey: boolean;
begin
  result := true;
end;

end.

