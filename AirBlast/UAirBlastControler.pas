unit UAirBlastControler;

(*
  Airplane controler classes.
  These are the actuators through which
  all actions (AI or player) should go.
*)

interface

uses
  System.Classes,
  System.Math,
  UAirplane,
  UGameEngine,
  UAirBlastEngine,
  UABEquipments,
  GLS.VectorGeometry,
  GLS.Scene,
  GLS.PersistentClasses,
  GLS.Objects,
  GLS.VectorTypes;

type

  // TABControler
  //
  { : Base abstract controler class. }
  TABControler = class(TControler)
  private
    { Private Properties }
    FAirplane: TABAirplane;

  protected
    { Protected Properties }
    function GroundCrashTest(var timeLapse: Single): Boolean;

    procedure SetMobile(aMobile: TMobile); override;

  public
    { Public Properties }

    // : steering command adjustment
    procedure Steer(roll, pitch, yaw: Single); virtual;
    // : throttle adjustment
    procedure Throttle(value: Single); virtual;
    // : fire with current equipment group
    procedure Fire(primary: Boolean); virtual;
    // : cycle targets
    procedure CycleTargets(next: Boolean); virtual;
    // : target enemy nearest to self
    procedure TargetNearestEnemy; virtual;
    // : target aimed airplane
    procedure TargetAimed; virtual;
    // cycle weapons (groups)
    procedure CycleWeapons(next: Boolean); virtual;
    // drop a decoy
    procedure DropDecoy; virtual;
    // use fire control systems (if any)
    procedure FireControl; virtual;
    // use airbrake
    procedure AirBrake; virtual;
    // Wingleader orders
    procedure WingLeaderOrder(order: TABWingLeaderOrder); virtual;

    property Airplane: TABAirplane read FAirplane;
  end;

  // TABControlerLog
  //
  { : Base class for log controlers (record/playback).<p>
    Assumes that all deltaTimes are of fixed length. }
  TABControlerLog = class(TABControler)
  private
    { Private Properties }
    FTick: Integer;
    FLog: TStrings;

  protected
    { Protected Properties }
    procedure DoLog(const data: String);

  public
    { Public Properties }
    constructor Create;
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;

    procedure Reset; dynamic;

    property Log: TStrings read FLog;
    property Tick: Integer read FTick;
  end;

  // TABControlerRecorder
  //
  { : Controler that records all actions changes into a timed log.<p>
    Assumes that all deltaTimes are of fixed length. }
  TABControlerRecorder = class(TABControlerLog)
  private
    { Private Properties }
    FLastSteer: TAffineVector;
    FLastThrottle: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Steer(roll, pitch, yaw: Single); override;
    procedure Throttle(value: Single); override;
    procedure Fire(primary: Boolean); override;
    procedure CycleTargets(next: Boolean); override;
    procedure TargetNearestEnemy; override;
    procedure TargetAimed; override;
    procedure CycleWeapons(next: Boolean); override;
    procedure DropDecoy; override;
    procedure FireControl; override;
    procedure AirBrake; override;
    procedure WingLeaderOrder(order: TABWingLeaderOrder); override;

    // : Clear log and reset ticks
    procedure Reset; override;
  end;

  // TABControlerPlayback
  //
  { : Controler that plays back recorded actions.<p>
    Assumes that all deltaTimes are of fixed length. }
  TABControlerPlayback = class(TABControlerLog)
  private
    { Private Properties }
    FNextEventsTick: Integer;
    FLogIter: Integer;
    FPlaybackControler: TABControler;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;
    // : Reset playback
    procedure Reset; override;

    property PlaybackControler: TABControler read FPlaybackControler
      write FPlaybackControler;
  end;

  // TABControlerTracker
  //
  { : Controler that offers a basic service to aim for a target.<p> }
  TABControlerTracker = class(TABControler)
  private
    { Private Properties }
    FIntegralBearing, FIntegralElevation: Single;
    FTargetPosition: TGLVector;
    FTargetVelocity: TGLVector;
    FIntegralGain: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure SteerToTarget(const deltaTime: Double); virtual;
    procedure SteerSkyward(const deltaTime: Double); virtual;

    property TargetPosition: TGLVector read FTargetPosition
      write FTargetPosition;
    property TargetVelocity: TGLVector read FTargetVelocity
      write FTargetVelocity;
    property IntegralGain: Single read FIntegralGain write FIntegralGain;
  end;

  // TABControlerMobileTracker
  //
  { : Controler that does its best to follow a mobile.<p> }
  TABControlerMobileTracker = class(TABControlerTracker)
  private
    { Private Properties }
    FTargetMobile: TMobile;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property TargetMobile: TMobile read FTargetMobile write FTargetMobile;
  end;

  // TABControlerMissileTracker
  //
  { : Controler that tracks using yaw/pitch.<p> }
  TABControlerMissileTracker = class(TABControlerMobileTracker)
  private
    { Private Properties }
    FProximityFuse: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure SteerToTarget(const deltaTime: Double); override;
    procedure SteerSkyward(const deltaTime: Double); override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property ProximityFuse: Single read FProximityFuse write FProximityFuse;
  end;

  TWaypoints = array of TGLVector;

  // TABControlerWaypoints
  //
  { : Controler that follows its waypoints.<p> }
  TABControlerWaypoints = class(TABControlerTracker)
  private
    { Private Properties }
    FWaypoints: TWaypoints;
    FCurrentWaypoint: Integer;
    FWaypointBumpDistance: Single;

  protected
    { Protected Properties }
    procedure SetCurrentWaypoint(val: Integer);

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    function CreateGLLines(const aParent: TGLBaseSceneObject): TGLLines;

    property Waypoints: TWaypoints read FWaypoints write FWaypoints;
    procedure AddWaypoint(const coord: TGLVector);
    procedure ClearWaypoints;

    property CurrentWaypoint: Integer read FCurrentWaypoint
      write SetCurrentWaypoint;
    property WaypointBumpDistance: Single read FWaypointBumpDistance
      write FWaypointBumpDistance;
  end;

  TAIState = (aisNone, aisChase, aisEvade, aisAvoidGround, aisBreakOff,
    aisFollow, aisGoTo);
  TAILevel = (ailHarmless, ailNoob, ailRecruit, ailSoldier, ailVeteran, ailAce);
  TAIOrder = (aioEngageEnemies, aioEngageTarget, aioFollowLeader,
    aioCoverLeader, aioAssistLeader, aioGoTo);

  // TABControlerAI
  //
  { : AI Controler.<p> }
  TABControlerAI = class(TABControlerTracker)
  private
    { Private Properties }
    FAIState: TAIState;
    FTargetingMe: TGLPersistentObjectList;
    FMissileFireDelay: Single;
    FThrottleIntegral: Single;
    FBreakOffCommand: TAffineVector;
    FSmoothedTargetDistance: Single;
    FAILevel: TAILevel;
    FGroundCrashAITestDistance: Single;
    FMissileAIDropDecoyDistance: Single;
    FMissileAIFireDelay: Single;
    FAIAirBrakeProba, FAIAirBrakeDelay: Single;
    FBreakOffAIMultiplier, FBreakOffAIDistance, FBreakOffAIRoll: Single;
    FAimingAIQuality: Integer;
    FTriggerHappyAI: Single;
    FManeuverabilityAI: Single;
    FAIOrder: TAIOrder;
    FAIOrderParam: String;
    FAIOrderExecutionDelay: Single;
    FAIOrderWLO: TABWingLeaderOrder;
    FNextChatDelay: Single;
    FLastAcceptN: Integer;

  protected
    { Protected Properties }
    function NearestMobile(aList: TGLPersistentObjectList): TMobile;
    procedure FilterOutSameTeam(aList: TGLPersistentObjectList);
    function OptimalWeapon(targetDistance: Single): TABEqptWeapon;
    function OptimalTarget(engaging: TMobile = nil): TABAirplane;
    function NearestIncomingMissileTimeToIntercept: Single;
    procedure DoRandomBreakOff(duration: Single);
    procedure SetAIOrder(val: TAIOrder);
    procedure CurrentOrderCompleted;
    procedure InitiateChase(target: TABAirplane);

    procedure Voice(const aMessage: String);
    procedure VoiceAcceptOrder(const extraOption: String = '');

    procedure PerformAINone(const deltaTime: Double);
    procedure PerformAIChase(const deltaTime: Double);
    procedure PerformAIAvoidGround(const deltaTime: Double);
    procedure PerformAIBreakOff(const deltaTime: Double);
    procedure PerformAIFollow(const deltaTime: Double);
    procedure PerformAIGoTo(const deltaTime: Double);

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;

    procedure Steer(roll, pitch, yaw: Single); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    procedure ExecuteWingLeaderOrder(order: TABWingLeaderOrder; delay: Single);
    procedure DoExecuteWingLeaderOrder;

    property AIState: TAIState read FAIState;
    property AILevel: TAILevel read FAILevel;
    property AIOrder: TAIOrder read FAIOrder write SetAIOrder;
    property AIOrderParam: String read FAIOrderParam write FAIOrderParam;
  end;

const
  cAILevelNames: array [TAILevel] of String = ('Harmless', 'Noob', 'Recruit',
    'Soldier', 'Veteran', 'Ace');
  cAIOrderNames: array [TAIOrder] of String = ('EngageEnemies', 'EngageTarget',
    'FollowLeader', 'CoverLeader', 'AssistLeader', 'GoTo');

  // ------------------------------------------------------------------
  // ------------------------------------------------------------------
  // ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  UABUtils,
  GLS.TerrainRenderer;

// ------------------
// ------------------ TABControler ------------------
// ------------------

// SetMobile
//
procedure TABControler.SetMobile(aMobile: TMobile);
begin
  inherited;
  FAirplane := TABAirplane(aMobile);
end;

// GroundCrashTest
//
function TABControler.GroundCrashTest(var timeLapse: Single): Boolean;
var
  t, h, margin, d: Single;
  p: TGLVector;
  terrain: TGLTerrainRenderer;
begin
  // are we on a crash course?
  t := 0;
  margin := (Mobile.Collision.Radius * 3 + Mobile.Speed * 0.5);
  d := 0.5;
  terrain := Airplane.ABEngine.TerrainRenderer;
  while t <= timeLapse do
  begin
    p := VectorCombine(Mobile.Position, Mobile.Velocity, 1, t);
    h := p.Z - terrain.InterpolatedHeight(p) - margin;
    if h <= 0 then
    begin
      timeLapse := t;
      Result := True;
      Exit;
    end;
    t := t + d;
    d := d * 1.1;
  end;
  Result := False;
end;

// Steer
//
procedure TABControler.Steer(roll, pitch, yaw: Single);
begin
  if Assigned(Controler) then
    TABControler(Controler).Steer(roll, pitch, yaw);
  if Airplane <> nil then
  begin
    Airplane.RollCmd := roll;
    Airplane.PitchCmd := pitch;
    Airplane.YawCmd := yaw;
  end;
end;

// Throttle
//
procedure TABControler.Throttle(value: Single);
begin
  if Assigned(Controler) then
    TABControler(Controler).Throttle(value);
  if Airplane <> nil then
  begin
    Airplane.Throttle := value;
  end;
end;

// Fire
//
procedure TABControler.Fire(primary: Boolean);
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).Fire(primary);
  if Airplane <> nil then
  begin
    Airplane.Fire(primary);
  end;
end;

// CycleTargets
//
procedure TABControler.CycleTargets(next: Boolean);
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).CycleTargets(next);
  if Airplane <> nil then
  begin
    Airplane.CycleTargets(next);
  end;
end;

// TargetNearestEnemy
//
procedure TABControler.TargetNearestEnemy;
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).TargetNearestEnemy;
  if Airplane <> nil then
  begin
    Airplane.TargetNearestEnemy;
  end;
end;

// TargetAimed
//
procedure TABControler.TargetAimed;
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).TargetAimed;
  if Airplane <> nil then
  begin
    Airplane.TargetAimed;
  end;
end;

// CycleWeapons
//
procedure TABControler.CycleWeapons(next: Boolean);
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).CycleWeapons(next);
  if Airplane <> nil then
    Airplane.CycleWeapons(next);
end;

// DropDecoy
//
procedure TABControler.DropDecoy;
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).DropDecoy;
  if Airplane <> nil then
    Airplane.DropDecoy;
end;

// FireControl
//
procedure TABControler.FireControl;
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).FireControl;
  if Airplane <> nil then
    Airplane.FireControl;
end;

// AirBrake
//
procedure TABControler.AirBrake;
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).AirBrake;
  if Airplane <> nil then
    Airplane.AirBrake;
end;

// WingLeaderOrder
//
procedure TABControler.WingLeaderOrder(order: TABWingLeaderOrder);
begin
  if Assigned(Controler) and (Controler is TABControler) then
    TABControler(Controler).WingLeaderOrder(order);
  if Airplane <> nil then
    Airplane.WingLeaderOrder(order);
end;

// ------------------
// ------------------ TABControlerLog ------------------
// ------------------

// Create
//
constructor TABControlerLog.Create;
begin
  inherited;
  FLog := TStringList.Create;
  Reset;
end;

// Destroy
//
destructor TABControlerLog.Destroy;
begin
  inherited;
  FLog.Free;
end;

// Progress
//
procedure TABControlerLog.Progress(const deltaTime: Double);
begin
  Inc(FTick);
  inherited;
end;

// Reset
//
procedure TABControlerLog.Reset;
begin
  FTick := -1;
end;

// DoLog
//
procedure TABControlerLog.DoLog(const data: String);
var
  n: Integer;
begin
  n := FLog.Count - 1;
  if FLog.Objects[n] = TObject(FTick) then
    FLog[n] := FLog[n] + ',' + data
  else
    FLog.AddObject(IntToStr(FTick) + ':' + data, TObject(FTick));
end;

// ------------------
// ------------------ TABControlerRecorder ------------------
// ------------------

// Steer
//
procedure TABControlerRecorder.Steer(roll, pitch, yaw: Single);
var
  newSteer: TAffineVector;
begin
  newSteer.X := roll;
  newSteer.Y := pitch;
  newSteer.Z := yaw;
  if not VectorEquals(newSteer, FLastSteer) then
  begin
    DoLog(Format('"Steer=%g,%g,%g"', [roll, pitch, yaw]));
    FLastSteer := newSteer;
  end;
  inherited;
end;

// Throttle
//
procedure TABControlerRecorder.Throttle(value: Single);
begin
  if value <> FLastThrottle then
  begin
    DoLog(Format('"Throttle=%g"', [value]));
    FLastThrottle := value;
  end;
  inherited;
end;

// Fire
//
procedure TABControlerRecorder.Fire(primary: Boolean);
begin
  if primary then
    DoLog('Fire=Primary')
  else
    DoLog('Fire=Alternate');
  inherited;
end;

// CycleTargets
//
procedure TABControlerRecorder.CycleTargets(next: Boolean);
begin
  if next then
    DoLog('CycleTargets=Next')
  else
    DoLog('CycleTargets=Prev');
  inherited;
end;

// TargetNearestEnemy
//
procedure TABControlerRecorder.TargetNearestEnemy;
begin
  DoLog('TargetNearestEnemy=Y');
  inherited;
end;

// TargetAimed
//
procedure TABControlerRecorder.TargetAimed;
begin
  DoLog('TargetAimed=Y');
  inherited;
end;

// CycleWeapons
//
procedure TABControlerRecorder.CycleWeapons(next: Boolean);
begin
  if next then
    DoLog('CycleWeapons=Next')
  else
    DoLog('CycleWeapons=Prev');
  inherited;
end;

// DropDecoy
//
procedure TABControlerRecorder.DropDecoy;
begin
  DoLog('DropDecoy=Y');
  inherited;
end;

// FireControl
//
procedure TABControlerRecorder.FireControl;
begin
  DoLog('FireControl=Y');
  inherited;
end;

// AirBrake
//
procedure TABControlerRecorder.AirBrake;
begin
  DoLog('AirBrake=Y');
  inherited;
end;

// WingLeaderOrder
//
procedure TABControlerRecorder.WingLeaderOrder(order: TABWingLeaderOrder);
begin
  DoLog('WingLeaderOrder=' + cWingLeaderOrder[order]);
  inherited;
end;

// Reset
//
procedure TABControlerRecorder.Reset;
begin
  inherited;
  FLastSteer := NullVector;
  FLastThrottle := 0;
  FLog.Clear;
  FLog.Add('0:Start');
end;

// ------------------
// ------------------ TABControlerPlayback ------------------
// ------------------

// Progress
//
procedure TABControlerPlayback.Progress(const deltaTime: Double);
var
  sl: TStringList;
  buf: String;
  p: Integer;
  rpy: TAffineVector;
  Throttle: Single;
  leaderOrder: TABWingLeaderOrder;
begin
  inherited;
  Assert(PlaybackControler <> nil);
  while FTick = FNextEventsTick do
  begin
    buf := FLog[FLogIter];
    p := Pos(':', buf);
    FNextEventsTick := StrToInt(Copy(buf, 1, p - 1));
    if FNextEventsTick = FTick then
    begin
      // perform events
      sl := TStringList.Create;
      try
        sl.CommaText := Copy(buf, p + 1, MaxInt);
        buf := sl.Values['Steer'];
        if buf <> '' then
        begin
          rpy := StringToVector3(buf);
          PlaybackControler.Steer(rpy.X, rpy.Y, rpy.Z);
        end;
        buf := sl.Values['Throttle'];
        if buf <> '' then
        begin
          Throttle := StrToFloat(buf);
          PlaybackControler.Throttle(Throttle);
        end;

        buf := sl.Values['Fire'];
        if buf <> '' then
          PlaybackControler.Fire(buf = 'Primary');

        buf := sl.Values['CycleTargets'];
        if buf <> '' then
          PlaybackControler.CycleTargets(buf = 'Next');
        if sl.Values['TargetNearestEnemy'] <> '' then
          PlaybackControler.TargetNearestEnemy;
        if sl.Values['TargetAimed'] <> '' then
          PlaybackControler.TargetAimed;

        buf := sl.Values['CycleWeapons'];
        if buf <> '' then
          PlaybackControler.CycleWeapons(buf = 'Next');
        if sl.Values['DropDecoy'] <> '' then
          PlaybackControler.DropDecoy;
        if sl.Values['FireControl'] <> '' then
          PlaybackControler.FireControl;
        if sl.Values['AirBrake'] <> '' then
          PlaybackControler.AirBrake;

        buf := sl.Values['WingLeaderOrder'];
        if buf <> '' then
        begin
          for leaderOrder := Low(TABWingLeaderOrder)
            to High(TABWingLeaderOrder) do
          begin
            if buf = cWingLeaderOrder[leaderOrder] then
            begin
              Airplane.WingLeaderOrder(leaderOrder);
              Break;
            end;
          end;
        end;
      finally
        sl.Free;
      end;
      Inc(FLogIter);
      if FLogIter >= FLog.Count then
      begin
        // log ended
        FNextEventsTick := MaxInt;
        Break;
      end;
    end;
  end;
end;

// Reset
//
procedure TABControlerPlayback.Reset;
begin
  inherited;
  FNextEventsTick := 0;
  FLogIter := 0;
end;

// ------------------
// ------------------ TABControlerTracker ------------------
// ------------------

// SteerToTarget
//
procedure TABControlerTracker.SteerToTarget(const deltaTime: Double);
var
  t, dist: Single;
  leftVector: TGLVector;
  targetBearing, targetElevation, roll, pitch, yaw, niceRoll: Single;
  gain: Single;
begin
  // first guesstimate target position at intercept time
  // (not accurate, but we gotta leave the player a chance)
  dist := VectorDistance(Airplane.Position, TargetPosition);
  t := dist / (VectorLength(Airplane.Velocity) + Airplane.Speed + 0.01);

  // adjust gain to distance, so that movements aren't too aggressive when far away
  gain := ClampValue(3 - t * 0.03, 3, 0.2);

  if t > 15 then
    t := 15;

  // then determinate bearing and elevation relatively to ourself (in rad)
  Airplane.BearingElevation(VectorCombine(TargetPosition, TargetVelocity, 1, t),
    targetBearing, targetElevation);

  // PI control loops (not too punchy, jerky planes don't look good)
  FIntegralBearing := ClampValue(FIntegralBearing * 0.9 + targetBearing, -1, 1);
  targetBearing := targetBearing * gain + FIntegralBearing * IntegralGain;
  FIntegralElevation := ClampValue(FIntegralElevation * 0.9 +
    targetElevation, -1, 1);
  targetElevation := targetElevation * gain + FIntegralElevation * IntegralGain;

  // steer accordingly, in a "nice" fashion
  roll := ClampValue(targetBearing, -1, 1);
  pitch := ClampValue(targetElevation, -1, 1);
  yaw := ClampValue(-targetBearing * 0.5, -1, 1);

  leftVector := Airplane.leftVector;
  if (leftVector.Z = 0) and (Airplane.Up.Z < 0) then
    niceRoll := Random(3) - 1
  else
    niceRoll := leftVector.Z;

  Steer(Lerp(niceRoll, roll, ClampValue(Abs(roll), 0, 1)), pitch, yaw);
end;

// SteerSkyward
//
procedure TABControlerTracker.SteerSkyward(const deltaTime: Double);
var
  pitch, roll: Single;
begin
  // basically shoot skyward
  pitch := ClampValue((1 - Mobile.Direction.Z) * Sign(Mobile.Up.Z), -1, 1);
  roll := -Mobile.RightVector.Z;

  Steer(roll, pitch, 0);
end;

// ------------------
// ------------------ TABControlerMobileTracker ------------------
// ------------------

// Progress
//
procedure TABControlerMobileTracker.Progress(const deltaTime: Double);
var
  groundCrash: Single;
begin
  inherited;
  if TargetMobile <> nil then
  begin
    TargetPosition := TargetMobile.Position;
    TargetVelocity := TargetMobile.Velocity;
    groundCrash := 10;
    if GroundCrashTest(groundCrash) then
      SteerSkyward(deltaTime)
    else
      SteerToTarget(deltaTime);
  end
  else
  begin
    Steer(0, 0, 0);
  end;
end;

// Notification
//
procedure TABControlerMobileTracker.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  inherited;
  if (operation = goRemove) and (TargetMobile = aMobile) then
    TargetMobile := nil;
end;

// SaveToStrings
//
procedure TABControlerMobileTracker.SaveToStrings(data: TStrings);
begin
  if TargetMobile <> nil then
    data.Values['Target'] := TargetMobile.Name
  else
    data.Values['Target'] := '';
end;

// LoadFromStrings
//
procedure TABControlerMobileTracker.LoadFromStrings(data: TStrings);
begin
  TargetMobile := GameEngine.MobileByName(data.Values['Target']);
end;

// ------------------
// ------------------ TABControlerWaypoints ------------------
// ------------------

// Progress
//
procedure TABControlerWaypoints.Progress(const deltaTime: Double);
var
  n: Integer;
  groundCrash: Single;
begin
  inherited;
  n := Length(Waypoints);
  if n > 0 then
  begin
    if Cardinal(CurrentWaypoint) >= Cardinal(n) then
      CurrentWaypoint := 0
    else if VectorDistance(Airplane.Position, TargetPosition) <= WaypointBumpDistance
    then
      CurrentWaypoint := (CurrentWaypoint + 1) mod n;
  end;
  groundCrash := 1;
  if GroundCrashTest(groundCrash) then
    SteerSkyward(deltaTime)
  else
    SteerToTarget(deltaTime);
end;

// SaveToStrings
//
procedure TABControlerWaypoints.SaveToStrings(data: TStrings);
var
  i: Integer;
begin
  data.Values['CurrentWP'] := IntToStr(CurrentWaypoint);
  data.Values['BumpDistance'] := FloatToStr(WaypointBumpDistance);
  for i := 0 to High(FWaypoints) do
    data.Values['WP' + IntToStr(i)] := Vector3ToString(Waypoints[i]);
end;

// LoadFromStrings
//
procedure TABControlerWaypoints.LoadFromStrings(data: TStrings);
var
  i: Integer;
  buf: String;
begin
  ClearWaypoints;
  i := 0;
  while True do
  begin
    buf := data.Values['WP' + IntToStr(i)];
    Inc(i);
    if buf <> '' then
      AddWaypoint(PointMake(StringToVector3(buf)))
    else
      Break;
  end;
  CurrentWaypoint := StrToIntDef(data.Values['CurrentWP'], 0);
  WaypointBumpDistance := StrToFloatDef(data.Values['BumpDistance'], 100);
end;

// CreateGLLines
//
function TABControlerWaypoints.CreateGLLines(const aParent: TGLBaseSceneObject)
  : TGLLines;
var
  i: Integer;
begin
  Result := TGLLines.CreateAsChild(aParent);
  Result.NodeSize := 150;
  Result.NodesAspect := lnaCube;
  for i := 0 to High(FWaypoints) do
    Result.AddNode(FWaypoints[i]);
end;

// AddWaypoint
//
procedure TABControlerWaypoints.AddWaypoint(const coord: TGLVector);
begin
  SetLength(FWaypoints, Length(FWaypoints) + 1);
  FWaypoints[High(FWaypoints)] := coord;
end;

// ClearWaypoints
//
procedure TABControlerWaypoints.ClearWaypoints;
begin
  SetLength(FWaypoints, 0);
end;

// SetCurrentWaypoint
//
procedure TABControlerWaypoints.SetCurrentWaypoint(val: Integer);
var
  n: Integer;
begin
  n := Length(Waypoints);
  if (n > 0) then
  begin
    if val >= n then
      FCurrentWaypoint := n - 1
    else if val < 0 then
      FCurrentWaypoint := 0
    else
      FCurrentWaypoint := val;
    TargetPosition := Waypoints[CurrentWaypoint];
    TargetVelocity := NullHmgVector;
  end;
end;

// ------------------
// ------------------ TABControlerMissileTracker ------------------
// ------------------

// SteerToTarget
//
procedure TABControlerMissileTracker.SteerToTarget(const deltaTime: Double);
var
  t, dist: Single;
  targetBearing, targetElevation: Single;
begin
  if TargetMobile = nil then
    Exit;

  dist := Airplane.DistanceTo(TargetMobile);
  Mobile.Detonate := Mobile.Detonate or
    ((dist < ProximityFuse) and (not Airplane.IsAhead(TargetMobile)));

  // guesstimate intercept time
  t := dist / (Mobile.Speed + Airplane.Speed + 0.1);
  if t > 15 then
    t := 15;

  // then determinate bearing and elevation relatively to ourself (in rad)
  Airplane.BearingElevation(VectorCombine(TargetPosition, TargetVelocity, 1, t),
    targetBearing, targetElevation);

  // PI control loops, with a nice overshoot - inefficient but pretty :)
  FIntegralBearing := ClampValue(FIntegralBearing * 0.9 + targetBearing, -1, 1);
  targetBearing := targetBearing * 3 + FIntegralBearing * 0.2;
  FIntegralElevation := ClampValue(FIntegralElevation * 0.9 +
    targetElevation, -1, 1);
  targetElevation := targetElevation * 3 + FIntegralElevation * 0.2;

  Steer(0, ClampValue(targetElevation, -1, 1),
    ClampValue(-targetBearing, -1, 1));
end;

// SteerSkyward
//
procedure TABControlerMissileTracker.SteerSkyward(const deltaTime: Double);
begin
  // our missiles don't know how to do that
  SteerToTarget(deltaTime);
end;

// Progress
//
procedure TABControlerMissileTracker.Progress(const deltaTime: Double);
begin
  TargetMobile := Airplane.CurrentTarget;
  inherited;
  if Airplane.Engines[0].Output = 0 then
    Airplane.Detonate := True;
end;

// Notification
//
procedure TABControlerMissileTracker.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  inherited;
  if (operation = goCollide) and (aMobile = TargetMobile) then
    Mobile.Detonate := True;
end;

// SaveToStrings
//
procedure TABControlerMissileTracker.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['ProximityFuse'] := FloatToStr(ProximityFuse);
end;

// LoadFromStrings
//
procedure TABControlerMissileTracker.LoadFromStrings(data: TStrings);
begin
  inherited;
  ProximityFuse := StrToFloatDef(data.Values['ProximityFuse'], 0);
  IntegralGain := 0.2;
end;

// ------------------
// ------------------ TABControlerAI ------------------
// ------------------

// Destroy
//
destructor TABControlerAI.Destroy;
begin
  inherited;
  FTargetingMe.Free;
end;

// SaveToStrings
//
procedure TABControlerAI.SaveToStrings(data: TStrings);
begin
  inherited;
end;

// LoadFromStrings
//
procedure TABControlerAI.LoadFromStrings(data: TStrings);
var
  buf: String;
  i: Integer;
begin
  inherited;
  IntegralGain := 0.2;

  buf := data.Values['Order'];
  if buf <> '' then
  begin
    FAIOrder := Low(TAIOrder);
    while FAIOrder < High(TAIOrder) do
    begin
      if buf = cAIOrderNames[FAIOrder] then
        Break;
      FAIOrder := Succ(FAIOrder);
    end;
  end
  else
    FAIOrder := aioEngageEnemies;
  FAIOrderParam := data.Values['OrderParam'];

  buf := data.Values['AILevel'];
  FAILevel := Low(TAILevel);
  while FAILevel < High(TAILevel) do
  begin
    if buf = cAILevelNames[FAILevel] then
      Break;
    FAILevel := Succ(FAILevel);
  end;

  i := Airplane.ABEngine.OptionsDifficultyOffset;
  while (i < 0) and (AILevel <> Low(TAILevel)) do
  begin
    Inc(i);
    FAILevel := Pred(AILevel);
  end;
  while (i > 0) and (AILevel <> High(TAILevel)) do
  begin
    Inc(i);
    FAILevel := Succ(AILevel);
  end;

  case AILevel of
    ailHarmless:
      begin
        FGroundCrashAITestDistance := 10;
        FMissileAIDropDecoyDistance := 0; // forgot about decoys!
        FBreakOffAIMultiplier := 4;
        FAimingAIQuality := 0;
        FBreakOffAIDistance := 3;
        FMissileAIFireDelay := 10; // rarely fires
        FTriggerHappyAI := 0.3;
        FManeuverabilityAI := 0.5;
        FBreakOffAIRoll := 0;
        FAIAirBrakeProba := 0;
        IntegralGain := 0.1;
      end;
    ailNoob:
      begin
        FGroundCrashAITestDistance := 10;
        FMissileAIDropDecoyDistance := Random(6);
        FBreakOffAIMultiplier := 3;
        FAimingAIQuality := 0;
        FBreakOffAIDistance := 2;
        FMissileAIFireDelay := 0.2 + Random * 5;
        FTriggerHappyAI := 0.4;
        FManeuverabilityAI := 0.7;
        FBreakOffAIRoll := 0.1;
        FAIAirBrakeProba := 0;
        IntegralGain := 0.1;
      end;
    ailRecruit:
      begin
        FGroundCrashAITestDistance := 8;
        FMissileAIDropDecoyDistance := Random(10);
        FBreakOffAIMultiplier := 2;
        FAimingAIQuality := 1;
        FBreakOffAIDistance := 1.5;
        FMissileAIFireDelay := 0.75 + Random * 3;
        FTriggerHappyAI := 0.5;
        FManeuverabilityAI := 0.77;
        FBreakOffAIRoll := 0.3;
        FAIAirBrakeProba := 0.1;
      end;
    ailSoldier:
      begin
        FGroundCrashAITestDistance := 8;
        FMissileAIDropDecoyDistance := 5 + Random(5);
        FBreakOffAIMultiplier := 1;
        FAimingAIQuality := 1;
        FBreakOffAIDistance := 1.2;
        FMissileAIFireDelay := 0.75 + Random * 0.5;
        FTriggerHappyAI := 0.7;
        FManeuverabilityAI := 0.85;
        FBreakOffAIRoll := 0.5;
        FAIAirBrakeProba := 0.2;
      end;
    ailVeteran:
      begin
        FGroundCrashAITestDistance := 6;
        FMissileAIDropDecoyDistance := 5 + Random(5);
        FBreakOffAIMultiplier := 1;
        FAimingAIQuality := 2;
        FBreakOffAIDistance := 1.0;
        FMissileAIFireDelay := 0.9;
        FTriggerHappyAI := 0.9;
        FManeuverabilityAI := 0.95;
        FBreakOffAIRoll := 0.8;
        FAIAirBrakeProba := 0.3;
      end;
    ailAce:
      begin
        FGroundCrashAITestDistance := 5;
        FMissileAIDropDecoyDistance := 6 + Random(3);
        FBreakOffAIMultiplier := 1;
        FAimingAIQuality := 2;
        FBreakOffAIDistance := 0.6;
        FMissileAIFireDelay := 0.8;
        FTriggerHappyAI := 1;
        FManeuverabilityAI := 1;
        FBreakOffAIRoll := 1;
        FAIAirBrakeProba := 0.4;
      end;
  else
    Assert(False);
  end;
end;

// Progress
//
procedure TABControlerAI.Progress(const deltaTime: Double);
var
  groundCrash, missileIntercept: Single;
begin
  inherited;

  FMissileFireDelay := FMissileFireDelay - deltaTime;
  FNextChatDelay := FNextChatDelay - deltaTime;

  if FAIOrderExecutionDelay > 0 then
  begin
    FAIOrderExecutionDelay := FAIOrderExecutionDelay - deltaTime;
    if FAIOrderExecutionDelay <= 0 then
      DoExecuteWingLeaderOrder;
  end;

  // ground crash prevention, overrides all other AI states
  groundCrash := FGroundCrashAITestDistance;
  if AIState = aisAvoidGround then
    FAIState := aisNone;
  if GroundCrashTest(groundCrash) then
    FAIState := aisAvoidGround
  else
  begin
    // decoy whenever missile after us
    if FTargetingMe <> nil then
    begin
      missileIntercept := NearestIncomingMissileTimeToIntercept;
      if missileIntercept < FMissileAIDropDecoyDistance then
        DropDecoy;
      if (AIState <> aisBreakOff) and
        (missileIntercept < FMissileAIDropDecoyDistance * 0.5) then
        DoRandomBreakOff(2);
    end;
  end;
  // damage control, only from Soldier and up
  if (Airplane.FireDamage > 0) and (AILevel in [ailSoldier .. ailAce]) then
    FireControl;

  case AIState of
    aisNone:
      PerformAINone(deltaTime);
    aisChase:
      PerformAIChase(deltaTime);
    aisAvoidGround:
      PerformAIAvoidGround(deltaTime);
    aisBreakOff:
      PerformAIBreakOff(deltaTime);
    aisFollow:
      PerformAIFollow(deltaTime);
    aisGoTo:
      PerformAIGoTo(deltaTime);
  else
    Assert(False);
  end;
end;

// Notification
//
procedure TABControlerAI.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  inherited;
  case operation of
    goTargeted:
      begin
        if FTargetingMe = nil then
          FTargetingMe := TGLPersistentObjectList.Create;
        FTargetingMe.Add(aMobile);
        if aMobile is TABMissile then
        begin
          if Random(2) = 0 then
            Voice('Vampire')
          else
            Voice('Under Attack');
        end;
      end;
    goRemove:
      begin
        if FTargetingMe <> nil then
        begin
          FTargetingMe.Remove(aMobile);
          if FTargetingMe.Count = 0 then
            FreeAndNil(FTargetingMe);
        end;
        if aMobile is TABAirplane then
        begin
          if (aMobile = Airplane.CurrentTarget) and
            (aMobile.Team <> Airplane.Team) and (Random < 0.5) then
          begin
            case Random(3) of
              0:
                Voice('Splash');
              1:
                Voice('Target Destroyed');
            else
              Voice('Bandit Down');
            end;
          end;
        end;
      end;
    goCollide:
      begin
        if Assigned(aMobile) and (aMobile.Collision.CollType = mctAmmo) then
        begin
          if (not(aMobile is TABMobileAmmo)) or
            (not TABMobileAmmo(aMobile).FiredBy(Airplane)) then
          begin
            if aMobile.Team = Airplane.Team then
              Voice('Friendly Fire')
            else
            begin
              if Random(2) = 0 then
                Voice('Taking Fire')
              else
                Voice('Under Attack');
            end;
            DoRandomBreakOff(1 + Random);
          end;
        end;
      end;
  end;
end;

// Steer
//
procedure TABControlerAI.Steer(roll, pitch, yaw: Single);
begin
  inherited Steer(roll * FManeuverabilityAI, pitch * FManeuverabilityAI,
    yaw * FManeuverabilityAI);
end;

// InitiateChase
//
procedure TABControlerAI.InitiateChase(target: TABAirplane);
begin
  Airplane.CurrentTarget := target;
  FAIState := aisChase;
  FSmoothedTargetDistance := Airplane.DistanceTo(target) * 10;
end;

// Voice
//
procedure TABControlerAI.Voice(const aMessage: String);
begin
  if Airplane.LeaderName <> 'Player' then
    Exit;
  with Airplane.ABEngine do
  begin
    AddMessage(aMessage, Airplane, MobileByName(Airplane.LeaderName));
    if FNextChatDelay < 0 then
    begin
      FNextChatDelay := 1;
      PlayVoice('Combat_Charles', aMessage);
    end;
  end;
end;

// VoiceAcceptOrder
//
procedure TABControlerAI.VoiceAcceptOrder(const extraOption: String = '');
var
  n, an: Integer;
  mess: String;
begin
  if extraOption <> '' then
    n := 7 // extra option gets a proba boost
  else
    n := 4;
  repeat
    an := Random(n);
  until an <> FLastAcceptN;
  FLastAcceptN := an;
  case an of
    0:
      mess := 'Affirmative';
    1:
      mess := 'Roger';
    2:
      mess := 'Copy That';
    3:
      mess := 'Copy';
  else
    mess := extraOption;
  end;
  Voice(mess);
end;

// ExecuteWingLeaderOrder
//
procedure TABControlerAI.ExecuteWingLeaderOrder(order: TABWingLeaderOrder;
  delay: Single);
begin
  FAIOrderExecutionDelay := delay;
  FAIOrderWLO := order;
end;

// DoExecuteWingLeaderOrder
//
procedure TABControlerAI.DoExecuteWingLeaderOrder;
var
  leader: TABAirplane;
begin
  FAIOrderExecutionDelay := 0;
  case FAIOrderWLO of
    wloFollowMe:
      begin
        if AIState = aisChase then
          VoiceAcceptOrder('Disengaging')
        else
          VoiceAcceptOrder;
        AIOrder := aioFollowLeader;
      end;
    wloEngageMyTarget:
      begin
        AIOrder := aioAssistLeader;
        leader := (GameEngine.MobileByName(Airplane.LeaderName) as TABAirplane);
        if leader.CurrentTarget <> nil then
        begin
          if leader.CurrentTarget.Team <> Airplane.Team then
            VoiceAcceptOrder('Engaging')
          else
            Voice('Negative');
        end
        else
          VoiceAcceptOrder;
      end;
    wloCoverMe:
      begin
        AIOrder := aioCoverLeader;
        VoiceAcceptOrder;
      end;
  else
    Assert(False);
  end;
end;

// PerformAINone
//
procedure TABControlerAI.PerformAINone(const deltaTime: Double);
var
  newTarget, leader: TMobile;
begin
  // find something to do
  case AIOrder of
    aioEngageEnemies:
      begin
        // pick an enemy not too far that isn't too much targeted
        newTarget := OptimalTarget;
        if newTarget <> nil then
          InitiateChase(newTarget as TABAirplane)
        else
        begin
          Steer(0, 0, 0);
          Throttle(0.7);
        end;
      end;
    aioEngageTarget:
      begin
        // engage specificly named target
        newTarget := Airplane.GameEngine.MobileByName(AIOrderParam);
        if newTarget <> nil then
          InitiateChase(newTarget as TABAirplane)
        else
          CurrentOrderCompleted;
      end;
    aioFollowLeader:
      begin
        leader := Airplane.GameEngine.MobileByName(Airplane.LeaderName);
        if leader <> nil then
        begin
          Airplane.CurrentTarget := leader;
          FAIState := aisFollow;
        end
        else
          CurrentOrderCompleted;
      end;
    aioCoverLeader:
      begin
        leader := Airplane.GameEngine.MobileByName(Airplane.LeaderName);
        if leader <> nil then
        begin
          newTarget := OptimalTarget(leader);
          if newTarget <> nil then
            InitiateChase(newTarget as TABAirplane)
          else
          begin
            Airplane.CurrentTarget := leader;
            PerformAIFollow(deltaTime);
          end;
        end
        else
          CurrentOrderCompleted;
      end;
    aioAssistLeader:
      begin
        leader := Airplane.GameEngine.MobileByName(Airplane.LeaderName);
        if leader <> nil then
        begin
          newTarget := (leader as TABAirplane).CurrentTarget;
          if (newTarget <> nil) and (newTarget.Team <> Airplane.Team) then
            InitiateChase(newTarget as TABAirplane)
          else
          begin
            Airplane.CurrentTarget := leader;
            PerformAIFollow(deltaTime);
          end;
        end
        else
          CurrentOrderCompleted;
      end;
    aioGoTo:
      begin
        FAIState := aisGoTo;
      end;
  end;
end;

// PerformAIChase
//
procedure TABControlerAI.PerformAIChase(const deltaTime: Double);
var
  weaponInRange: Boolean;
  targetDistance, desiredDistance: Single;
  vectorToTarget: TGLVector;
  f, fTreshold: Single;
  weap: TABEqptWeapon;
  p: TGLVector;
  newTarget: TMobile;
begin
  if Airplane.CurrentTarget = nil then
  begin
    FAIState := aisNone;
    Exit;
  end;

  // weapons selection and flight guidance
  targetDistance := Mobile.DistanceTo(Airplane.CurrentTarget);
  weap := OptimalWeapon(targetDistance);
  if (weap <> nil) then
  begin
    Airplane.CurrentWeaponGroup := weap.GroupName;
    weaponInRange := (targetDistance < weap.MaxRange);
  end
  else
    weaponInRange := False;
  if weaponInRange and (weap is TABEqptGun) then
  begin
    // aim gun
    TABEqptGun(weap).BestAimEstimate(p, FAimingAIQuality);
    TargetPosition := p;
    TargetVelocity := NullHmgVector;
  end
  else if weaponInRange and (weap is TABEqptGuidedMissile) then
  begin
    // attempt to lock target
    TargetPosition := Airplane.CurrentTarget.Position;
    TargetVelocity := NullHmgVector;
    p := TargetPosition;
  end
  else
  begin
    // intercept
    TargetPosition := Airplane.CurrentTarget.Position;
    TargetVelocity := Airplane.CurrentTarget.Velocity;
    p := TargetPosition;
  end;
  SteerToTarget(deltaTime);

  // cos alpha to target
  vectorToTarget := VectorNormalize(VectorSubtract(p, Mobile.Position));
  f := VectorDotProduct(vectorToTarget, Mobile.Direction);

  // Break off is too close, or got locked in a tourney
  // Note: the more and the longer the AI breaks off, the easier it is to shot it down!
  FSmoothedTargetDistance := FSmoothedTargetDistance * 0.99 +
    targetDistance * 0.01;
  if FAIAirBrakeDelay > 0 then
  begin
    FAIAirBrakeDelay := FAIAirBrakeDelay - deltaTime;
    AirBrake;
  end
  else if f < 0.7 then
  begin
    if (targetDistance < 200 * FBreakOffAIDistance) or
      (FSmoothedTargetDistance < 1250 * FBreakOffAIDistance) then
    begin
      if Random > FAIAirBrakeProba then
        DoRandomBreakOff(3)
      else
      begin
        FAIAirBrakeDelay := 0.5 + 2 * Random;
      end;
    end;
  end;

  // throttle adjustments
  if weap <> nil then
    desiredDistance := weap.OptimalRange
  else
    desiredDistance := 250;
  Throttle(ClampValue(Airplane.Throttle + deltaTime * (targetDistance -
    desiredDistance) / Airplane.Speed, 0.3, 1));

  // fire if solution looks good
  if weap <> nil then
  begin
    f := Exp(FTriggerHappyAI * Ln(f));
    if f > 0 then
    begin
      if weap is TABEqptGun then
      begin
        fTreshold := ClampValue((Airplane.CurrentTarget.Collision.Radius + 10) /
          (100 + targetDistance), 0, 1);
        fTreshold := Sqrt(1 - fTreshold * fTreshold);
        if f > Exp((1 / FTriggerHappyAI) * Ln(fTreshold)) then
          Fire(True);
      end
      else if weap is TABEqptGuidedMissile then
      begin
        f := f * ClampValue(0.5 + Abs(VectorDotProduct(vectorToTarget,
          Airplane.CurrentTarget.Velocity)), 0.5, 1.2);
        if (f > 0.85) and (FMissileFireDelay < 0) and (weap.CanFirePrimary) then
        begin
          if weap.VoiceNotification <> '' then
            Voice(weap.VoiceNotification);
          Fire(True);
          newTarget := OptimalTarget;
          if newTarget = Airplane.CurrentTarget then
            FMissileFireDelay := (5 + Random * 5) * FMissileAIFireDelay
          else
          begin
            Airplane.CurrentTarget := newTarget;
            FMissileFireDelay := (Random * 5) * FMissileAIFireDelay
          end;
        end;
      end;
    end;
  end;
end;

// PerformAIAvoidGround
//
procedure TABControlerAI.PerformAIAvoidGround(const deltaTime: Double);
begin
  // basically shoot skyward
  SteerSkyward(deltaTime);
  Throttle(1);
end;

// PerformAIBreakOff
//
procedure TABControlerAI.PerformAIBreakOff(const deltaTime: Double);
begin
  FBreakOffCommand.Z := FBreakOffCommand.Z - deltaTime;
  if FBreakOffCommand.Z < 0 then
    FAIState := aisNone;
  Steer(FBreakOffCommand.X, FBreakOffCommand.Y, 0);
  Throttle(1);
end;

// PerformAIFollow
//
procedure TABControlerAI.PerformAIFollow(const deltaTime: Double);
var
  Mobile: TMobile;
  d, targetBearing, targetElevation, f: Single;
begin
  Mobile := Airplane.CurrentTarget;
  if Mobile <> nil then
  begin
    // TODO: pick position from formation data
    TargetPosition := VectorCombine3(Mobile.Position, Mobile.Direction,
      Mobile.RightVector, 1, -50, 50);
    d := VectorDistance(Airplane.Position, TargetPosition);
    if d > 500 then
    begin
      // when far away use normal flight logic
      TargetVelocity := Mobile.Velocity;
      SteerToTarget(deltaTime);
      FThrottleIntegral := ClampValue(FThrottleIntegral * 0.9 + d, -1E4, +1E4);
      d := d + FThrottleIntegral;
      Throttle(ClampValue(d * 0.1, 0.2, 1.5));
    end
    else
    begin
      // close by, use formation flight logic
      Airplane.BearingElevation(VectorCombine(TargetPosition, Mobile.Velocity,
        1, Mobile.Speed), targetBearing, targetElevation);
      Steer(ClampValue(VectorDotProduct(Airplane.Up, Mobile.RightVector) * 2 -
        targetBearing * d * 0.1, -1, 1),
        ClampValue(-5 * VectorDotProduct(Airplane.Up, Mobile.Direction) * 2 +
        targetElevation * d, -1, 1), -ClampValue(targetBearing * d, -0.5, 0.5));
      // Throttle adjustment, gotta love fuzzy logic :)
      f := PointProject(TargetPosition, Airplane.Position, Airplane.Direction) *
        0.1 + (Mobile.Speed - Airplane.Speed);
      Throttle(Lerp(ClampValue((Mobile as TABAirplane).Throttle *
        (1 + f * 0.05), 0.2, 3), Airplane.Throttle, 0.9));
    end;
  end
  else
    FAIState := aisNone;
end;

// PerformAIGoTo
//
procedure TABControlerAI.PerformAIGoTo(const deltaTime: Double);
begin
  TargetPosition := PointMake(StringToVector3(AIOrderParam));
  TargetVelocity := NullHmgVector;
  Throttle(0.8);
end;

// NearestMobile
//
function TABControlerAI.NearestMobile(aList: TGLPersistentObjectList): TMobile;
var
  i: Integer;
  d, minD: Single;
  mob: TMobile;
begin
  Result := nil;
  minD := 1E30;
  for i := 0 to aList.Count - 1 do
  begin
    mob := TMobile(aList[i]);
    d := Mobile.DistanceToSquared(mob);
    if d < minD then
    begin
      Result := mob;
      minD := d;
    end;
  end;
end;

// FilterOutSameTeam
//
procedure TABControlerAI.FilterOutSameTeam(aList: TGLPersistentObjectList);
var
  i, Team: Integer;
  mob: TMobile;
begin
  Team := Mobile.Team;
  for i := 0 to aList.Count - 1 do
  begin
    mob := TMobile(aList[i]);
    if mob.Team = Team then
      aList[i] := nil;
  end;
  aList.Pack;
end;

// OptimalWeapon
//
function TABControlerAI.OptimalWeapon(targetDistance: Single): TABEqptWeapon;
var
  i: Integer;
  air: TABAirplane;
  eqpt: TABEquipment;
  weap: TABEqptWeapon;
  f, fOptimal: Single;
begin
  air := Airplane;
  Result := nil;
  fOptimal := 1E30;
  for i := 0 to air.EquipmentCount - 1 do
  begin
    eqpt := air.Equipments[i];
    if not(eqpt is TABEqptWeapon) then
      continue;
    weap := TABEqptWeapon(eqpt);
    if weap.AmmoCapacity < weap.PrimaryConsumption then
      continue;
    if weap.MaxRange < targetDistance then
      continue;
    f := Abs(weap.OptimalRange - targetDistance);
    if f < fOptimal then
    begin
      fOptimal := f;
      Result := weap;
    end;
  end;
end;

// OptimalTarget
//
function TABControlerAI.OptimalTarget(engaging: TMobile = nil): TABAirplane;
var
  i, j: Integer;
  mobiles: TGLPersistentObjectList;
  aTarget: TMobile;
  marks: array of Single;
begin
  // pick an enemy not too far that isn't too much targeted
  Result := nil;
  mobiles := TGLPersistentObjectList.Create;
  Mobile.GameEngine.EnumerateMobiles(TABAirplane, mobiles);
  if engaging <> nil then
  begin
    // filter out those not engaging us
    for i := mobiles.Count - 1 downto 0 do
    begin
      if TABAirplane(mobiles[i]).CurrentTarget <> engaging then
        mobiles[i] := nil;
    end;
    mobiles.Pack;
  end;
  if mobiles.Count > 0 then
  begin
    SetLength(marks, mobiles.Count);
    for i := 0 to mobiles.Count - 1 do
    begin
      aTarget := TABAirplane(mobiles[i]).CurrentTarget;
      j := mobiles.IndexOf(aTarget);
      if j >= 0 then
        marks[j] := marks[j] - 500 /
          (500 + TABAirplane(mobiles[i]).DistanceTo(aTarget));
      if aTarget = Airplane then
        marks[i] := marks[i] + 500 / TABAirplane(mobiles[i])
          .DistanceTo(aTarget);
    end;
    j := -1;
    for i := 0 to mobiles.Count - 1 do
      if TABAirplane(mobiles[i]).Team <> Airplane.Team then
        if (j < 0) or (marks[i] >= marks[j]) then
          j := i;
    if j >= 0 then
      Result := TABAirplane(mobiles[j]);
  end;
  mobiles.Free;
end;

// NearestIncomingMissileTimeToIntercept
//
function TABControlerAI.NearestIncomingMissileTimeToIntercept: Single;
var
  i: Integer;
  d, spd: Single;
begin
  Result := 1E30;
  spd := 1;
  for i := 0 to FTargetingMe.Count - 1 do
  begin
    d := TMobile(FTargetingMe[i]).DistanceToSquared(Airplane);
    if d < Result then
    begin
      Result := d;
      spd := TMobile(FTargetingMe[i]).Speed;
    end;
  end;
  Result := Sqrt(Result) / (spd + 1);
end;

// DoRandomBreakOff
//
procedure TABControlerAI.DoRandomBreakOff(duration: Single);
begin
  FAIState := aisBreakOff;
  if Random < FBreakOffAIRoll then
    FBreakOffCommand.X := Random - 0.5
  else
    FBreakOffCommand.X := 0;
  FBreakOffCommand.Y := Sign(Random - 0.3); // favor pull up
  FBreakOffCommand.Z := duration * (1 + Random) * FBreakOffAIMultiplier;
  // FAirplane.ABEngine.AddMessage('Breaking off!', Airplane, nil);
end;

// SetAIOrder
//
procedure TABControlerAI.SetAIOrder(val: TAIOrder);
begin
  FAIOrder := val;
  FAIState := aisNone;
end;

// CurrentOrderCompleted
//
procedure TABControlerAI.CurrentOrderCompleted;
begin
  FAIOrder := aioEngageEnemies;
  FAIState := aisNone;
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

RegisterControlerClass(TABControlerTracker);
RegisterControlerClass(TABControlerMobileTracker);
RegisterControlerClass(TABControlerWaypoints);
RegisterControlerClass(TABControlerMissileTracker);
RegisterControlerClass(TABControlerAI);

end.
