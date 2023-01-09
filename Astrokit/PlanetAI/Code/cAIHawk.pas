{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIHawk.pas,v 1.18 2003/08/31 17:15:33 aidave Exp $
}
unit cAIHawk;

interface

uses System.Classes, cAIBaseObject, cAIThings,
     cAIPosition, cAILife, cAILink, cAICreature;

const
  cHawkBaby = 0;
  cHawkAdult = 256;

  cHawkDesireNone = 0;
  cHawkDesireWander = 1;
  cHawkDesireFood = 2;
  cHawkDesireRest = 3;

  cHawkGoalNone = 0;
  cHawkGoalMove = 1;
  cHawkGoalEat = 2;
  cHawkGoalAttack = 3;

  cHawkMove = 0;
  cHawkRest = 1;
  cHawkJoinFlock = 2;
  cHawkForage = 3;
  cHawkEatFood = 4;
  cHawkAttack = 5;
  cHawkNoGoal = 6;
  cHawkFindNest = 7;
  cHawkFollow = 8;

  cHawkSpeed = 0.01;

type

// ============================================================================
// an individual Hawk
AIHawk = Class(AICreature)
private
  fFlying: boolean;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Flying: boolean read fFlying write fFlying;

  procedure Fuel; override;
  procedure Hop;
  procedure FlapWings;
  function IsPredator: boolean; override;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities;

// ----------------------------------------------------------------------------
Constructor AIHawk.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cHawk;

  Position.SetPosition(Random * 10.0, Random * -10.0, 5);
  Position.SetSize(1, 0.75, 0.4, true);

  Health := 5500 + Random(500);
  Flying := true;
end;

// ----------------------------------------------------------------------------
destructor AIHawk.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIHawk.Fuel;
var
  myBird: AIBird;
begin
  inherited Fuel;

  // determine desire
  desire := cHawkDesireNone;
  if Health < 5120 then
    desire := cHawkDesireFood
  else
    desire := cHawkDesireWander;

  // find goal to enact that desire
  if desire = cHawkDesireWander then
  begin
    if Flying then
    begin
      if (Position.Velocity.DeltaHeight <= -0.2) then
        Position.Acceleration.ApplyForce(0, 0, 0.05);
      if (Position.Height < 40) then
        Position.Acceleration.ApplyForce(0, 0, 0.04);
      if Position.Velocity.XYStrength < 0.2 then
        Position.Acceleration.ApplyAngularForce(Pi, 0.05);
    end
    else
      if (Age mod 32) = 0 then
        Hop;
    Position.FaceVelocity;
  end;

  if (desire = cHawkDesireFood) and not Grabber.Holding then
  begin
    if not Eyes.ValidTarget then
    begin
      myBird := gEnvironment.Things.Tables[cBird].RandomThing;
      if not (myBird = nil) then
      begin
        Eyes.AssignTarget(myBird);
        Noise(cNoiseHawk, 1);
      end;
    end;

    // chase bird
    if Eyes.ValidTarget then
    begin
      myBird := AIBird(Eyes.Target);
      Position.TurnTowardsTarget(myBird.Position, ca75);
      Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.1);
      if (myBird.Position.Height > Position.Height) or (Position.Velocity.DeltaHeight < -0.5) then
        FlapWings;
      if Position.DistancePlusHeightTo(myBird.Position) < 2.0 then
      begin
        if myBird.Position.Carried then
          Bonk
        else
          Grab(myBird);
      end;
    end;
  end;

  Position.Velocity.LimitSpeed(0.8);

  if Grabber.Holding then
  begin
    if Eat(8) then Noise(cNoiseEat, 1);
    if (Position.Height < 15) then
      FlapWings;
    if Position.Velocity.XYStrength < 0.2 then
      Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0, 0.05);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIHawk.Hop;
begin
  if Position.Binding = bindLand then
    Position.Acceleration.ApplyForce(0, 0, 0.2);
end;

// ----------------------------------------------------------------------------
procedure AIHawk.FlapWings;
begin
//  if Position.Velocity.DeltaHeight < 0.5 then
    Position.Acceleration.ApplyForce(0, 0, 0.03);
end;

// ----------------------------------------------------------------------------
procedure AIHawk.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeFileBoolean(aFile, fFlying);
end;

// ----------------------------------------------------------------------------
procedure AIHawk.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  fFlying := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
function AIHawk.IsPredator: boolean;
begin
  result := true;
end;

end.

