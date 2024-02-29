unit UGameEngine;

(* Introduces base game engine classes *)

interface

uses
  System.Classes,
  System.Math,
  GLS.PersistentClasses,
  GLS.VectorGeometry,
  GLS.VectorTypes;

type

  TGameEngine = class;
  TControler = class;
  TMobile = class;

  // TGameEngineObject
  //
  { : Basic class for all game engine objects. }
  TGameEngineObject = class(TObject)
  private
    { Private Properties }
    FName: String;
    FDisabled: Boolean;

  protected
    { Protected Properties }
    procedure SetName(const val: String); virtual;
    procedure SetDisabled(val: Boolean); virtual;

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); virtual;

    procedure SaveToStrings(data: TStrings); dynamic;
    procedure LoadFromStrings(data: TStrings); dynamic;
    procedure Loaded; dynamic;

    procedure SaveToFile(const fileName: String);
    procedure LoadFromFile(const fileName: String);
    function SaveToString: String;
    procedure LoadFromString(const data: String);

    property Name: String read FName write SetName;
    { : Disabled objects shouldn't receive progression events.<br> }
    property Disabled: Boolean read FDisabled write SetDisabled;
  end;

  // TGameEngine3DObject
  //
  { : Basic class for all game engine objects positionned in 3D. }
  TGameEngine3DObject = class(TGameEngineObject)
  private
    { Private Properties }
    FPosition: TGLVector;
    FDirection, FUp: TGLVector;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    // : True if p is in the half-plane defined by Position and Direction
    function IsAhead(const p: TGLVector): Boolean; overload;
    function IsAhead(obj: TGameEngine3DObject): Boolean; overload;
    function DistanceTo(obj: TGameEngine3DObject): Single;
    function DistanceToSquared(obj: TGameEngine3DObject): Single;
    function AbsoluteToRelative(const p: TGLVector): TGLVector;
    procedure BearingElevation(const p: TGLVector;
      var bearing, elevation: Single);

    property Position: TGLVector read FPosition write FPosition;
    property PosX: Single read FPosition.X write FPosition.X;
    property PosY: Single read FPosition.Y write FPosition.Y;
    property PosZ: Single read FPosition.Z write FPosition.Z;

    property Direction: TGLVector read FDirection write FDirection;
    property Up: TGLVector read FUp write FUp;
    function RightVector: TGLVector;
    function Leftvector: TGLVector;
  end;

  // TMobileCollisionType
  //
  { : Cross-collision types for game engine items.<p>
    Mobiles collide against everything static and ammo do not collide
    among each other, but ammo can collide against static.
    Nothing collides against immaterial but mobiles }
  TMobileCollisionType = (mctStatic, mctMobile, mctAmmo, mctImmaterial);

  // TCollisionVolume
  //
  TCollisionVolume = class(TGameEngineObject)
  private
    { Private Properties }
    FMobile: TMobile;
    FCollType: TMobileCollisionType;
    FSize: TAffineVector;
    FRadius: Single;

  protected
    { Protected Properties }
    procedure SetSize(const val: TAffineVector);

  public
    { Public Properties }
    constructor Create(aMobile: TMobile);
    destructor Destroy; override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property Mobile: TMobile read FMobile;
    property CollType: TMobileCollisionType read FCollType write FCollType;
    property Size: TAffineVector read FSize write SetSize;
    property Radius: Single read FRadius;
  end;

  // TGameOperation
  //
  TGameOperation = (goInsert, goRemove, goCollide, goTargeted);

  // TMobile
  //
  { : Basic mobile entity. }
  TMobile = class(TGameEngine3DObject)
  private
    { Private Properties }
    FGameEngine: TGameEngine;
    FControler: TControler;
    FVelocity: TGLVector;
    FSpeed: Single;
    FTeam: Integer;
    FCollision: TCollisionVolume;
    FDetonate: Boolean;

  protected
    { Protected Properties }
    procedure SetName(const val: String); override;
    procedure SetVelocity(const aVelocity: TGLVector);

  public
    { Public Properties }
    constructor Create(aGameEngine: TGameEngine = nil); virtual;
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure DoDetonate; virtual;

    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); virtual;
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    // : Adjust orientation from current velocity and a world up reference
    procedure SetOrientationFromVelocity(const Up: TGLVector);

    function BestCaseInterceptTime(target: TMobile; quality: Integer): Single;

    property GameEngine: TGameEngine read FGameEngine write FGameEngine;
    property Collision: TCollisionVolume read FCollision;
    property Controler: TControler read FControler write FControler;
    property Team: Integer read FTeam write FTeam;

    property Velocity: TGLVector read FVelocity write SetVelocity;
    property Speed: Single read FSpeed;
    property Detonate: Boolean read FDetonate write FDetonate;
  end;

  TMobileClass = class of TMobile;

  // TControler
  //
  { : Base abstract controler class. }
  TControler = class(TGameEngineObject)
  private
    { Private Properties }
    FMobile: TMobile;
    FControler: TControler;

  protected
    { Protected Properties }
    procedure SetMobile(aMobile: TMobile); virtual;

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); virtual;

    property Controler: TControler read FControler write FControler;
    property Mobile: TMobile read FMobile write SetMobile;
    function GameEngine: TGameEngine;
  end;

  TControlerClass = class of TControler;

  // TControlerGravity
  //
  { : Controler that applies gravity and nothing more. }
  TControlerGravity = class(TControler)
  private
    { Private Properties }

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;
  end;

  // TGameEvent
  //
  { : Base abstract class for game events. }
  TGameEvent = class(TGameEngineObject)
  private
    { Private Properties }
    FGameEngine: TGameEngine;
    FEventTime: Integer;
    FCompleted: Boolean;

  protected
    { Protected Properties }
    procedure SetDisabled(val: Boolean); override;

  public
    { Public Properties }
    function Triggered: Boolean; virtual;
    procedure Trigger; virtual;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property GameEngine: TGameEngine read FGameEngine write FGameEngine;
    property EventTime: Integer read FEventTime write FEventTime;
    property Completed: Boolean read FCompleted write FCompleted;
  end;

  TGameEventClass = class of TGameEvent;

  // TGameEventTerminator
  //
  { : Game event that CleanFrees an object list upon trigger. }
  TGameEventTerminator = class(TGameEvent)
  private
    { Private Properties }
    FList: TGLPersistentObjectList;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Trigger; override;

    property List: TGLPersistentObjectList read FList write FList;
  end;

  // TGameMessage
  //
  TGameMessage = record
    Ticks: Integer;
    FromMobile, ToMobile: TMobile;
    Text: String;
  end;

  PGameMessage = ^TGameMessage;
  TGameMessages = array of TGameMessage;

  // TGameEngineStatus
  //
  TGameEngineStatus = (gesInitializing, gesPlaying, gesPaused, gesCompleted,
    gesFinalizing);

  // TGameEngine
  //
  TGameEngine = class(TGameEngineObject)
  private
    { Private Properties }
    FTicks: Integer;
    FOptions: TStrings;
    FMobiles: TGLPersistentObjectList;
    FMobilesIndex: TStringList;
    FEvents: TGLPersistentObjectList;
    FCollisionLists: array [TMobileCollisionType] of TGLPersistentObjectList;
    FMessageLog: TGameMessages;
    FStatus: TGameEngineStatus;
    FGameEndCountDown: Double;

  protected
    { Protected Properties }
    function GetMobile(index: Integer): TMobile;

    property Events: TGLPersistentObjectList read FEvents write FEvents;

  public
    { Public Properties }
    constructor Create;
    destructor Destroy; override;

    procedure Startup; virtual;
    procedure Pause; virtual;
    procedure Resume; virtual;
    procedure Completed; virtual;

    procedure Progress(const deltaTime: Double); override;
    procedure Loaded; override;
    procedure CheckCollisions(const deltaTime: Double);
    procedure CheckTerrainCollision(Mobile: TMobile); virtual;
    procedure CheckMobileCollision(mobile1, mobile2: TMobile;
      deltaTime: Double);
    procedure CheckMobileVsStaticCollision(Mobile, static: TMobile;
      deltaTime: Double);

    function ObjectByName(const aName: String): TGameEngineObject; virtual;

    procedure NotifyAllMobiles(aMobile: TMobile;
      operation: TGameOperation); virtual;
    procedure EnumerateMobiles(mobileClass: TMobileClass;
      destList: TGLPersistentObjectList);
    procedure Clear; dynamic;

    property Status: TGameEngineStatus read FStatus;
    property Ticks: Integer read FTicks;
    property GameEndCountDown: Double read FGameEndCountDown
      write FGameEndCountDown;
    procedure DoGameCountDown(secondsRemaining: Integer); virtual;

    property Mobiles[index: Integer]: TMobile read GetMobile;
    function AddMobile(aMobile: TMobile): Integer;
    function IndexOfMobile(aMobile: TMobile): Integer;
    procedure RemoveMobile(aMobile: TMobile);
    function MobileByName(const aName: String): TMobile;
    function MobileCount: Integer;

    property MessageLog: TGameMessages read FMessageLog;
    procedure AddMessage(const Text: String;
      FromMobile, ToMobile: TMobile); overload;
    procedure CleanMessageLog(const olderThanTicks: Integer = MaxInt);
    procedure FilterMessagesTo(ToMobile: TMobile; minTicks: Integer;
      destList: TStrings);

    procedure RegisterEvent(gameEvent: TGameEvent);
    function EventByName(const aName: String): TGameEvent;

    property Options: TStrings read FOptions write FOptions;
  end;

var
  vSpeedScaleUp: Single = 1;

procedure RegisterControlerClass(const aClass: TControlerClass);
function ControlerClass(const aName: String): TControlerClass;

procedure RegisterGameEventClass(const aClass: TGameEventClass);
function GameEventClass(const aName: String): TGameEventClass;

procedure PreProcessor(data: TStrings);

{ : Estimates best-case interception time to target.<p>
  The higher the quality, the better the estimate:
  - 0 : takes into account only distance and self speed
  - 1 : takes into account target speed too (roughly).
  - 2 : better accounting for target speed. }
function BestCaseInterceptTime(quality: Integer; const chaserPos: TGLVector;
  chaserSpeed: Single; const targetPos, targetVelocity: TGLVector): Single;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  GLS.ApplicationFileIO,
  UABUtils;

var
  vRegisteredControlers: TStringList;
  vRegisteredGameEvents: TStringList;

  // RegisterControlerClass
  //
procedure RegisterControlerClass(const aClass: TControlerClass);
begin
  if not Assigned(vRegisteredControlers) then
    vRegisteredControlers := TStringList.Create;
  vRegisteredControlers.AddObject(aClass.ClassName, TObject(aClass));
end;

// ControlerClass
//
function ControlerClass(const aName: String): TControlerClass;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(vRegisteredControlers) then
  begin
    i := vRegisteredControlers.IndexOf(aName);
    if i >= 0 then
      Result := TControlerClass(vRegisteredControlers.Objects[i]);
  end;
end;

// RegisterGameEventClass
//
procedure RegisterGameEventClass(const aClass: TGameEventClass);
begin
  if not Assigned(vRegisteredGameEvents) then
    vRegisteredGameEvents := TStringList.Create;
  vRegisteredGameEvents.AddObject(aClass.ClassName, TObject(aClass));
end;

// GameEventClass
//
function GameEventClass(const aName: String): TGameEventClass;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(vRegisteredGameEvents) then
  begin
    i := vRegisteredGameEvents.IndexOf(aName);
    if i >= 0 then
      Result := TGameEventClass(vRegisteredGameEvents.Objects[i]);
  end;
end;

// PreProcessor
//
procedure PreProcessor(data: TStrings);
var
  i, k: Integer;
  blocks: TGLPersistentObjectList;
  s: TStream;
  sl: TStringList;
  curLine: String;
begin
  blocks := TGLPersistentObjectList.Create;
  blocks.Add(TStringList.Create);
  i := 0;
  while i < data.Count do
  begin
    curLine := Trim(data[i]);
    if (curLine = '') or (curLine[1] = ';') then
    begin
      // skip
    end
    else if curLine[1] = '#' then
    begin
      // preprocessor command
      if Copy(curLine, 1, 9) = '#include ' then
      begin
        s := TFileStream.Create(Copy(curLine, 10, MaxInt), fmOpenRead);
        sl := TStringList.Create;
        try
          sl.LoadFromStream(s);
          for k := sl.Count - 1 downto 0 do
            data.Insert(i + 1, sl[k]);
        finally
          sl.Free;
          s.Free;
        end;
      end
      else
        Assert(False, 'Unknown preprocessor command ' + curLine);
    end
    else if Copy(curLine, Length(curLine) - 4, 5) = 'begin' then
    begin
      // new block
      blocks.Add(TStringList.Create);
      TStrings(blocks.Last).Add(Trim(Copy(curLine, 1, Length(curLine) - 5)));
    end
    else if (curLine = 'end') or (curLine = 'end;') then
    begin
      // end of block
      Assert(blocks.Count > 1, 'Unbalanced "end"');
      curLine := TStrings(blocks.Last).CommaText;
      blocks.PopAndFree;
      TStrings(blocks.Last).Add(curLine);
    end
    else
      TStrings(blocks.Last).Add(curLine);
    Inc(i);
  end;
  Assert(blocks.Count = 1, 'Unbalanced "begin"');
  data.Assign(TStrings(blocks.First));
  blocks.CleanFree;
end;

// BestCaseInterceptTime
//
function BestCaseInterceptTime(quality: Integer; const chaserPos: TGLVector;
  chaserSpeed: Single; const targetPos, targetVelocity: TGLVector): Single;
var
  invSpeed: Single;
  targEst: TGLVector;
begin
  invSpeed := 1 / (chaserSpeed + 0.1);
  Result := VectorDistance(chaserPos, targetPos) * invSpeed;
  if quality >= 1 then
  begin
    targEst := VectorCombine(targetPos, targetVelocity, 1, Result);
    Result := VectorDistance(chaserPos, targEst) * invSpeed;
    if quality >= 2 then
    begin
      targEst := VectorCombine(targetPos, targetVelocity, 1, Result);
      Result := VectorDistance(chaserPos, targEst) * invSpeed;
    end;
  end;
end;

// ------------------
// ------------------ TGameEngineObject ------------------
// ------------------

// Progress
//
procedure TGameEngineObject.Progress(const deltaTime: Double);
begin
  // nothing
end;

// SaveToStrings
//
procedure TGameEngineObject.SaveToStrings(data: TStrings);
begin
  data.Values['Name'] := Name;
  if Disabled then
    data.Values['Disabled'] := 'Y'
  else
    data.Values['Disabled'] := 'N';
end;

// LoadFromStrings
//
procedure TGameEngineObject.LoadFromStrings(data: TStrings);
begin
  Name := data.Values['Name'];
  Disabled := (data.Values['Enabled'] = 'N') or (data.Values['Disabled'] = 'Y');
end;

// Loaded
//
procedure TGameEngineObject.Loaded;
begin
  // nothing
end;

// SaveToFile
//
procedure TGameEngineObject.SaveToFile(const fileName: String);
var
  s: TStream;
  sl: TStringList;
begin
  s := TFileStream.Create(fileName, fmCreate);
  sl := TStringList.Create;
  try
    SaveToStrings(sl);
    sl.SaveToStream(s);
  finally
    sl.Free;
    s.Free;
  end;
end;

// LoadFromFile
//
procedure TGameEngineObject.LoadFromFile(const fileName: String);
var
  s: TStream;
  sl: TStringList;
begin
  s := TFileStream.Create(fileName, fmOpenRead);
  sl := TStringList.Create;
  try
    sl.LoadFromStream(s);
    PreProcessor(sl);
    LoadFromStrings(sl);
  finally
    sl.Free;
    s.Free;
  end;
end;

// SaveToString
//
function TGameEngineObject.SaveToString: String;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    SaveToStrings(sl);
    Result := sl.CommaText;
  finally
    sl.Free;
  end;
end;

// LoadFromString
//
procedure TGameEngineObject.LoadFromString(const data: String);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.CommaText := data;
    LoadFromStrings(sl);
  finally
    sl.Free;
  end;
end;

// SetName
//
procedure TGameEngineObject.SetName(const val: String);
begin
  FName := val;
end;

// SetDisabled
//
procedure TGameEngineObject.SetDisabled(val: Boolean);
begin
  FDisabled := val;
end;

// ------------------
// ------------------ TMobile ------------------
// ------------------

// Create
//
constructor TMobile.Create(aGameEngine: TGameEngine = nil);
begin
  inherited Create;
  if Assigned(aGameEngine) then
    aGameEngine.AddMobile(Self);
end;

// Destroy
//
destructor TMobile.Destroy;
begin
  Collision.Free;
  Controler.Free;
  if Assigned(FGameEngine) then
    FGameEngine.RemoveMobile(Self);
  inherited;
end;

// Progress
//
procedure TMobile.Progress(const deltaTime: Double);
var
  f: Single;
begin
  // integrate velocity
  f := deltaTime * vSpeedScaleUp;
  CombineVector(FPosition, Velocity, f);
  FPosition.W := 1;
end;

// DoDetonate
//
procedure TMobile.DoDetonate;
begin
  Free;
end;

// Notification
//
procedure TMobile.Notification(aMobile: TMobile; operation: TGameOperation);
begin
  if Controler <> nil then
    Controler.Notification(aMobile, operation);
end;

// SaveToStrings
//
procedure TMobile.SaveToStrings(data: TStrings);
begin
  inherited;
  if Collision <> nil then
    data.Values['Collision'] := Collision.SaveToString
  else
    data.Values['Collision'] := '';
end;

// LoadFromStrings
//
procedure TMobile.LoadFromStrings(data: TStrings);
var
  buf: String;
begin
  inherited;
  Collision.Free;
  buf := data.Values['Collision'];
  if buf <> '' then
    TCollisionVolume.Create(Self).LoadFromString(buf);
end;

// SetOrientationFromVelocity
//
procedure TMobile.SetOrientationFromVelocity(const Up: TGLVector);
var
  RightVector: TGLVector;
begin
  RightVector := VectorCrossProduct(Velocity, ZHmgVector);
  FDirection := VectorNormalize(Velocity);
  FUp := VectorNormalize(VectorCrossProduct(RightVector, Direction));
end;

// BestCaseInterceptTime
//
function TMobile.BestCaseInterceptTime(target: TMobile;
  quality: Integer): Single;
begin
  Result := UGameEngine.BestCaseInterceptTime(quality, Position, Speed,
    target.Position, target.Velocity);
end;

// SetVelocity
//
procedure TMobile.SetVelocity(const aVelocity: TGLVector);
begin
  FVelocity := aVelocity;
  FVelocity.W := 0;
  FSpeed := VectorLength(FVelocity);
end;

// SetName
//
procedure TMobile.SetName(const val: String);
var
  i: Integer;
begin
  if val <> Name then
  begin
    if Name <> '' then
    begin
      i := GameEngine.FMobilesIndex.IndexOfObject(Self);
      Assert(i >= 0);
      GameEngine.FMobilesIndex.Delete(i);
    end;
    FName := val;
    if Name <> '' then
      GameEngine.FMobilesIndex.AddObject(Name, Self);
  end;
end;

// ------------------
// ------------------ TGameEngine ------------------
// ------------------

// Create
//
constructor TGameEngine.Create;
var
  mct: TMobileCollisionType;
begin
  inherited;
  FStatus := gesInitializing;
  FOptions := TStringList.Create;
  FMobiles := TGLPersistentObjectList.Create;
  FMobilesIndex := TStringList.Create;
  FMobilesIndex.Sorted := True;
  FMobilesIndex.Duplicates := dupAccept;
  FEvents := TGLPersistentObjectList.Create;
  for mct := Low(FCollisionLists) to High(FCollisionLists) do
    FCollisionLists[mct] := TGLPersistentObjectList.Create;
end;

// Destroy
//
destructor TGameEngine.Destroy;
var
  mct: TMobileCollisionType;
begin
  FStatus := gesFinalizing;
  for mct := Low(FCollisionLists) to High(FCollisionLists) do
    FCollisionLists[mct].Free;
  Clear;
  FOptions.Free;
  FEvents.Free;
  FMobiles.Free;
  FMobilesIndex.Free;
  inherited;
end;

// Startup
//
procedure TGameEngine.Startup;
begin
  FStatus := gesPlaying;
end;

// Pause
//
procedure TGameEngine.Pause;
begin
  Assert(Status = gesPlaying);
  FStatus := gesPaused;
end;

// Resume
//
procedure TGameEngine.Resume;
begin
  Assert(Status = gesPaused);
  FStatus := gesPlaying;
end;

// Completed
//
procedure TGameEngine.Completed;
begin
  FStatus := gesCompleted;
end;

// Progress
//
procedure TGameEngine.Progress(const deltaTime: Double);
var
  i: Integer;
  Controler: TControler;
  Mobile: TMobile;
  event: TGameEvent;
  lastSecond, newSecond: Integer;
begin
  if deltaTime = 0 then
    Exit;

  Inc(FTicks);

  // fire events
  for i := 0 to FEvents.Count - 1 do
  begin
    event := TGameEvent(FEvents[i]);
    if (not event.Disabled) and event.Triggered then
      event.Trigger;
    if event.Completed then
    begin
      event.Free;
      FEvents[i] := nil;
    end;
  end;
  FEvents.Pack;

  // check for collisions
  CheckCollisions(deltaTime);
  // Detonate stuff (special loop as stuff may disappear as we go)
  i := FMobiles.Count - 1;
  while i >= 0 do
  begin
    if i < FMobiles.Count then
    begin
      Mobile := TMobile(FMobiles.List[i]);
      if Mobile.Detonate then
        Mobile.DoDetonate;
    end;
    Dec(i);
  end;
  // progress all mobile's controlers
  for i := 0 to FMobiles.Count - 1 do
  begin
    Controler := TMobile(FMobiles.List[i]).Controler;
    if (Controler <> nil) and (not Controler.Disabled) then
      Controler.Progress(deltaTime);
  end;
  // progress all mobiles (mobiles are allowed to self-destruct here too)
  i := FMobiles.Count - 1;
  while i >= 0 do
  begin
    if i < FMobiles.Count then
    begin
      Mobile := TMobile(FMobiles.List[i]);
      if not Mobile.Disabled then
        Mobile.Progress(deltaTime);
    end;
    Dec(i);
  end;

  if (Status = gesPlaying) and (FGameEndCountDown <> 0) then
  begin
    lastSecond := Trunc(FGameEndCountDown);
    FGameEndCountDown := FGameEndCountDown - deltaTime;
    newSecond := Trunc(FGameEndCountDown);
    if newSecond <> lastSecond then
      DoGameCountDown(newSecond);
    if FGameEndCountDown < 0 then
      Completed;
  end;
end;

// Loaded
//
procedure TGameEngine.Loaded;
var
  i: Integer;
begin
  for i := 0 to MobileCount - 1 do
    Mobiles[i].Loaded;
end;

// CheckCollisions
//
procedure TGameEngine.CheckCollisions(const deltaTime: Double);
var
  mct: TMobileCollisionType;
  i, j, n: Integer;
  Mobile: TMobile;
begin
  n := MobileCount;
  // build categories lists
  for mct := Low(FCollisionLists) to High(FCollisionLists) do
    FCollisionLists[mct].Count := 0;
  for i := 0 to n - 1 do
  begin
    Mobile := TMobile(FMobiles[i]);
    if Mobile.Collision <> nil then
      FCollisionLists[Mobile.Collision.CollType].Add(Mobile);
  end;
  // collide mobiles against static, mobile, ammo and immaterial
  for i := 0 to FCollisionLists[mctMobile].Count - 1 do
  begin
    Mobile := TMobile(FCollisionLists[mctMobile][i]);
    CheckTerrainCollision(Mobile);
    for j := 0 to FCollisionLists[mctStatic].Count - 1 do
      CheckMobileVsStaticCollision(Mobile, TMobile(FCollisionLists[mctStatic][j]
        ), deltaTime);
    for j := i + 1 to FCollisionLists[mctMobile].Count - 1 do
      CheckMobileCollision(Mobile, TMobile(FCollisionLists[mctMobile][j]),
        deltaTime);
    for j := 0 to FCollisionLists[mctAmmo].Count - 1 do
      CheckMobileCollision(Mobile, TMobile(FCollisionLists[mctAmmo][j]),
        deltaTime);
    for j := 0 to FCollisionLists[mctImmaterial].Count - 1 do
      CheckMobileCollision(Mobile, TMobile(FCollisionLists[mctImmaterial][j]),
        deltaTime);
  end;
  // collide ammo against static
  for i := 0 to FCollisionLists[mctAmmo].Count - 1 do
  begin
    Mobile := TMobile(FCollisionLists[mctAmmo][i]);
    CheckTerrainCollision(Mobile);
    for j := 0 to FCollisionLists[mctStatic].Count - 1 do
      CheckMobileVsStaticCollision(Mobile, TMobile(FCollisionLists[mctStatic][j]
        ), deltaTime);
  end;
end;

// CheckTerrainCollision
//
procedure TGameEngine.CheckTerrainCollision(Mobile: TMobile);
begin
  // nothing
end;

// CheckMobileCollision
//
procedure TGameEngine.CheckMobileCollision(mobile1, mobile2: TMobile;
  deltaTime: Double);
var
  p, dir, mVel: TGLVector;
  t, d: Single;
begin
  // is there a possible collision?
  if mobile1.DistanceTo(mobile2) - mobile1.Speed - mobile2.Speed <
    mobile1.Collision.Radius + mobile2.Collision.Radius then
  begin
    // express everything as if mobile2 was static
    dir := VectorNormalize(mobile1.Velocity);
    p := VectorSubtract(mobile2.Position, mobile1.Position);
    mVel := VectorCombine(mobile1.Velocity, dir, 1,
      VectorDotProduct(mobile2.Velocity, dir));
    t := ClampValue(VectorDotProduct(p, dir) / VectorLength(mVel), 0,
      deltaTime);
    // check distance at t
    d := VectorDistance(VectorScale(mVel, t), p);
    if d < mobile1.Collision.Radius + mobile2.Collision.Radius then
    begin
      mobile1.Notification(mobile2, goCollide);
      mobile2.Notification(mobile1, goCollide);
    end;
  end;
end;

// CheckMobileVsStaticCollision
//
procedure TGameEngine.CheckMobileVsStaticCollision(Mobile, static: TMobile;
  deltaTime: Double);
var
  p, dir: TGLVector;
  t, d: Single;
begin
  // determine point where mobile is closest to static within deltaTime
  p := VectorSubtract(static.Position, Mobile.Position);
  dir := VectorNormalize(Mobile.Velocity);
  t := ClampValue(VectorDotProduct(p, dir) / Mobile.Speed, 0, deltaTime);
  // check distance at t
  d := VectorDistance(VectorCombine(Mobile.Position, Mobile.Velocity, 1, t),
    static.Position);
  if d < Mobile.Collision.Radius + static.Collision.Radius then
  begin
    Mobile.Notification(Mobile, goCollide);
    static.Notification(static, goCollide);
  end;
end;

// ObjectByName
//
function TGameEngine.ObjectByName(const aName: String): TGameEngineObject;
begin
  Result := EventByName(aName);
  if Result = nil then
    Result := MobileByName(aName);
end;

// NotifyAllMobiles
//
procedure TGameEngine.NotifyAllMobiles(aMobile: TMobile;
  operation: TGameOperation);
var
  i: Integer;
begin
  for i := 0 to FMobiles.Count - 1 do
    TMobile(FMobiles[i]).Notification(aMobile, operation);
end;

// EnumerateMobiles
//
procedure TGameEngine.EnumerateMobiles(mobileClass: TMobileClass;
  destList: TGLPersistentObjectList);
var
  i: Integer;
  Mobile: TMobile;
begin
  for i := 0 to FMobiles.Count - 1 do
  begin
    Mobile := TMobile(FMobiles[i]);
    if Mobile.ClassType = mobileClass then
      destList.Add(Mobile);
  end;
end;

// Clear
//
procedure TGameEngine.Clear;
var
  mob: TMobile;
begin
  while MobileCount > 0 do
  begin
    mob := Mobiles[MobileCount - 1];
    NotifyAllMobiles(mob, goRemove);
    if mob.Controler <> nil then
      mob.Controler.Free;
    mob.Free;
  end;
  SetLength(FMessageLog, 0);
  FEvents.Clean;
  FTicks := 0;
  FGameEndCountDown := 0;
end;

// DoGameCountDown
//
procedure TGameEngine.DoGameCountDown(secondsRemaining: Integer);
begin
  // nothing
end;

// AddMobile
//
function TGameEngine.AddMobile(aMobile: TMobile): Integer;
begin
  Assert(aMobile.GameEngine = nil);
  aMobile.GameEngine := Self;
  NotifyAllMobiles(aMobile, goInsert);
  Result := FMobiles.Add(aMobile);
  if aMobile.Name <> '' then
    FMobilesIndex.AddObject(aMobile.Name, aMobile);
end;

// IndexOfMobile
//
function TGameEngine.IndexOfMobile(aMobile: TMobile): Integer;
begin
  Result := FMobiles.IndexOf(aMobile);
end;

// RemoveMobile
//
procedure TGameEngine.RemoveMobile(aMobile: TMobile);
var
  i: Integer;
begin
  Assert(aMobile.GameEngine = Self);
  FMobiles.Remove(aMobile);
  NotifyAllMobiles(aMobile, goRemove);
  aMobile.GameEngine := nil;
  if aMobile.Name <> '' then
  begin
    i := FMobilesIndex.IndexOfObject(aMobile);
    if i >= 0 then
      FMobilesIndex.Delete(i);
  end;
end;

// MobileByName
//
function TGameEngine.MobileByName(const aName: String): TMobile;
var
  i: Integer;
begin
  if Assigned(Self) and (aName <> '') then
  begin
    i := FMobilesIndex.IndexOf(aName);
    if i >= 0 then
    begin
      Result := TMobile(FMobilesIndex.Objects[i]);
      Exit;
    end;
  end;
  Result := nil;
end;

// MobileCount
//
function TGameEngine.MobileCount: Integer;
begin
  Result := FMobiles.Count;
end;

// AddMessage
//
procedure TGameEngine.AddMessage(const Text: String;
  FromMobile, ToMobile: TMobile);
var
  n: Integer;
begin
  n := Length(FMessageLog);
  SetLength(FMessageLog, n + 1);
  FMessageLog[n].Ticks := Ticks;
  FMessageLog[n].FromMobile := FromMobile;
  FMessageLog[n].ToMobile := ToMobile;
  FMessageLog[n].Text := Text;
end;

// CleanMessageLog
//
procedure TGameEngine.CleanMessageLog(const olderThanTicks: Integer = MaxInt);
var
  i, k: Integer;
begin
  k := 0;
  for i := 0 to Length(FMessageLog) do
  begin
    if FMessageLog[i].Ticks > olderThanTicks then
    begin
      FMessageLog[k] := FMessageLog[i];
      Inc(k);
    end;
  end;
  SetLength(FMessageLog, k);
end;

// FilterMessagesTo
//
procedure TGameEngine.FilterMessagesTo(ToMobile: TMobile; minTicks: Integer;
  destList: TStrings);
var
  i: Integer;
  pMess: PGameMessage;
begin
  for i := High(FMessageLog) downto 0 do
  begin
    pMess := @FMessageLog[i];
    if pMess.Ticks < minTicks then
      Break;
    if (pMess.ToMobile = ToMobile) or (pMess.ToMobile = nil) then
    begin
      destList.AddObject(pMess.Text, TObject(pMess));
    end;
  end;
end;

// RegisterEvent
//
procedure TGameEngine.RegisterEvent(gameEvent: TGameEvent);
begin
  gameEvent.GameEngine := Self;
  FEvents.Add(gameEvent);
end;

// EventByName
//
function TGameEngine.EventByName(const aName: String): TGameEvent;
var
  i: Integer;
begin
  for i := 0 to FEvents.Count - 1 do
  begin
    Result := TGameEvent(FEvents[i]);
    if Assigned(Result) and (Result.Name = aName) then
      Exit;
  end;
  Result := nil;
end;

// GetMobile
//
function TGameEngine.GetMobile(index: Integer): TMobile;
begin
  Result := TMobile(FMobiles[index]);
end;

// ------------------
// ------------------ TControler ------------------
// ------------------

// Destroy
//
destructor TControler.Destroy;
begin
  Mobile.FControler := nil;
  inherited;
end;

// Progress
//
procedure TControler.Progress(const deltaTime: Double);
begin
  if Assigned(FControler) then
    FControler.Progress(deltaTime);
end;

// Notification
//
procedure TControler.Notification(aMobile: TMobile; operation: TGameOperation);
begin
  if Assigned(FControler) then
    FControler.Notification(aMobile, operation);
end;

// GameEngine
//
function TControler.GameEngine: TGameEngine;
begin
  if Assigned(Mobile) then
    Result := Mobile.GameEngine
  else
    Result := nil;
end;

// SetMobile
//
procedure TControler.SetMobile(aMobile: TMobile);
begin
  if aMobile = FMobile then
    Exit;
  if Assigned(FMobile) then
  begin
    // disconnect previous controler
    if FMobile.Controler <> nil then
      FMobile.Controler.Mobile := nil;
  end;
  FMobile := aMobile;
  if Assigned(FMobile) then
    FMobile.Controler := Self;
end;

// ------------------
// ------------------ TControlerGravity ------------------
// ------------------

// Progress
//
procedure TControlerGravity.Progress(const deltaTime: Double);
begin
  inherited;
  Mobile.Velocity := VectorCombine(Mobile.Velocity, ZHmgVector, 1,
    -10 * deltaTime);
end;

// ------------------
// ------------------ TGameEngine3DObject ------------------
// ------------------

// SaveToStrings
//
procedure TGameEngine3DObject.SaveToStrings(data: TStrings);
begin
  data.Values['Position'] := Vector3ToString(FPosition);
  data.Values['Direction'] := Vector3ToString(FDirection);
  data.Values['Up'] := Vector3ToString(FUp);
  inherited;
end;

// LoadFromStrings
//
procedure TGameEngine3DObject.LoadFromStrings(data: TStrings);
begin
  MakePoint(FPosition, StringToVector3(data.Values['Position']));
  MakeVector(FDirection, StringToVector3(data.Values['Direction']));
  MakeVector(FUp, StringToVector3(data.Values['Up']));
  inherited;
end;

// IsAhead
//
function TGameEngine3DObject.IsAhead(const p: TGLVector): Boolean;
begin
  Result := (VectorDotProduct(Direction, VectorSubtract(p, Position)) > 0)
end;

// IsAhead
//
function TGameEngine3DObject.IsAhead(obj: TGameEngine3DObject): Boolean;
begin
  Result := (VectorDotProduct(Direction, VectorSubtract(obj.Position,
    Position)) > 0)
end;

// DistanceTo
//
function TGameEngine3DObject.DistanceTo(obj: TGameEngine3DObject): Single;
begin
  Result := VectorDistance(Position, obj.Position);
end;

// DistanceToSquared
//
function TGameEngine3DObject.DistanceToSquared
  (obj: TGameEngine3DObject): Single;
begin
  Result := VectorDistance2(Position, obj.Position);
end;

// AbsoluteToRelative
//
function TGameEngine3DObject.AbsoluteToRelative(const p: TGLVector): TGLVector;
var
  pRel: TGLVector;
begin
  pRel := VectorSubtract(p, Position);
  Result.X := VectorDotProduct(Direction, pRel);
  Result.Y := VectorDotProduct(Leftvector, pRel);
  Result.Z := VectorDotProduct(Up, pRel);
  Result.W := 1;
end;

// BearingElevation
//
procedure TGameEngine3DObject.BearingElevation(const p: TGLVector;
  var bearing, elevation: Single);
var
  locP: TGLVector;
begin
  // compute its local coordinates (X front, Y left, Z up)
  locP := AbsoluteToRelative(p);

  // then determinate bearing and elevation relatively to ourself (in rad)
  bearing := ClampValue(ArcTan2(locP.Y, locP.X), -3, 3);
  elevation := ArcTan2(locP.Z, locP.X);
end;

// RightVector
//
function TGameEngine3DObject.RightVector: TGLVector;
begin
  Result := VectorCrossProduct(Direction, Up);
end;

// Leftvector
//
function TGameEngine3DObject.Leftvector: TGLVector;
begin
  Result := VectorCrossProduct(Up, Direction);
end;

// ------------------
// ------------------ TGameEvent ------------------
// ------------------

// Triggered
//
function TGameEvent.Triggered: Boolean;
begin
  Result := (EventTime <= GameEngine.Ticks);
end;

// Trigger
//
procedure TGameEvent.Trigger;
begin
  Completed := True;
end;

// SaveToStrings
//
procedure TGameEvent.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['Time'] := FloatToStr(EventTime * 0.01);
end;

// LoadFromStrings
//
procedure TGameEvent.LoadFromStrings(data: TStrings);
begin
  inherited;
  EventTime := Round(StrToFloatDef(data.Values['Time'], 0) * 100);
end;

// SetDisabled
//
procedure TGameEvent.SetDisabled(val: Boolean);
begin
  inherited;
  if not Completed then
  begin
    // event countdown stopped while disable
    if val then
      EventTime := EventTime - GameEngine.Ticks
    else
      EventTime := GameEngine.Ticks + EventTime;
  end;
end;

// ------------------
// ------------------ TGameEventTerminator ------------------
// ------------------

// Trigger
//
procedure TGameEventTerminator.Trigger;
begin
  FList.CleanFree;
  inherited;
end;

// ------------------
// ------------------ TCollisionVolume ------------------
// ------------------

// Create
//
constructor TCollisionVolume.Create(aMobile: TMobile);
begin
  inherited Create;
  aMobile.FCollision := Self;
  FMobile := aMobile;
  FSize := XYZVector;
  FRadius := 1;
end;

// Destroy
//
destructor TCollisionVolume.Destroy;
begin
  inherited;
  if Assigned(FMobile) then
    FMobile.FCollision := nil;
end;

const
  cCollType: array [TMobileCollisionType] of String = ('Static', 'Mobile',
    'Ammo', 'Immaterial');

  // SaveToStrings
  //
procedure TCollisionVolume.SaveToStrings(data: TStrings);
begin
  data.Values['Size'] := Vector3ToString(Size);
  data.Values['Type'] := cCollType[CollType];
end;

// LoadFromStrings
//
procedure TCollisionVolume.LoadFromStrings(data: TStrings);
var
  i: TMobileCollisionType;
  buf: String;
begin
  Size := StringToVector3(data.Values['Size']);
  buf := data.Values['Type'];
  for i := Low(cCollType) to High(cCollType) do
  begin
    if buf = cCollType[i] then
    begin
      FCollType := i;
      Break;
    end;
  end;
end;

// SetSize
//
procedure TCollisionVolume.SetSize(const val: TAffineVector);
begin
  FSize := val;
  FRadius := MaxFloat(val.X, val.Y, val.Z);
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

finalization

FreeAndNil(vRegisteredControlers);

end.
