{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAITrex.pas,v 1.11 2003/08/31 17:15:33 aidave Exp $
}
unit cAITrex;

interface

uses System.Classes, cAIBaseObject, cAIThings,
     cAIPosition, cAILife, cAILink, cAICreature;

const
  cTrexBaby = 0;
  cTrexAdult = 256;

  cTrexDesireNone = 0;
  cTrexDesireWander = 1;
  cTrexDesireFood = 2;
  cTrexDesireRest = 3;
  cTrexDesireBully = 4;

type

// ============================================================================
// an individual Trex
AITrex = Class(AICreature)
protected
  procedure Bully;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  function IsPredator: boolean; override;
  procedure Fuel; override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities;

// ----------------------------------------------------------------------------
Constructor AITrex.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cTrex;
  Position.SetSize(0.75, 0.75, 0.4, true);
  Health := 6000;
end;

// ----------------------------------------------------------------------------
destructor AITrex.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AITrex.Fuel;
begin
  inherited Fuel;

  // determine desire
  desire := cTrexDesireNone;

//  myFoodDesire := Fuzz(Health, 5120);

  if Health < 5120 then
    desire := cTrexDesireFood
  else
    desire := cTrexDesireBully;

  // enact desire
  case desire of
    cTrexDesireFood:
    begin
      Forage(0.15);
      if Grabber.Holding then
      begin
        if Eat(128) then Noise(cNoiseEat, 1);
      end;
    end;
    cTrexDesireBully: Bully;
  end;
end;

// ----------------------------------------------------------------------------
procedure AITrex.Bully;
var
  myThing: AIThing;
begin
    // torment
    if Grabber.Holding then
    begin
      if ((Age mod 128) = 0) then
      begin
        Kick(0.4);
        Noise(cNoiseRoar, 1);
      end;
      Position.TurnLeft(RandomSwing * QuarterPi/4);
      exit;
    end;

    // find a grazer to bully
    if not (Eyes.TargetKind = cGrazer) then
      Eyes.AssignTarget(gEnvironment.Things.Existents.NearestAvailableOfKind(cGrazer, Position, 50));

    // track the grazer
    if Eyes.Connected then
    begin
      myThing := Eyes.Target;
      Position.TurnTowardsTarget(myThing.Position, ca30);
//      Position.FaceTarget(myThing.Position);
      if Position.Velocity.XYStrength < 0.07 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.075);
      if (Position.DistancePlusHeightTo(myThing.Position) < 1.5) then
        Grab(myThing);
    end;
end;

// ----------------------------------------------------------------------------
function AITrex.IsPredator: boolean;
begin
  result := true;
end;

end.

