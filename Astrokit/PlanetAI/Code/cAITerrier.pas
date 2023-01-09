{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAITerrier.pas,v 1.8 2003/08/31 17:15:33 aidave Exp $
}
unit cAITerrier;

interface

uses System.Classes, cAIBaseObject, cAIThings,
     cAIPosition, cAILife, cAILink, cAICreature;

type

// ============================================================================
// an individual Terrier
AITerrier = Class(AICreature)
private
  fDestination: AIPosition;
  fShaker: integer;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Destination: AIPosition read fDestination;
  property Shaker: integer read fShaker;
  function IsPredator: boolean; override;

  procedure Fuel; override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities;

// ----------------------------------------------------------------------------
Constructor AITerrier.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cTerrier;

  Size := 32;
  Health := 5024;
  Position.SetSize(3, 3, 3, true);
  Position.SetProperties(5, 0.1, 0.25);
  fDestination := AIPosition.Create(self);
  Health := 4000;
  Desire := cDesireWander;
end;

// ----------------------------------------------------------------------------
destructor AITerrier.Destroy;
begin
  fDestination.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AITerrier.Fuel;
begin
  inherited Fuel;

  Health := Health + 1;

  if Position.UnderWater then
  begin
    if not (Desire = cDesireLand) then
      Destination.FullCopy(Position);
    Desire := cDesireLand;
  end
  else
    Desire := cDesireWander;

{  // search for bird
  if not Eyes.ValidTarget then
    Eyes.AssignTarget(
      gThings.Existents.NearestOfKind(cBird, Position, 10));

  if Eyes.ValidTarget and not Grabber.Holding then
  begin
    myBird := AIBird(Eyes.Target);
    // is the bird low off the ground?
    if (myBird.Position.Height - myBird.Position.Land < 10) and
    // is the bird within 4 meters?
      (Position.DistanceTo(myBird.Position) < 10) then
    begin
      // set to chase the bird
      Destination.FullCopy(myBird.Position);
      Destination.Fuel;
    end
    else
      // find another bird
      Eyes.InvalidateTarget;
  end;
 }
  if (Desire = cDesireLand) then
  begin
    if not Destination.UnderWater then
    begin
      Position.FaceTarget(Destination);
      Position.Velocity.ApplyAngularForce(Position.DirectionXY, 0.3);
    end
    else
    begin
      Destination.ApplyForce(Random*TwoPi, 1);
      Destination.Fuel;
    end;
  end;
  {
  // move to random position within 2 if land
  if not (Eyes.ValidTarget) and (Position.Binding = bindLand) then
  begin
    Destination.FullCopy(Position);
    Destination.Acceleration.ApplyAngularForce(Random*TwoPi, QuarterPi, 0.2);
    Position.FaceTarget(Destination);
  end;

  if Eyes.ValidTarget then
  begin
    Position.FaceTarget(Destination);
    Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.3);
    if (Position.Binding = bindLand) and (Position.Height < Destination.Height) and (Position.DistanceTo(Destination) < 2) then
      Position.Acceleration.ApplyForce(0, 0, 0.4);
    if Position.DistancePlusHeightTo(Destination) < 1.5 then
    begin
      Grab(Eyes.Target);
      fShaker := Age + 32;
    end;
  end;

  if Grabber.Holding then
  begin
    Position.DirectionXY := Position.DirectionXY + RandomSwing * QuarterPi;
    if fShaker > Age then
      Drop;
  end;
  }
end;

// ----------------------------------------------------------------------------
function AITerrier.IsPredator: boolean;
begin
  result := true;
end;

end.

