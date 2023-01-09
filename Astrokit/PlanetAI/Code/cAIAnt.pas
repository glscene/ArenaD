{
  The unit of ai.planet project http://aiplanet.sourceforge.net
  Created by Dave Kerr
}

unit cAIAnt;

interface

uses
  System.Classes,
  cAIBaseObject,
  cAIThings,
  cAIPosition,
  cAILife,
  cAILink,
  cAICreature,
  cAICommunity;

type

// ============================================================================
// an individual Ant
AIAnt = Class(AICommunityCreature)
private
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Fuel; override;
  function IsPrey: boolean; override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities;

// ----------------------------------------------------------------------------
Constructor AIAnt.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cAnt;
  Health := 4000;
  Desire := cDesireWander;
  Position.SetSize(0.2, 0.2, 0.2);
  Position.SetProperties(1, 0.3, 0.9);
end;

// ----------------------------------------------------------------------------
destructor AIAnt.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIAnt.Fuel;
begin
  inherited Fuel;

  // example code to eat grass
  Forage(0.02);
  if Grabber.Holding then
    if Eat(128) then Noise(cNoiseEat, 1);
end;

// ----------------------------------------------------------------------------
function AIAnt.IsPrey: boolean;
begin
  result := true;
end;

end.

