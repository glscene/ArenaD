unit UAirplane;

(*
  Airplane simulation class.<br>
  Implements a crappy pseudo-flight model
*)

interface

uses
  System.Classes,
  UGameEngine,
  System.Math,
  GLS.VectorGeometry,
  GLS.VectorTypes;

type

  // TAirplaneEngine
  //
  { : Airplane engine information and status. }
  TAirplaneEngine = class(TGameEngine3DObject)
  private
    { Private Properties }
    FFuel, FMaxFuel: Double;
    FMaxOutput, FOutputInertia, FOutput: Single;
    FThrottle: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    // : Engine Throttle, 0 for stopped, 1 for full power
    property Throttle: Single read FThrottle write FThrottle;
    // : Maximum power output (full throttle stabilized) in kg
    property MaxOutput: Single read FMaxOutput write FMaxOutput;
    // : Maximum variation in output per second in kg/s
    property OutputInertia: Single read FOutputInertia write FOutputInertia;
    // : Current power output in kg
    property Output: Single read FOutput write FOutput;
    // : Remaining fuel in seconds of work at Throttle=1
    property Fuel: Double read FFuel write FFuel;
    property MaxFuel: Double read FMaxFuel write FMaxFuel;
  end;

  TAirplaneEngines = array of TAirplaneEngine;

  // TAirplane
  //
  { : Main airplane simulation class. }
  TAirplane = class(TMobile)
  private
    { Private Properties }
    FEngines: TAirplaneEngines;
    FMass: Single;
    FLiftPerMSec: Single;
    FStallVelocity: Single;
    FStallAngle: Single;
    FStallManeuverabilityRatio: Single;
    FMaxRoll, FMaxPitch, FMaxYaw: Single;
    FRollCmd, FPitchCmd, FYawCmd: Single;
    FThrottle: Single;
    FLastRoll, FLastPitch, FLastYaw: Single;
    FAirFrictionMin, FAirFrictionMax: Single;

  protected
    { Protected Properties }
    procedure SetThrottle(const val: Single);

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    { : Adjust throttle of all engines. }
    property Throttle: Single read FThrottle write SetThrottle;

    property RollCmd: Single read FRollCmd write FRollCmd;
    property PitchCmd: Single read FPitchCmd write FPitchCmd;
    property YawCmd: Single read FYawCmd write FYawCmd;

    property Engines: TAirplaneEngines read FEngines;
    function AddEngine: TAirplaneEngine;
    function EngineCount: Integer;
    procedure ClearEngines;
    procedure EnginesMatchOutputToThrottle;
    procedure ReplenishFuel;

    // : Mass (in kg)
    property Mass: Single read FMass write FMass;
    // : Lift in rad/m (aka (rad/s)/(m/s))
    property LiftPerMSec: Single read FLiftPerMSec write FLiftPerMSec;
    // : Stall velocity in m/s
    property StallVelocity: Single read FStallVelocity write FStallVelocity;
    // : Stall angle in rad
    property StallAngle: Single read FStallAngle write FStallAngle;
    // : Stall maneauverability ratio [0; 1]
    property StallManeuverabilityRatio: Single read FStallManeuverabilityRatio
      write FStallManeuverabilityRatio;
    // : Minimal air friction (straight flight)
    property AirFrictionMin: Single read FAirFrictionMin write FAirFrictionMin;
    // : Maximal air friction (crab-like)
    property AirFrictionMax: Single read FAirFrictionMax write FAirFrictionMax;

    // : Maximum command roll in rad/s
    property MaxRoll: Single read FMaxRoll write FMaxRoll;
    // : Maximum command pitch in rad/s
    property MaxPitch: Single read FMaxPitch write FMaxPitch;
    // : Maximum command yaw in rad/s
    property MaxYaw: Single read FMaxYaw write FMaxYaw;
  end;

var
  vAltitudeLimit: Single = 2000;
  vAltitudeLimitMargin: Single = 8000;

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

// ------------------
// ------------------ TAirplaneEngine ------------------
// ------------------

// Progress
//
procedure TAirplaneEngine.Progress(const deltaTime: Double);
var
  delta: Single;
begin
  if FFuel > 0 then
  begin
    delta := Throttle * MaxOutput - Output;
    if (Throttle > 1) or (delta < 0) then
      delta := Sign(delta) * MinFloat(Abs(delta), deltaTime * OutputInertia * 5)
    else
      delta := Sign(delta) * MinFloat(Abs(delta), deltaTime * OutputInertia);
    Output := Output + delta;
    FFuel := FFuel - Throttle * deltaTime;
  end
  else
  begin
    Output := MaxFloat(0, Output - OutputInertia);
  end;
end;

// SaveToStrings
//
procedure TAirplaneEngine.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['MaxOutput'] := FloatToStr(MaxOutput);
  data.Values['OutputInertia'] := FloatToStr(OutputInertia);
  data.Values['Fuel'] := FloatToStr(MaxFuel);
end;

// LoadFromStrings
//
procedure TAirplaneEngine.LoadFromStrings(data: TStrings);
begin
  inherited;
  MaxOutput := StrToFloat(data.Values['MaxOutput']);
  OutputInertia := StrToFloat(data.Values['OutputInertia']);
  MaxFuel := StrToFloatDef(data.Values['Fuel'], 1E30);
  Fuel := MaxFuel;
end;

// ------------------
// ------------------ TAirplane ------------------
// ------------------

// Destroy
//
destructor TAirplane.Destroy;
begin
  inherited;
  ClearEngines;
end;

// Progress
//
procedure TAirplane.Progress(const deltaTime: Double);
var
  i: Integer;
  rightVector: TGLVector;
  thrust, accel: TGLVector;
  engine: TAirplaneEngine;
  roll, pitch, yaw: Single;
  f, fStraight, fLift, speed2: Single;
  stalled: Boolean;
  rotMat: TGLMatrix;
  velFwd, fTan: Single;
  velTan: TGLVector;
begin
  speed2 := Speed * Speed;
  fStraight := VectorDotProduct(Direction, VectorNormalize(Velocity));
  fLift := VectorDotProduct(Up, VectorNormalize(Velocity));
  stalled := (Speed < StallVelocity);
  rightVector := VectorCrossProduct(Direction, Up);

  // compute global engine thrust (no torque)
  thrust := NullHmgVector;
  for i := Low(FEngines) to High(FEngines) do
  begin
    engine := FEngines[i];
    engine.Progress(deltaTime);
    f := engine.Output;
    CombineVector(thrust, Direction, f);
  end;

  // apply commands
  if not stalled then
  begin
    roll := RollCmd * MaxRoll;
    pitch := PitchCmd * MaxPitch;
    yaw := YawCmd * MaxYaw;
  end
  else
  begin
    roll := RollCmd * MaxRoll * FStallManeuverabilityRatio;
    pitch := PitchCmd * MaxPitch * FStallManeuverabilityRatio;
    yaw := YawCmd * MaxYaw * FStallManeuverabilityRatio;
  end;
  // torquy lift (hmphhhh....)
  pitch := pitch + LiftPerMSec * Speed * ClampValue(fStraight, 0, 1) * 1E-4;
  // make plane go down at low speed or high-alt
  pitch := pitch - Up.Z * (Direction.Z / (1 + speed2) +
    ClampValue(Position.Z - vAltitudeLimit, 0, vAltitudeLimitMargin) /
    (vAltitudeLimitMargin * 10));
  yaw := yaw - 1 * rightVector.Z / (1 + speed2);

  // attitude inertia (sort of)
  f := 0.05;
  roll := Lerp(FLastRoll, roll, f);
  FLastRoll := roll;
  pitch := Lerp(FLastPitch, pitch, f);
  FLastPitch := pitch;
  yaw := Lerp(FLastYaw, yaw, f);
  FLastYaw := yaw;

  if yaw <> 0 then
  begin
    rotMat := CreateRotationMatrix(Up, yaw);
    Direction := VectorTransform(Direction, rotMat);
  end;
  if roll <> 0 then
  begin
    rotMat := CreateRotationMatrix(Direction, roll);
    Up := VectorTransform(Up, rotMat);
  end;
  rightVector := VectorCrossProduct(Direction, Up);
  if pitch <> 0 then
  begin
    rotMat := CreateRotationMatrix(rightVector, -pitch);
    Direction := VectorTransform(Direction, rotMat);
    Up := VectorTransform(Up, rotMat);
  end;

  // compute other accelerations
  // gravity
  SetVector(accel, 0, 0, -Mass);
  // lift (oh, well...)
  if not stalled then
  begin
    f := ClampValue(-fLift, -StallAngle, StallAngle) * speed2 *
      (Mass * (1 / 75));
    if LiftPerMSec > 0 then
      CombineVector(accel, Up, f)
    else if VectorNorm(thrust) > 0 then
      accel.Z := 0;
  end;
  // integrate thrust and gravity
  f := 10 * deltaTime / Mass;
  Velocity := VectorCombine3(Velocity, thrust, accel, 1, f, f);

  // drag/friction (pifométrage à deux balles)
  velFwd := VectorDotProduct(Velocity, Direction);
  f := Exp(cLn10 * Lerp(AirFrictionMax, AirFrictionMin, Abs(fStraight)));
  f := ClampValue(velFwd * velFwd * f, 0, velFwd);

  velTan := VectorSubtract(Velocity, VectorScale(Direction, velFwd));
  fTan := Exp(cLn10 * AirFrictionMax);
  fTan := ClampValue(1 - VectorLength(velTan) * fTan, 0, 1);

  Velocity := VectorCombine(Direction, velTan, velFwd - f, 0 * fTan);

  // integrate velocity
  inherited;
end;

// SaveToStrings
//
procedure TAirplane.SaveToStrings(data: TStrings);
var
  i: Integer;
begin
  inherited;
  for i := Low(FEngines) to High(FEngines) do
    data.Values['Engine' + IntToStr(i)] := FEngines[i].SaveToString;
  data.Values['Mass'] := FloatToStr(Mass);
  data.Values['LiftPerMSec'] := FloatToStr(LiftPerMSec);
  data.Values['StallVelocity'] := FloatToStr(StallVelocity);
  data.Values['StallAngle'] := FloatToStr(StallAngle);
  data.Values['StallManeuverabilityRatio'] :=
    FloatToStr(StallManeuverabilityRatio);
  data.Values['MaxRoll'] := FloatToStr(MaxRoll);
  data.Values['MaxPitch'] := FloatToStr(MaxPitch);
  data.Values['MaxYaw'] := FloatToStr(MaxYaw);
  data.Values['AirFrictionMin'] := FloatToStr(AirFrictionMin);
  data.Values['AirFrictionMax'] := FloatToStr(AirFrictionMax);
end;

// LoadFromStrings
//
procedure TAirplane.LoadFromStrings(data: TStrings);
var
  i: Integer;
  buf: String;
begin
  inherited;
  ClearEngines;
  for i := 0 to 9 do
  begin
    buf := data.Values['Engine' + IntToStr(i)];
    if buf <> '' then
      AddEngine.LoadFromString(buf)
    else
      Break;
  end;
  Mass := StrToFloat(data.Values['Mass']);
  LiftPerMSec := StrToFloat(data.Values['LiftPerMSec']);
  StallVelocity := StrToFloat(data.Values['StallVelocity']);
  StallAngle := StrToFloat(data.Values['StallAngle']);
  StallManeuverabilityRatio :=
    StrToFloat(data.Values['StallManeuverabilityRatio']);
  MaxRoll := StrToFloat(data.Values['MaxRoll']);
  MaxPitch := StrToFloat(data.Values['MaxPitch']);
  MaxYaw := StrToFloat(data.Values['MaxYaw']);
  AirFrictionMin := StrToFloat(data.Values['AirFrictionMin']);
  AirFrictionMax := StrToFloat(data.Values['AirFrictionMax']);
end;

// AddEngine
//
function TAirplane.AddEngine: TAirplaneEngine;
var
  n: Integer;
begin
  n := Length(FEngines);
  SetLength(FEngines, n + 1);
  Result := TAirplaneEngine.Create;
  FEngines[n] := Result;
end;

// EngineCount
//
function TAirplane.EngineCount: Integer;
begin
  Result := Length(FEngines);
end;

// ClearEngines
//
procedure TAirplane.ClearEngines;
var
  i: Integer;
begin
  for i := Low(FEngines) to High(FEngines) do
    FEngines[i].Free;
  SetLength(FEngines, 0);
end;

// EnginesMatchOutputToThrottle
//
procedure TAirplane.EnginesMatchOutputToThrottle;
var
  i: Integer;
begin
  for i := Low(FEngines) to High(FEngines) do
    with FEngines[i] do
      FOutput := MaxOutput * Throttle;
end;

// ReplenishFuel
//
procedure TAirplane.ReplenishFuel;
var
  i: Integer;
begin
  for i := Low(FEngines) to High(FEngines) do
    with FEngines[i] do
      Fuel := MaxFuel;
end;

// SetThrottle
//
procedure TAirplane.SetThrottle(const val: Single);
var
  i: Integer;
begin
  FThrottle := val;
  for i := Low(FEngines) to High(FEngines) do
    FEngines[i].Throttle := val;
end;

end.
