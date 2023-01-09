{
  ai.planet
  http://aiplanet.sourceforge.net
  $Id: cAIMouse.pas,v 1.8 2003/08/09 23:13:22 aidave Exp $
  Mouse by:
    Dave Kerr
    Matt Snelling
    Jeff Yoshimi
}
unit cAIMouse;

interface

uses System.Classes, cAIBaseObject, cAISpace, cAIThings, cAILife,
  cAICreature;

const
  cMouseBaby = 0;
  cMouseAdult = 512;

type

// ============================================================================
AIMouse = Class(AICreature)
protected
public
  Constructor Create(aParent: pointer);
  procedure Fuel; override;
  function IsPrey: boolean; override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAIGrid, cAIPosition, cGlobals,
  cAIVibes, cUtilities, cAITrees;

// ----------------------------------------------------------------------------
Constructor AIMouse.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cMouse;
  Position.SetSize(0.5, 0.5, 0.5);
  Position.SetProperties(1, 0.5, 0.6);
end;

// ----------------------------------------------------------------------------
procedure AIMouse.Fuel;
begin
  inherited Fuel;

  if Random(512)=0 then
    Noise(cNoiseMouseHigh, 1);

  // example code to eat
  Forage(0.15);
  if Grabber.Holding then
    if Eat(128) then Noise(cNoiseMouseLow, 1);
end;

// ----------------------------------------------------------------------------
function AIMouse.IsPrey: boolean;
begin
  result := true;
end;

end.

