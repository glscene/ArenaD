unit UABEquipments;

(* Equipment platform classes *)

interface

uses
  System.Classes,
  System.Math,
  VCL.Graphics,
  UGameEngine,
  UAirBlastEngine,
  GLS.VectorGeometry,
  GLS.PersistentClasses,
  GLS.VectorTypes,
  GLS.VectorLists,
  GLS.Color,
  GLS.Objects,
  GLS.Scene,
  GLS.Texture,
  GLS.Canvas,
  GLS.SoundManager,
  GLS.RenderContextInfo,
  GLS.Material;

type

  // TABEqptInstruments
  //
  (* Flight instrument. *)
  TABEqptInstruments = class(TABEquipment)
  private
    { Private Properties }
    FSEMissileAlert: TGLBSoundEmitter;

  protected
    { Protected Properties }
    procedure RenderTargetHighlight(var rci: TGLRenderContextInfo); virtual;
    // Canvas is standardized to 1024x768
    procedure RenderReticle(var rci: TGLRenderContextInfo;
      Canvas: TGLCanvas); virtual;
    // Canvas is standardized to 1024x768
    procedure RenderWeaponsSelection(var rci: TGLRenderContextInfo;
      Canvas: TGLCanvas); virtual;
    // Canvas is standardized to 1024x768
    procedure RenderRadar(var rci: TGLRenderContextInfo;
      Canvas: TGLCanvas); virtual;

  public
    { Public Properties }
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;
    procedure SetupSyncObject; override;
    procedure TearDownSyncObject; override;

    procedure PerformPreRenders; override;
    procedure Progress(const deltaTime: Double); override;
    procedure HUDRender(var rci: TGLRenderContextInfo); override;
  end;

  // TABEqptWeapon
  //
  (* Abstract weapons platforms, with ability to fire and ammo capacity. *)
  TABEqptWeapon = class(TABEquipment)
  private
    { Private Properties }
    FAmmoType: String;
    FAmmoMaxCapacity, FAmmoCapacity: Integer;
    FPrimaryConsumption, FAlternateConsumption: Integer;
    FPrimaryCoolDown, FAlternateCoolDown, FReloadCoolDown: Single;
    FMaxRange, FOptimalRange: Single;
    FInitialVelocity: TGLVector;
    FCoolDown: Single;
    FVoiceNotification: String;

  protected
    { Protected Properties }
    function SpawnAmmo(primary: Boolean): TMobile; virtual; abstract;

  public
    { Public Properties }

    procedure Progress(const deltaTime: Double); override;
    procedure Replenish; override;
    procedure Deplete; override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    // : Type of ammo being fired
    property AmmoType: String read FAmmoType write FAmmoType;

    // : Extra ammo initial velocity (upon firing)
    property InitialVelocity: TGLVector read FInitialVelocity
      write FInitialVelocity;

    // : Maximum ammo capacity
    property AmmoMaxCapacity: Integer read FAmmoMaxCapacity
      write FAmmoMaxCapacity;
    property AmmoCapacity: Integer read FAmmoCapacity write FAmmoCapacity;
    procedure Reload;

    // : Ammo consumption for primary fire
    property PrimaryConsumption: Integer read FPrimaryConsumption
      write FPrimaryConsumption;
    // : Ammo consumption for alternate fire
    property AlternateConsumption: Integer read FAlternateConsumption
      write FAlternateConsumption;

    // : Cool down delay after primary fire (in sec)
    property PrimaryCoolDown: Single read FPrimaryCoolDown
      write FPrimaryCoolDown;
    // : Cool down delay after alternate fire (in sec)
    property AlternateCoolDown: Single read FAlternateCoolDown
      write FAlternateCoolDown;
    // : Cool down delay after reload (in sec)
    property ReloadCoolDown: Single read FReloadCoolDown write FReloadCoolDown;

    // : Maximum weapon range (for AI consumption)
    property MaxRange: Single read FMaxRange write FMaxRange;
    // : Optimal weapon range (for AI consumption)
    property OptimalRange: Single read FOptimalRange write FOptimalRange;

    // : Cool down time remaining
    property CoolDown: Single read FCoolDown;

    property VoiceNotification: String read FVoiceNotification
      write FVoiceNotification;

    function CanFirePrimary: Boolean; virtual;
    function CanFireAlternate: Boolean; virtual;

    procedure FirePrimary; override;
    procedure FireAlternate; override;
  end;

  // TABEqptGun
  //
  { : Fires ungided bullet ammo. }
  TABEqptGun = class(TABEqptWeapon)
  private
    { Private Properties }
    FTimeToLive: Single;
    FNbActive: Integer;
    FPoints: TGLPoints;
    FBullets: TGLPersistentObjectList;
    FNextBulletTime: Single;
    FSalvoRemaining: Integer;
    FSalvoInterval: Single;
    FTargetingAssist: Integer;
    FPrimaryDamage: Integer;
    FPrimarySalvoCount: Integer;
    FPrimarySalvoInterval: Single;
    FAlternateDamage: Integer;
    FAlternateSalvoCount: Integer;
    FAlternateSalvoInterval: Single;

  protected
    { Protected Properties }
    procedure SetupSyncObject; override;
    procedure TearDownSyncObject; override;

    function SpawnAmmo(primary: Boolean): TMobile; override;

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;
    procedure HUDRender(var rci: TGLRenderContextInfo); override;

    { : Returns best estimate for targeting position aim.<p>
      Returned float is the range estimation (1 for range limit, >1 for
      out of range). }
    function BestAimEstimate(var p: TGLVector; quality: Integer): Single;

    procedure FirePrimary; override;
    procedure FireAlternate; override;

    property TimeToLive: Single read FTimeToLive write FTimeToLive;
    property TargetingAssist: Integer read FTargetingAssist
      write FTargetingAssist;
    property PrimaryDamage: Integer read FPrimaryDamage write FPrimaryDamage;
    property PrimarySalvoCount: Integer read FPrimarySalvoCount
      write FPrimarySalvoCount;
    property PrimarySalvoInterval: Single read FPrimarySalvoInterval
      write FPrimarySalvoInterval;
    property AlternateDamage: Integer read FAlternateDamage
      write FAlternateDamage;
    property AlternateSalvoCount: Integer read FAlternateSalvoCount
      write FAlternateSalvoCount;
    property AlternateSalvoInterval: Single read FAlternateSalvoInterval
      write FAlternateSalvoInterval;
  end;

  // TABEqptMissile
  //
  { : Detachable missile (unguided). }
  TABEqptMissile = class(TABEqptWeapon)
  private
    { Private Properties }
    FAmmoControler: TControlerClass;
    FAmmoControlerParams: String;

  protected
    { Protected Properties }
    function SpawnAmmo(primary: Boolean): TMobile; override;

  public
    { Public Properties }
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;
    procedure Deplete; override;

    property AmmoControler: TControlerClass read FAmmoControler
      write FAmmoControler;
    property AmmoControlerParams: String read FAmmoControlerParams
      write FAmmoControlerParams;
  end;

  // TABEqptGuidedMissile
  //
  { : Detachable missile (unguided). }
  TABEqptGuidedMissile = class(TABEqptMissile)
  private
    { Private Properties }
    FLockDelay: Single;
    FLockAngle: Single;
    FLockDelayRemaining: Single;
    FLockingTargetMobile: TMobile;
    FTargetLocked, FLockingTarget: Boolean;
    FSEBuzz: TGLBSoundEmitter;

  protected
    { Protected Properties }
    function SpawnAmmo(primary: Boolean): TMobile; override;

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;
    procedure HUDRender(var rci: TGLRenderContextInfo); override;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;
    procedure SetupSyncObject; override;
    procedure TearDownSyncObject; override;

    function CanFirePrimary: Boolean; override;
    function CanFireAlternate: Boolean; override;

    property LockDelay: Single read FLockDelay write FLockDelay;
    property LockAngle: Single read FLockAngle write FLockAngle;

    property TargetLocked: Boolean read FTargetLocked;
    property LockingTarget: Boolean read FLockingTarget;

  end;

  // TABEqptDecoyLauncher
  //
  { : Decoy launcher equipment, fires decoy to divert missiles. }
  TABEqptDecoyLauncher = class(TABEquipment)
  private
    { Private Properties }
    FCapacity, FMaxCapacity: Integer;
    FEfficiency: Single;
    FCoolDown, FCoolDownRemaining: Single;
    FDecoyLifeTime: Single;

  protected
    { Protected Properties }
    function SpawnDecoy: TMobile;

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;
    procedure Replenish; override;

    procedure Use;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    { : Decoy chances to divert missile. }
    property Efficiency: Single read FEfficiency write FEfficiency;
    { : Number of decoys in stock. }
    property Capacity: Integer read FCapacity write FCapacity;
    property MaxCapacity: Integer read FMaxCapacity write FMaxCapacity;
    { : Delay between each decoy fire. }
    property CoolDown: Single read FCoolDown write FCoolDown;
    { : Decoy persistence in seconds. }
    property DecoyLifeTime: Single read FDecoyLifeTime write FDecoyLifeTime;
  end;

  // TABEqptDamageControl
  //
  { : Attempts to control fire and other damages. }
  TABEqptDamageControl = class(TABEquipment)
  private
    { Private Properties }
    FCapacity, FMaxCapacity: Integer;
    FEfficiency: Single;
    FCoolDown, FCoolDownRemaining: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure Progress(const deltaTime: Double); override;
    procedure Replenish; override;

    procedure Use;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    { : Decoy chances to divert missile. }
    property Efficiency: Single read FEfficiency write FEfficiency;
    { : Number of decoys in stock. }
    property Capacity: Integer read FCapacity write FCapacity;
    property MaxCapacity: Integer read FMaxCapacity write FMaxCapacity;
    { : Delay between each decoy fire. }
    property CoolDown: Single read FCoolDown write FCoolDown;
  end;

  // TABMobileAmmo
  //
  { : Ammo's mobile, just detonates with a boom. }
  TABMobileAmmo = class(TMobile)
  private
    { Private Properties }
    FTimeToLive: Single;
    FBulletID: Integer;
    FGun: TABEqptGun;
    FDamage: Integer;

  protected
    { Protected Properties }

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;

    procedure DoDetonate; override;

    function FiredBy(aMobile: TMobile): Boolean;
    property Gun: TABEqptGun read FGun;
  end;

  // TABDecoy
  //
  { : Flies (as a fire point) and dies when timed out or hits anything. }
  TABDecoy = class(TMobile)
  private
    { Private Properties }
    FTimeToLive: Single;
    FFirePoint: TGLBaseSceneObject;

  protected
    { Protected Properties }

  public
    { Public Properties }
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;
  end;

  // TABMissile
  //
  TABMissile = class(TABAirplane)
  private
    { Private Properties }
    FDecoyResistance: Single;
    FDamageRadius: Single;
    FDamageMin, FDamageMax: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    procedure DoDetonate; override;

    { : Ratio applied to Decoy's efficiency. }
    property DecoyResistance: Single read FDecoyResistance
      write FDecoyResistance;

    property DamageRadius: Single read FDamageRadius write FDamageRadius;
    property DamageMin: Single read FDamageMin write FDamageMin;
    property DamageMax: Single read FDamageMax write FDamageMax;
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
  Winapi.OpenGL,
  UABUtils,
  UAirBlastControler,
  UABMobiles,
  GLS.Context,
  GLS.BitmapFont;

// ------------------
// ------------------ TABEqptInstruments ------------------
// ------------------

// SaveToStrings
//
procedure TABEqptInstruments.SaveToStrings(data: TStrings);
begin
  inherited;
end;

// LoadFromStrings
//
procedure TABEqptInstruments.LoadFromStrings(data: TStrings);
begin
  inherited;
end;

// SetupSyncObject
//
procedure TABEqptInstruments.SetupSyncObject;
begin
  inherited;
  if Airplane.Name = 'Player' then
  begin
    FSEMissileAlert := TGLBSoundEmitter.Create(Airplane.SyncObject.Behaviours);
    with FSEMissileAlert do
    begin
      Source.SoundLibrary := Airplane.ABEngine.SoundLibrary;
      Source.SoundName := 'Missile_Alert';
      Source.NbLoops := 999999;
      Source.Volume := 0.5;
    end;
  end;
end;

// TearDownSyncObject
//
procedure TABEqptInstruments.TearDownSyncObject;
begin
  inherited;
  FSEMissileAlert.Free;
  FSEMissileAlert := nil;
end;

// PerformPreRenders
//
procedure TABEqptInstruments.PerformPreRenders;
var
  i: Integer;
  eqpt: TABEquipment;
begin
  Airplane.ABEngine.TopDownTextureMaterial(Airplane.ModelName, 256);
  for i := 0 to Airplane.EquipmentCount - 1 do
  begin
    eqpt := Airplane.Equipments[i];
    if eqpt is TABEqptMissile then
      Airplane.ABEngine.TopDownTextureMaterial(eqpt.ModelName);
  end;
end;

// Progress
//
procedure TABEqptInstruments.Progress(const deltaTime: Double);
var
  alert: Boolean;
  i: Integer;
  list: TGLPersistentObjectList;
begin
  inherited;

  if Assigned(FSEMissileAlert) then
  begin
    list := TGLPersistentObjectList.Create;
    Airplane.ABEngine.EnumerateMobiles(TABMissile, list);
    alert := False;
    for i := 0 to list.Count - 1 do
    begin
      if TABMissile(list[i]).CurrentTarget = Airplane then
      begin
        alert := True;
        Break;
      end;
    end;
    FSEMissileAlert.Playing := alert;
    list.Free;
  end;
end;

// HUDRender
//
procedure TABEqptInstruments.HUDRender(var rci: TGLRenderContextInfo);
var
  Canvas: TGLCanvas;
begin
  RenderTargetHighlight(rci);

  Canvas := TGLCanvas.Create(1024, 768);

  if FSEMissileAlert.Playing and (Frac(Airplane.ABEngine.Cadencer.CurrentTime) >
    0.5) then
  begin
    Canvas.PenColor := clRed;
    Canvas.PenAlpha := 0.7;
    Canvas.FillRect(5, 200, 25, 500);
    Canvas.FillRect(1024 - 5, 200, 1024 - 25, 500);
  end;

  RenderReticle(rci, Canvas);
  RenderWeaponsSelection(rci, Canvas);
  RenderRadar(rci, Canvas);

  Canvas.Free;
end;

// RenderTargetHighlight
//
procedure TABEqptInstruments.RenderTargetHighlight
  (var rci: TGLRenderContextInfo);
var
  Canvas: TGLCanvas;
  mobile: TMobile;
  screenPos: TGLVector;
  f: Single;
  s: Integer;
begin
  mobile := Airplane.CurrentTarget;
  if Assigned(mobile) and Airplane.IsAhead(mobile.Position) then
  begin
    Canvas := CreateBufferGLCanvas(rci);
    if mobile.Team = Airplane.Team then
      Canvas.PenColor := clLime
    else
      Canvas.PenColor := clRed;
    screenPos := TGLSceneBuffer(rci.buffer).WorldToScreen(mobile.Position);
    screenPos.Y := Canvas.CanvasSizeY - screenPos.Y;
    s := Canvas.CanvasSizeX div 64;

    Canvas.PenWidth := 5;
    Canvas.MoveTo(screenPos.X, screenPos.Y);
    RenderCornersQuad(Canvas, s);
    if mobile is TABAirplane then
    begin
      with TABAirplane(mobile) do
        f := HullResistance / BaseHullResistance;
      Canvas.MoveTo(screenPos.X - s, screenPos.Y - s * 1.5);
      Canvas.LineToRel(f * 2 * s, 0);
    end;
    Canvas.PenWidth := 1;
    Canvas.PenColor := clWhite;
    Canvas.MoveTo(screenPos.X, screenPos.Y);
    RenderCornersQuad(Canvas, s);
    Canvas.Free;
  end;
end;

// RenderReticle
//
procedure TABEqptInstruments.RenderReticle(var rci: TGLRenderContextInfo;
  Canvas: TGLCanvas);
var
  h, d: Single;
  buf: String;
  hudColor: TColor;
begin
  hudColor := clWhite;

  with Canvas do
  begin
    PenColor := hudColor;
    PenAlpha := 1;
    PenWidth := 1;
    MoveTo(512, 384);
    MoveToRel(0, -10);
    LineToRel(0, 21);
    MoveToRel(-10, -11);
    LineToRel(21, 0);

    Line(512 - 150, 384, 512 - 75, 384);
    Line(512 + 75, 384, 512 + 150, 384);
    FrameRect(512 - 200 - 20, 384 - 10, 512 - 200 + 20, 384 + 10);
    FrameRect(512 + 200 - 20, 384 - 10, 512 + 200 + 20, 384 + 10);
  end;
  Canvas.StopPrimitive;

  h := Airplane.Position.Y - Airplane.ABEngine.TerrainRenderer.
    InterpolatedHeight(Airplane.Position);
  with Airplane.ABEngine.SmallFont do
  begin
    TextOut(rci, 512 - 200 - 10, 384 - 8,
      Format('%.3d', [Round(Airplane.Speed * vSpeedScaleUp)]), hudColor);
    if Airplane.Throttle <= 1 then
      TextOut(rci, 512 - 200 - 15, 384 + 24,
        Format('%3d%%', [Round(Airplane.Throttle * 100)]), hudColor)
    else
      TextOut(rci, 512 - 200 - 15, 384 + 24, ' AB', hudColor);
    TextOut(rci, 512 + 200 - 13, 384 - 8, Format('%.4d', [Round(h)]), hudColor);
    buf := Format('%.3d', [Round(Airplane.Velocity.Y * vSpeedScaleUp)]);
    if buf[1] <> '-' then
      buf := '+' + buf;
    TextOut(rci, 512 + 200 - 13, 384 - 8 + 20, buf, hudColor);

    if Airplane.CurrentTarget <> nil then
    begin
      TextOut(rci, 600, 600, Airplane.CurrentTarget.Name, hudColor);
      d := Airplane.DistanceTo(Airplane.CurrentTarget);
      if d < 1000 then
        buf := Format('%.4d', [Round(d)])
      else
        buf := Format('%.1fk', [d * 0.001]);
      TextOut(rci, 600, 615, buf, hudColor);
    end
    else
      TextOut(rci, 600, 600, 'No Target', hudColor);
  end;
end;

// RenderWeaponsSelection
//
procedure TABEqptInstruments.RenderWeaponsSelection
  (var rci: TGLRenderContextInfo; Canvas: TGLCanvas);
const
  cHullColor100: TGLColorVector = (X: 0.60; Y: 0.60; Z: 1.00; W: 1);
  cHullColor0: TGLColorVector = (X: 1.0; Y: 0.6; Z: 0.6; W: 1.0);
var
  i: Integer;
  screenPos: TGLVector;
  libMat: TGLLibMaterial;
  eqpt: TABEquipment;
  posX, posY, f: Single;
  hullStateColor: TGLColorVector;
  groupName: String;
  weaponAmmo, decoyAmmo, extinguisherAmmo: Integer;
begin
  posX := 100;
  posY := Canvas.CanvasSizeY - 100;

  Canvas.PenColor := clBlack;
  Canvas.PenAlpha := 0.5;
  Canvas.FillRect(posX - 90, posY - 90, posX + 90, posY + 90);
  Canvas.PenColor := $B0B0B0;
  Canvas.PenAlpha := 1;
  Canvas.FrameRect(posX - 90, posY - 90, posX + 90, posY + 90);
  Canvas.StopPrimitive;

  Airplane.RenderWeaponsLoadout(rci, Canvas, posX, posY, 80);

  decoyAmmo := 0;
  extinguisherAmmo := 0;
  for i := 0 to Airplane.EquipmentCount - 1 do
  begin
    eqpt := Airplane.Equipments[i];
    if eqpt is TABEqptDecoyLauncher then
      decoyAmmo := decoyAmmo + TABEqptDecoyLauncher(eqpt).Capacity
    else if eqpt is TABEqptDamageControl then
      extinguisherAmmo := extinguisherAmmo + TABEqptDamageControl(eqpt)
        .Capacity;
  end;
  Canvas.StopPrimitive;

  groupName := Airplane.CurrentWeaponGroup;
  if groupName <> '' then
  begin
    weaponAmmo := Airplane.WeaponGroupAmmo(groupName);
    if groupName[1] = '!' then
      groupName := Copy(groupName, 2, MaxInt);
    groupName := groupName + ' x' + IntToStr(weaponAmmo);
    screenPos.X := posX;
    screenPos.Y := Canvas.CanvasSizeY - 35;
    screenPos.Z := 0;
    with Airplane.ABEngine.SmallFont do
      TextOut(rci, screenPos.X - TextWidth(groupName) div 2, screenPos.Y,
        groupName, clrWhite);
  end;

  // Decoy Status
  with Airplane.ABEngine.SmallFont do
  begin
    TextOut(rci, posX + 45, posY - 85, 'Decoy', clrSilver);
    TextOut(rci, posX + 55, posY - 70, Format('x%.3d', [decoyAmmo]), clrSilver);
  end;
  // Extinguisher Status
  with Airplane.ABEngine.SmallFont do
  begin
    TextOut(rci, posX - 45, posY - 85, StringOfChar('/', extinguisherAmmo),
      clrOrangeRed);
  end;

  // Hull Status
  f := Airplane.HullResistance / Airplane.BaseHullResistance;
  with Airplane.ABEngine.SmallFont do
    TextOut(rci, posX - 85, posY - 85, Format('%3d%%', [Round(100 * f)]),
      clrSilver);
  glBegin(GL_QUADS);
  hullStateColor := VectorLerp(cHullColor0, cHullColor100, f);
  glColor4fv(@hullStateColor);
  f := Lerp(posY + 80, posY - 65, f);
  glVertex2f(posX - 80, f);
  glVertex2f(posX - 70, f);
  glColor4fv(@cHullColor0);
  glVertex2f(posX - 70, posY + 80);
  glVertex2f(posX - 80, posY + 80);
  glEnd;
  if Airplane.FireDamage > 0 then
  begin
    if Frac(Airplane.ABEngine.Cadencer.CurrentTime) > 0.5 then
    begin
      libMat := Airplane.ABEngine.SpriteTextureMaterial('Flame');
      glColor4fv(@clrRed);
      RenderSpriteQuad(rci, posX - 40, posY - 40, 32, libMat);
    end;
  end;
end;

// RenderRadar
//
procedure TABEqptInstruments.RenderRadar(var rci: TGLRenderContextInfo;
  Canvas: TGLCanvas);
var
  i: Integer;
  posX, posY, r, X, Y: Single;
  fFront, fBack, f: Single;
  p: TGLVector;
  mobile: TMobile;
  engine: TAirBlastEngine;
begin
  posX := Canvas.CanvasSizeX - 100;
  posY := Canvas.CanvasSizeY - 100;
  r := 90;
  fFront := r * 0.666;
  fBack := r - fFront;

  Canvas.PenColor := clBlack;
  Canvas.PenAlpha := 0.5;
  Canvas.FillEllipse(Round(posX), Round(posY), r, r);
  Canvas.PenColor := $B0B0B0;
  Canvas.PenAlpha := 1;
  Canvas.PenWidth := 1;
  Canvas.PlotPixel(posX, posY);
  Canvas.Ellipse(Round(posX), Round(posY), r, r);
  Canvas.Ellipse(Round(posX), Round(posY), fFront, fFront);

  engine := Airplane.ABEngine;
  for i := 0 to engine.MobileCount - 1 do
  begin
    mobile := engine.Mobiles[i];
    if mobile is TABAirplane then
    begin
      if mobile = Airplane then
        continue;
      if mobile.Team = Airplane.Team then
        Canvas.PenColor := clLime
      else
        Canvas.PenColor := clRed;
      if mobile = Airplane.CurrentTarget then
        Canvas.PenWidth := 4
      else
        Canvas.PenWidth := 2;
    end
    else if (mobile is TABHoop) and TABHoop(mobile).Active then
    begin
      Canvas.PenWidth := 3;
      Canvas.PenColor := clYellow;
    end
    else if (mobile is TABBonus) and (TABBonus(mobile).Model <> nil) then
    begin
      Canvas.PenWidth := 3;
      Canvas.PenColor := clBlue;
    end
    else
      continue;

    p := VectorNormalize(Airplane.AbsoluteToRelative(mobile.Position));
    if p.X > 0 then
    begin
      X := posX - p.Y * fFront;
      Y := posY - p.Z * fFront;
    end
    else
    begin
      f := r * RLength(p.X, p.Z);
      X := posX - p.X * f + p.X * fBack;
      Y := posY - p.Z * f + p.Z * fBack;
    end;
    Canvas.PlotPixel(X, Y);
  end;
end;

// ------------------
// ------------------ TABEqptWeapon ------------------
// ------------------

// Progress
//
procedure TABEqptWeapon.Progress(const deltaTime: Double);
begin
  inherited;
  FCoolDown := FCoolDown - deltaTime;
end;

// Replenish
//
procedure TABEqptWeapon.Replenish;
begin
  AmmoCapacity := AmmoMaxCapacity;
  inherited;
end;

// Deplete
//
procedure TABEqptWeapon.Deplete;
begin
  AmmoCapacity := 0;
  inherited;
end;

// SaveToStrings
//
procedure TABEqptWeapon.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['AmmoType'] := AmmoType;
  data.Values['InitialVelocity'] := Vector3ToString(FInitialVelocity);
  data.Values['AmmoMaxCapacity'] := IntToStr(AmmoMaxCapacity);
  data.Values['PrimaryConsumption'] := IntToStr(PrimaryConsumption);
  data.Values['AlternateConsumption'] := IntToStr(AlternateConsumption);
  data.Values['PrimaryCoolDown'] := FloatToStr(PrimaryCoolDown);
  data.Values['AlternateCoolDown'] := FloatToStr(AlternateCoolDown);
  data.Values['ReloadCoolDown'] := FloatToStr(ReloadCoolDown);
  data.Values['MaxRange'] := FloatToStr(MaxRange);
  data.Values['OptimalRange'] := FloatToStr(OptimalRange);
  data.Values['VoiceNotification'] := VoiceNotification;
end;

// LoadFromStrings
//
procedure TABEqptWeapon.LoadFromStrings(data: TStrings);
begin
  inherited;
  FAmmoType := data.Values['AmmoType'];
  FInitialVelocity :=
    VectorMake(StringToVector3(data.Values['InitialVelocity']));
  FAmmoMaxCapacity := StrToIntDef(data.Values['AmmoMaxCapacity'], 1);
  FAmmoCapacity := FAmmoMaxCapacity;
  FPrimaryConsumption := StrToIntDef(data.Values['PrimaryConsumption'], 1);
  FAlternateConsumption := StrToIntDef(data.Values['AlternateConsumption'],
    FPrimaryConsumption);
  FPrimaryCoolDown := StrToFloatDef(data.Values['PrimaryCoolDown'], 0);
  FAlternateCoolDown := StrToFloatDef(data.Values['AlternateCoolDown'],
    FPrimaryCoolDown);
  FReloadCoolDown := StrToFloatDef(data.Values['ReloadCoolDown'], 0);
  FMaxRange := StrToFloat(data.Values['MaxRange']);
  FOptimalRange := StrToFloat(data.Values['OptimalRange']);
  VoiceNotification := data.Values['VoiceNotification'];
  FCoolDown := 0;
end;

// Reload
//
procedure TABEqptWeapon.Reload;
begin
  AmmoCapacity := AmmoMaxCapacity;
  FCoolDown := MaxFloat(FCoolDown, FReloadCoolDown);
end;

// CanFirePrimary
//
function TABEqptWeapon.CanFirePrimary: Boolean;
begin
  Result := (CoolDown <= 0) and (AmmoCapacity >= PrimaryConsumption);
end;

// CanFireAlternate
//
function TABEqptWeapon.CanFireAlternate: Boolean;
begin
  Result := (CoolDown <= 0) and (AmmoCapacity >= AlternateConsumption);
end;

// FirePrimary
//
procedure TABEqptWeapon.FirePrimary;
begin
  if CanFirePrimary then
  begin
    Dec(FAmmoCapacity, PrimaryConsumption);
    FCoolDown := PrimaryCoolDown;
    SpawnAmmo(True);
  end
  else if AmmoCapacity < PrimaryConsumption then
  begin
    if FCoolDown < 0 then
    begin
      Airplane.ABEngine.PlaySound(Airplane.Name, 'Gun_Dry');
      FCoolDown := 0.5;
    end;
  end;
end;

// FireAlternate
//
procedure TABEqptWeapon.FireAlternate;
begin
  if CanFireAlternate then
  begin
    Dec(FAmmoCapacity, AlternateConsumption);
    FCoolDown := AlternateCoolDown;
    SpawnAmmo(False);
  end
  else if AmmoCapacity < AlternateConsumption then
  begin
    if FCoolDown < 0 then
    begin
      Airplane.ABEngine.PlaySound(Airplane.Name, 'Gun_Dry');
      FCoolDown := 0.5;
    end;
  end;
end;

// ------------------
// ------------------ TABEqptGun ------------------
// ------------------

// Progress
//
procedure TABEqptGun.Progress(const deltaTime: Double);
var
  i: Integer;
begin
  inherited;
  if FSalvoRemaining > 0 then
  begin
    FNextBulletTime := FNextBulletTime - deltaTime;
    if FNextBulletTime < 0 then
    begin
      SpawnAmmo(False);
      FNextBulletTime := FNextBulletTime + FSalvoInterval;
      Dec(FSalvoRemaining);
    end;
  end;
  if Assigned(FBullets) then
  begin
    if FNbActive = 0 then
    begin
      FBullets.Count := 0;
      FPoints.Positions.Count := 0;
      FPoints.Colors.Count := 0;
      FPoints.Visible := False;
    end
    else
    begin
      FPoints.Visible := True;
      for i := 0 to FBullets.Count - 1 do
      begin
        if Assigned(FBullets[i]) then
          FPoints.Positions[i] :=
            AffineVectorMake(TMobile(FBullets[i]).Position);
      end;
    end;
  end;
end;

// SaveToStrings
//
procedure TABEqptGun.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['TimeToLive'] := FloatToStr(TimeToLive);
  data.Values['TargetingAssist'] := IntToStr(TargetingAssist);
  data.Values['PrimaryDamage'] := IntToStr(PrimaryDamage);
  data.Values['PrimarySalvoCount'] := IntToStr(PrimarySalvoCount);
  data.Values['PrimarySalvoInterval'] := FloatToStr(PrimarySalvoInterval);
  data.Values['AlternateDamage'] := IntToStr(AlternateDamage);
  data.Values['AlternateSalvoCount'] := IntToStr(AlternateSalvoCount);
  data.Values['AlternateSalvoInterval'] := FloatToStr(AlternateSalvoInterval);
end;

// LoadFromStrings
//
procedure TABEqptGun.LoadFromStrings(data: TStrings);
begin
  inherited;
  TimeToLive := StrToFloatDef(data.Values['TimeToLive'], 5);
  TargetingAssist := StrToIntDef(data.Values['TargetingAssist'], -1);
  PrimaryDamage := StrToIntDef(data.Values['PrimaryDamage'], 5);
  PrimarySalvoCount := StrToIntDef(data.Values['PrimarySalvoCount'], 1);
  PrimarySalvoInterval :=
    StrToFloatDef(data.Values['PrimarySalvoInterval'], 0.1);
  AlternateDamage := StrToIntDef(data.Values['AlternateDamage'], PrimaryDamage);
  AlternateSalvoCount := StrToIntDef(data.Values['AlternateSalvoCount'],
    PrimarySalvoCount);
  AlternateSalvoInterval := StrToFloatDef(data.Values['AlternateSalvoInterval'],
    PrimarySalvoInterval);
end;

// HUDRender
//
procedure TABEqptGun.HUDRender(var rci: TGLRenderContextInfo);
var
  range, f, f2: Single;
  p, pScreen: TGLVector;
  buffer: TGLSceneBuffer;
  Canvas: TGLCanvas;
begin
  if not Selected then
    Exit;
  if TargetingAssist < 0 then
    Exit;
  buffer := TGLSceneBuffer(rci.buffer);

  range := BestAimEstimate(p, 2);
  if (range = 0) or ((range > 0) and (not Airplane.IsAhead(p))) then
  begin
    pScreen.X := buffer.Width * 0.5;
    pScreen.Y := buffer.Height * 0.5;
  end
  else
  begin
    pScreen := buffer.WorldToScreen(p);
    pScreen.Y := buffer.Height - pScreen.Y;
  end;

  Canvas := TGLCanvas.Create(buffer.Width, buffer.Height);
  with Canvas do
  begin
    f := 15;
    f2 := 7.5;
    PenAlpha := 1;
    if Assigned(Airplane.CurrentTarget) then
    begin
      PenWidth := 3;
      if Airplane.CurrentTarget.Team = Airplane.Team then
        PenColor := clLime
      else
        PenColor := clRed;
    end
    else
    begin
      PenWidth := 1;
      PenColor := clWhite;
    end;
    if (range > 0) and (range < 1) then
    begin
      MoveTo(pScreen.X, pScreen.Y);
      MoveToRel(-f, -f);
      LineToRel(f2, f2);
      MoveToRel(f, f);
      LineToRel(f2, f2);
      MoveToRel(-2 * f, 0);
      LineToRel(f2, -f2);
      MoveToRel(f, -f);
      LineToRel(f2, -f2);
    end
    else
    begin
      MoveTo(pScreen.X, pScreen.Y);
      MoveToRel(-f, -f);
      LineToRel(2 * f, 2 * f);
      MoveToRel(-2 * f, 0);
      LineToRel(2 * f, -2 * f);
    end;
  end;
  Canvas.Free;
end;

// BestAimEstimate
//
function TABEqptGun.BestAimEstimate(var p: TGLVector; quality: Integer): Single;
var
  target: TMobile;
  t: Single;
begin
  target := Airplane.CurrentTarget;
  if target <> nil then
  begin
    // estimate target position
    t := BestCaseInterceptTime(quality, Airplane.Position,
      Airplane.Speed + VectorLength(InitialVelocity), target.Position,
      target.Velocity);
    p := VectorCombine(target.Position, target.Velocity, 1, t);
    // compensate gravity
    p.Z := p.Z + (0.5 * 10) * Sqr(t);
    Result := t / TimeToLive;
  end
  else
  begin
    { p:=VectorCombine3(Airplane.Position, Airplane.Velocity, Airplane.Direction,
      1, TimeToLive, TimeToLive*InitialVelocity[2]);
      p[2]:=p[2]-(0.5*10)*Sqr(TimeToLive); }
    p := VectorCombine(Airplane.Position, Airplane.Direction, 1,
      TimeToLive * InitialVelocity.Z);
    Result := 0;
  end;
end;

// FirePrimary
//
procedure TABEqptGun.FirePrimary;
begin
  if CanFirePrimary then
  begin
    Airplane.ABEngine.PlaySound(Airplane.Name, 'MGun_Short');
    FSalvoRemaining := PrimarySalvoCount - 1;
    FSalvoInterval := PrimarySalvoInterval;
    FNextBulletTime := PrimarySalvoInterval;
    Airplane.ABEngine.TeamFireRecord(Airplane.Team, PrimaryConsumption,
      frtGunRound);
  end;
  inherited;
end;

// FireAlternate
//
procedure TABEqptGun.FireAlternate;
begin
  if CanFireAlternate then
  begin
    Airplane.ABEngine.PlaySound(Airplane.Name, 'MGun_Long');
    FSalvoRemaining := AlternateSalvoCount - 1;
    FSalvoInterval := AlternateSalvoInterval;
    FNextBulletTime := AlternateSalvoInterval;
    Airplane.ABEngine.TeamFireRecord(Airplane.Team, AlternateConsumption,
      frtGunRound);
  end;
  inherited;
end;

// SetupSyncObject
//
procedure TABEqptGun.SetupSyncObject;
begin
  inherited;
  FPoints := TGLPoints.CreateAsChild(Airplane.ABEngine.SceneRoot);
  FPoints.Style := psSmooth;
  with FPoints.PointParameters do
  begin
    Enabled := True;
    MinSize := 1;
    MaxSize := 4;
    DistanceAttenuation.SetVector(0, 0.001, 0);
  end;
  FPoints.Positions.Clear;
  FPoints.Colors.Clear;
  FBullets := TGLPersistentObjectList.Create;
end;

// TearDownSyncObject
//
procedure TABEqptGun.TearDownSyncObject;
var
  i: Integer;
begin
  inherited;
  FPoints.Free;
  FPoints := nil;
  for i := 0 to FBullets.Count - 1 do
    if FBullets[i] <> nil then
      TABMobileAmmo(FBullets[i]).FGun := nil;
  FBullets.Free;
  FBullets := nil;
end;

// SpawnAmmo
//
function TABEqptGun.SpawnAmmo(primary: Boolean): TMobile;
var
  bullet: TABMobileAmmo;
  ctrl: TControlerGravity;
begin
  bullet := TABMobileAmmo.Create(Airplane.GameEngine);
  bullet.Team := Airplane.Team;
  bullet.Position := Airplane.SyncObject.LocalToAbsolute(Position);
  bullet.Direction := Airplane.Direction;
  bullet.Up := Airplane.Up;
  bullet.Velocity := VectorAdd(Airplane.Velocity,
    Airplane.SyncObject.LocalToAbsolute(InitialVelocity));
  with TCollisionVolume.Create(bullet) do
  begin
    CollType := mctAmmo;
    Size := AffineVectorMake(3, 3, 3);
  end;
  bullet.FBulletID := FBullets.Add(bullet);
  bullet.FGun := Self;
  bullet.FTimeToLive := TimeToLive;
  if primary then
    bullet.FDamage := FPrimaryDamage
  else
    bullet.FDamage := FAlternateDamage;

  FPoints.Positions.Add(bullet.Position);
  FPoints.Colors.Add(clrYellow);
  Inc(FNbActive);

  ctrl := TControlerGravity.Create;
  ctrl.mobile := bullet;

  Result := bullet;
end;

// ------------------
// ------------------ TABEqptMissile ------------------
// ------------------

// SaveToStrings
//
procedure TABEqptMissile.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['Controler'] := AmmoControler.ClassName;
  data.Values['ControlerParams'] := AmmoControlerParams;
end;

// LoadFromStrings
//
procedure TABEqptMissile.LoadFromStrings(data: TStrings);
begin
  inherited;
  FAmmoControler := ControlerClass(data.Values['Controler']);
  Assert(FAmmoControler <> nil, 'Unknown Controler ' + data.Values
    ['AmmoControler']);
  FAmmoControlerParams := data.Values['ControlerParams'];
end;

// Deplete
//
procedure TABEqptMissile.Deplete;
begin
  TearDownSyncObject;
  inherited;
end;

// SpawnAmmo
//
function TABEqptMissile.SpawnAmmo(primary: Boolean): TMobile;
var
  missile: TABAirplane;
  ctrl: TControler;
begin
  Assert(Model <> nil);

  Airplane.ABEngine.TeamFireRecord(Airplane.Team, 1, frtMissile);

  Airplane.ABEngine.PlaySound(Airplane.Name, 'Blast_Small');

  missile := TABMissile.Create(Airplane.GameEngine);
  missile.LoadFromFile(AmmoType);
  missile.Team := Airplane.Team;
  missile.Position := Model.AbsolutePosition;
  missile.Direction := Airplane.Direction;
  missile.Up := Airplane.Up;
  missile.Velocity := VectorAdd(Airplane.Velocity,
    Airplane.SyncObject.LocalToAbsolute(InitialVelocity));
  missile.Throttle := 2.0;
  missile.SyncObject := TGLDummyCube.CreateAsChild(Airplane.ABEngine.SceneRoot);
  missile.SmokeBurst;

  ctrl := AmmoControler.Create;
  ctrl.mobile := missile;
  ctrl.LoadFromString(AmmoControlerParams);

  TearDownSyncObject;

  Result := missile;
end;

// ------------------
// ------------------ TABEqptGuidedMissile ------------------
// ------------------

// SaveToStrings
//
procedure TABEqptGuidedMissile.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['LockDelay'] := FloatToStr(LockDelay);
  data.Values['LockAngle'] := FloatToStr(LockAngle);
end;

// LoadFromStrings
//
procedure TABEqptGuidedMissile.LoadFromStrings(data: TStrings);
begin
  inherited;
  LockDelay := StrToFloatDef(data.Values['LockDelay'], 3);
  LockAngle := StrToFloatDef(data.Values['LockAngle'], 0.25);
  FLockDelayRemaining := LockDelay;
end;

// SetupSyncObject
//
procedure TABEqptGuidedMissile.SetupSyncObject;
begin
  inherited;
  if (Model <> nil) and (Airplane.Name = 'Player') then
  begin
    FSEBuzz := TGLBSoundEmitter.Create(Airplane.SyncObject.Behaviours);
    with FSEBuzz do
    begin
      Source.SoundLibrary := Airplane.ABEngine.SoundLibrary;
      Source.SoundName := 'Buzz_Loop';
      Source.NbLoops := 999999;
      Source.Volume := 0.4;
      Source.Frequency := 2000;
    end;
  end;
end;

// TearDownSyncObject
//
procedure TABEqptGuidedMissile.TearDownSyncObject;
begin
  inherited;
  FSEBuzz.Free;
  FSEBuzz := nil;
end;

// CanFirePrimary
//
function TABEqptGuidedMissile.CanFirePrimary: Boolean;
begin
  Result := TargetLocked and (inherited CanFirePrimary);
end;

// CanFireAlternate
//
function TABEqptGuidedMissile.CanFireAlternate: Boolean;
begin
  Result := TargetLocked and (inherited CanFireAlternate);
end;

// Progress
//
procedure TABEqptGuidedMissile.Progress(const deltaTime: Double);
var
  vectorToTarget: TGLVector;
  targetAngle: Single;
  wasLocked: Boolean;
begin
  inherited;
  if (not Selected) or (AmmoCapacity < PrimaryConsumption) then
  begin
    FLockingTarget := False;
  end
  else
  begin
    if Airplane.CurrentTarget = nil then
      FLockingTarget := False
    else
    begin
      vectorToTarget := VectorNormalize
        (VectorSubtract(Airplane.CurrentTarget.Position, Airplane.Position));
      FLockingTarget := (VectorLength(vectorToTarget) < MaxRange * 1.5);
      if FLockingTarget then
      begin
        targetAngle := ArcCos(VectorDotProduct(vectorToTarget,
          Airplane.Direction));
        FLockingTarget := (Abs(targetAngle) < LockAngle);
      end;
    end;
  end;
  if FLockingTarget then
  begin
    if Airplane.CurrentTarget <> FLockingTargetMobile then
    begin
      FLockDelayRemaining := LockDelay;
      FLockingTargetMobile := Airplane.CurrentTarget;
    end;
    FLockDelayRemaining := FLockDelayRemaining - deltaTime;
    wasLocked := FTargetLocked;
    FTargetLocked := (FLockDelayRemaining <= 0);
    if FSEBuzz <> nil then
    begin
      FSEBuzz.Playing := not TargetLocked;
      if TargetLocked and (not wasLocked) then
        Airplane.ABEngine.PlaySound(Airplane.Name, 'Missile_Lock');
    end;
  end
  else
  begin
    if FSEBuzz <> nil then
      FSEBuzz.Playing := False;
    FTargetLocked := False;
    FLockDelayRemaining := LockDelay;
  end;
end;

// HUDRender
//
procedure TABEqptGuidedMissile.HUDRender(var rci: TGLRenderContextInfo);
var
  Canvas: TGLCanvas;
  p: TGLVector;
  r, c, s: Single;
begin
  if Selected then
  begin
    Canvas := CreateBufferGLCanvas(rci);

    SinCos(LockAngle, s, c);
    p := VectorCombine3(Airplane.Position, Airplane.Direction,
      Airplane.Up, 1, c, s);
    p := TGLSceneBuffer(rci.buffer).WorldToScreen(p);
    r := VectorLength(p.X - (Canvas.CanvasSizeX div 2),
      p.Y - (Canvas.CanvasSizeY div 2));
    Canvas.PenColor := clWhite;
    if LockingTarget then
    begin
      if TargetLocked then
        Canvas.PenColor := clRed;
      Canvas.PenWidth := 2;
      p := TGLSceneBuffer(rci.buffer)
        .WorldToScreen(Airplane.CurrentTarget.Position);
      Canvas.MoveTo(p.X, Canvas.CanvasSizeY - p.Y);
      RenderLosange(Canvas, Round(r * 0.1 + 5));
    end;
    Canvas.Ellipse(Canvas.CanvasSizeX div 2, Canvas.CanvasSizeY div 2, r, r);

    Canvas.Free;
  end;
end;

// SpawnAmmo
//
function TABEqptGuidedMissile.SpawnAmmo(primary: Boolean): TMobile;
begin
  Result := inherited SpawnAmmo(primary);

  Assert(Result.Controler is TABControlerMissileTracker);
  (Result as TABMissile).CurrentTarget := Airplane.CurrentTarget;
  TABControlerMissileTracker(Result.Controler).TargetMobile :=
    Airplane.CurrentTarget;
  if Airplane.CurrentTarget <> nil then
    Airplane.CurrentTarget.Notification(Result, goTargeted);
end;

// ------------------
// ------------------ TABEqptDecoyLauncher ------------------
// ------------------

// SaveToStrings
//
procedure TABEqptDecoyLauncher.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['MaxCapacity'] := IntToStr(MaxCapacity);
  data.Values['Efficiency'] := FloatToStr(Efficiency);
  data.Values['CoolDown'] := FloatToStr(CoolDown);
  data.Values['DecoyLifeTime'] := FloatToStr(DecoyLifeTime);
end;

// LoadFromStrings
//
procedure TABEqptDecoyLauncher.LoadFromStrings(data: TStrings);
begin
  inherited;
  MaxCapacity := StrToIntDef(data.Values['MaxCapacity'], 1);
  Capacity := MaxCapacity;
  Efficiency := StrToFloatDef(data.Values['Efficiency'], 0.1);
  CoolDown := StrToFloatDef(data.Values['CoolDown'], 0.5);
  FCoolDownRemaining := 0;
  DecoyLifeTime := StrToFloatDef(data.Values['DecoyLifeTime'], 7);
end;

// Progress
//
procedure TABEqptDecoyLauncher.Progress(const deltaTime: Double);
begin
  inherited;
  FCoolDownRemaining := FCoolDownRemaining - deltaTime;
end;

// Replenish
//
procedure TABEqptDecoyLauncher.Replenish;
begin
  Capacity := MaxCapacity;
  inherited;
end;

// Use
//
procedure TABEqptDecoyLauncher.Use;
begin
  if FCoolDownRemaining <= 0 then
  begin
    if Capacity > 0 then
    begin
      Dec(FCapacity);
      FCoolDownRemaining := FCoolDown;
      SpawnDecoy;
    end
    else if Airplane.Name = 'Player' then
      Airplane.ABEngine.PlaySound(Airplane.Name, 'Gun_Dry');
  end;
end;

// SpawnDecoy
//
function TABEqptDecoyLauncher.SpawnDecoy: TMobile;
var
  i: Integer;
  decoy: TABDecoy;
  missile: TABMissile;
  ctrl: TControler;
  missileList: TGLPersistentObjectList;
  proba: Single;
begin
  Airplane.ABEngine.PlaySound(Airplane.Name, 'Decoy_Drop');
  Airplane.ABEngine.TeamFireRecord(Airplane.Team, 1, frtDecoy);

  decoy := TABDecoy.Create(Airplane.GameEngine);
  decoy.Team := Airplane.Team;
  decoy.Direction := Airplane.Direction;
  decoy.Up := Airplane.Up;
  decoy.Velocity := VectorCombine3(Airplane.Velocity, Airplane.Up,
    Airplane.RightVector, 0.9, -5 * Random, (Random - 0.5) * 40);
  decoy.Position := VectorCombine(Airplane.Position, Airplane.Direction, 1,
    -Airplane.Collision.Radius);
  decoy.FFirePoint := Airplane.ABEngine.CreateFirePoint
    (Airplane.ABEngine.SceneRoot, False);
  decoy.FTimeToLive := DecoyLifeTime;

  ctrl := TControlerGravity.Create;
  ctrl.mobile := decoy;

  Result := decoy;

  // decoy missiles
  missileList := TGLPersistentObjectList.Create;
  Airplane.GameEngine.EnumerateMobiles(TABMissile, missileList);
  for i := 0 to missileList.Count - 1 do
  begin
    missile := TABMissile(missileList[i]);
    if missile.CurrentTarget = Airplane then
    begin
      proba := Efficiency * missile.DecoyResistance;
      if Random <= proba then
        missile.CurrentTarget := decoy;
    end;
  end;
  missileList.Free;
end;

// ------------------
// ------------------ TABEqptDamageControl ------------------
// ------------------

// SaveToStrings
//
procedure TABEqptDamageControl.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['MaxCapacity'] := IntToStr(MaxCapacity);
  data.Values['Efficiency'] := FloatToStr(Efficiency);
  data.Values['CoolDown'] := FloatToStr(CoolDown);
end;

// LoadFromStrings
//
procedure TABEqptDamageControl.LoadFromStrings(data: TStrings);
begin
  inherited;
  MaxCapacity := StrToIntDef(data.Values['MaxCapacity'], 1);
  Capacity := MaxCapacity;
  Efficiency := StrToFloatDef(data.Values['Efficiency'], 0.1);
  CoolDown := StrToFloatDef(data.Values['CoolDown'], 0.5);
  FCoolDownRemaining := 0;
end;

// Progress
//
procedure TABEqptDamageControl.Progress(const deltaTime: Double);
begin
  inherited;
  FCoolDownRemaining := FCoolDownRemaining - deltaTime;
end;

// Replenish
//
procedure TABEqptDamageControl.Replenish;
begin
  Capacity := MaxCapacity;
  inherited;
end;

// Use
//
procedure TABEqptDamageControl.Use;
begin
  if (FCoolDownRemaining <= 0) then
  begin
    if Capacity > 0 then
    begin
      Dec(FCapacity);
      Airplane.FireDamage :=
        ClampValue(Airplane.FireDamage - Efficiency, 0, 1E30);
      Airplane.ABEngine.PlaySound(Airplane.Name, 'Extinguisher');
      FCoolDownRemaining := FCoolDown;
    end
    else if Airplane.Name = 'Player' then
      Airplane.ABEngine.PlaySound(Airplane.Name, 'Gun_Dry');
  end;
end;

// ------------------
// ------------------ TABMobileAmmo ------------------
// ------------------

// Destroy
//
destructor TABMobileAmmo.Destroy;
begin
  inherited;
  if Assigned(FGun) then
  begin
    FGun.FBullets[FBulletID] := nil;
    FGun.FPoints.Colors[FBulletID] := clrTransparent;
    Dec(FGun.FNbActive);
  end;
end;

// Progress
//
procedure TABMobileAmmo.Progress(const deltaTime: Double);
begin
  inherited;
  FTimeToLive := FTimeToLive - deltaTime;
  if FTimeToLive < 0 then
    Free;
end;

// Notification
//
procedure TABMobileAmmo.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  inherited;
  if (operation = goCollide) then
  begin
    if Assigned(aMobile) then
    begin
      if (aMobile.Team <> Team) and (aMobile is TABAirplane) then
      begin
        TABAirplane(aMobile).TakeDamage(FDamage, Position, Team);
        (GameEngine as TAirBlastEngine).MakeSmoke(Position);
        Detonate := True;
      end;
    end
    else
    begin
      (GameEngine as TAirBlastEngine).MakeDust(Position);
      Detonate := True;
    end;
  end;
end;

// DoDetonate
//
procedure TABMobileAmmo.DoDetonate;
begin
  // (GameEngine as TAirBlastEngine).MakeBoom(Position, 15);
  inherited;
end;

// FiredBy
//
function TABMobileAmmo.FiredBy(aMobile: TMobile): Boolean;
begin
  Result := (FGun <> nil) and (FGun.Airplane = aMobile);
end;

// ------------------
// ------------------ TABDecoy ------------------
// ------------------

// Destroy
//
destructor TABDecoy.Destroy;
begin
  inherited;
  FFirePoint.Free;
end;

// Progress
//
procedure TABDecoy.Progress(const deltaTime: Double);
begin
  inherited;
  if FFirePoint <> nil then
    FFirePoint.Position.SetPoint(Position);
  FTimeToLive := FTimeToLive - deltaTime;
  if FTimeToLive <= 0 then
    Detonate := True;
end;

// Notification
//
procedure TABDecoy.Notification(aMobile: TMobile; operation: TGameOperation);
begin
  inherited;
  if (operation = goCollide) then
    Detonate := True;
end;

// ------------------
// ------------------ TABMissile ------------------
// ------------------

// DoDetonate
//
procedure TABMissile.DoDetonate;
begin
  with (GameEngine as TAirBlastEngine) do
  begin
    AirBurstDamage(Position, DamageRadius, DamageMax, DamageMin, Team);
    MakeBoom(Position, 15, 0);
  end;
  inherited;
end;

// SaveToStrings
//
procedure TABMissile.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['DecoyResistance'] := FloatToStr(DecoyResistance);
  data.Values['DamageRadius'] := FloatToStr(DamageRadius);
  data.Values['DamageMin'] := FloatToStr(DamageMin);
  data.Values['DamageMax'] := FloatToStr(DamageMax);
end;

// LoadFromStrings
//
procedure TABMissile.LoadFromStrings(data: TStrings);
begin
  inherited;
  DecoyResistance := StrToFloatDef(data.Values['DecoyResistance'], 1);
  DamageRadius := StrToFloat(data.Values['DamageRadius']);
  DamageMin := StrToFloat(data.Values['DamageMin']);
  DamageMax := StrToFloat(data.Values['DamageMax']);
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

RegisterEquipmentClass(TABEqptInstruments);
RegisterEquipmentClass(TABEqptGun);
RegisterEquipmentClass(TABEqptMissile);
RegisterEquipmentClass(TABEqptGuidedMissile);
RegisterEquipmentClass(TABEqptDecoyLauncher);
RegisterEquipmentClass(TABEqptDamageControl);

end.
