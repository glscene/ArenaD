{
  ai.planet
  http://aiplanet.sourceforge.net
  $Id: cAIGrass.pas,v 1.7 2003/08/31 17:15:33 aidave Exp $
}
unit cAIGrass;

interface

uses 
  System.Classes, 
  System.SysUtils,
  cAIBaseObject, 
  cAISpace, 
  cAIThings, 
  cAILife, 
  cAITrees;

type

// ============================================================================
AIGrass = Class(AIPlant)
private
public
  Constructor Create(aParent: pointer);

  procedure Fuel; override;
  procedure Grow;
  function IsFruit: boolean; override;
end;

implementation

uses
  cAIReality, 
  cAIEnvironment, 
  cAIGrid, 
  cUtilities, 
  cAIVibes, 
  cGlobals,
  cAIPosition;

// ----------------------------------------------------------------------------
Constructor AIGrass.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cGrass;
  Health := 5024;
  Position.SetSize(1, 0.2, 0.2, true);
  Position.SetProperties(1, 0.1, 0.25);
  Position.Collider := false;

  Water := 0.05;
  Health := 64;
end;

// ----------------------------------------------------------------------------
procedure AIGrass.Fuel;
begin
  inherited Fuel;

  if (Age mod 128 = 0) then
    Grow;

  if Water < 0.5 then
    Water := Water + 0.01;

  if (Position.Binding = bindLand) and not Position.UnderWater then
    Health := Health + 1;
end;

// ----------------------------------------------------------------------------
procedure AIGrass.Grow;
var
  myGrass: AIGrass;
begin
//  if gThings.Existents.HasKindWithinDistance(cGrass, Position, 1) then
//    exit;
  if not gThings.CanAdd(cGrass) then
    exit;

  myGrass := AIGrass(gThings.NewThing(cGrass));
  myGrass.Position.FullCopy(Position);
  myGrass.Position.DirectionXY := Random * TwoPi;
  myGrass.Position.MoveBy(1);
  myGrass.Position.Height := 0;
end;

// ----------------------------------------------------------------------------
function AIGrass.IsFruit: boolean;
begin
  result := true;
end;

end.

