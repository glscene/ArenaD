{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIExplosions.pas,v 1.15 2003/09/14 00:31:48 aidave Exp $
}
unit cAIExplosions;

interface

uses System.Classes, cAIBaseObject, cAIThings, cAILife;

const
  cExplosionDeath = 168;

  cEffectFire = 0;
  cEffectRocket = 1;
  cEffectBlast = 2;
  cEffectImplode = 3;
  cEffectShockWave = 4;   // sun explode
  cEffectIceWave = 5;     // moon explode
  cEffectSteam = 6;
  cEffectLava = 7;
  cEffectNapalm = 8;
  cEffectShell = 9;
  cEffectBullet = 10;

type

// ============================================================================
AIExplosion = Class(AIThing)
private
  fEffect: integer;
  fStrength: single;
  fDiminish: single;
  fBlastRadius: single;
public
  Constructor Create(aParent: pointer);

  property Effect: integer read fEffect write fEffect;
  property Strength: single read fStrength write fStrength;
  property Diminish: single read fDiminish write fDiminish;
  property BlastRadius: single read fBlastRadius write fBlastRadius;

  procedure Fuel; override;
  procedure Shrapnel;
  function Digest(const aAmount: integer): integer; override;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIBomb = Class(AIThing)
private
  fTimer: integer;
  fEffect: integer;
  fStrength: single;
  fDiminish: single;
  fBlastRadius: single;
public
  Constructor Create(aParent: pointer);

  property Timer: integer read fTimer write fTimer;
  property Effect: integer read fEffect write fEffect;
  property Strength: single read fStrength write fStrength;
  property Diminish: single read fDiminish write fDiminish;
  property BlastRadius: single read fBlastRadius write fBlastRadius;

  procedure Fuel; override;
  procedure Explode;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cGlobals, cAIGrid, cAIPosition;

// ----------------------------------------------------------------------------
Constructor AIBomb.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cBomb;
  Timer := 128;
  Strength := 0.175;
  Effect := cEffectFire;
  Diminish := 0.025;
  BlastRadius := 25;
  Position.SetSize(0.25, 0.25, 0.3, true);
end;

// ----------------------------------------------------------------------------
// this kind of code works good: constantly running a fast check for the expensive occasion
procedure AIBomb.Fuel;
begin
  inherited Fuel;

  if (Age >= Timer) then
    Explode;
end;

// ----------------------------------------------------------------------------
procedure AIBomb.Explode;
var
  myExplosion: AIExplosion;
begin
  Cease;

  if (Effect = cEffectShell) or (Effect = cEffectBullet) then
    exit;

  myExplosion := AIExplosion(gThings.NewThing(cExplosion));
  if not (myExplosion = nil) then
  begin
    myExplosion.Position.CopyCoords(Position);
    myExplosion.Strength := Strength;
    myExplosion.Effect := Effect;
    myExplosion.Diminish := Diminish;
    myExplosion.BlastRadius := BlastRadius;
  end;
end;

// ----------------------------------------------------------------------------
Constructor AIExplosion.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cExplosion;
  Effect := cEffectFire;
  Strength := 0.5;
  Diminish := 0.1;
  BlastRadius := 25;
  Position.Tangible := false;
  Position.Collider := false;
end;

// ----------------------------------------------------------------------------
procedure AIExplosion.Fuel;
var
  myGrid: AIGrid;
begin
  inherited Fuel;

  Shrapnel;

  // change temp
  myGrid := AIGrid(Position.Location);
  if not (Position.Binding = bindSpace) then
    myGrid.AlterTemperature(0.1);
  if Position.Height < (Position.Water + BlastRadius) then
    myGrid.Splash(Strength); 

  gEnvironment.Things.Existents.ApplyOriginatingForceToAll(Position, Strength*10, BlastRadius);
  gEnvironment.Things.Existents.ApplyDamage(Position, 512, BlastRadius);

  Strength := Strength - Diminish;
  if Strength <= 0 then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AIExplosion.Shrapnel;
var
  myBomb: AIBomb;
begin
  myBomb := gEnvironment.Things.Tables[cBomb].NearestOfKind(cBomb, Position, BlastRadius);

  if not (myBomb = nil) then
    myBomb.Timer := 0;
end;

// ----------------------------------------------------------------------------
procedure AIExplosion.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fEffect);
  writeln(aFile, fStrength);
  writeln(aFile, fDiminish);
  writeln(aFile, fBlastRadius);
end;

// ----------------------------------------------------------------------------
procedure AIExplosion.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fEffect);
  readln(aFile, fStrength);
  readln(aFile, fDiminish);
  readln(aFile, fBlastRadius);
end;

// ----------------------------------------------------------------------------
procedure AIBomb.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fTimer);
  writeln(aFile, fEffect);
  writeln(aFile, fStrength);
  writeln(aFile, fDiminish);
  writeln(aFile, fBlastRadius);
end;

// ----------------------------------------------------------------------------
procedure AIBomb.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fTimer);
  readln(aFile, fEffect);
  readln(aFile, fStrength);
  readln(aFile, fDiminish);
  readln(aFile, fBlastRadius);
end;

// ----------------------------------------------------------------------------
function AIExplosion.Digest(const aAmount: integer): integer;
begin
  result := -1 * aAmount;
end;

end.

