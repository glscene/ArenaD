{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIVibes.pas,v 1.14 2003/08/31 01:31:33 aidave Exp $
}
unit cAIVibes;

interface

uses
  System.Classes,
  cAIBaseObject,
  cAIThings,
  cAIPosition,
  cAILife,
  GLS.VectorGeometry;

const
  cEffectNoise = 0;
  cEffectShake = 1;
  cEffectStopShake = 2;
  cEffectSpeech = 3;

  cNoisePing = 0;
  cNoiseFire = 1;
  cNoiseQuake = 2;
  cNoiseRain = 3;
  cNoiseBirdChirp = 4;
  cNoisePop = 5;
  cNoiseSquawk = 6;
  cNoiseFall = 7;
  cNoiseCricket = 8;
  cNoiseEat = 9;
  cNoiseExplode = 10;
  cNoiseForest = 11;
  cNoiseHawk = 12;
  cNoiseRoar = 13;
  cNoiseBirdHungry = 16;
  cNoiseBirdHappy = 17;
  cNoiseKick = 18;
  cNoiseGrab = 19;
  cNoiseDrop = 22;
  cNoiseWeaponFire = 20;
  cNoiseSmash = 21;
  cNoiseThrow = 22;
  cNoiseUproot = 23;
  cNoiseSploosh = 24;
  cNoiseMouseLow = 25;
  cNoiseMouseHigh = 26;
  cNoiseYowl = 27;
  cNoiseQuack = 28;
  cNoiseDuckling = 29;

type

// ============================================================================
// an individual vibe
AIVibe = Class(AIThing)
private
  fEffectType: integer;
  fEffectIndex: integer;
  fSensoryType: integer;
  fTimerDeath: integer;
public
  Constructor Create(aParent: pointer);

  property EffectType: integer read fEffectType write fEffectType;
  property EffectIndex: integer read fEffectIndex write fEffectIndex;
  property SensoryType: integer read fSensoryType write fSensoryType;
  property TimerDeath: integer read fTimerDeath write fTimerDeath;

  procedure SetVibe(aEffectType, aEffectIndex, aTimerDeath: integer);

  procedure Fuel; override;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
// an visible string of text
AISpeech = Class(AIThing)
private
  fText: string;          // text to communicate
  fRadius: single;        // how widely can it be "heard"
  fTimerDeath: integer;   // how long will this stick around?
public
  Constructor Create(aParent: pointer);

  property Text: string read fText write fText;
  property Radius: single read fRadius write fRadius;
  property TimerDeath: integer read fTimerDeath write fTimerDeath;

  procedure Fuel; override;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

// ----------------------------------------------------------------------------
Constructor AIVibe.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cVibe;

  Position.SetPosition(0, 0, 0);
  Position.SetSize(0, 0, 0, false);
  Position.SetProperties(100000, 0, 0);
  Position.Collider := false;
  Position.Tangible := false;
end;

// ----------------------------------------------------------------------------
procedure AIVibe.Fuel;
begin
  inherited Fuel;

  if Age >= TimerDeath then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AIVibe.SetVibe(aEffectType, aEffectIndex, aTimerDeath: integer);
begin
  fEffectType := aEffectType;
  fEffectIndex := aEffectIndex;
  fTimerDeath := aTimerDeath;
end;

// ----------------------------------------------------------------------------
procedure AIVibe.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fEffectType);
  writeln(aFile, fEffectIndex);
  writeln(aFile, fSensoryType);
  writeln(aFile, fTimerDeath);
end;

// ----------------------------------------------------------------------------
procedure AIVibe.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fEffectType);
  readln(aFile, fEffectIndex);
  readln(aFile, fSensoryType);
  readln(aFile, fTimerDeath);
end;

// ----------------------------------------------------------------------------
Constructor AISpeech.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cSpeech;

  Position.SetSize(0, 0, 0, false);
  Position.SetProperties(100000, 0, 0);
  Position.Collider := false;
  Position.Tangible := false;
  Radius := 10.0;
end;

// ----------------------------------------------------------------------------
procedure AISpeech.Fuel;
begin
  inherited Fuel;

  if Age >= TimerDeath then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AISpeech.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fText);
  writeln(aFile, fRadius);
  writeln(aFile, fTimerDeath);
end;

// ----------------------------------------------------------------------------
procedure AISpeech.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fText);
  readln(aFile, fRadius);
  readln(aFile, fTimerDeath);
end;

end.
