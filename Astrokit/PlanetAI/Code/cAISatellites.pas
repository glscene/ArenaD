{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAISatellites.pas,v 1.32 2003/09/17 08:04:59 aidave Exp $
}
unit cAISatellites;

interface

uses System.Classes, cAIThings, cAIGrid, cAICoordinates, cAILife, cAIPosition,
  cAIForce;

type

// ============================================================================
AISatellite = Class(AIThing)
private
  fSize: single;       // size of object; radius
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Size: single read fSize write fSize;

  procedure Fuel; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIOrbiter = Class(AISatellite)
private
  fRadius: integer;     // how many squares the sun shines on
  fRate: single;       // qualitative rate of effect
public
  property Rate: single read fRate write fRate;
  property Radius: integer read fRadius write fRadius;

  procedure Fuel; override;

  procedure Explode; virtual; abstract; // when collide, explode into smaller, falling pieces
  procedure OnCollide(aCollider: AIThing); override;

  procedure Perform(aActivity: integer); override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AISun = Class(AIOrbiter)
private
  fSwing: boolean;
public
  Constructor Create(aParent: pointer);
  property Swing: boolean read fSwing;

  procedure Explode; override;
  procedure Fuel; override;
  procedure FullDisplay(aList: TStrings); override;
end;

// ============================================================================
AIMoon = Class(AIOrbiter)
public
  Constructor Create(aParent: pointer);
  procedure Explode; override;
  procedure Fuel; override;
end;

// ============================================================================
AIAsteroid = Class(AIThing)
private
  fEnergy: integer;
  fBurning: boolean;
  fSize: single;
  fMarkers: integer;
public
  Constructor Create(aParent: pointer);
  property Energy: integer read fEnergy write fEnergy;
  property Burning: boolean read fBurning write fBurning;
  property Size: single read fSize write fSize;
  property Markers: integer read fMarkers write fMarkers;

  procedure Smash;
  procedure Burn;
  procedure Fuel; override;
  procedure Mark;
  procedure UnMark;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAISpace, cAIExplosions, cGlobals,
  cUtilities, cAIVibes, cAIWeather;

// ----------------------------------------------------------------------------
Constructor AISatellite.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Position.Binding := bindSpace;
  Position.DirectionH := Pi;
end;

// ----------------------------------------------------------------------------
Destructor AISatellite.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AISatellite.Fuel;
begin
  inherited Fuel;

  // counteract gravity
  Position.Velocity.DeltaHeight := 0;
end;

// ----------------------------------------------------------------------------
Constructor AISun.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cSun;
  Rate := 0.3;
  Radius := 5;
  Size := 2.0;
  Position.SetPosition(Random*gWorldWidth, gHalfWorldHeight, 420);
  Position.Velocity.SetForce(0.05, 0.0, 0.0);
  Position.Mass := 1000;
end;

// ----------------------------------------------------------------------------
procedure AISun.Fuel;
var
  myReach: integer;
  myExtend: AIGrid;
begin
  inherited Fuel;

{  if Position.Y < gOneQuarterWorldHeight then
    Position.Velocity.DeltaY := 0.01;
  if Position.Y > gThreeQuartersWorldHeight then
    Position.Velocity.DeltaY := -0.01;
 }
  // find random square by radius
  myExtend := AIGrid(Position.Location);
  for myReach := 0 to Radius - 1 do
  begin
    case Random(4) of
      cDirectionUp:     myExtend := myExtend.ConnectionUp;
      cDirectionDown:   myExtend := myExtend.ConnectionDown;
      cDirectionLeft:   myExtend := myExtend.ConnectionLeft;
      cDirectionRight:  myExtend := myExtend.ConnectionRight;
    end;
  end;

  // heat the square, unless there are clouds
  myExtend.AlterTemperature(Rate);
end;

// ----------------------------------------------------------------------------
procedure AISun.Explode;
var
  myAsteroid: AIAsteroid;
  i: integer;
begin
  for i := 0 to 25 do
  begin
    myAsteroid := AIAsteroid(gThings.NewThing(cAsteroid));
    if Assigned(myAsteroid) then
    begin
      myAsteroid.Energy := 20;
      myAsteroid.Position.CopyCoords(Position);
      myAsteroid.Position.Velocity.ApplyForce(RandomSwing * 1, RandomSwing * 1, 0);
      myAsteroid.Position.Velocity.DeltaHeight := RandomSwing * 0.4;
    end;
  end;

  Cease;
end;

// ----------------------------------------------------------------------------
Constructor AIMoon.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cMoon;
  Rate := 0.2;
  Radius := 1;
  Size := 0.75;
  Position.SetPosition(Random*gWorldWidth, Random*gWorldHeight, 200);
  Position.Velocity.SetForce(0.01, 0.1, 0.0);
  Position.Mass := 100;
end;

// ----------------------------------------------------------------------------
procedure AIMoon.Fuel;
var
//  myReach: integer;
  myExtend: AIGrid;
begin
  inherited Fuel;

  // find random square by radius
  myExtend := AIGrid(Position.Location);
  // cause a tide
  myExtend.SuckWater(0.1);

//  for myReach := 0 to Radius - 1 do
//    myExtend := myExtend.RandomConnection;

  // cool the square
  myExtend.AlterTemperature(-0.01);

end;

// ----------------------------------------------------------------------------
procedure AIMoon.Explode;
var
  myAsteroid: AIAsteroid;
  i: integer;
begin
  for i := 0 to 10 do
  begin
    myAsteroid := AIGrid(Position.Location).NewThing(cAsteroid);
    if Assigned(myAsteroid) then
    begin
      myAsteroid.Energy := -15;
      myAsteroid.Position.CopyCoords(Position);
      myAsteroid.Position.Velocity.ApplyForce(RandomSwing * 1, RandomSwing * 1, 0);
      myAsteroid.Position.Velocity.DeltaHeight := RandomSwing * 0.4;
    end;
  end;

  Cease;
end;

// ----------------------------------------------------------------------------
Constructor AIAsteroid.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cAsteroid;

  Energy := 0;
  Size := Random(20);

  Position.Height := 750 + gThings.Counters[cAsteroid]*20.0;
  Position.Velocity.SetForce(0.0, 0.0, -1.0);
  Position.SetSize(2, 2, 2, true);
  Position.SetProperties(15, 0, 0);
  Position.DirectionH := Pi;
  Markers := 0;
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.Fuel;
begin
  inherited Fuel;

  if Position.Height <= Position.Land then
    Smash;

  if (Position.Height < 100) then
  begin
    if not Burning then
      Noise(cNoiseFall, 1);
    Burn;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIOrbiter.Fuel;
begin
  inherited Fuel;

  if (Position.Binding = bindLand) then Explode;
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.Smash;
var
  myExplosion: AIExplosion;
  myEarthquake: AIEarthquake;
  myLand: single;
  Location: AIGrid;
begin
  Location := AIGrid(Position.Location);

  // change temp
  Location.AlterTemperature(Energy+2);
  // make a crater
  myLand := Min(Location.Height, Size/2);
  if myLand > 0 then
  begin
    Location.AlterHeight(-1 * myLand);
    Location.RaiseSurroundingHeightsBy(myLand/5);
  end;
  // splash water
  if Location.UnderWater then
    Location.Splash(Location.SeaWater/2);

  myExplosion := nil;
  if (Energy >= 0) or (not Position.UnderWater) then
    myExplosion := AIExplosion(Location.NewThing(cExplosion));
  Noise(cNoiseSmash, 1);
  if Assigned(myExplosion) then
  begin
    myExplosion.Position.CopyCoords(Position);
    myExplosion.Position.Velocity.Zero;
    myExplosion.Position.Acceleration.Zero;
    myExplosion.Effect := cEffectBlast;
    myExplosion.BlastRadius := 10;
    myExplosion.Strength := 0.0100;
    myExplosion.Diminish := 0.0001;
    myExplosion.Position.Fuel;
  end;

  // create or add to earthquake
  if gThings.Counters[cEarthquake] > 0 then
    myEarthquake := gThings.Tables[cEarthquake].FirstOfKind(cEarthquake)
  else
    myEarthquake := AIEarthquake(Location.NewThing(cEarthquake));
  if Assigned(myEarthquake) then
  begin
    myEarthquake.Rumble := myEarthquake.Rumble + 0.2;
  end;

  Cease;
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.Burn;
begin
  fBurning := true;
  Size := Size - 0.1;
  if Size <= 0 then
    Cease; 
end;

// ----------------------------------------------------------------------------
procedure AISatellite.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fSize);
end;

// ----------------------------------------------------------------------------
procedure AISatellite.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fSize);
end;

// ----------------------------------------------------------------------------
procedure AIOrbiter.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fRate);
  writeln(aFile, fRadius);
end;

// ----------------------------------------------------------------------------
procedure AIOrbiter.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fRate);
  readln(aFile, fRadius);
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fEnergy);
  writeln(aFile, fSize);
  writeFileBoolean(aFile, fBurning);
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fEnergy);
  readln(aFile, fSize);
  fBurning := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
procedure AISatellite.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add(Format('Size: %0.2f', [fSize]));
end;

// ----------------------------------------------------------------------------
procedure AIOrbiter.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Radius: ' + IntToStr(fRadius));
  aList.Add(Format('Rate: %0.2f', [fRate]));
end;

// ----------------------------------------------------------------------------
procedure AISun.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Swing: ' + BoolToYesNoStr(fSwing));
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Energy: ' + IntToStr(fEnergy));
  aList.Add(Format('Size: %0.2f', [fSize]));
  aList.Add('Burning: ' + BoolToYesNoStr(fBurning));
end;

// ----------------------------------------------------------------------------
procedure AIOrbiter.Perform(aActivity: integer);
begin
  case aActivity of
    0: Explode;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIOrbiter.OnCollide(aCollider: AIThing);
begin
  if aCollider is AISatellite then
    Explode;
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.Mark;
begin
  fMarkers := fMarkers + 1;
end;

// ----------------------------------------------------------------------------
procedure AIAsteroid.UnMark;
begin
  fMarkers := fMarkers - 1;
end;

end.

