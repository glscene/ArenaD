{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIGrid;
{
  Node AIGrid

  This class holds the grid component of the map.
}
interface

uses
  cAIBaseObject,
  cAICoordinates,
  cAIThingReferenceList,

  GLS.VectorTypes,
  GLS.VectorGeometry;

const
  // water levels
  wlDesert = 0;
  wlDirt = 10;
  wlField = 50;
  wlGrass = 100;

  wlPond = 0;
  wlLake = 20;
  wlSea = 50;
  wlOcean = 200;

  // land states
  lsGrass = 0;
  lsDirt = 1;
  lsField = 2;
  lsDesert = 3;

  lsSea = 4;
  lsPond = 5;
  lsLake = 6;
  lsOcean = 7;

  lsGlacier = 9;

  cWaterFloor = 0;
  cWaterCeiling = 200;
  cHeightFloor = 0;
  cHeightCeiling = 40;
  cTemperatureFloor = 0;
  cTemperatureCeiling = 10;
  cHumidityFloor = 0;
  cHumidityCeiling = 10;

  cWaterSurfaceTension = 0.25; // how much water there needs to be before it spills

  cWaterUpLeft = 0;
  cWaterUpRight = 1;
  cWaterDownLeft = 2;
  cWaterDownRight = 3;
  cHeightUpLeft = 4;
  cHeightUpRight = 5;
  cHeightDownLeft = 6;
  cHeightDownRight = 7;
  cHeightUp = 8;
  cHeightDown = 9;
  cHeightLeft = 10;
  cHeightRight = 11;

  cMaxTempFlow = 0.5;
type

AIHeightArray = array of single;

// ============================================================================
AIGrid = Class(AIBaseObject)
private
  // Atmosphere
  fTemperature: single;   // temperature of atmosphere
  fHumidity: single;      // humidity of atmosphere
  // Land
  fWater: single;         // water on land
  fHeight: single;        // height of land

  fNormal: TAffineVector;

  fChanged: boolean;
  fUnderWater: boolean;

  // water wave
  fWave: TAffineVector;
  fWind: TAffineVector;
  fWindy: boolean; // is it windy?
  fWavy: boolean;  // is it wavy?

  // set at runtime by AISpace.ConnectMap
  fAtTop: boolean;        // at top of map?
  fAtBottom: boolean;     // at bottom of map?

  fCornerValues: AIHeightArray;
  fWaterMax: single;
  fLandMax: single;

  // links
  fConnectionUp: AIGrid;
  fConnectionDown: AIGrid;
  fConnectionLeft: AIGrid;
  fConnectionRight: AIGrid;
  fConnectionUpLeft: AIGrid;
  fConnectionUpRight: AIGrid;
  fConnectionDownLeft: AIGrid;
  fConnectionDownRight: AIGrid;

  fWaterCrossover: pointer; // for external convenience

  // owned
  fCoordinates: AICoordinates;

  procedure SetWater(aAmount: single);
  procedure SetHumidity(aAmount: single);
  procedure SetTemperature(aAmount: single);
  procedure SetHeight(aAmount: single);

  procedure QueueMoveWater(
    aAmount: single;
    aDestination: AIGrid);
protected
  procedure JiggleWater;
  procedure SetChanged(aValue: boolean);
  procedure CalculateWind;
  procedure CalculateLandMax;
public
  Constructor Create(
    aSpace: pointer;
    X: integer;
    Y: integer);
  Destructor Destroy; override;

  property Water: single read fWater write SetWater;
  property Humidity: single read fHumidity write SetHumidity;
  property Temperature: single read fTemperature write SetTemperature;
  property Height: single read fHeight write SetHeight;

  property UnderWater: boolean read fUnderwater;
  property Changed: boolean read fChanged write fChanged;
  property WaterCrossover: pointer read fWaterCrossover write fWaterCrossover;
  property Normal: TAffineVector read fNormal;
  property Wave: TAffineVector read fWave write fWave;
  property Wind: TAffineVector read fWind write fWind;
  property Wavy: boolean read fWavy;
  property Windy: boolean read fWindy;
  property WaterMax: single read fWaterMax;
  property LandMax: single read fLandMax;

  // change by amount
  procedure AlterWater(aAmount: single);
  procedure AlterHumidity(aAmount: single);
  procedure AlterTemperature(aAmount: single);
  procedure AlterHeight(aAmount: single);

  // ENVIRONMENT CALLS ONLY
  procedure ChangeWater(aAmount: single);
  procedure ChangeHumidity(aAmount: single);
  procedure ChangeTemperature(aAmount: single);
  procedure ChangeHeight(aAmount: single);

  property Coordinates: AICoordinates read fCoordinates;
  property AtTop: boolean read fAtTop write fAtTop;
  property AtBottom: boolean read fAtBottom write fAtBottom;

  property ConnectionUp: AIGrid read fConnectionUp write fConnectionUp;
  property ConnectionDown: AIGrid read fConnectionDown write fConnectionDown;
  property ConnectionLeft: AIGrid read fConnectionLeft;
  property ConnectionRight: AIGrid read fConnectionRight;
  property ConnectionUpLeft: AIGrid read fConnectionUpLeft;
  property ConnectionUpRight: AIGrid read fConnectionUpRight;
  property ConnectionDownLeft: AIGrid read fConnectionDownLeft;
  property ConnectionDownRight: AIGrid read fConnectionDownRight;
  property CornerValues: AIHeightArray read fCornerValues;

  procedure CalculateHeights;
  procedure CalculateFullHeights;
  procedure CalculateWaters;
  procedure CalculateFullWaters;

  function DetermineLandHeight(aX, aY: single): single;
  function DetermineWaterHeight(aX, aY: single): single;

  function RandomConnection: AIGrid;
  function Connection(aDirection: integer): AIGrid;
  function AtPole: boolean;

  procedure DefaultSettings;

  procedure Connect(
    aConnectionUp: AIGrid;
    aConnectionDown: AIGrid;
    aConnectionLeft: AIGrid;
    aConnectionRight: AIGrid);
  procedure ConnectDiagonals;

  function OneLineDisplay: string; override;
  function Freezing: boolean;
  function IsGlacier: boolean;
  function Melting: boolean;
  function OverSaturated: boolean;
  function UnderSaturated: boolean;
  function ExcessSaturation: single;
  function SeaWater: single;
  function WaterHeight: single;
  function IsLand: boolean;
  function NoPlants: boolean;
  function SurroundedByWater: boolean;

  function LandState: integer;

  procedure RaiseSurroundingHeightsTo(newHeight: single);
  procedure RaiseSurroundingHeightsBy(newHeight: single);

  procedure Splash(aExcessWater: single);          // water spills into adjacent squares
  procedure Boil;           // temp turns water into humidity
  procedure Condense;       // condense humidity into a cloud
  procedure Vibrate(aEffectType, aEffectIndex, aTimerDeath: integer);
  procedure SuckWater(aAmount: single);  // sucks water from surrounding squares
  procedure FreezeWater; // create an iceberg

  procedure Stabalize;    // validate grid
  procedure Naturalize;   // uncommon effects on grid

  function NewThing(aKind: integer): pointer;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

AIDimensions = array of array of AIGrid;

implementation

uses
  System.SysUtils, cAIEnvironment, cAIThings, cAISpace, cAISatellites, cUtilities,
  cGlobals, cAIPosition, cAIWeather, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AIGrid.Create(
    aSpace: pointer; X: integer; Y: integer);
begin
  inherited Create(aSpace);

  Handle := UniqueHandle;

  fCoordinates := AICoordinates.Create(self, X, Y);

  SetLength(fCornerValues, 12);

  fChanged := true;
end;

// ----------------------------------------------------------------------------
Destructor AIGrid.Destroy;
begin
  fCoordinates.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.Connect(
    aConnectionUp: AIGrid;
    aConnectionDown: AIGrid;
    aConnectionLeft: AIGrid;
    aConnectionRight: AIGrid);
begin
  fConnectionUp    := aConnectionUp;
  fConnectionDown  := aConnectionDown;
  fConnectionLeft  := aConnectionLeft;
  fConnectionRight := aConnectionRight;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.ConnectDiagonals;
begin
  fConnectionUpLeft := fConnectionLeft.ConnectionUp;
  fConnectionUpRight := fConnectionRight.ConnectionUp;
  fConnectionDownLeft := fConnectionLeft.ConnectionDown;
  fConnectionDownRight := fConnectionRight.ConnectionDown;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.SetChanged(aValue: boolean);
begin
  fChanged := aValue;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.SetWater(aAmount: single);
begin
  AlterWater(aAmount - fWater);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.SetHumidity(aAmount: single);
begin
  ChangeHumidity(aAmount - fHumidity);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.SetTemperature(aAmount: single);
begin
  ChangeTemperature(aAmount - fTemperature);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.SetHeight(aAmount: single);
begin
  AlterHeight(aAmount - fHeight);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.AlterWater(aAmount: single);
begin
  gSpace.QueueChange(self, cEventAddWater, aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.AlterHumidity(aAmount: single);
begin
  ChangeHumidity(aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.AlterTemperature(aAmount: single);
begin
  ChangeTemperature(aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.AlterHeight(aAmount: single);
begin
  gSpace.QueueChange(self, cEventAddHeight, aAmount);
end;

// ----------------------------------------------------------------------------
function AIGrid.RandomConnection: AIGrid;
begin
  case Random(4) of
    cDirectionUp:     result := ConnectionUp;
    cDirectionDown:   result := ConnectionDown;
    cDirectionLeft:   result := ConnectionLeft;
    cDirectionRight:  result := ConnectionRight;
    else result := nil;
  end;
end;

// ----------------------------------------------------------------------------
function AIGrid.Connection(aDirection: integer): AIGrid;
begin
  case aDirection of
    cDirectionUp:     result := ConnectionUp;
    cDirectionDown:   result := ConnectionDown;
    cDirectionLeft:   result := ConnectionLeft;
    cDirectionRight:  result := ConnectionRight;
    cDirectionNone:   result := self;
    else result := nil;
  end;
end;

// ----------------------------------------------------------------------------
function AIGrid.Freezing: boolean;
begin
  result := Temperature <= 0;
end;

// ----------------------------------------------------------------------------
function AIGrid.IsGlacier: boolean;
begin
  result := Freezing and (Water >= wlLake);
end;

// ----------------------------------------------------------------------------
function AIGrid.Melting: boolean;
begin
  result := false;
end;

// ----------------------------------------------------------------------------
// water is added to this grid
// first, add to the saturation table
// if that is full, then add to water
// if the land is sloped, then spill
procedure AIGrid.ChangeWater(aAmount: single);
begin
  if fUnderWater then
    JiggleWater;

  if aAmount = 0 then
    exit;

  if aAmount < 0 then
  begin
    gSpace.QueueChange(ConnectionUp, cEventAddWater, 0);
    gSpace.QueueChange(ConnectionDown, cEventAddWater, 0);
    gSpace.QueueChange(ConnectionLeft, cEventAddWater, 0);
    gSpace.QueueChange(ConnectionRight, cEventAddWater, 0);
  end;

  fWater := fWater + aAmount;
  fUnderWater := fWater > (fHeight);

  if fWater < cWaterFloor then
    fWater := cWaterFloor;

  CalculateFullWaters;

  AlterWater(0);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.JiggleWater;
var
  myWaterHeight: single;
  spillage: single;
  stable: boolean;
  runLeft, runRight, runUp, runDown: boolean;
  parts: single;
begin
  stable := true;
  runLeft := false;
  runRight := false;
  runUp := false;
  runDown := false;
  spillage := 0;
  parts := 0;

  fWave.X := 0;
  fWave.Y := 0;
  fWave.Z := 0;
  fWavy := false;

  // ASSUMED UNDERWATER
  myWaterHeight := Water - cWaterSurfaceTension;

  if myWaterHeight > ConnectionLeft.Water then
  begin
    stable := false;
    runLeft := true;
    parts := parts + 1;
    if spillage < Water - ConnectionLeft.Water then
      spillage := Water - ConnectionLeft.Water;
  end;

  if myWaterHeight > ConnectionRight.Water then
  begin
    stable := false;
    runRight := true;
    parts := parts + 1;
    if spillage < Water - ConnectionRight.Water then
      spillage := Water - ConnectionRight.Water;
  end;

  if myWaterHeight > ConnectionUp.Water then
  begin
    stable := false;
    runUp := true;
    parts := parts + 1;
    if spillage < Water - ConnectionUp.Water then
      spillage := Water - ConnectionUp.Water;
  end;

  if myWaterHeight > ConnectionDown.Water then
  begin
    stable := false;
    runDown := true;
    parts := parts + 1;
    if spillage < Water - ConnectionDown.Water then
      spillage := Water - ConnectionDown.Water;
  end;

  if not stable then
  begin
    gSpace.QueueChange(self, cEventAddWater, spillage/(-4));
    spillage := (spillage/4) / parts;
    if runLeft then
    begin
      gSpace.QueueChange(ConnectionLeft, cEventAddWater, spillage);
      fWave.X := fWave.X - spillage/10;
    end;
    if runRight then
    begin
      gSpace.QueueChange(ConnectionRight, cEventAddWater, spillage);
      fWave.X := fWave.X + spillage/10;
    end;
    if runUp then
    begin
      gSpace.QueueChange(ConnectionUp, cEventAddWater, spillage);
      fWave.Y := fWave.Y - spillage/10;
    end;
    if runDown then
    begin
      gSpace.QueueChange(ConnectionDown, cEventAddWater, spillage);
      fWave.Y := fWave.Y + spillage/10;
    end;
    fWavy := true;
  end;
end;

// ----------------------------------------------------------------------------
function AIGrid.WaterHeight: single;
begin
  if fHeight > fWater then
    result := fHeight
  else
    result := fWater;
end;

// ----------------------------------------------------------------------------
function AIGrid.OverSaturated: boolean;
begin
  result := fWater > fHeight;
end;

// ----------------------------------------------------------------------------
function AIGrid.ExcessSaturation: single;
begin
  result := fWater - fHeight;
end;

// ----------------------------------------------------------------------------
function AIGrid.UnderSaturated: boolean;
begin
  result := fWater < fHeight;
end;

// ----------------------------------------------------------------------------
function AIGrid.SeaWater: single;
begin
  result := 0;
  if fWater > fHeight then
    result := fWater - fHeight;
end;

// ----------------------------------------------------------------------------
function AIGrid.IsLand: boolean;
begin
  result := (SeaWater = 0);
end;

// ----------------------------------------------------------------------------
function AIGrid.NoPlants: boolean;
begin
  result := (SeaWater >= wlLake);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.Boil;
begin
  gSpace.QueueChange(self, cEventAddWater, -0.1);
  gSpace.QueueChange(self, cEventAddHumidity, 0.1);
  gSpace.QueueChange(self, cEventAddTemperature, -0.1);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.Condense;
var
  myCloud: AICloud;
begin
  myCloud := AICloud(NewThing(cCloud));
  if Assigned(myCloud) then
  begin
    myCloud.Water := 1;
    myCloud.Position.SetToCoordinates(Coordinates);
    myCloud.Position.RandomizeOffset;
    fHumidity := fHumidity - 1;
  end;

  gSpace.QueueChange(self, cEventAddTemperature, -0.1);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.Splash(aExcessWater: single);
var
  mySplash: single;
begin
  mySplash := aExcessWater/4;

  QueueMoveWater(mySplash, ConnectionUp);
  QueueMoveWater(mySplash, ConnectionDown);
  QueueMoveWater(mySplash, ConnectionLeft);
  QueueMoveWater(mySplash, ConnectionRight);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.ChangeHumidity(aAmount: single);
begin
  fHumidity := fHumidity + aAmount;

  if fHumidity > 9 then
    Condense;

  if fHumidity < 0 then
    fHumidity := 0;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.ChangeTemperature(aAmount: single);
begin
  fTemperature := fTemperature + aAmount;

{  if Melting then
  begin
    Spill(aAmount);
    fTemperature := fTemperature - aAmount;
  end;
 }
  if (fTemperature > cTemperatureCeiling) then
  begin
    if fWater > 0 then
      Boil
    else
      fTemperature := cTemperatureCeiling;
  end;


  if fTemperature < cTemperatureFloor then
  begin
    fTemperature := cTemperatureFloor;
    // create an iceberg
    if (fWater > 0.1) and (Random(128) = 0) then
      if not gThings.Tables[cIceberg].HasKindAtLocation(self, cIceberg) then
        FreezeWater;
  end;

  CalculateWind;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.ChangeHeight(aAmount: single);
begin
  fHeight := fHeight + aAmount;

  if fHeight < cHeightFloor then
    fHeight := cHeightFloor;

  if fHeight > cHeightCeiling then
    fHeight := cHeightCeiling;

  fUnderWater := fWater > (fHeight + cWaterSurfaceTension);

  CalculateFullHeights;

  if fUnderWater then
    JiggleWater;
end;

// ----------------------------------------------------------------------------
// returns the visual state of the land
//  desert, dirt, field, grass
function AIGrid.LandState: integer;
var
  myWaterHeight: single;
begin
  myWaterHeight := fWater - fHeight;

  if myWaterHeight > 1 then
  begin
    result := lsLake;
    if myWaterHeight > 40 then result := lsOcean;
    if myWaterHeight < 5 then result := lsLake;
    if myWaterHeight < 2.5 then result := lsPond;
    if SurroundedByWater then
      result := lsSea;
  end
  else
  begin
    result := lsDesert;
    if fWater > 1 then result := lsDirt;
    if fWater > 3 then result := lsField;
    if fWater > 5 then result := lsGrass;
  end;
end;

// ----------------------------------------------------------------------------
function AIGrid.SurroundedByWater: boolean;
begin
  result := true;
  if ConnectionLeft.IsLand or
    ConnectionRight.IsLand or
    ConnectionUp.IsLand or
    ConnectionDown.IsLand or
    ConnectionUpLeft.IsLand or
    ConnectionUpRight.IsLand or
    ConnectionDownLeft.IsLand or
    ConnectionDownRight.IsLand then
    result := false;
end;


// ----------------------------------------------------------------------------
function AIGrid.OneLineDisplay: string;
begin
  result :=
    Format('Water %.1f, Humid %.1f, Temp %.1f, Height %.1f ',
    [Water, Humidity, Temperature, Height])
    + Coordinates.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
function AIGrid.NewThing(aKind: integer): pointer;
begin
  result := gThings.NewThing(aKind, self);
end;

// ----------------------------------------------------------------------------
function AIGrid.AtPole: boolean;
begin
  result := AtTop or AtBottom;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  Coordinates.LoadFromFile(aFile);
  readln(aFile, fWater);
  readln(aFile, fTemperature);
  readln(aFile, fHumidity);
  readln(aFile, fHeight);
  readln(aFile, fNormal.X);
  readln(aFile, fNormal.Y);
  readln(aFile, fNormal.Z);
  fUnderWater := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  Coordinates.SaveToFile(aFile);
  writeln(aFile, fWater);
  writeln(aFile, fTemperature);
  writeln(aFile, fHumidity);
  writeln(aFile, fHeight);
  writeln(aFile, fNormal.X);
  writeln(aFile, fNormal.Y);
  writeln(aFile, fNormal.Z);
  writeFileBoolean(aFile, fUnderWater);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.Stabalize;
begin
  ChangeWater(0);
  ChangeHumidity(0);
  ChangeTemperature(0);
  ChangeHeight(0);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.QueueMoveWater(
    aAmount: single;
    aDestination: AIGrid);
begin
  gSpace.MoveWater(self, aAmount, aDestination);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.DefaultSettings;
begin
  fWater := gSpace.DefaultWater;
  fHeight := gSpace.DefaultHeight;
  fTemperature := gSpace.DefaultTemperature;
  fHumidity := gSpace.DefaultHumidity;
  fUnderWater := fWater > (fHeight + cWaterSurfaceTension);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.RaiseSurroundingHeightsTo(newHeight: single);
begin
  if ConnectionUp.Height < newHeight then ConnectionUp.Height := newHeight;
  if ConnectionDown.Height < newHeight then ConnectionDown.Height := newHeight;
  if ConnectionLeft.Height < newHeight then ConnectionLeft.Height := newHeight;
  if ConnectionRight.Height < newHeight then ConnectionRight.Height := newHeight;
  if ConnectionUpLeft.Height < newHeight then ConnectionUpLeft.Height := newHeight;
  if ConnectionUpRight.Height < newHeight then ConnectionUpRight.Height := newHeight;
  if ConnectionDownLeft.Height < newHeight then ConnectionDownLeft.Height := newHeight;
  if ConnectionDownRight.Height < newHeight then ConnectionDownRight.Height := newHeight;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.RaiseSurroundingHeightsBy(newHeight: single);
begin
  ConnectionUp.AlterHeight(newHeight);
  ConnectionDown.AlterHeight(newHeight);
  ConnectionLeft.AlterHeight(newHeight);
  ConnectionRight.AlterHeight(newHeight);
end;

// ----------------------------------------------------------------------------
// this function, can be used with 2 options:
//   Min(a,b,c,d) = lowest height of any adjacent grid
//   Avg(a,b,c,d) = average height of all adjacent grids
//  using Min gives you "plains", where the highest square is always flat
//  using Avg gives you "mountains", where the highest square is always a mountain
//  Min is better for lower resolution planets
//  Avg is better for higher resolution planets
//  because four Avg squares of equal hight, equals one Min square in the center
//  avg is faster, but this function is only called when the land is changed
procedure AIGrid.CalculateHeights;
begin
  fCornerValues[cHeightUpLeft] := Avg(Height, ConnectionUp.Height, ConnectionLeft.Height, ConnectionUpLeft.Height);
  fCornerValues[cHeightUpRight] := Avg(Height, ConnectionUp.Height, ConnectionRight.Height, ConnectionUpRight.Height);
  fCornerValues[cHeightDownLeft] := Avg(Height, ConnectionDown.Height, ConnectionLeft.Height, ConnectionDownLeft.Height);
  fCornerValues[cHeightDownRight] := Avg(Height, ConnectionDown.Height, ConnectionRight.Height, ConnectionDownRight.Height);
  fCornerValues[cHeightUp] := Avg(Height, ConnectionUp.Height);
  fCornerValues[cHeightDown] := Avg(Height, ConnectionDown.Height);
  fCornerValues[cHeightLeft] := Avg(Height, ConnectionLeft.Height);
  fCornerValues[cHeightRight] := Avg(Height, ConnectionRight.Height);
  fLandMax := Max(fHeight, fCornerValues[cHeightUpLeft], fCornerValues[cHeightUpRight], fCornerValues[cHeightDownLeft], fCornerValues[cHeightDownRight],
    fCornerValues[cHeightUp], fCornerValues[cHeightDown], fCornerValues[cHeightLeft], fCornerValues[cHeightRight]);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.CalculateFullHeights;
begin
  fCornerValues[cHeightUpLeft] := Avg(Height, ConnectionUp.Height, ConnectionLeft.Height, ConnectionUpLeft.Height);
  fCornerValues[cHeightUpRight] := Avg(Height, ConnectionUp.Height, ConnectionRight.Height, ConnectionUpRight.Height);
  fCornerValues[cHeightDownLeft] := Avg(Height, ConnectionDown.Height, ConnectionLeft.Height, ConnectionDownLeft.Height);
  fCornerValues[cHeightDownRight] := Avg(Height, ConnectionDown.Height, ConnectionRight.Height, ConnectionDownRight.Height);
  fCornerValues[cHeightUp] := Avg(Height, ConnectionUp.Height);
  fCornerValues[cHeightDown] := Avg(Height, ConnectionDown.Height);
  fCornerValues[cHeightLeft] := Avg(Height, ConnectionLeft.Height);
  fCornerValues[cHeightRight] := Avg(Height, ConnectionRight.Height);

  // set adjacent grid values to match
  if not fAtTop then
  begin
    fConnectionUp.CornerValues[cHeightDownLeft] := fCornerValues[cHeightUpLeft];
    fConnectionUp.CornerValues[cHeightDownRight] := fCornerValues[cHeightUpRight];
    fConnectionUp.CornerValues[cHeightDown] := fCornerValues[cHeightUp];
    fConnectionUpLeft.CornerValues[cHeightDownRight] := fCornerValues[cHeightUpLeft];
    fConnectionUpRight.CornerValues[cHeightDownLeft] := fCornerValues[cHeightUpRight];
    fConnectionUp.CalculateLandMax;
    fConnectionUpLeft.CalculateLandMax;
    fConnectionUpRight.CalculateLandMax;
  end
  else
  begin
    fConnectionUp.CalculateHeights;
    fConnectionUpLeft.CalculateHeights;
    fConnectionUpRight.CalculateHeights;
  end;

  if not fAtBottom then
  begin
    fConnectionDown.CornerValues[cHeightUpLeft] := fCornerValues[cHeightDownLeft];
    fConnectionDown.CornerValues[cHeightUpRight] := fCornerValues[cHeightDownRight];
    fConnectionDown.CornerValues[cHeightUp] := fCornerValues[cHeightDown];
    fConnectionDownLeft.CornerValues[cHeightUpRight] := fCornerValues[cHeightDownLeft];
    fConnectionDownRight.CornerValues[cHeightUpLeft] := fCornerValues[cHeightDownRight];
    fConnectionDown.CalculateLandMax;
    fConnectionDownLeft.CalculateLandMax;
    fConnectionDownRight.CalculateLandMax;
  end
  else
  begin
    fConnectionDown.CalculateHeights;
    fConnectionDownLeft.CalculateHeights;
    fConnectionDownRight.CalculateHeights;
  end;

  fConnectionLeft.CornerValues[cHeightUpRight] := fCornerValues[cHeightUpLeft];
  fConnectionLeft.CornerValues[cHeightDownRight] := fCornerValues[cHeightDownLeft];
  fConnectionLeft.CornerValues[cHeightRight] := fCornerValues[cHeightLeft];
  fConnectionRight.CornerValues[cHeightUpLeft] := fCornerValues[cHeightUpRight];
  fConnectionRight.CornerValues[cHeightDownLeft] := fCornerValues[cHeightDownRight];
  fConnectionRight.CornerValues[cHeightLeft] := fCornerValues[cHeightRight];
  fConnectionLeft.CalculateLandMax;
  fConnectionRight.CalculateLandMax;

  CalculateLandMax;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.CalculateLandMax;
begin
  fLandMax := Max(fHeight, fCornerValues[cHeightUpLeft], fCornerValues[cHeightUpRight], fCornerValues[cHeightDownLeft], fCornerValues[cHeightDownRight],
    fCornerValues[cHeightUp], fCornerValues[cHeightDown], fCornerValues[cHeightLeft], fCornerValues[cHeightRight]);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.CalculateWaters;
begin
  fCornerValues[cWaterUpLeft] := Min(Water, ConnectionUp.Water, ConnectionLeft.Water, ConnectionUpLeft.Water);
  fCornerValues[cWaterUpRight] := Min(Water, ConnectionUp.Water, ConnectionRight.Water, ConnectionUpRight.Water);
  fCornerValues[cWaterDownLeft] := Min(Water, ConnectionDown.Water, ConnectionLeft.Water, ConnectionDownLeft.Water);
  fCornerValues[cWaterDownRight] := Min(Water, ConnectionDown.Water, ConnectionRight.Water, ConnectionDownRight.Water);
  fWaterMax := fWater;
//  fWaterMax := Max(Water, fCornerValues[cWaterUpLeft], fCornerValues[cWaterUpRight], fCornerValues[cWaterDownLeft], fCornerValues[cWaterDownRight]);
end;

// ----------------------------------------------------------------------------
procedure AIGrid.CalculateFullWaters;
begin
  fCornerValues[cWaterUpLeft] := Min(Water, ConnectionUp.Water, ConnectionLeft.Water, ConnectionUpLeft.Water);
  fCornerValues[cWaterUpRight] := Min(Water, ConnectionUp.Water, ConnectionRight.Water, ConnectionUpRight.Water);
  fCornerValues[cWaterDownLeft] := Min(Water, ConnectionDown.Water, ConnectionLeft.Water, ConnectionDownLeft.Water);
  fCornerValues[cWaterDownRight] := Min(Water, ConnectionDown.Water, ConnectionRight.Water, ConnectionDownRight.Water);

  // set adjacent grid values to match
  if not fAtTop then
  begin
    fConnectionUp.CornerValues[cWaterDownLeft] := fCornerValues[cWaterUpLeft];
    fConnectionUp.CornerValues[cWaterDownRight] := fCornerValues[cWaterUpRight];
    fConnectionUpLeft.CornerValues[cWaterDownRight] := fCornerValues[cWaterUpLeft];
    fConnectionUpRight.CornerValues[cWaterDownLeft] := fCornerValues[cWaterUpRight];
  end;

  if not fAtBottom then
  begin
    fConnectionDown.CornerValues[cWaterUpLeft] := fCornerValues[cWaterDownLeft];
    fConnectionDown.CornerValues[cWaterUpRight] := fCornerValues[cWaterDownRight];
    fConnectionDownLeft.CornerValues[cWaterUpRight] := fCornerValues[cWaterDownLeft];
    fConnectionDownRight.CornerValues[cWaterUpLeft] := fCornerValues[cWaterDownRight];
  end;

  fConnectionLeft.CornerValues[cWaterUpRight] := fCornerValues[cWaterUpLeft];
  fConnectionLeft.CornerValues[cWaterDownRight] := fCornerValues[cWaterDownLeft];
  fConnectionRight.CornerValues[cWaterUpLeft] := fCornerValues[cWaterUpRight];
  fConnectionRight.CornerValues[cWaterDownLeft] := fCornerValues[cWaterDownRight];

  fWaterMax := fWater;
//  fWaterMax := Max(Water, fCornerValues[cWaterUpLeft], fCornerValues[cWaterUpRight], fCornerValues[cWaterDownLeft], fCornerValues[cWaterDownRight]);
end;

// ----------------------------------------------------------------------------
function AIGrid.DetermineLandHeight(aX, aY: single): single;
var
  v0, v1, v2, u, v: TAffineVector;
  px, py: single;
begin
  px := ax - Coordinates.XS;
  py := ay - Coordinates.YS;

  v0.X := 5.0;   v0.Y := 5.0;   v0.Z := fHeight;
  // upper right
  if (px > 5.0) and (py <= 5.0) then
  begin
    // 1
    if (py) < (10.0-px) then
    begin
      v1.X := 5.0;    v1.Y := 0.0;   v1.Z := fCornerValues[cHeightUp];
      v2.X := 10.0;   v2.Y := 0.0;   v2.Z := fCornerValues[cHeightUpRight];
    end else
    // 2
    begin
      v1.X := 10.0;   v1.Y := 0.0;   v1.Z := fCornerValues[cHeightUpRight];
      v2.X := 10.0;   v2.Y := 5.0;   v2.Z := fCornerValues[cHeightRight];
    end;
  end
  else
  // lower right
  if (px > 5.0) and (py > 5.0) then
  begin
    // 3
    if py < px then
    begin
      v1.X := 10.0;   v1.Y := 5.0;    v1.Z := fCornerValues[cHeightRight];
      v2.X := 10.0;   v2.Y := 10.0;   v2.Z := fCornerValues[cHeightDownRight];
    end else
    // 4
    begin
      v1.X := 10.0;   v1.Y := 10.0;    v1.Z := fCornerValues[cHeightDownRight];
      v2.X := 5.0;    v2.Y := 10.0;    v2.Z := fCornerValues[cHeightDown];
    end;
  end
  else
  // lower left
  if (px <= 5.0) and (py > 5.0) then
  begin
    // 5
    if (10.0-py) < px then
    begin
      v1.X := 5.0;   v1.Y := 10.0;   v1.Z := fCornerValues[cHeightDown];
      v2.X := 0.0;   v2.Y := 10.0;   v2.Z := fCornerValues[cHeightDownLeft];
    end else
    // 6
    begin
      v1.X := 0.0;   v1.Y := 10.0;   v1.Z := fCornerValues[cHeightDownLeft];
      v2.X := 0.0;   v2.Y := 5.0;    v2.Z := fCornerValues[cHeightLeft];
    end;
  end
  else
  // upper left
  if (px <= 5.0) and (py <= 5.0) then
  begin
    // 7
    if py > px then
    begin
      v1.X := 0.0;   v1.Y := 5.0;    v1.Z := fCornerValues[cHeightLeft];
      v2.X := 0.0;   v2.Y := 0.0;    v2.Z := fCornerValues[cHeightUpLeft];
    end else
    // 8
    begin
      v1.X := 0.0;   v1.Y := 0.0;    v1.Z := fCornerValues[cHeightUpLeft]; // crashed here once
      v2.X := 5.0;   v2.Y := 0.0;    v2.Z := fCornerValues[cHeightUp];
    end;
  end;

  // optimize later
  VectorSubtract(v0, v1, u);
  VectorSubtract(v0, v2, v);
  // normal
  fNormal := VectorCrossProduct(u, v);
  NormalizeVector(fNormal);
  // solve for Height
  result := ((5.0 - px)*fNormal.X + (5.0-py)*fNormal.Y)/fNormal.Z + fHeight;
end;

// ----------------------------------------------------------------------------
function AIGrid.DetermineWaterHeight(aX, aY: single): single;
{begin
  result := Min(fCornerValues[cWaterDownLeft], fCornerValues[cWaterUpLeft],
    fCornerValues[cWaterUpRight], fCornerValues[cWaterDownLeft]);
//  result := fWater;
end;}
var
  v0, v1, v2, u, v, myNormal: TAffineVector;
  px, py: single;
begin
  px := ax - Coordinates.XS;
  py := ay - Coordinates.YS;

  v0.X := 5.0;   v0.Y := 5.0;   v0.Z := fWater;
  // upper right
  if (px > 5.0) and (py <= 5.0) then
  begin
    // 1
    if (py) < (10.0-px) then
    begin
      v1.X := 0.0;    v1.Y := 0.0;   v1.Z := fCornerValues[cWaterUpRight];
      v2.X := 10.0;   v2.Y := 0.0;   v2.Z := fCornerValues[cWaterUpLeft];
    end else
    // 2
    begin
      v1.X := 10.0;   v1.Y := 0.0;   v1.Z := fCornerValues[cWaterUpRight];
      v2.X := 10.0;   v2.Y := 10.0;  v2.Z := fCornerValues[cWaterDownRight];
    end;
  end
  else
  // lower right
  if (px > 5.0) and (py > 5.0) then
  begin
    // 3
    if py < px then
    begin
      v1.X := 10.0;   v1.Y := 0.0;   v1.Z := fCornerValues[cWaterUpRight];
      v2.X := 10.0;   v2.Y := 10.0;  v2.Z := fCornerValues[cWaterDownRight];
    end else
    // 4
    begin
      v1.X := 10.0;   v1.Y := 10.0;    v1.Z := fCornerValues[cWaterDownRight];
      v2.X := 0.0;    v2.Y := 10.0;    v2.Z := fCornerValues[cWaterDownLeft];
    end;
  end
  else
  // lower left
  if (px <= 5.0) and (py > 5.0) then
  begin
    // 5
    if (10.0-py) < px then
    begin
      v1.X := 10.0;   v1.Y := 10.0;    v1.Z := fCornerValues[cWaterDownRight];
      v2.X := 0.0;    v2.Y := 10.0;    v2.Z := fCornerValues[cWaterDownLeft];
    end else
    // 6
    begin
      v1.X := 0.0;   v1.Y := 10.0;   v1.Z := fCornerValues[cWaterDownLeft];
      v2.X := 0.0;   v2.Y := 0.0;    v2.Z := fCornerValues[cWaterUpLeft];
    end;
  end
  else
  // upper left
  if (px <= 5.0) and (py <= 5.0) then
  begin
    // 7
    if py > px then
    begin
      v1.X := 0.0;   v1.Y := 10.0;   v1.Z := fCornerValues[cWaterDownLeft];
      v2.X := 0.0;   v2.Y := 0.0;    v2.Z := fCornerValues[cWaterUpLeft];
    end else
    // 8
    begin
      v1.X := 0.0;    v1.Y := 0.0;   v1.Z := fCornerValues[cWaterUpRight];
      v2.X := 10.0;   v2.Y := 0.0;   v2.Z := fCornerValues[cWaterUpLeft];
    end;
  end;

  // optimize later
  VectorSubtract(v0, v1, u);
  VectorSubtract(v0, v2, v);
  // normal
  myNormal := VectorCrossProduct(u, v);
  // solve for Height
  result := ((5.0 - px)*myNormal.X + (5.0-py)*myNormal.Y)/myNormal.Z + fWater;
end;

// ----------------------------------------------------------------------------
procedure AIGrid.Vibrate(aEffectType, aEffectIndex, aTimerDeath: integer);
var
  myVibe: AIVibe;
begin
  if not gThings.CanAdd(cVibe) then exit;

  myVibe := AIVibe(gEnvironment.Things.NewThing(cVibe));
  myVibe.SetVibe(aEffectType, aEffectIndex, aTimerDeath);
  myVibe.Position.SetToCoordinates(Coordinates);
end;

// ----------------------------------------------------------------------------
// sucks water from surrounding squares
//  find a random connection and then move water
procedure AIGrid.SuckWater(aAmount: single);
var
  myGrid: AIGrid;
begin
  myGrid := RandomConnection;
  if myGrid.UnderWater then
  begin
    if aAmount > myGrid.Water then
      aAmount := myGrid.Water;
    gSpace.QueueChange(self, cEventAddWater, aAmount);
    gSpace.QueueChange(RandomConnection, cEventAddWater, -1*aAmount);
  end;
end;

// ----------------------------------------------------------------------------
//  CalculateWind;
procedure AIGrid.CalculateWind;
begin
  fWind.X := 0;
  fWind.Y := 0;
  fWind.Z := 0;
  fWindy := false;

  fWind.X := fWind.X - (fTemperature - ConnectionLeft.Temperature);
  fWind.X := fWind.X + (fTemperature - ConnectionRight.Temperature);
  fWind.Y := fWind.Y - (fTemperature - ConnectionUp.Temperature);
  fWind.Y := fWind.Y + (fTemperature - ConnectionDown.Temperature);

  fWind.X := fWind.X / 1000.0;
  fWind.Y := fWind.Y / 1000.0;
  if (fWind.X<>0) or (fWind.Y<>0) then fWindy := true;
end;

// ----------------------------------------------------------------------------
//  create an iceberg
procedure AIGrid.FreezeWater;
var
  myIceberg: AIIceberg;
begin
  myIceberg := NewThing(cIceberg);

  if Assigned(myIceberg) then
  begin
    myIceberg.Position.Height := fWater;
    myIceberg.Position.Velocity.Zero;
    myIceberg.Position.Acceleration.Zero;
    fWater := fWater - 0.1;
    myIceberg.Water := 0.1;
  end;
end;

// ----------------------------------------------------------------------------
//  this is called every now and then to perform temperature stabalization
procedure AIGrid.Naturalize;
var
  myInversion: single;
begin
  // cool a bit
  ChangeTemperature(-0.1);

  // blow temperature via wind
  case Random(4) of
    0:  if (fTemperature > ConnectionLeft.Temperature) then
        begin
          myInversion := (fTemperature - ConnectionLeft.Temperature)/2;
          if myInversion > cMaxTempFlow then myInversion := cMaxTempFlow;
          ChangeTemperature(-1 * myInversion);
          ConnectionLeft.ChangeTemperature(myInversion);
        end;
    1:  if (fTemperature > ConnectionRight.Temperature) then
        begin
          myInversion := (fTemperature - ConnectionRight.Temperature)/2;
          if myInversion > cMaxTempFlow then myInversion := cMaxTempFlow;
          ChangeTemperature(-1 * myInversion);
          ConnectionRight.ChangeTemperature(myInversion);
        end;
    2:  if (fTemperature > ConnectionUp.Temperature) then
        begin
          myInversion := (fTemperature - ConnectionUp.Temperature)/2;
          if myInversion > cMaxTempFlow then myInversion := cMaxTempFlow;
          ChangeTemperature(-1 * myInversion);
          ConnectionUp.ChangeTemperature(myInversion);
        end;
    3:  if (fTemperature > ConnectionDown.Temperature) then
        begin
          myInversion := (fTemperature - ConnectionDown.Temperature)/2;
          if myInversion > cMaxTempFlow then myInversion := cMaxTempFlow;
          ChangeTemperature(-1 * myInversion);
          ConnectionDown.ChangeTemperature(myInversion);
        end;
  end;
end;

end.
