unit UABMobiles;

(* Special-purpose AirBlast mobiles *)

interface

uses
  System.Classes,
  VCL.Graphics,
  UGameEngine,
  UAirBlastEngine,
  GLS.Scene,
  GLS.Color,
  GLS.VectorGeometry,
  GLS.Material,
  GLS.RenderContextInfo,
  GLS.PersistentClasses,
  GLS.VectorTypes;

type

  // TABAgonizingAirplane
  //
  { : And agonizing airplane, falls and dies when timed out or hits anything. }
  TABAgonizingAirplane = class(TMobile)
  private
    { Private Properties }
    FTimeToLive, FRollSpeed: Single;
    FModel: TGLBaseSceneObject;
    FFirePoints: array of TGLBaseSceneObject;

  protected
    { Protected Properties }
    procedure ClearVisualObjects;

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Initialize(airplane: TABAirplane; particleRateBoost: Single);

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;

    property Model: TGLBaseSceneObject read FModel;
  end;

  // TABBumpable
  //
  { : Base class for bumpable AB mobiles. }
  TABBumpable = class(TMobile)
  private
    { Private Properties }
    FBumpActions: String;

  protected
    { Protected Properties }
    procedure DoAirplaneBump(airplane: TABAirplane); virtual;

  public
    { Public Properties }
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property BumpActions: String read FBumpActions write FBumpActions;
  end;

  // TABBonus
  //
  { : A bonus airplanes can bump into to get stuff. }
  TABBonus = class(TABBumpable)
  private
    { Private Properties }
    FModel: TGLBaseSceneObject;
    FModelName: String;
    FRespawnDelay: Single;
    FBasePosition: TGLVector;
    FTimeToRespawn: Single;
    FRespawnDispersion: Single;
    FRespawnActions, FBumpActions: String;
    FBonusColor: TColor;

  protected
    { Protected Properties }
    procedure SetupVisualObjects;
    procedure ClearVisualObjects;
    procedure DoAirplaneBump(airplane: TABAirplane); override;

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property ModelName: String read FModelName write FModelName;
    property Model: TGLBaseSceneObject read FModel;
    property BonusColor: TColor read FBonusColor write FBonusColor;
    property RespawnDelay: Single read FRespawnDelay write FRespawnDelay;
    property RespawnDispersion: Single read FRespawnDispersion
      write FRespawnDispersion;
    property RespawnActions: String read FRespawnActions write FRespawnActions;
  end;

  // TABHoop
  //
  { : A hoop for the player to go through. }
  TABHoop = class(TABBumpable)
  private
    { Private Properties }
    FModel: TGLBaseSceneObject;
    FNextHoop: String;
    FActive: Boolean;

  protected
    { Protected Properties }
    procedure SetActive(val: Boolean);

    procedure SetupVisualObjects;
    procedure ClearVisualObjects;
    procedure DoAirplaneBump(airplane: TABAirplane); override;

  public
    { Public Properties }
    destructor Destroy; override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;
    procedure Loaded; override;

    property NextHoop: String read FNextHoop write FNextHoop;
    property Active: Boolean read FActive write SetActive;
  end;

  // ------------------------------------------------------------------
  // ------------------------------------------------------------------
  // ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  UABActions,
  GLS.Objects,
  GLS.Texture,
  GLS.ProxyObjects,
  GLS.VectorFileObjects,
  GLS.Coordinates;

// ------------------
// ------------------ TABAgonizingAirplane ------------------
// ------------------

// Destroy
//
destructor TABAgonizingAirplane.Destroy;
begin
  inherited;
  ClearVisualObjects;
end;

// Initialize
//
procedure TABAgonizingAirplane.Initialize(airplane: TABAirplane;
  particleRateBoost: Single);
var
  n: Integer;
  engine: TAirBlastEngine;
begin
  engine := airplane.ABEngine;
  FModel := engine.FreeFormProxy(airplane.ModelName);
  engine.SceneRoot.AddChild(FModel);
  n := Round(2 / engine.OptionsParticles);
  if n < 1 then
    n := 1;
  SetLength(FFirePoints, n);
  while n > 0 do
  begin
    FFirePoints[n - 1] := engine.CreateFirePoint(FModel, True,
      particleRateBoost);
    FFirePoints[n - 1].Position.X := (Random - 0.5) * airplane.Collision.Radius;
    Dec(n);
  end;
  Direction := airplane.Direction;
  Up := airplane.Up;
  Position := airplane.Position;
  Velocity := airplane.Velocity;
  FRollSpeed := (Random - 0.5) * 300;
  FTimeToLive := 15;
  with TCollisionVolume.Create(Self) do
  begin
    CollType := mctMobile;
    Size := VectorScale(XYZVector, airplane.Collision.Radius);
  end;
end;

// Progress
//
procedure TABAgonizingAirplane.Progress(const deltaTime: Double);
begin
  inherited;
  if Assigned(FModel) then
  begin
    Velocity := VectorCombine(Velocity, ZHmgVector, 0.999, -1);
    FModel.Direction.SetVector(Velocity);
    FModel.Position.SetPoint(Position);
    FModel.Roll(deltaTime * FRollSpeed);
  end;
  FTimeToLive := FTimeToLive - deltaTime;
  if FTimeToLive <= 0 then
    Detonate := True;
end;

// Notification
//
procedure TABAgonizingAirplane.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  inherited;
  if (operation = goCollide) and (aMobile = nil) then
  begin
    if Assigned(FModel) then
    begin
      (GameEngine as TAirBlastEngine).MakeBoom(Position, 12, 12);
      ClearVisualObjects;
      Velocity := NullHmgVector;
    end;
  end;
end;

// ClearVisualObjects
//
procedure TABAgonizingAirplane.ClearVisualObjects;
var
  i: Integer;
begin
  for i := 0 to High(FFirePoints) do
    FFirePoints[i].Free;
  SetLength(FFirePoints, 0);
  FreeAndNil(FModel);
end;

// ------------------
// ------------------ TABBumpable ------------------
// ------------------

// Notification
//
procedure TABBumpable.Notification(aMobile: TMobile; operation: TGameOperation);
begin
  inherited;
  if (operation = goCollide) and (aMobile.ClassType = TABAirplane) then
  begin
    DoAirplaneBump(TABAirplane(aMobile));
  end;
end;

// SaveToStrings
//
procedure TABBumpable.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['BumpActions'] := FBumpActions;
end;

// LoadFromStrings
//
procedure TABBumpable.LoadFromStrings(data: TStrings);
begin
  inherited;
  BumpActions := data.Values['BumpActions'];
end;

// DoAirplaneBump
//
procedure TABBumpable.DoAirplaneBump(airplane: TABAirplane);
var
  envVars: TStringList;
begin
  envVars := TStringList.Create;
  envVars.Values['CurrentAirplane'] := airplane.Name;
  PerformABActions(GameEngine as TAirBlastEngine, BumpActions, envVars);
  envVars.Free;
end;

// ------------------
// ------------------ TABBonus ------------------
// ------------------

// Destroy
//
destructor TABBonus.Destroy;
begin
  inherited;
  ClearVisualObjects;
end;

// Progress
//
procedure TABBonus.Progress(const deltaTime: Double);
begin
  inherited;
  if FModel = nil then
  begin
    FTimeToRespawn := FTimeToRespawn - deltaTime;
    if FTimeToRespawn < 0 then
      SetupVisualObjects;
  end
  else
  begin
    FModel.Roll(deltaTime * 50);
  end;
end;

// SaveToStrings
//
procedure TABBonus.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['ModelName'] := ModelName;
  data.Values['BonusColor'] := '$' + IntToHex(FBonusColor, 6);
  data.Values['RespawnDelay'] := FloatToStr(RespawnDelay);
  data.Values['RespawnDispersion'] := FloatToStr(RespawnDispersion);
  data.Values['RespawnActions'] := FRespawnActions;
  data.Values['BumpActions'] := FBumpActions;
end;

// LoadFromStrings
//
procedure TABBonus.LoadFromStrings(data: TStrings);
begin
  inherited;
  ModelName := data.Values['ModelName'];
  FBonusColor := StrToIntDef(data.Values['BonusColor'], $FF3030);

  RespawnDelay := StrToFloat(data.Values['RespawnDelay']);
  RespawnDispersion := StrToFloat(data.Values['RespawnDispersion']);
  RespawnActions := data.Values['RespawnActions'];
  BumpActions := data.Values['BumpActions'];
  FTimeToRespawn := RespawnDelay;
  FBasePosition := Position;
end;

// SetupVisualObjects
//
procedure TABBonus.SetupVisualObjects;
var
  engine: TAirBlastEngine;
  ffProxy: TGLBaseSceneObject;
  envVars: TStringList;
begin
  if Collision = nil then
    TCollisionVolume.Create(Self);
  engine := (GameEngine as TAirBlastEngine);
  PosX := FBasePosition.X + 2 * (Random - 0.5) * RespawnDispersion;
  PosY := FBasePosition.Y + 2 * (Random - 0.5) * RespawnDispersion;
  PosZ := engine.TerrainRenderer.InterpolatedHeight(Position);
  FModel := TGLDummyCube(engine.SortedSceneRoot.AddNewChild(TGLDummyCube));
  FModel.ObjectsSorting := osNone;
  FModel.Position.AsVector := Self.Position;
  if ModelName <> '' then
  begin
    ffProxy := engine.FreeFormProxy(ModelName);
    FModel.AddChild(ffProxy);
    with ffProxy do
    begin
      Position.Z := Collision.Radius * 0.4;
      Scale.Scale(0.3 * Collision.Radius / BoundingSphereRadius);
      TurnAngle := 60;
    end;
  end
  else
  begin
    ffProxy := engine.FreeFormProxy('Models\aaram.3ds');
    FModel.AddChild(ffProxy);
    with ffProxy do
    begin
      Position.Z := Collision.Radius * 0.3;
      Scale.Scale(0.3 * Collision.Radius / BoundingSphereRadius);
      TurnAngle := 60;
    end;
    ffProxy := engine.FreeFormProxy('Models\aim9.3ds');
    FModel.AddChild(ffProxy);
    with ffProxy do
    begin
      Position.Z := Collision.Radius * 0.6;
      Scale.Scale(0.3 * Collision.Radius / BoundingSphereRadius);
      TurnAngle := 60;
    end;
  end;
  with TGLSphere.CreateAsChild(FModel) do
  begin
    Radius := Collision.Radius;
    Material.BlendingMode := bmAdditive;
    Material.FrontProperties.Diffuse.AsWinColor := BonusColor;
    Slices := 12;
    Stacks := 9;
    Bottom := 0;
    Up.AsAffineVector := ZVector;
  end;
  if RespawnActions <> '' then
  begin
    envVars := TStringList.Create;
    PerformABActions(engine, RespawnActions, envVars);
    envVars.Free;
  end;
end;

// ClearVisualObjects
//
procedure TABBonus.ClearVisualObjects;
begin
  FreeAndNil(FModel);
end;

// DoAirplaneBump
//
procedure TABBonus.DoAirplaneBump(airplane: TABAirplane);
begin
  if FModel = nil then
    Exit;
  ClearVisualObjects;
  FTimeToRespawn := FRespawnDelay;
  if BumpActions <> '' then
    inherited DoAirplaneBump(airplane);
end;

// ------------------
// ------------------ TABHoop ------------------
// ------------------

// Destroy
//
destructor TABHoop.Destroy;
begin
  inherited;
  ClearVisualObjects;
end;

// SaveToStrings
//
procedure TABHoop.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['NextHoop'] := NextHoop;
  if Active then
    data.Values['Active'] := 'Y'
  else
    data.Values['Active'] := 'N';
  if Collision <> nil then
    data.Values['HoopSize'] := FloatToStr(Collision.Radius);
end;

// LoadFromStrings
//
procedure TABHoop.LoadFromStrings(data: TStrings);
begin
  inherited;
  NextHoop := data.Values['NextHoop'];
  Active := (data.Values['Active'] = 'Y');
  if Collision = nil then
    TCollisionVolume.Create(Self);
  Collision.Size := VectorScale(XYZVector, StrToFloat(data.Values['HoopSize']));
  Collision.CollType := mctImmaterial;
end;

// Loaded
//
procedure TABHoop.Loaded;
var
  i: Integer;
  hoops: TGLPersistentObjectList;
  next, prev: TABHoop;
begin
  if VectorNorm(Direction) = 0 then
  begin
    // auto-orient to next hoop
    hoops := TGLPersistentObjectList.Create;
    GameEngine.EnumerateMobiles(TABHoop, hoops);
    next := nil;
    prev := nil;
    for i := 0 to hoops.Count - 1 do
      with TABHoop(hoops[i]) do
      begin
        if NextHoop = Self.Name then
          prev := TABHoop(hoops[i])
        else if Name = Self.NextHoop then
          next := TABHoop(hoops[i]);
      end;
    hoops.Free;
    if Assigned(next) then
      if Assigned(prev) then
        Direction := VectorNormalize(VectorSubtract(next.Position,
          prev.Position))
      else
        Direction := VectorNormalize(VectorSubtract(next.Position, Position))
    else if Assigned(prev) then
      Direction := VectorNormalize(VectorSubtract(Position, prev.Position))
    else
      Direction := XHmgVector;
  end;
  SetupVisualObjects;
end;

// SetupVisualObjects
//
procedure TABHoop.SetupVisualObjects;
var
  engine: TAirBlastEngine;
  hoop: TGLFreeForm;
begin

  engine := (GameEngine as TAirBlastEngine);
  hoop := TGLFreeForm(engine.SortedSceneRoot.AddNewChild(TGLFreeForm));
  hoop.LoadFromFile('Models\gate.3ds');
  FModel := engine.FreeFormProxy('Models\gate.3ds', TGLColorProxy);
  engine.SortedSceneRoot.AddChild(FModel);
  with TGLColorProxy(FModel) do
  begin
    MasterObject := hoop;
    ProxyOptions := [pooObjects];
    Position.SetPoint(Self.Position);
    Up.SetVector(Self.Up);
    Direction.SetVector(Self.Direction);
    Scale.Scale(Collision.Radius);
  end;
  SetActive(Active);
end;

// ClearVisualObjects
//
procedure TABHoop.ClearVisualObjects;
begin
  FModel.Free;
  FModel := nil;
end;

// DoAirplaneBump
//
procedure TABHoop.DoAirplaneBump(airplane: TABAirplane);
var
  mobile: TMobile;
begin
  if Active then
  begin
    inherited;
    // deactivate self and...
    Active := False;
    // ...activate next hoop
    mobile := GameEngine.MobileByName(NextHoop);
    if mobile is TABHoop then
      TABHoop(mobile).Active := True;
  end;
end;

// SetActive
//
procedure TABHoop.SetActive(val: Boolean);
begin

  FActive := val;
  if Assigned(FModel) then
  begin
    with TGLColorProxy(FModel).FrontColor do
    begin
      if Active then
        Emission.SetColor(1, 1, 0, 1)
      else
        Emission.SetColor(0, 0, 1, 1);
    end;
  end;
end;

end.
