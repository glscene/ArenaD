{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIFireTree.pas,v 1.1 2003/08/30 08:15:57 aidave Exp $
  In light of all the recent forest fires in BC, I thought I would make
    a forest fire simulator.  Dave
}
unit cAIFireTree;

interface

uses System.Classes, cAIBaseObject, cAISpace, cAIThings, cAILife, cAITrees;

const
  cBurnStart = 1.0;
  cBurnIncrease = 0.2;
  cBurnSpread = 16.0;
  cBurnDown = 32.0;

type

// ============================================================================
AIFireTree = Class(AIThing)
private
  fFire: single;
  fBurning: boolean;

  procedure SetFire(aAmount: single);
public
  property Fire: single read fFire write SetFire;
  property Burning: boolean read fBurning;

  Constructor Create(aParent: pointer);

  procedure Fuel; override;

  procedure Damage(aAmount: integer); override;
  function Digest(const aAmount: integer): integer; override;
  function IsPlant: boolean; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAIGrid, cUtilities, cAIVibes, cGlobals,
  cAIPosition;

// ----------------------------------------------------------------------------
Constructor AIFireTree.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cFireTree;
  Position.DirectionXY := Random*TwoPi;
  Position.Collider := true;
  Position.SetProperties(5, 0.3, 0.5);
  Position.SetSize(1,1,4);
  fFire := 0;
  fBurning := false;
end;

// ----------------------------------------------------------------------------
procedure AIFireTree.SetFire(aAmount: single);
begin
  fFire := aAmount;

  fBurning := (fFire <> 0);

  if fFire < 0 then fFire := 0;
  if fFire >= 256 then Cease;
//  if fFire >= cBurnDown then Cease;
end;

// ----------------------------------------------------------------------------
procedure AIFireTree.Fuel;
begin
  inherited Fuel;

  if Burning then
  begin
    // spread to nearby trees
    if Fire >= cBurnSpread then
    begin
      gThings.Existents.ApplyDamage(Position, 32, Min(Fire/cBurnDown*2, 3));
    end;
    Fire := Fire + cBurnIncrease;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIFireTree.Damage(aAmount: integer);
begin
  if not Burning then
    Fire := cBurnStart;
end;

// ----------------------------------------------------------------------------
procedure AIFireTree.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIFireTree.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIFireTree.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);
end;

// ----------------------------------------------------------------------------
function AIFireTree.Digest(const aAmount: integer): integer;
begin
  result := -1 * inherited Digest(aAmount);
end;

// ----------------------------------------------------------------------------
function AIFireTree.IsPlant: boolean;
begin
  result := true;
end;

end.

