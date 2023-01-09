unit cAIReality;
(*
  Node AIReality
  This is the top-level interface for every AI data object.
  Patterns:
    Environment
    Culture
    Concepts
    Spatial Dimensions
    Time
*)
interface

uses
  System.Classes,
  System.SysUtils,
  cAIBaseObject,
  cAIEnvironment;

const
  cTimeFlowing = 0;
  cTimeTicking = 1;
  cTimeBurst = 1;

type

// ============================================================================
AIReality =  Class(AIBaseObject)
private
  fCreator: string;

  fTimeStream: integer;       // time mode: ticking or flowing
  fTime: integer;             // the number of ticks after reality is first run
  fTimeSinceExecute: integer; // last time the user stopped reality
  fClockStagger: integer;     // earth time per tick in milliseconds
  fIsRunning: boolean;        // but is it running?
  fVersion: integer;          // program version
  fFileName: string;          // possible file name of this reality

  fEnvironment: AIEnvironment;

  procedure Tick;
  procedure Tock;
  procedure AdvanceTime;
public
  Constructor Create;
  Destructor Destroy; override;

  // questions
  function TimeIsTicking: boolean;
  function TimeIsFlowing: boolean;

  // actions
  procedure FlipTimeStream;
  procedure SetTimeTicking;
  procedure SetTimeFlowing;
  procedure TickTock;

  function RandomInteger(aMin: integer; aMax: integer): integer;

  // info
  property Creator: string read fCreator write fCreator;
  property Environment: AIEnvironment read fEnvironment write fEnvironment;
  property Time: integer read fTime;
  property TimeSinceExecute: integer read fTimeSinceExecute;
  property IsRunning: boolean read fIsRunning;
  property ClockStagger: integer read fClockStagger write fClockStagger;
  property Version: integer read fVersion;
  property FileName: string read fFileName;

  procedure Clean;
  procedure Build(aWidth: integer; aHeight: integer);
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
  procedure FullDisplay(aList: TStrings); override;

  function LoadReality(aFileName: string): boolean;
  procedure SaveReality(aFileName: string);
  function ValidFile(aFileName: string): boolean;
end;

implementation

uses
  cUtilities,
  cGlobals;

// ----------------------------------------------------------------------------
// Create Reality
Constructor AIReality.Create;
begin
  inherited Create(nil);

  gReality := self;
  fVersion := gVersion;

  fEnvironment := AIEnvironment.Create(self);
  fClockStagger := 40;
  fIsRunning := false;

  fCreator := 'User';

  SetTimeFlowing;
  Randomize;
end;

// ----------------------------------------------------------------------------
// Destroy Reality
Destructor AIReality.Destroy;
begin
  fEnvironment.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIReality.Clean;
begin
  fTime := 0;
  Environment.Clean;
end;

// ----------------------------------------------------------------------------
procedure AIReality.Build(aWidth: integer; aHeight: integer);
begin
  gReality := self;
  Environment.Build(aWidth, aHeight);
end;

// ----------------------------------------------------------------------------
function AIReality.RandomInteger(aMin: integer; aMax: integer): integer;
begin
  result := aMin + Random(aMax);
end;

// ----------------------------------------------------------------------------
// TimeIsTicking
// In this mode, reality fuels the environment with one time unit, then halts
function AIReality.TimeIsTicking: boolean;
begin
  result := (fTimeStream = cTimeTicking);
end;

// ----------------------------------------------------------------------------
procedure AIReality.SetTimeTicking;
begin
  fTimeStream := cTimeTicking;
end;

// ----------------------------------------------------------------------------
// TimeIsFlowing
// In this mode, reality keeps fueling the environment with time until halted
function AIReality.TimeIsFlowing: boolean;
begin
  result := (fTimeStream = cTimeFlowing);
end;

// ----------------------------------------------------------------------------
procedure AIReality.SetTimeFlowing;
begin
  fTimeStream := cTimeFlowing;
end;

// ----------------------------------------------------------------------------
// Change Ticking to Flowing or vice versa
procedure AIReality.FlipTimeStream;
begin
  if TimeIsFlowing then
    fTimeStream := cTimeTicking
  else
    fTimeStream := cTimeFlowing;
end;

// ----------------------------------------------------------------------------
// tick the clock
// increase time gauge
procedure AIReality.Tick;
begin
  fTime := fTime + 1;
end;

// ----------------------------------------------------------------------------
// tock the clock
// pause time
procedure AIReality.Tock;
begin
  fTimeSinceExecute := fTime;
end;

// ----------------------------------------------------------------------------
// tick the earth clock
// fuel the environment
procedure AIReality.AdvanceTime;
begin
  Tick;

  Environment.Fuel;

  if TimeIsTicking then
    Tock;
end;

// ----------------------------------------------------------------------------
procedure AIReality.TickTock;
begin
  fIsRunning := true;
  AdvanceTime;
  fIsRunning := false;
end;

// ----------------------------------------------------------------------------
procedure AIReality.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fVersion);
  inherited SaveToFile(aFile);
  writeln(aFile, gUniqueHandle);
  writeln(aFile, fCreator);
  writeln(aFile, fTimeStream);
  writeln(aFile, fTime);
  writeln(aFile, fTimeSinceExecute);
  writeln(aFile, fClockStagger);
  writeFileBoolean(aFile, fIsRunning);
  Environment.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIReality.LoadFromFile(var aFile: TextFile);
var
  myVersion: integer; // saved to fake variable
begin
  readln(aFile, myVersion);  // isnt used, gets read previously by LoadReality
  if myVersion <> fVersion then exit;
  inherited LoadFromFile(aFile);
  readln(aFile, gUniqueHandle);
  readln(aFile, fCreator);
  readln(aFile, fTimeStream);
  readln(aFile, fTime);
  readln(aFile, fTimeSinceExecute);
  readln(aFile, fClockStagger);
  fIsRunning := readFileBoolean(aFile);
  Environment.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
function AIReality.LoadReality(aFileName: string): boolean;
var
  myFile: TextFile;
begin
  result := false;

  if not ValidFile(aFileName) then exit;

  AssignFile(myFile, aFileName);
  Reset(myFile);
  LoadFromFile(myFile);
  CloseFile(myFile);
  fFileName := aFileName;
  result := true;
end;

// ----------------------------------------------------------------------------
function AIReality.ValidFile(aFileName: string): boolean;
var
  myFile: TextFile;
  myFileVersion: integer;
begin
  result := false;

  if not FileExists(aFileName) then exit;

  AssignFile(myFile, aFileName);
  Reset(myFile);
  readln(myFile, myFileVersion);

  if Version = myFileVersion then
    result := true;

  Close(myFile);
end;

// ----------------------------------------------------------------------------
procedure AIReality.SaveReality(aFileName: string);
var
  myFile: TextFile;
begin
  AssignFile(myFile, aFileName);
  Rewrite(myFile);

  SaveToFile(myFile);

  writeln(myFile, 'Saved at: ' + DateToStr(Now) + ' ' + TimeToStr(Now));

  CloseFile(myFile);
end;

// ----------------------------------------------------------------------------
procedure AIReality.FullDisplay(aList: TStrings);
begin
  aList.Add('REALITY');
  aList.Add('-------------');
  inherited FullDisplay(aList);
  aList.Add('Creator: ' + fCreator);
  aList.Add('TimeStream='+IntToStr(fTimeStream));
  aList.Add('Time='+IntToStr(fTime));
  aList.Add('TimeSinceExecute='+IntToStr(fTimeSinceExecute));
  aList.Add('ClockStagger='+IntToStr(fClockStagger));
  aList.Add('Version='+IntToStr(fVersion));
  aList.Add('IsRunning='+BoolToYesNoStr(fIsRunning));
  aList.Add('FileName: ' + fFileName);
  aList.Add('Environment='+PtrToStr(fEnvironment));
  aList.Add('GLOBALS');
  aList.Add('-----------------');
  aList.Add('gUniqueHandle='+IntToStr(gUniqueHandle));
  aList.Add('gPlanetRadius='+Format('%0.2f', [gPlanetRadius]));
  aList.Add('gWidthSingle='+Format('%0.2f', [gWidthSingle]));
  aList.Add('gHeightSingle='+Format('%0.2f', [gHeightSingle]));
  aList.Add('gHalfWidthSingle='+Format('%0.2f', [gHalfWidthSingle]));
  aList.Add('gHalfHeightSingle='+Format('%0.2f', [gHalfHeightSingle]));
  aList.Add('gPlanetHeight='+IntToStr(gPlanetHeight));
  aList.Add('gPlanetWidth='+IntToStr(gPlanetWidth));
  aList.Add('gWorldWidth='+Format('%0.2f', [gWorldWidth]));
  aList.Add('gWorldHeight='+Format('%0.2f', [gWorldHeight]));
  aList.Add('gHalfWorldWidth='+Format('%0.2f', [gHalfWorldWidth]));
  aList.Add('gHalfWorldHeight='+Format('%0.2f', [gHalfWorldHeight]));
  aList.Add('gOneQuarterWorldHeight='+Format('%0.2f', [gOneQuarterWorldHeight]));
  aList.Add('gThreeQuartersWorldHeight='+Format('%0.2f', [gThreeQuartersWorldHeight]));
  aList.Add('gReality='+PtrToStr(gReality));
  aList.Add('gEnvironment='+PtrToStr(gEnvironment));
  aList.Add('gSpace='+PtrToStr(gSpace));
  aList.Add('gThings='+PtrToStr(gThings));
  aList.Add('gGravity='+PtrToStr(gGravity));
  aList.Add('gAirFriction='+PtrToStr(gAirFriction));
  aList.Add('gLandFriction='+PtrToStr(gLandFriction));
  aList.Add('gWaterFriction='+PtrToStr(gWaterFriction));
  aList.Add('gVersion='+IntToStr(gVersion));
end;

end.


