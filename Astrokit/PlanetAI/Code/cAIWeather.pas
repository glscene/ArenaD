{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIWeather.pas,v 1.29 2003/09/03 00:14:14 aidave Exp $
}
unit cAIWeather;

interface

uses System.Classes, cAIThings, cAIGrid, cAICoordinates, cAILife, cAIPosition,
  cAIForce, cAISatellites;

type

// ============================================================================
AICloud = Class(AIThing)
private
  fWater: single;
  fRaining: boolean;
  fStorm: boolean;
  procedure Separate;
public
  Constructor Create(aParent: pointer);

  property Water: single read fWater write fWater;
  property Raining: boolean read fRaining write fRaining;
  property Storm: boolean read fStorm write fStorm;
  procedure LightningStrike;
  procedure Fuel; override;

  procedure Perform(aActivity: integer); override;
  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AILightning = Class(AIThing)
private
  fLifeTime: integer;
protected
  procedure Shock;
public
  Constructor Create(aParent: pointer);

  property LifeTime: integer read fLifeTime write fLifeTime;

  procedure Fuel; override;
  function Digest(const aAmount: integer): integer; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIIceberg = Class(AIThing)
private
  fWater: single;
public
  Constructor Create(aParent: pointer);

  property Water: single read fWater write fWater;
  procedure Fuel; override;
  procedure Separate;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIAurora = Class(AISatellite)
private
  fLuminosity: single;
public
  procedure Fuel; override;
end;

// ============================================================================
AIEarthquake = Class(AIThing)
private
  fRumble: single;
  procedure SetRumble(aValue: single);
protected
  procedure Shake;
public
  Constructor Create(aParent: pointer);

  property Rumble: single read fRumble write SetRumble;

  procedure Fuel; override;
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAISpace, cAIExplosions, cGlobals,
  cUtilities, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AICloud.Create;
begin
  inherited Create(aParent);

  Kind := cCloud;

  Water := 1 + Random*2;
  Raining := false;
  Storm := false;
  if Random(8) = 0 then
    Raining := true;

  Position.Height := 50 - Random*5;
  Position.SetProperties(10, 0, 1);
  Position.Collider := false;
  Position.DirectionH := Pi;
end;

// ----------------------------------------------------------------------------
procedure AICloud.Fuel;
var
  Location: AIGrid;
begin
  inherited Fuel;

  if Water <= 0 then
    Cease;

  // if sinking then rise
  if Position.Height < (40 + Water) then
  begin
    Position.Velocity.DeltaHeight := Position.Velocity.DeltaHeight + 0.025;
    if Position.Height < (38 + Water) then
      Position.Velocity.DeltaHeight := Position.Velocity.DeltaHeight + 0.05;
  end;

  Location := AIGrid(Position.Location);

  // rain
  if Raining then
  begin
    if (Age mod 12 = 0) then
      Noise(cNoiseRain, 1);

    if fWater > 0.25 then
    begin
      gSpace.QueueChange(Location, cEventAddWater, 0.025);
      Water := Water - 0.025;
    end
    else
    begin
      gSpace.QueueChange(Location, cEventAddWater, Water);
      Water := 0;
    end;

    if Location.Temperature > 7 then
      Location.AlterTemperature(-0.1);
  end;

  if Storm then
  begin
    if (Age mod 4 = 0) and (Random(32) = 0) and (Water > 3) then
      LightningStrike;
  end;

  if Age = 2048 then
  begin
    Raining := true;
    Noise(cNoiseRain, 1);
  end;

  // grow
  if Location.Humidity > 2 then
  begin
    Water := Water + 0.1;
    Location.AlterHumidity(-0.1);
    if Water > 10 then
      Separate;
  end;
end;

// ----------------------------------------------------------------------------
procedure AICloud.Separate;
var
  myBrotherCloud: AICloud;
begin
  if Random(2) = 0 then
  begin
    Raining := true;
    Noise(cNoiseRain, 1);
  end;

  if not gThings.CanAdd(cCloud) then
    exit;

  if Random(32) = 0 then Storm := true;

  myBrotherCloud := AICloud(gThings.NewThing(cCloud));
  myBrotherCloud.Water := Water/2;
  myBrotherCloud.Position.CopyCoords(Position);
  myBrotherCloud.Position.Velocity.ApplyForce(RandomSwing * 0.05, RandomSwing * 0.05, 0);
  Position.Velocity.ApplyForce(RandomSwing * 0.05, RandomSwing * 0.05, 0);
  myBrotherCloud.Storm := Storm;
  if Random(4) = 0 then
    myBrotherCloud.Raining := true;
  Water := Water/2;
end;

// ----------------------------------------------------------------------------
procedure AICloud.LightningStrike;
var
  myLightning: AILightning;
begin
  if not gThings.CanAdd(cLightning) then
    exit;

  myLightning := AILightning(gThings.NewThing(cLightning));
  myLightning.Position.CopyCoords(Position);
  myLightning.LifeTime := 8;
  myLightning.Position.Fuel;
end;

// ----------------------------------------------------------------------------
Constructor AILightning.Create;
begin
  inherited Create(aParent);

  Kind := cLightning;

  Position.SetSize(0.75, 0.75, 0.4, false);
  Position.SetProperties(10000, 0, 0);
  Position.Collider := false;
  LifeTime := 16;
  Position.DirectionH := Pi;
end;

// ----------------------------------------------------------------------------
procedure AILightning.Fuel;
begin
  inherited Fuel;

  Position.Velocity.Zero;

  if (Age = 1) and (Position.Land > Position.Water) then
    Shock;

  if (Age > fLifeTime) then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AILightning.Shock;
var
  myExplosion: AIExplosion;
begin
  if not gThings.CanAdd(cExplosion) then
    exit;

  myExplosion := AIExplosion(gThings.NewThing(cExplosion));
  myExplosion.Position.CopyCoords(Position);
  myExplosion.Position.Height := 0;
  myExplosion.Effect := cEffectBlast;
  myExplosion.Strength := 0.005;
  myExplosion.Diminish := 0.00025;
  myExplosion.BlastRadius := 3;
  myExplosion.Position.Fuel;
end;

// ----------------------------------------------------------------------------
procedure AICloud.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fWater);
  writeFileBoolean(aFile, fRaining);
  writeFileBoolean(aFile, fStorm);
end;

// ----------------------------------------------------------------------------
procedure AICloud.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fWater);
  fRaining := readFileBoolean(aFile);
  fStorm := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
procedure AILightning.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AILightning.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIAurora.Fuel;
begin
  inherited Fuel;

  fLuminosity := fLuminosity - Random * 0.1 + 0.025;
  if fLuminosity < 0 then
    Cease;
end;

// ----------------------------------------------------------------------------
function AICloud.OneLineDisplay: string;
begin
  result := Format('Cloud %d Water=%0.2f ', [Handle, Water])
    + 'Rain=' + BoolToYesNoStr(Raining)
    + ' Storm=' + BoolToYesNoStr(Storm)
    + ' ' + Position.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIIceberg.Separate;
var
  myBrotherIceberg: AIIceberg;
begin
  if not gThings.CanAdd(cIceberg) then
    exit;

  myBrotherIceberg := AIIceberg(gThings.NewThing(cIceberg));
  myBrotherIceberg.Water := Water/2;
  myBrotherIceberg.Position.CopyCoords(Position);
  myBrotherIceberg.Position.Velocity.ApplyForce(RandomSwing * 1.75, RandomSwing * 1.75, 0);
  Position.Velocity.ApplyOppositeForce(myBrotherIceberg.Position.Velocity);

  Water := Water / 2;
end;

// ----------------------------------------------------------------------------
procedure AIIceberg.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fWater);
end;

// ----------------------------------------------------------------------------
procedure AIIceberg.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fWater);
end;

// ----------------------------------------------------------------------------
Constructor AIIceberg.Create;
begin
  inherited Create(aParent);

  Kind := cIceberg;
  fWater := 10.0 + Random*20;
  Position.SetSize(Water/10, Water/10, Water/10, true);
  Position.Mass := Water;
  Position.Buoyancy := Water * 0.6;
end;

// ----------------------------------------------------------------------------
procedure AIIceberg.Fuel;
var
  Location: AIGrid;
begin
  inherited Fuel;

  if Water <= 0 then
    Cease;

  Location := AIGrid(Position.Location);

//  Melting := ;

  // rain
  if Location.Temperature > 0 then
  begin
    gSpace.QueueChange(Location, cEventAddWater, Location.Temperature/100);
    Water := Water - Location.Temperature/100;
    if Location.Temperature > 1 then
      Location.AlterTemperature(-0.02);
  end
  else
  begin
    if Location.UnderWater and (Water < 100) then
    begin
      gSpace.QueueChange(Location, cEventAddWater, -0.1);
      Water := Water + 0.1;
    end;

//    if Water > 50 then
//      Separate;
  end;

  Position.SetSize(Water/20, Water/20, Water/20);
  Position.Mass := Water;
  Position.Buoyancy := Water * 0.6;
end;

// ----------------------------------------------------------------------------
procedure AICloud.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add(Format('Water: %0.2f', [fWater]));
  aList.Add('Raining: ' + BoolToYesNoStr(fRaining));
  aList.Add('Storm: ' + BoolToYesNoStr(fStorm));
end;

// ----------------------------------------------------------------------------
procedure AICloud.Perform(aActivity: integer);
begin
  case aActivity of
    0: LightningStrike;
    1: Separate;
    2: Raining := not Raining;
    3: Storm := not Storm;
  end;
end;

// ----------------------------------------------------------------------------
procedure AILightning.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('LifeTime: ' + IntToStr(fLifeTime));
end;

// ----------------------------------------------------------------------------
procedure AIIceberg.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add(Format('Water: %0.2f', [fWater]));
end;

// ----------------------------------------------------------------------------
function AILightning.Digest(const aAmount: integer): integer;
begin
  result := -10000;
end;

// ----------------------------------------------------------------------------
Constructor AIEarthquake.Create;
begin
  inherited Create(aParent);

  Kind := cEarthquake;

  Position.SetSize(0, 0, 0, false);
  Position.SetProperties(10000, 0, 0);
  Position.Tangible := false;
  Position.Collider := false;
  Rumble := 0.1;
  Noise(cNoiseQuake, 1);
end;

// ----------------------------------------------------------------------------
procedure AIEarthquake.SetRumble(aValue: single);
begin
  fRumble := aValue;
  if fRumble > 10 then
      fRumble := 10;
end;

// ----------------------------------------------------------------------------
procedure AIEarthquake.Fuel;
begin
  inherited Fuel;

  Shake;
  if Random(8) = 0 then
    Noise(cNoiseQuake, 1);

  fRumble := fRumble - 0.05;
  if fRumble <= 0 then
  begin
    Cease;
    Vibrate(cEffectStopShake, 0, 1);
  end
  else
    Vibrate(cEffectShake, 0, 1);
end;

// ----------------------------------------------------------------------------
procedure AIEarthquake.Shake;
begin
  gThings.Existents.ShakeLand(fRumble/10);
end;

// ----------------------------------------------------------------------------
procedure AIEarthquake.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add(Format('Rumble: %0.2f', [fRumble]));
end;

// ----------------------------------------------------------------------------
procedure AIEarthquake.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fRumble);
end;

// ----------------------------------------------------------------------------
procedure AIEarthquake.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fRumble);
end;

end.

