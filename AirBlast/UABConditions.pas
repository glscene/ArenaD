unit UABConditions;

(* AirBlast conditions *)

interface

uses
  System.Classes,
  UAirBlastEngine,
  UGameEngine,
  UABEvents,
  GLS.PersistentClasses,
  GLS.VectorGeometry,
  GLS.Material,
  GLS.VectorTypes;

type

  // TABECSpawnPointExhausted
  //
  TABECSpawnPointExhausted = class(TABEventCondition)
  private
    { Private Properties }
    FSpawnPoint: TABSpawnPoint;

  protected
    { Protected Properties }

  public
    { Public Properties }
    constructor Create(engine: TAirBlastEngine; const params: String); override;
    function ConditionMet: Boolean; override;
  end;

  // TABECAirplaneDamage
  //
  TABECAirplaneDamage = class(TABEventCondition)
  private
    { Private Properties }
    FAirplaneName: String;
    FDamageTreshold: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    constructor Create(engine: TAirBlastEngine; const params: String); override;
    function ConditionMet: Boolean; override;
  end;

  // TABECMobileAtWaypoint
  //
  TABECMobileAtWaypoint = class(TABEventCondition)
  private
    { Private Properties }
    FMobileName: String;
    FWaypointPos: TGLVector;
    FBumpRadius, FBumpRadius2: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    constructor Create(engine: TAirBlastEngine; const params: String); override;
    function ConditionMet: Boolean; override;
    procedure CreateDebugStuff; override;
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
  UABUtils,
  GLS.Objects,
  GLS.Scene,
  GLS.Texture;


// ------------------
// ------------------ TABECSpawnPointExhausted ------------------
// ------------------

// Create
//
constructor TABECSpawnPointExhausted.Create(engine: TAirBlastEngine;
  const params: String);
begin
  inherited;
  FSpawnPoint := ABEngine.SpawnPointByName(params);
end;

// ConditionMet
//
function TABECSpawnPointExhausted.ConditionMet: Boolean;
begin
  Result := (FSpawnPoint = nil) or (FSpawnPoint.Exhausted);
end;

// ------------------
// ------------------ TABECAirplaneDamage ------------------
// ------------------

// Create
//
constructor TABECAirplaneDamage.Create(engine: TAirBlastEngine;
  const params: String);
var
  p: Integer;
begin
  inherited;
  p := Pos(' ', params);
  FAirplaneName := Copy(params, 1, p - 1);
  FDamageTreshold := StrToFloatDef(Copy(params, p + 1, MaxInt), 50) * 0.01;
end;

// ConditionMet
//
function TABECAirplaneDamage.ConditionMet: Boolean;
var
  mobile: TMobile;
begin
  mobile := ABEngine.MobileByName(FAirplaneName);
  Result := (mobile is TABAirplane) and
    (TABAirplane(mobile).HullResistance < TABAirplane(mobile).BaseHullResistance
    * FDamageTreshold);
end;

// ------------------
// ------------------ TABECMobileAtWaypoint ------------------
// ------------------

// Create
//
constructor TABECMobileAtWaypoint.Create(engine: TAirBlastEngine;
  const params: String);
var
  sl: TStringList;
begin
  inherited;
  sl := TStringList.Create;
  sl.CommaText := params;
  FMobileName := sl.Values['Mobile'];
  MakePoint(FWaypointPos, StringToVector3(sl.Values['Position']));
  FBumpRadius := StrToFloat(sl.Values['BumpRadius']);
  FBumpRadius2 := Sqr(FBumpRadius);
  sl.Free;
end;

// ConditionMet
//
function TABECMobileAtWaypoint.ConditionMet: Boolean;
var
  mobile: TMobile;
begin
  mobile := ABEngine.MobileByName(FMobileName);
  Result := (mobile is TMobile) and
    (VectorDistance2(TABAirplane(mobile).Position, FWaypointPos) <=
    FBumpRadius2);
end;

// CreateDebugStuff
//
procedure TABECMobileAtWaypoint.CreateDebugStuff;
begin
  with TGLSphere.CreateAsChild(ABEngine.SceneRoot) do
  begin
    Position.SetPoint(Self.FWaypointPos);
    Radius := FBumpRadius;
    Slices := 9;
    Stacks := 7;
    // Material.PolygonMode := pmLines;
  end;
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

RegisterEventConditionClass('SpawnPointExhausted', TABECSpawnPointExhausted);
RegisterEventConditionClass('AirplaneDamage', TABECAirplaneDamage);
RegisterEventConditionClass('MobileAtWaypoint', TABECMobileAtWaypoint);

end.
