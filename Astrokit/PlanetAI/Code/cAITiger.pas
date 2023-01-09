{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Aaron Hochwimmer
  $Id: cAITiger.pas,v 1.7 2003/08/31 17:15:33 aidave Exp $
}
unit cAITiger;

interface

uses System.Classes, cAIBaseObject, cAIThings,
     cAIPosition, cAILife, cAILink, cAICreature;

const
  cTigerDesireNone = 0;
  cTigerDesireFood = 2;
  cTigerDesireRest = 3;
  cTigerDesireBully = 4;

type

// ============================================================================
// an individual Tiger
// tigers hunt eat mice if they are hungry - sometimes they play with their
// food first! :) Should be extended to try and catch birds, rabbits - play
// with Terriers? etc.
// Also should avoid water as tigers don't like getting wet.

AITiger = Class(AICreature)
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
Constructor AITiger.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cTiger;
  Size := 32;
  Position.SetSize(2, 2, 2, true);
  Position.SetProperties(5, 0.1, 0.25);

  Health := 6000;
  Desire := cDesireWander;
end;

// ----------------------------------------------------------------------------
destructor AITiger.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AITiger.Fuel;
begin
  inherited Fuel;

// determine desire
  if Health < 3000 then
    desire := cTigerDesireFood
  else
  begin
    Randomize;
// a 75% chance of playing with food first
    if Random <= 0.75 then
      desire := cTigerDesireBully
    else
      desire := cTigerDesireFood;
  end;

// enact desire - modified from Trex
  case desire of
    cTigerDesireFood:
    begin
      Forage(cMouse,0.5);
      if Grabber.Holding then
        if Eat(128) then Noise(cNoiseEat, 1);
    end;
    cTigerDesireBully: Bully;
  end;
end;

// ----------------------------------------------------------------------------
procedure AITiger.Bully;
var
  myThing: AIThing;

begin
    // torment
    if Grabber.Holding then
    begin
      if ((Age mod 64) = 0) then
      begin
        Kick(0.4);
        Noise(cNoiseYowl, 1);
      end;
      Position.TurnLeft(RandomSwing * QuarterPi/4);
      exit;
    end;

    // find a mouse to bully
    if not (Eyes.TargetKind = cMouse) then
      Eyes.AssignTarget(gEnvironment.Things.Existents.NearestAvailableOfKind(cMouse, Position, 50));

    // track the mouse
    if Eyes.Connected then
    begin
      myThing := Eyes.Target;
      Position.FaceTarget(myThing.Position);
      if Position.Velocity.XYStrength < 0.07 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.25);
      if (Position.DistancePlusHeightTo(myThing.Position) < 1.5) then
        Grab(myThing);
    end;
end;

// ----------------------------------------------------------------------------
function AITiger.IsPredator: boolean;
begin
  result := true;
end;

end.

