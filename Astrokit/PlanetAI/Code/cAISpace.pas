{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAISpace.pas,v 1.30 2003/10/01 00:54:52 aidave Exp $
}
unit cAISpace;
{
  Node AISpace

  This class holds the spatial map.
  The map provides easy access to anything at any coordinate.

  Patterns:
    Map
}
interface

uses
  cAIBaseObject, cAIGrid, cAICoordinates,
  cAIEnvironmentStructures, cAIPosition, Classes;

const
  // events
  cEventAddWater = 0;
  cEventAddHumidity = 1;
  cEventAddTemperature = 2;
  cEventAddHeight = 3;

type

AIMap = array of array of AIGrid;

// ============================================================================
AISpace = Class(AIBaseObject)
private
  fWidth: integer;      // width of the map (grids)
  fHeight: integer;     // height of the map (grids)
  fRadius: single;      // radius of the planet (for visual only)
  fSpherical: boolean;  // is the user viewing this in sphere or flat mode?

  fMap: AIMap;          // array of grids

  // keep two lists of events
  fEventList1: AIEventList; // first round of events
  fEventList2: AIEventList; // next round of events
  fEventRound: AIEventList; // pointer to active event queue
  fEventQueue: AIEventList; // pointer to active round of events

  // derived at runtime
  fWidthLoop: integer;    //width-1
  fHeightLoop: integer;   //height-1
  fHalfWidth: integer;    //width/2
  fHalfHeight: integer;   //height/2

  fWidthSingle: single;
  fHeightSingle: single;
  fHalfWidthSingle: single;
  fHalfHeightSingle: single;

  fWorldWidth: single;
  fWorldHeight: single;

  fDefaultHeight: integer;
  fDefaultWater: integer;
  fDefaultTemperature: integer;
  fDefaultHumidity: integer;

  fAsteroids: integer;

  procedure InitializeMap;
  procedure FreeMap;
  procedure ConnectMap;
  procedure HeightenMap;
  procedure DeriveDimensionalValues;
  function GetDefaultWaterHeight: integer;
  procedure Effects;
public
  Constructor Create(
    aEnvironment: pointer;
    aWidth: integer;
    aHeight: integer);
  Destructor Destroy; override;

  property Width: integer read fWidth;
  property Height: integer read fHeight;
  property Radius: single read fRadius write fRadius;
  property Spherical: boolean read fSpherical write fSpherical;

  property EventRound: AIEventList read fEventRound;
  property EventQueue: AIEventList read fEventQueue;
  property WidthLoop: integer read fWidthLoop;
  property HeightLoop: integer read fHeightLoop;
  property HalfWidth: integer read fHalfWidth;
  property HalfHeight: integer read fHalfHeight;
  property WidthSingle: single read fWidthSingle;
  property HeightSingle: single read fHeightSingle;
  property HalfWidthSingle: single read fHalfWidthSingle;
  property HalfHeightSingle: single read fHalfHeightSingle;

  property DefaultHeight: integer read fDefaultHeight write fDefaultHeight;
  property DefaultWater: integer read fDefaultWater write fDefaultWater;
  property DefaultTemperature: integer read fDefaultTemperature write fDefaultTemperature;
  property DefaultHumidity: integer read fDefaultHumidity write fDefaultHumidity;
  property DefaultWaterHeight: integer read GetDefaultWaterHeight;
  property Asteroids: integer read fAsteroids write fAsteroids;

  // terrain generation routines
  procedure GenerateHalo;
  procedure GenerateContinents(aAmount: integer);
  procedure GenerateIslands(aAmount: integer);
  procedure FreezePoles;
  procedure MeteorShower;
  procedure ResetMapToDefaults;

  property Map: AIMap read fMap;

  procedure MoveWater(
    aSource: AIGrid;
    aAmount: single;
    aDestination: AIGrid);

  procedure QueueChange(
    aDestination: AIGrid;
    aChangeKind: integer;
    aAmount: single);

  procedure Fuel;
  procedure Stabalize;  // large scale grid validization
  procedure FuzzyHeight(aFuzz: integer); // adds small random values to height

  function RandomLocation: AIGrid;
  function RandomLocationAwayFromPoles: AIGrid;

  procedure Clean;
  procedure Build(aWidth: integer; aHeight: integer);
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;

  function LandAtPosition(aX, aY: single): single;
  function WaterAtPosition(aX, aY: single): single;

  function FindWithHandle(aHandle: integer): AIBaseObject;

  procedure FullDisplay(aList: TStrings); override;
end;

implementation

uses
  cUtilities, System.SysUtils, cAIEnvironment, cAIThings, cAISatellites, cGlobals,
  cAIVibes;

// ----------------------------------------------------------------------------
Constructor AISpace.Create(
    aEnvironment: pointer;
    aWidth: integer;
    aHeight: integer);
begin
  inherited Create(aEnvironment);

  fWidth := aWidth;
  fHeight := aHeight;
  fRadius := (aWidth + aHeight) / 3;
  fSpherical := false;
  fSpherical := true;
  fAsteroids := 2;

  fDefaultHeight := 5;
  fDefaultWater := 15;
  fDefaultTemperature := 4;
  fDefaultHumidity := 0;

  gSpace := self;

  DeriveDimensionalValues;

  SetLength(fMap, fWidth, fHeight);

  InitializeMap;
  ConnectMap;
  HeightenMap;

  fEventList1 := AIEventList.Create(self, 64);
  fEventList2 := AIEventList.Create(self, 64);
  fEventRound := fEventList1;
  fEventQueue := fEventList2;

  FreezePoles;
end;

// ----------------------------------------------------------------------------
Destructor AISpace.Destroy;
begin
  fEventList1.Free;
  fEventList2.Free;

  FreeMap;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AISpace.Clean;
begin
  fEventList1.Free;
  fEventList2.Free;
  FreeMap;
end;

// ----------------------------------------------------------------------------
procedure AISpace.Build(aWidth: integer; aHeight: integer);
begin
  fWidth := aWidth;
  fHeight := aHeight;
  fAsteroids := 0;

  DeriveDimensionalValues;

  SetLength(fMap, fWidth, fHeight);
  InitializeMap;
  ConnectMap;
  HeightenMap;

  fEventList1 := AIEventList.Create(self, fWidth*fHeight*2);
  fEventList2 := AIEventList.Create(self, fWidth*fHeight*2);
  fEventRound := fEventList1;
  fEventQueue := fEventList2;
end;

// ----------------------------------------------------------------------------
procedure AISpace.DeriveDimensionalValues;
begin
  fWidthLoop := fWidth - 1;
  fHeightLoop := fHeight - 1;
  fHalfWidth := fWidth div 2;
  fHalfHeight := fHeight div 2;
  fWidthSingle := fWidth;
  fHeightSingle := fHeight;
  fHalfWidthSingle := fHalfWidth;
  fHalfHeightSingle := fHalfHeight;

  fWorldWidth := fWidthSingle * 10;
  fWorldHeight := fHeightSingle * 10;

  // set global variables
  gPlanetRadius := fRadius;
  gPlanetHeight := fHeight;
  gPlanetWidth  := fWidth;
  gWidthSingle := fWidthSingle;
  gHeightSingle := fHeightSingle;
  gHalfWidthSingle := fHalfWidthSingle;
  gHalfHeightSingle := fHalfHeightSingle;

  gWorldWidth := fWorldWidth;
  gWorldHeight := fWorldHeight;
  gHalfWorldWidth := fWorldWidth/2;
  gHalfWorldHeight := fWorldHeight/2;
  gOneQuarterWorldHeight := fWorldHeight/4;
  gThreeQuartersWorldHeight := fWorldHeight - fWorldHeight/4;

  gSpace := self;
end;

// ----------------------------------------------------------------------------
procedure AISpace.InitializeMap;
var
  myWidth: integer;
  myHeight: integer;
  myGrid: AIGrid;
begin
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
      begin
        myGrid := AIGrid.Create(self, myWidth, myHeight);
        Map[myWidth][myHeight] := myGrid;
        myGrid.DefaultSettings;
      end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.HeightenMap;
var
  myWidth: integer;
  myHeight: integer;
begin
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
    begin
        Map[myWidth][myHeight].CalculateHeights;
        Map[myWidth][myHeight].CalculateWaters;
    end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.ResetMapToDefaults;
var
  myWidth: integer;
  myHeight: integer;
  myGrid: AIGrid;
begin
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
      begin
        myGrid := Map[myWidth][myHeight];
        myGrid.DefaultSettings;
      end;
  Stabalize;
end;

// ----------------------------------------------------------------------------
// This procedure links all the grids to the adjacent grids
// this must be called after InitializeMap since the adjacent grids wont
// exist until after InitializeMap is called
// Edges of the map are connected, not nil
procedure AISpace.ConnectMap;
var
  myWidth: integer;
  myHeight: integer;
  myGrid: AIGrid;
  myGridUp: AIGrid;
  myGridDown: AIGrid;
  myGridLeft: AIGrid;
  myGridRight: AIGrid;
begin
  // connect all grids to adjacent grids, ala curved 2 dimensions
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
      begin
        myGrid := Map[myWidth][myHeight];

        if myHeight > 0 then
          myGridUp := Map[myWidth][myHeight - 1]
        else
          myGridUp := Map[myWidth][Height - 1];

        if myHeight < Height - 1 then
          myGridDown := Map[myWidth][myHeight + 1]
        else
          myGridDown := Map[myWidth][0];

        if myWidth > 0 then
          myGridLeft  := Map[myWidth - 1][myHeight]
        else
          myGridLeft  := Map[Width - 1][myHeight];

        if myWidth < Width - 1 then
          myGridRight := Map[myWidth + 1][myHeight]
        else
          myGridRight := Map[0][myHeight];

        myGrid.Connect(
          myGridUp,
          myGridDown,
          myGridLeft,
          myGridRight);
      end;

  // adjust for spherical top and bottom connections
  for myWidth := 0 to (HalfWidth - 1) do
    begin
      // top
      myGrid := Map[myWidth][0];
      myGridUp := Map[myWidth + HalfWidth][0];
      myGrid.ConnectionUp := myGridUp;    // connect grid in first half
      myGridUp.ConnectionUp := myGrid;    // connect grid in second half
      myGrid.AtTop := true;
      myGridUp.AtTop := true;

      // bottom
      myGrid := Map[myWidth][Height - 1];
      myGridDown := Map[myWidth + HalfWidth][Height - 1];
      myGrid.ConnectionDown := myGridDown;    // connect grid in first half
      myGridDown.ConnectionDown := myGrid;    // connect grid in second half
      myGrid.AtBottom := true;
      myGridDown.AtBottom := true;
    end;

  // connect diagonals
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
      begin
        myGrid := Map[myWidth][myHeight];
        myGrid.ConnectDiagonals;
      end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.FreeMap;
var
  myWidth: integer;
  myHeight: integer;
  myGrid: AIGrid;
begin
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
      begin
        myGrid := Map[myWidth][myHeight];
        myGrid.Free;
      end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.MoveWater(
    aSource: AIGrid;
    aAmount: single;
    aDestination: AIGrid);
begin
  // remove water from source
  QueueChange(
    aSource,
    cEventAddWater,
    aAmount * -1);
  // add water to destination
  QueueChange(
    aDestination,
    cEventAddWater,
    aAmount);
end;

// ----------------------------------------------------------------------------
procedure AISpace.FuzzyHeight(aFuzz: integer);
var
  myWidth: integer;
  myHeight: integer;
  myGrid: AIGrid;
begin
  for myWidth := 0 to Width - 1 do
    for myHeight := 0 to Height - 1 do
      begin
        myGrid := Map[myWidth][myHeight];
        myGrid.ChangeHeight(Random(aFuzz) - (aFuzz div 2));
      end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.LoadFromFile(var aFile: TextFile);
var
  X, Y: integer;
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fWidth);
  readln(aFile, fHeight);
  readln(aFile, fRadius);
  readln(aFile, fDefaultHeight);
  readln(aFile, fDefaultWater);
  readln(aFile, fDefaultTemperature);
  readln(aFile, fDefaultHumidity);

  // rebuild space and map
  Build(fWidth, fHeight);

  // load each grid
  for X := 0 to Width - 1 do
    for Y := 0 to Height - 1 do
      Map[X][Y].LoadFromFile(aFile);

  HeightenMap;

  fEventList1.LoadFromFile(aFile);
  fEventList2.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AISpace.SaveToFile(var aFile: TextFile);
var
  X, Y: integer;
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fWidth);
  writeln(aFile, fHeight);
  writeln(aFile, fRadius);
  writeln(aFile, fDefaultHeight);
  writeln(aFile, fDefaultWater);
  writeln(aFile, fDefaultTemperature);
  writeln(aFile, fDefaultHumidity);

  for X := 0 to Width - 1 do
    for Y := 0 to Height - 1 do
      Map[X][Y].SaveToFile(aFile);

  fEventList1.SaveToFile(aFile);
  fEventList2.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AISpace.Stabalize;
var
  myWidth: integer;
  myHeight: integer;
begin
  for myWidth := 0 to WidthLoop do
    for myHeight := 0 to HeightLoop do
        Map[myWidth][myHeight].Stabalize;
end;

// ----------------------------------------------------------------------------
function AISpace.RandomLocation: AIGrid;
begin
  result := Map[Random(Width)][Random(Height)];
end;

// ----------------------------------------------------------------------------
function AISpace.RandomLocationAwayFromPoles: AIGrid;
var
  myNiceHeight: integer;
begin
  myNiceHeight := Height - Height div 4;
  result := Map[Random(Width)][Height div 8 + Random(myNiceHeight)];
end;

// ----------------------------------------------------------------------------
function AISpace.GetDefaultWaterHeight: integer;
begin
  result := fDefaultWater;
  if fDefaultHeight > fDefaultWater then
    result := fDefaultHeight;
end;

// ----------------------------------------------------------------------------
// builds a ring of height around the equator
procedure AISpace.GenerateHalo;
var
  myWidth: integer;
  myGrid: AIGrid;
begin
  for myWidth := 0 to WidthLoop do
  begin
    myGrid := Map[myWidth][HalfHeight];
    myGrid.Height := DefaultWaterHeight + 75;
    myGrid.ConnectionUp.Height := DefaultWaterHeight + 50;
    myGrid.ConnectionDown.Height := DefaultWaterHeight + 50;
    if Height > 6 then
    begin
      myGrid.ConnectionUp.ConnectionUp.Height := DefaultWaterHeight - 25;
      myGrid.ConnectionDown.ConnectionDown.Height := DefaultWaterHeight - 25;
      myGrid.ConnectionUp.ConnectionUp.ConnectionUp.Height := DefaultWaterHeight - 50;
      myGrid.ConnectionDown.ConnectionDown.ConnectionDown.Height := DefaultWaterHeight - 50;
    end;
  end;
end;

// ----------------------------------------------------------------------------
// randomly make continents
procedure AISpace.GenerateContinents(aAmount: integer);
var
  myGrid: AIGrid;
  myConnection: AIGrid;
  mySize: integer;
  i, j: integer;
begin
  for i := 0 to aAmount - 1 do
  begin
    mySize := Random(10) + 5;
    myGrid := RandomLocationAwayFromPoles;
    myGrid.Height := DefaultWaterHeight + 4 + Random*1;
    myConnection := myGrid.RandomConnection;
    for j := 0 to mySize - 1 do
    begin
      if not myConnection.AtPole then
        myConnection.Height := DefaultWaterHeight + 1 + Random*2;
      myConnection := myConnection.RandomConnection;
    end;
  end;

end;

// ----------------------------------------------------------------------------
// randomly picks grids and makes them islands
procedure AISpace.GenerateIslands(aAmount: integer);
var
  myGrid: AIGrid;
  i: integer;
begin
  for i := 0 to aAmount - 1 do
  begin
    myGrid := RandomLocationAwayFromPoles;
    myGrid.Height := DefaultWaterHeight + 3 + Random*1;
  end;
end;

// ----------------------------------------------------------------------------
// sets temp to lowest at poles
procedure AISpace.FreezePoles;
var
  myWidth: integer;
  myGrid: AIGrid;
begin
  for myWidth := 0 to WidthLoop do
  begin
    myGrid := Map[myWidth][0];
    myGrid.Temperature := 0;
    myGrid.ConnectionDown.Temperature := 0;

    myGrid := Map[myWidth][HeightLoop];
    myGrid.Temperature := 0;
    myGrid.ConnectionUp.Temperature := 0;
  end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.Effects;
var
  i: integer;
  RigidCount: integer;
  myEvent: AISpatialEvent;
  myGrid: AIGrid;
begin
  RigidCount := fEventRound.ActiveIndex - 1;

  for i := 0 to RigidCount do
  begin
    myEvent := fEventRound.Events[i];
    myGrid := AIGrid(myEvent.Target);

    case myEvent.Kind
    of
      cEventAddWater:
      begin
        myGrid.ChangeWater(myEvent.Modifier);
        myGrid.Changed := true;
      end;

      cEventAddHumidity:
      begin
        myGrid.ChangeHumidity(myEvent.Modifier);
      end;

      cEventAddTemperature:
      begin
        myGrid.ChangeTemperature(myEvent.Modifier);
      end;

      cEventAddHeight:
      begin
        if myEvent.Modifier > 0.5 then
        begin
          myGrid.ChangeHeight(0.5);
          fEventQueue.AddEvent(cEventAddHeight, myGrid, myEvent.Modifier - 0.5);
        end
        else
        if myEvent.Modifier < -0.5 then
        begin
          myGrid.ChangeHeight(-0.5);
          fEventQueue.AddEvent(cEventAddHeight, myGrid, myEvent.Modifier + 0.5);
        end
        else
          myGrid.ChangeHeight(myEvent.Modifier);
        myGrid.Splash(0.1);
        myGrid.Changed := true;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.Fuel;
begin
  // clear old events
  fEventRound.Clear;

  // switch lists
  if fEventQueue = fEventList1 then
  begin
    fEventRound := fEventList1;
    fEventQueue := fEventList2;
  end
  else
  begin
    fEventRound := fEventList2;
    fEventQueue := fEventList1;
  end;

  // run the events for this round
  // new events will be put into the queue
  if fEventRound.Full then
    Effects;

  RandomLocation.Naturalize;
  RandomLocation.Naturalize;
  RandomLocation.Naturalize;

  if (fAsteroids <> 0) and (gReality.Time mod 128 = 0) and (Random(32) = 0) then
//  if (fAsteroids <> 0) and (gReality.Time mod 4 = 0) and (Random(4)=0) then
    MeteorShower;
end;

// ----------------------------------------------------------------------------
procedure AISpace.QueueChange(
    aDestination: AIGrid;
    aChangeKind: integer;
    aAmount: single);
var
  myChange: AISpatialEvent;
  i, RigidCount: integer;
  duplicate: boolean;
begin
  duplicate := false;

  RigidCount := fEventQueue.ActiveIndex-1;

//  if aDestination.Flagged then
  for i := 0 to RigidCount do
  begin
    myChange := AISpatialEvent(fEventQueue.Events[i]);

    if (myChange.Target = aDestination) and (myChange.Kind = aChangeKind) then
    begin
      if not (myChange.Kind = cEventAddHeight) then
        fEventQueue.Events[i].Modifier := myChange.Modifier + aAmount;
      duplicate := true;
      break;
    end;
  end;

  if not duplicate then
  begin
    fEventQueue.AddEvent(
      aChangeKind,
      aDestination,
      aAmount);
    // make a noise
    if (aChangeKind = cEventAddHeight) then
      aDestination.Vibrate(cEffectNoise, cNoiseQuake, 1);
  end;
end;

// ----------------------------------------------------------------------------
function AISpace.LandAtPosition(aX, aY: single): single;
var
  Gridx, Gridy: integer;
begin
  gridx := Round(aX/10-0.5);
  gridy := Round(aY/10-0.5);

  result := Map[gridx][gridy].DetermineLandHeight(aX, aY);
end;

// ----------------------------------------------------------------------------
function AISpace.WaterAtPosition(aX, aY: single): single;
var
  Gridx, Gridy: integer;
begin
  gridx := Round(aX/10-0.5);
  gridy := Round(aY/10-0.5);

  result := Map[gridx][gridy].DetermineWaterHeight(aX, aY);
end;

// ----------------------------------------------------------------------------
function AISpace.FindWithHandle(aHandle: integer): AIBaseObject;
var
  myWidth: integer;
  myHeight: integer;
begin
  result := nil;

  for myWidth := 0 to WidthLoop do
    for myHeight := 0 to HeightLoop do
      if Map[myWidth][myHeight].Handle = aHandle then
      begin
        result := Map[myWidth][myHeight];
        exit;
      end;
end;

// ----------------------------------------------------------------------------
procedure AISpace.MeteorShower;
var
  i: integer;
  myLocation: AIGrid;
begin
  myLocation := RandomLocation;
//  myLocation := Map[HalfWidth][HalfHeight].RandomConnection;
  myLocation.NewThing(cAsteroid);


  for i := 1 to fAsteroids - 1 do
    if Random(i) = 0 then myLocation.RandomConnection.NewThing(cAsteroid);
end;

// ----------------------------------------------------------------------------
procedure AISpace.FullDisplay(aList: TStrings);
begin
  {
  aList.Add('='+IntToStr());
  aList.Add('='+PtrToStr());
  aList.Add('='+Format('%0.2f', []));
  }
  aList.Add('SPACE');
  aList.Add('-------------');
  inherited FullDisplay(aList);

  aList.Add('Width='+IntToStr(fWidth));
  aList.Add('Height='+IntToStr(fHeight));
  aList.Add('Radius='+Format('%0.2f', [fRadius]));

  aList.Add('Map='+PtrToStr(fMap));
  aList.Add('EventList1='+PtrToStr(fEventList1));
  aList.Add('EventList2='+PtrToStr(fEventList2));
  aList.Add('EventRound='+PtrToStr(fEventRound));
  aList.Add('EventQueue='+PtrToStr(fEventQueue));

  aList.Add('WidthLoop='+IntToStr(fWidthLoop));
  aList.Add('HeightLoop='+IntToStr(fHeightLoop));
  aList.Add('HalfWidth='+IntToStr(fHalfWidth));
  aList.Add('HalfHeight='+IntToStr(fHalfHeight));

  aList.Add('WidthSingle='+Format('%0.2f', [fWidthSingle]));
  aList.Add('HeightSingle='+Format('%0.2f', [fHeightSingle]));
  aList.Add('HalfWidthSingle='+Format('%0.2f', [fHalfWidthSingle]));
  aList.Add('HalfHeightSingle='+Format('%0.2f', [fHalfHeightSingle]));

  aList.Add('WorldWidth='+Format('%0.2f', [fWorldWidth]));
  aList.Add('WorldHeight='+Format('%0.2f', [fWorldHeight]));

  aList.Add('DefaultHeight='+IntToStr(fDefaultHeight));
  aList.Add('DefaultWater='+IntToStr(fDefaultWater));
  aList.Add('DefaultTemperature='+IntToStr(fDefaultTemperature));
  aList.Add('DefaultHumidity='+IntToStr(fDefaultHumidity));

  aList.Add('Asteroids='+IntToStr(fAsteroids));
end;

end.
