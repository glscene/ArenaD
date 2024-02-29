unit UAirBlastEngine;

(* Main AirBlast game engine classes *)

interface

uses
  System.Classes,
  VCL.Graphics,
  FMOD.Import,
  FMOD.Types,
  Winapi.OpenGL,
  Winapi.Windows,
  UGameEngine,
  UAirplane,
  UABVoice,
  GLS.Scene,
  GLS.VectorFileObjects,
  GLS.VectorGeometry,
  GLS.PersistentClasses,
  GLS.ParticleFX,
  GLS.PerlinPFX,
  GLS.Cadencer,
  GLS.Texture,
  GLS.Canvas,
  GLS.TerrainRenderer,
  GLS.SoundManager,
  GLS.Objects,
  GLS.Screen,
  GLS.Context,
  GLS.Graphics,
  GLS.WindowsFont,
  GLS.RenderContextInfo,
  GLS.Material,
  GLS.Color,
  GLS.Coordinates,
  GLS.VectorTypes,
  System.Win.ComObj;

type

  TAirBlastEngine = class;
  TABAirplane = class;
  TABSpawnPoint = class;

  TABWingLeaderOrder = (wloFollowMe, wloEngageMyTarget, wloCoverMe);

  // TABEquipment
  //
  TABEquipment = class(TGameEngine3DObject)
  private
    { Private Properties }
    FAirplane: TABAirplane;
    FModel: TGLBaseSceneObject;
    FModelName: String;
    FGroupName: String;

  protected
    { Protected Properties }
    function CreateBufferGLCanvas(var rci: TGLRenderContextInfo): TGLCanvas;

    procedure SetupSyncObject; virtual;
    procedure TearDownSyncObject; virtual;

  public
    { Public Properties }
    procedure FirePrimary; virtual;
    procedure FireAlternate; virtual;

    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); virtual;
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    procedure PerformPreRenders; virtual;
    procedure HUDRender(var rci: TGLRenderContextInfo); virtual;
    procedure Replenish; virtual;
    procedure Deplete; virtual;

    property Airplane: TABAirplane read FAirplane write FAirplane;
    property ModelName: String read FModelName write FModelName;
    property Model: TGLBaseSceneObject read FModel;
    property GroupName: String read FGroupName write FGroupName;
    function Selected: Boolean;
  end;

  TABEquipmentClass = class of TABEquipment;
  TABEquipments = array of TABEquipment;

  // TABAirplane
  //
  TABAirplane = class(TAirplane)
  private
    { Private Properties }
    FABEngine: TAirBlastEngine;
    FSyncObject: TGLBaseSceneObject;
    FPFXSources: TGLPersistentObjectList;
    FPFXSmoke: TGLBaseSpritePFXManager;
    FDenseSmoke: Boolean;
    FPFXThrust: TGLPolygonPFXManager;
    FSEEngine: TGLBSoundEmitter;
    FSEFire: TGLBSoundEmitter;
    FSEAirBrake: TGLBSoundEmitter;

    FBaseHullResistance: Integer;
    FHullResistance: Single;
    FDamagePoint: TGLBaseSceneObject;
    FFireDamage: Single;

    FModel: TGLBaseSceneObject;
    FModelName: String;
    FEquipments: TABEquipments;

    FWeaponGroups: TStringList;
    FCurrentWeaponGroup: String;

    FLeaderName: String;
    FCurrentTarget: TMobile;

    FKillScore: Integer;
    FLastDamageFromTeam: Integer;
    FAirBrakeUsed: Boolean;
    FDestroyActions: TStrings;

  protected
    { Protected Properties }
    procedure SetModelVisible(val: Boolean);
    procedure SetSyncObject(obj: TGLBaseSceneObject);

    procedure PrepareWeaponGroups;

    procedure SetupSyncObject;
    procedure TearDownSyncObject;

  public
    { Public Properties }
    constructor Create(aGameEngine: TGameEngine = nil); override;
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure DoDetonate; override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); override;

    procedure Fire(primary: Boolean); virtual;
    procedure CycleTargets(next: Boolean); virtual;
    procedure TargetNearestEnemy; virtual;
    procedure TargetAimed; virtual;
    procedure CycleWeapons(next: Boolean); virtual;

    procedure DropDecoy; virtual;
    procedure FireControl; virtual;
    procedure AirBrake; virtual;
    procedure WingLeaderOrder(order: TABWingLeaderOrder); virtual;

    procedure TakeDamage(amount: Single; const absolutePosition: TGLVector;
      fromTeam: Integer);

    procedure SmokeBurst;
    procedure MakeBoom(coreParticles, nbDebris: Integer);

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    procedure PerformPreRenders;
    procedure SyncFromObject(obj: TGLBaseSceneObject; aVelocity: Single);
    procedure SyncToObject(obj: TGLBaseSceneObject);

    property LeaderName: String read FLeaderName write FLeaderName;
    property CurrentTarget: TMobile read FCurrentTarget write FCurrentTarget;

    property Equipments: TABEquipments read FEquipments write FEquipments;
    function AddEquipment(const typeName: String): TABEquipment;
    function EquipmentCount: Integer;
    procedure ClearEquipements;
    procedure EquipementsHUDRender(var rci: TGLRenderContextInfo);
    procedure ReplenishEquipments;
    procedure DepleteEquipments;
    procedure Repair;

    property CurrentWeaponGroup: String read FCurrentWeaponGroup
      write FCurrentWeaponGroup;
    property WeaponGroups: TStringList read FWeaponGroups;
    function WeaponGroupAmmo(const name: String): Integer;

    procedure RenderWeaponsLoadout(var rci: TGLRenderContextInfo;
      Canvas: TGLCanvas; posX, posY, scale: Single);
    // : Canvas is expected standardized to 1024x768
    procedure RenderMessageLog(var rci: TGLRenderContextInfo;
      Canvas: TGLCanvas); virtual;

    property ModelName: String read FModelName write FModelName;
    property SyncObject: TGLBaseSceneObject read FSyncObject
      write SetSyncObject;
    property Model: TGLBaseSceneObject read FModel;
    property ABEngine: TAirBlastEngine read FABEngine;
    property DenseSmoke: Boolean read FDenseSmoke write FDenseSmoke;

    property KillScore: Integer read FKillScore write FKillScore;
    property LastDamageFromTeam: Integer read FLastDamageFromTeam
      write FLastDamageFromTeam;
    property DestroyActions: TStrings read FDestroyActions;

    property BaseHullResistance: Integer read FBaseHullResistance
      write FBaseHullResistance;
    property HullResistance: Single read FHullResistance write FHullResistance;
    property FireDamage: Single read FFireDamage write FFireDamage;
  end;

  // TABSpawnEntity
  //
  TABSpawnEntity = class(TGameEngineObject)
  private
    { Private Properties }
    FSpawnPoint: TABSpawnPoint;
    FEntityType: String;
    FEntityData: String;
    FCounter: Integer;
    FAmount, FAmountRemaining: Integer;
    FMaxSimultaneous: Integer;
    FSpawnDelay: Single;
    FDelayToNextSpawn: Single;
    FSpawnedMobiles: TGLPersistentObjectList;

  protected
    { Protected Properties }

  public
    { Public Properties }
    constructor Create(aSpawnPoint: TABSpawnPoint);
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile; operation: TGameOperation);
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    procedure SpawnEntity;

    property SpawnPoint: TABSpawnPoint read FSpawnPoint;
    property EntityType: String read FEntityType write FEntityType;
    property EntityData: String read FEntityData write FEntityData;
    property amount: Integer read FAmount write FAmount;
    property AmountRemaining: Integer read FAmountRemaining
      write FAmountRemaining;
    property MaxSimultaneous: Integer read FMaxSimultaneous
      write FMaxSimultaneous;
    property SpawnDelay: Single read FSpawnDelay write FSpawnDelay;
    property DelayToNextSpawn: Single read FDelayToNextSpawn
      write FDelayToNextSpawn;
    property SpawnedMobiles: TGLPersistentObjectList read FSpawnedMobiles;
    // : total number of entities spawned since start
    property Counter: Integer read FCounter;
  end;

  TABSpawnEntities = array of TABSpawnEntity;

  // TABSpawnPoint
  //
  TABSpawnPoint = class(TGameEngine3DObject)
  private
    { Private Properties }
    FGameEngine: TAirBlastEngine;
    FSpawnEntities: TABSpawnEntities;

  protected
    { Protected Properties }

  public
    { Public Properties }
    constructor Create(aGameEngine: TAirBlastEngine);
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure Notification(aMobile: TMobile;
      operation: TGameOperation); virtual;
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property GameEngine: TAirBlastEngine read FGameEngine;
    property SpawnEntities: TABSpawnEntities read FSpawnEntities;
    function AddSpawnEntity: TABSpawnEntity;
    function SpawnEntitiesCount: Integer;

    procedure Replenish;
    function Exhausted: Boolean;
  end;

  TABSpawnPoints = array of TABSpawnPoint;

  // TViewerCamMode
  //
  TViewerCamMode = (vcmCockpit, vcmChase, vcmTarget, vcmFreeTarget, vcmVanity,
    vcmDeathCam);

  // TABViewerCam
  //
  { : Manages a viewer and its camera. }
  TABViewerCam = class(TGameEngineObject)
  private
    { Private Properties }
    FGameEngine: TAirBlastEngine;
    FDCTracker: TGLDummyCube;
    FCamera: TGLCamera;
    FViewerBuffer: TGLSceneBuffer;
    FMobileName: String;
    FCamMode: TViewerCamMode;
    FChaseOffset, FFreePosition, FFreeDirection, FVanityOffset,
      FVanity: TAffineVector;
    FFreeDirectionTracker: TAffineVector;
    FTension: Single;
    FPOV, FPOVTracker: Single;
    FPOVActive: Boolean;

  protected
    { Protected Properties }
    procedure SetupSyncObject;
    procedure TearDownSyncObject;
    procedure SetViewerBuffer(newBuf: TGLSceneBuffer);

    procedure ViewerBeforeRender(Sender: TObject);
    procedure ViewerWrapUpRender(Sender: TObject;
      var rci: TGLRenderContextInfo);
    procedure ViewerAfterRender(Sender: TObject);

  public
    { Public Properties }
    constructor Create;
    destructor Destroy; override;

    procedure Progress(const deltaTime: Double); override;
    procedure CycleCamera;

    procedure HUDRender(var rci: TGLRenderContextInfo); virtual;

    property GameEngine: TAirBlastEngine read FGameEngine;
    property ViewerBuffer: TGLSceneBuffer read FViewerBuffer
      write SetViewerBuffer;
    property Camera: TGLCamera read FCamera;

    procedure SetCamMode(const modeName: String);

    // : Reference mobile this ViewerCam is attached to
    property MobileName: String read FMobileName write FMobileName;
    property CamMode: TViewerCamMode read FCamMode write FCamMode;

    property ChaseOffset: TAffineVector read FChaseOffset write FChaseOffset;
    property FreePosition: TAffineVector read FFreePosition write FFreePosition;
    property FreeDirection: TAffineVector read FFreeDirection
      write FFreeDirection;
    property VanityOffset: TAffineVector read FVanityOffset write FVanityOffset;
    property Tension: Single read FTension write FTension;
    // joystick POV normalized in Degrees [0; 360[, only meaningful if POVActive is true
    property POV: Single read FPOV write FPOV;
    // True if joystick POV is used
    property POVActive: Boolean read FPOVActive write FPOVActive;
  end;

  TViewerCamsArray = array of TABViewerCam;

  // TABFireRecordType
  //
  TABFireRecordType = (frtGunRound, frtMissile, frtDecoy);
  TABFireRecord = array [TABFireRecordType] of Integer;

  // TABTeam
  //
  TABTeam = record
    name: String;
    Score: Integer;
    FireRecord: TABFireRecord;
  end;

  TABTeams = array of TABTeam;

  TABSpawnAirplaneEvent = procedure(engine: TAirBlastEngine;
    Airplane: TABAirplane) of object;

  TABGameResult = (grUndetermined, grVictory, grDefeat, grTie);

  // TAirBlastEngine
  //
  TAirBlastEngine = class(TGameEngine)
  private
    { Private Properties }
    FOptions: TStrings;
    FMaterialLibrary: TGLMaterialLibrary;
    FSoundLibrary: TGLSoundLibrary;
    FPFXRenderer: TGLParticleFXRenderer;
    FPFXSmoke, FPFXFire, FPFXDust: TGLBaseSpritePFXManager;
    FTerrainRenderer: TGLTerrainRenderer;
    FCadencer: TGLCadencer;
    FSceneRoot, FSortedSceneRoot: TGLBaseSceneObject;
    FProxiesRoot: TGLBaseSceneObject;
    FSoundManager: TGLSoundManager;
    FSoundEmitters: TStringList;
    F3DSoundEmitters: TStringList;
    FSmallFont, FBigFont: TGLWindowsBitmapFont;
    FEnginesVolume: Single;
    FVoices: TStringList;
    FOptionsParticles: Single;
    FViewerCams: TViewerCamsArray;
    FTeams: TABTeams;
    FSpawnPoints: TABSpawnPoints;
    FOnSpawnAirplane: TABSpawnAirplaneEvent;
    FMusicSample: PFSoundSample;
    FMusicChannel: Integer;
    F2DSoundSample: PFSoundSample;
    F2DSoundChannel: Integer;
    FGameResult: TABGameResult;
    FUIDisabled: Boolean;
    FRatings: TStringList;

  protected
    { Protected Properties }
    function GetOrCreateSoundEmitter(const MobileName, sampleName: String)
      : TGLBSoundEmitter;
    function GetOrCreate3DSoundEmitter(const sampleName: String)
      : TGLBSoundEmitter;
    procedure SetEnginesVolume(val: Single);

    function SpawnAirplane(data: TStrings): TABAirplane;

    procedure OnDebrisProgress(Sender: TObject;
      const deltaTime, newTime: Double);

    // : Expects a string like "800x600 24bit"
    procedure VideoModeStringToValues(const videoMode: String;
      var x, y, bpp: Integer);

    procedure StartPlayingSound(var sample: PFSoundSample; var channel: Integer;
      const sampleName: String; loop: Boolean; volume: Single);
    procedure StopPlayingSound(var sample: PFSoundSample; var channel: Integer);

  public
    { Public Properties }
    constructor Create;
    destructor Destroy; override;

    procedure Startup; override;
    procedure Pause; override;
    procedure Resume; override;
    procedure Completed; override;

    procedure Progress(const deltaTime: Double); override;
    procedure NotifyAllMobiles(aMobile: TMobile;
      operation: TGameOperation); override;
    procedure CheckTerrainCollision(mobile: TMobile); override;
    procedure DoGameCountDown(secondsRemaining: Integer); override;

    function ObjectByName(const aName: String): TGameEngineObject; override;

    property ViewerCams: TViewerCamsArray read FViewerCams;
    function AddViewerCam: TABViewerCam;
    function ViewerCamsCount: Integer;
    function ViewerCamForMobile(const MobileName: String): TABViewerCam;
    procedure CycleCameraForMobile(const MobileName: String);
    procedure ClearViewerCams;

    procedure LoadFromStrings(data: TStrings); override;
    procedure AddFromStrings(data: TStrings);
    procedure Clear; override;
    procedure ApplyOptions;
    function OptionsDifficultyOffset: Integer;

    property EnginesVolume: Single read FEnginesVolume write SetEnginesVolume;
    procedure PlaySound(const MobileName, sampleName: String);
    procedure Play3DSound(const sampleName: String;
      position, velocity: TGLVector);
    procedure PlayVoice(const voiceName, text: String);
    procedure StopVoice(const voiceName: String);
    procedure StopVoices;
    procedure PauseVoices;
    procedure ResumeVoices;
    procedure PlayMusic(const musicName: String; loop: Boolean);
    procedure StopMusic;
    procedure Play2DSound(const sampleName: String);
    procedure Stop2DSound;

    function CreateFirePoint(parent: TGLBaseSceneObject = nil;
      smoking: Boolean = True; rateBoost: Single = 1): TGLBaseSceneObject;
    procedure AdjustFirePointIntensity(fp: TGLBaseSceneObject;
      intensity: Single);

    procedure AirBurstDamage(const p: TGLVector; radius: Single;
      maxDamage, minDamage: Single; fromTeam: Integer);

    procedure MakeBoom(position: TGLVector; coreParticles, nbDebris: Integer);
    procedure MakeDust(position: TGLVector);
    procedure MakeSmoke(position: TGLVector);

    procedure SetupEventsDebugStuff;
    procedure PerformPreRenders;
    function FreeFormProxy(const ModelName: String): TGLProxyObject; overload;
    function FreeFormProxy(const ModelName: String;
      proxyClass: TGLProxyObjectClass): TGLProxyObject; overload;
    function TopDownTextureMaterial(const ModelName: String;
      const texSize: Integer = 128): TGLLibMaterial;
    function SpriteTextureMaterial(const spriteName: String): TGLLibMaterial;

    property Teams: TABTeams read FTeams;
    function AddTeam(const name: String; Score: Integer = 0): Integer;
    function TeamCount: Integer;
    function TeamByName(const aName: String): TABTeam;
    procedure ClearTeams;
    function TeamScore(team: Integer; scoreDelta: Integer = 0): Integer;
    function TeamFireRecord(team: Integer; nb: Integer;
      what: TABFireRecordType): Integer;

    property Ratings: TStringList read FRatings write FRatings;
    function RatingForScore(aScore: Integer): String;

    procedure EnableUI(const enable: Boolean);
    property GameResult: TABGameResult read FGameResult;

    property SpawnPoints: TABSpawnPoints read FSpawnPoints;
    function AddSpawnPoint: TABSpawnPoint;
    function SpawnPointsCount: Integer;
    function SpawnPointByName(const aName: String): TABSpawnPoint;
    procedure ClearSpawnPoints;

    property Options: TStrings read FOptions write FOptions;
    function OptionsScreenResolution: TResolution;
    function OptionsFSAA: TGLAntiAliasing;
    property OptionsParticles: Single read FOptionsParticles;

    property MaterialLibrary: TGLMaterialLibrary read FMaterialLibrary
      write FMaterialLibrary;
    property SoundLibrary: TGLSoundLibrary read FSoundLibrary
      write FSoundLibrary;
    property TerrainRenderer: TGLTerrainRenderer read FTerrainRenderer
      write FTerrainRenderer;
    property PFXRenderer: TGLParticleFXRenderer read FPFXRenderer
      write FPFXRenderer;
    property PFXSmoke: TGLBaseSpritePFXManager read FPFXSmoke write FPFXSmoke;
    property PFXFire: TGLBaseSpritePFXManager read FPFXFire write FPFXFire;
    property PFXDust: TGLBaseSpritePFXManager read FPFXDust write FPFXDust;
    property Cadencer: TGLCadencer read FCadencer write FCadencer;
    property SceneRoot: TGLBaseSceneObject read FSceneRoot write FSceneRoot;
    property SortedSceneRoot: TGLBaseSceneObject read FSortedSceneRoot
      write FSortedSceneRoot;
    property ProxiesRoot: TGLBaseSceneObject read FProxiesRoot
      write FProxiesRoot;
    property SoundManager: TGLSoundManager read FSoundManager
      write FSoundManager;
    property SmallFont: TGLWindowsBitmapFont read FSmallFont write FSmallFont;
    property BigFont: TGLWindowsBitmapFont read FBigFont write FBigFont;

    property OnSpawnAirplane: TABSpawnAirplaneEvent read FOnSpawnAirplane
      write FOnSpawnAirplane;
  end;

const
  cViewerCamModeName: array [TViewerCamMode] of String = ('Cockpit',
    'Chase Camera', 'Target Camera', 'Free Target', 'Vanity Camera',
    'Death Camera');

  cWingLeaderOrder: array [TABWingLeaderOrder] of String = ('Follow Me',
    'Engage My Target', 'Cover Me');

procedure RegisterEquipmentClass(const aClass: TABEquipmentClass);
function EquipmentClass(const name: String): TABEquipmentClass;

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
    UAirBlastControler,
    UABControlerUI,
    UABEquipments,
    UABEvents,
    UABMobiles,
    UABActions,
    DToolBox,
    GLS.XCollection,
    GLS.ApplicationFileIO,
    GLS.Behaviours,
    GLS.BitmapFont;


var
  vRegisteredEquipments: TStringList;

  // RegisterEquipmentClass
  //
procedure RegisterEquipmentClass(const aClass: TABEquipmentClass);
begin
  if not Assigned(vRegisteredEquipments) then
    vRegisteredEquipments := TStringList.Create;
  vRegisteredEquipments.AddObject(aClass.ClassName, TObject(aClass));
end;

// EquipmentClass
//
function EquipmentClass(const name: String): TABEquipmentClass;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(vRegisteredEquipments) then
  begin
    i := vRegisteredEquipments.IndexOf(name);
    if i >= 0 then
      Result := TABEquipmentClass(vRegisteredEquipments.Objects[i]);
  end;
end;

// ------------------
// ------------------ TABAirplane ------------------
// ------------------

// Create
//
constructor TABAirplane.Create(aGameEngine: TGameEngine = nil);
begin
  inherited;
  FWeaponGroups := TStringList.Create;
  FLastDamageFromTeam := -1;
  FABEngine := (aGameEngine as TAirBlastEngine);
  FDestroyActions := TStringList.Create;
end;

// Destroy
//
destructor TABAirplane.Destroy;
var
  i: Integer;
  obj: TGLBaseSceneObject;
begin
  FDestroyActions.Free;
  obj := SyncObject;
  SyncObject := nil;
  for i := 0 to EquipmentCount - 1 do
    FEquipments[i].Free;
  SetLength(FEquipments, 0);
  FWeaponGroups.Free;
  obj.Free;
  inherited;
end;

// Progress
//
procedure TABAirplane.Progress(const deltaTime: Double);
var
  i, j: Integer;
  f, fThrottle, fOutput, pb2: Single;
  enableSources: Boolean;
  source: TGLSourcePFXEffect;
  p: TAffineVector;
begin
  inherited;
  if FFireDamage > 0 then
  begin
    FSEFire.Playing := True;
    FHullResistance := FHullResistance - FFireDamage * deltaTime;
    FFireDamage := FFireDamage + (Random - 0.5) * deltaTime * 10;
    // ABEngine.AdjustFirePointIntensity(FDamagePoint, ClampValue(Sqrt(FFireDamage)*0.3, 1, 2));
  end
  else
  begin
    FSEFire.Playing := False;
    if FDamagePoint <> nil then
    begin
      FDamagePoint.Free;
      FDamagePoint := nil;
    end;
  end;
  if FHullResistance < 0 then
    Detonate := True;

  if FAirBrakeUsed then
  begin
    FSEAirBrake.Playing := True;
    f := ClampValue(Speed * 0.008, 0.05, 1);
    FSEAirBrake.source.volume := f;
    FSEAirBrake.source.Frequency := Round(Lerp(4000, 8000, f));
    if FSEAirBrake.PlayingSource <> nil then
    begin
      FSEAirBrake.PlayingSource.volume := FSEAirBrake.source.volume;
      FSEAirBrake.PlayingSource.Frequency := FSEAirBrake.source.Frequency;
    end;
    FAirBrakeUsed := False;
  end
  else
    FSEAirBrake.Playing := False;

  for i := 0 to EquipmentCount - 1 do
    if not Equipments[i].Disabled then
      Equipments[i].Progress(deltaTime);

  if Assigned(SyncObject) then
  begin
    // update object
    SyncToObject(SyncObject);

    if Engines[0].Fuel > 0 then
      fThrottle := Engines[0].Throttle
    else
      fThrottle := 0;
    fOutput := Engines[0].Output / Engines[0].MaxOutput;

    // update sound
    if Assigned(FSEEngine) then
    begin
      f := ClampValue(0.3 + Sqr(fOutput) * 0.4, 0.4, 1);
      if FSEEngine.PlayingSource <> nil then
      begin
        FSEEngine.PlayingSource.Frequency := Round(22050 * f);
        FSEEngine.PlayingSource.volume := f;
      end;
    end;

    // update PFX
    if Assigned(FPFXSources) then
    begin
      if FDenseSmoke then
      begin
        enableSources := (fOutput > 0);
        f := 0.34;
      end
      else
      begin
        f := ClampValue(Sqrt(fThrottle) * 0.2, 0.01, 0.34);
        enableSources := (f > 0.15);
      end;
      for i := 0 to FPFXSources.Count - 1 do
      begin
        source := (FPFXSources[i] as TGLSourcePFXEffect);
        source.Enabled := enableSources;
        if enableSources then
          source.ParticleInterval := (0.01 + (0.34 - f) * 0.25) /
            ABEngine.OptionsParticles;
      end;
    end;

    if Assigned(FPFXThrust) then
    begin
      f := ClampValue(Sqrt(fOutput) * 0.2, 0.01, 0.34);
      FPFXThrust.ColorInner.SetColor(1, 1, f, ClampValue(2 * f, 0, 1));
      FPFXThrust.ColorOuter.SetColor(1, f, 0, 0);
      f := f * 5;
      FPFXThrust.ParticleSize := f;
      for j := 0 to EngineCount - 1 do
      begin
        SetVector(p, Engines[j].position);
        pb2 := p.Z;
        for i := 0 to 2 do
        begin
          p.Z := pb2 - i * f - Random * 0.5;
          FPFXThrust.Particles[i + 3 * j].position :=
            SyncObject.LocalToAbsolute(p);
        end;
      end;
    end;
  end;
end;

// DoDetonate
//
procedure TABAirplane.DoDetonate;
var
  agonizing: TABAgonizingAirplane;
  envVars: TStrings;
begin
  envVars := TStringList.Create;
  PerformABActions(ABEngine, DestroyActions, envVars);
  envVars.Free;

  if LeaderName = 'Player' then
    ABEngine.PlayVoice('GameMenu', 'Wingman destroyed');

  if LastDamageFromTeam >= 0 then
    ABEngine.TeamScore(LastDamageFromTeam, KillScore)
  else
    ABEngine.TeamScore(team, -KillScore);
  if ClassType = TABAirplane then
  begin
    MakeBoom(10, 10);
    agonizing := TABAgonizingAirplane.Create(GameEngine);
    if Name = 'Player' then
      agonizing.Initialize(Self, 3)
      // more particles, player gets a closer look at his own demise!
    else
      agonizing.Initialize(Self, 1.5);
    agonizing.name := Name + '-Agonizing';
  end;
  inherited;
end;

// Notification
//
procedure TABAirplane.Notification(aMobile: TMobile; operation: TGameOperation);
var
  i: Integer;
begin
  inherited;
  for i := 0 to EquipmentCount - 1 do
    Equipments[i].Notification(aMobile, operation);
  case operation of
    goRemove:
      begin
        if aMobile = CurrentTarget then
          CurrentTarget := nil;
      end;
    goCollide:
      if aMobile = nil then
        Detonate := True;
  end;
end;

// Fire
//
procedure TABAirplane.Fire(primary: Boolean);
var
  i: Integer;
  eqpt: TABEquipment;
  weap, matchWeap: TABEqptWeapon;
begin
  matchWeap := nil;
  for i := 0 to EquipmentCount - 1 do
  begin
    eqpt := Equipments[i];
    if eqpt is TABEqptWeapon then
    begin
      weap := TABEqptWeapon(eqpt);
      if (weap.GroupName = CurrentWeaponGroup) then
      begin
        matchWeap := weap;
        if (primary and weap.CanFirePrimary) or
          ((not primary) and weap.CanFireAlternate) then
          Break;
      end;
    end;
  end;
  if Assigned(matchWeap) then
  begin
    if primary then
      matchWeap.FirePrimary
    else
      matchWeap.FireAlternate;
  end;
end;

// CycleTargets
//
procedure TABAirplane.CycleTargets(next: Boolean);
var
  i, d, n: Integer;
  newTarget: TMobile;
begin
  n := GameEngine.MobileCount;
  if n > 1 then
  begin
    if next then
      d := n + 1
    else
      d := n - 1;
    i := GameEngine.IndexOfMobile(FCurrentTarget);
    repeat
      i := (i + d) mod n;
      newTarget := GameEngine.Mobiles[i];
      if newTarget = FCurrentTarget then
        Break;

    until (newTarget <> Self) and (newTarget.ClassType = TABAirplane);
    FCurrentTarget := newTarget;
  end;
end;

// TargetNearestEnemy
//
procedure TABAirplane.TargetNearestEnemy;
var
  i: Integer;
  dist, minDist: Single;
  current, closest: TMobile;
begin
  closest := nil;
  minDist := 1E36;
  for i := 0 to GameEngine.MobileCount - 1 do
  begin
    current := GameEngine.Mobiles[i];
    if current = Self then
      continue;
    if current.team = Self.team then
      continue;
    if current.ClassType <> TABAirplane then
      continue;
    dist := VectorDistance2(position, current.position);
    if dist < minDist then
    begin
      minDist := dist;
      closest := current;
    end;
  end;
  FCurrentTarget := closest;
end;

// TargetAimed
//
procedure TABAirplane.TargetAimed;
var
  i: Integer;
  delta: TGLVector;
  dist, bestDist: Single;
  current, closest: TMobile;
begin
  closest := nil;
  bestDist := 0.9;
  for i := 0 to GameEngine.MobileCount - 1 do
  begin
    current := GameEngine.Mobiles[i];
    if current = Self then
      continue;
    if current.ClassType <> TABAirplane then
      continue;
    delta := VectorSubtract(current.position, position);
    dist := VectorDotProduct(Direction, delta) / VectorLength(delta);
    if dist > bestDist then
    begin
      bestDist := dist;
      closest := current;
    end;
  end;
  FCurrentTarget := closest;
end;

// CycleWeapons
//
procedure TABAirplane.CycleWeapons(next: Boolean);
var
  i, d, n: Integer;
begin
  n := WeaponGroups.Count;
  if n > 1 then
  begin
    if next then
      d := n + 1
    else
      d := n - 1;
    i := (WeaponGroups.IndexOf(CurrentWeaponGroup) + d) mod n;
    CurrentWeaponGroup := WeaponGroups[i];
  end;
end;

// DropDecoy
//
procedure TABAirplane.DropDecoy;
var
  i: Integer;
begin
  for i := 0 to EquipmentCount - 1 do
  begin
    if Equipments[i] is TABEqptDecoyLauncher then
      TABEqptDecoyLauncher(Equipments[i]).Use;
  end;
end;

// FireControl
//
procedure TABAirplane.FireControl;
var
  i: Integer;
begin
  for i := 0 to EquipmentCount - 1 do
  begin
    if Equipments[i] is TABEqptDamageControl then
      TABEqptDamageControl(Equipments[i]).Use;
  end;
end;

// AirBrake
//
procedure TABAirplane.AirBrake;
var
  f: Single;
begin
  FAirBrakeUsed := True;
  f := VectorDotProduct(Direction, VectorNormalize(velocity));
  if f < 0 then
    Exit;
  f := Speed - Exp(cLn10 * Lerp(AirFrictionMin, AirFrictionMax, f * 0.5)) *
    Speed * Speed;
  velocity := VectorScale(velocity, f / Speed);
end;

// WingLeaderOrder
//
procedure TABAirplane.WingLeaderOrder(order: TABWingLeaderOrder);
var
  i: Integer;
  mobile: TMobile;
  Airplane: TABAirplane;
  controlerAI: TABControlerAI;
begin
  if Name = 'Player' then
  begin
    case order of
      wloFollowMe:
        begin
          if Random(2) = 0 then
          begin
            ABEngine.PlayVoice('Orders_Rich', 'Follow Me');
            ABEngine.AddMessage('Follow Me!', Self, nil);
          end
          else
          begin
            ABEngine.PlayVoice('Orders_Rich', 'Vic Formation');
            ABEngine.AddMessage('Vice Formation!', Self, nil);
          end;
        end;
      wloEngageMyTarget:
        begin
          if Random(2) = 0 then
          begin
            ABEngine.PlayVoice('Orders_Rich', 'Engage My Target');
            ABEngine.AddMessage('Engage My Target!', Self, nil);
          end
          else
          begin
            ABEngine.PlayVoice('Orders_Rich', 'Tally Ho');
            ABEngine.AddMessage('Tally Ho!', Self, nil);
          end;
        end;
      wloCoverMe:
        begin
          ABEngine.PlayVoice('Orders_Rich', 'Cover Me');
          ABEngine.AddMessage('Cover Me!', Self, nil);
        end;
    end;
  end;
  for i := 0 to GameEngine.MobileCount - 1 do
  begin
    mobile := GameEngine.Mobiles[i];
    if mobile is TABAirplane then
    begin
      Airplane := TABAirplane(mobile);
      if (Airplane.LeaderName = Name) and (mobile.Controler is TABControlerAI)
      then
      begin
        controlerAI := TABControlerAI(mobile.Controler);
        controlerAI.ExecuteWingLeaderOrder(order, 1.1 + Random * 0.25);
      end;
    end;
  end;
end;

// TakeDamage
//
procedure TABAirplane.TakeDamage(amount: Single;
  const absolutePosition: TGLVector; fromTeam: Integer);
var
  relPos: TGLVector;
begin
  FLastDamageFromTeam := fromTeam;
  if Random < 2 * amount / FHullResistance then
  begin
    if ClassType = TABAirplane then
      ABEngine.PlaySound(Name, 'BigImpact_' + IntToStr(Random(2)));
    FFireDamage := FFireDamage + amount * 0.5;
    if (FDamagePoint = nil) and (SyncObject <> nil) then
    begin
      FDamagePoint := ABEngine.CreateFirePoint(SyncObject);
      relPos := VectorSubtract(absolutePosition, position);
      FDamagePoint.position.SetPoint(ClampValue(-VectorDotProduct(RightVector,
        relPos), -Collision.Size.x, Collision.Size.x), 0, -2);
      // ABEngine.AdjustFirePointIntensity(FDamagePoint, ClampValue(Sqrt(FFireDamage)*0.3, 1, 2));
    end;
  end
  else
  begin
    if ClassType = TABAirplane then
      ABEngine.PlaySound(Name, 'SmallImpact_' + IntToStr(Random(3)));
    if FFireDamage > 0 then
      FFireDamage := FFireDamage + amount * 0.1;
  end;
  FHullResistance := FHullResistance - amount;
end;

// SmokeBurst
//
procedure TABAirplane.SmokeBurst;
var
  i: Integer;
  source: TGLSourcePFXEffect;
  oldZ: Single;
begin
  if Assigned(FPFXSources) then
  begin
    FPFXSmoke.LifeColors[0].ColorInner.Alpha := 1;
    for i := 0 to FPFXSources.Count - 1 do
    begin
      source := (FPFXSources[i] as TGLSourcePFXEffect);
      oldZ := source.InitialPosition.Z;
      source.InitialPosition.Z := Speed * 0.1;
      source.Burst(ABEngine.Cadencer.CurrentTime - 0.3, 10);
      source.InitialPosition.Z := oldZ;
    end;
  end;
end;

// MakeBoom
//
procedure TABAirplane.MakeBoom(coreParticles, nbDebris: Integer);
begin
  ABEngine.MakeBoom(position, coreParticles, nbDebris);
end;

// SaveToStrings
//
procedure TABAirplane.SaveToStrings(data: TStrings);
var
  i: Integer;
  sl: TStringList;
begin
  if DenseSmoke then
    data.Values['DenseSmoke'] := 'Y'
  else
    data.Values['DenseSmoke'] := '';
  data.Values['Model'] := ModelName;
  sl := TStringList.Create;
  for i := 0 to EquipmentCount - 1 do
  begin
    sl.Clear;
    sl.Values['Type'] := Equipments[i].ClassName;
    Equipments[i].SaveToStrings(sl);
    data.Values['Equipment' + IntToStr(i)] := sl.CommaText;
  end;
  sl.Free;
  inherited;
end;

// LoadFromStrings
//
procedure TABAirplane.LoadFromStrings(data: TStrings);
var
  i: Integer;
  buf: String;
  sl: TStrings;
begin
  inherited;
  sl := TStringList.Create;
  ModelName := data.Values['Model'];
  DenseSmoke := (data.Values['DenseSmoke'] = 'Y');
  i := 0;
  while True do
  begin
    buf := data.Values['Equipment' + IntToStr(i)];
    Inc(i);
    if buf = '' then
      Break;
    sl.CommaText := buf;
    AddEquipment(sl.Values['Type']).LoadFromStrings(sl);
  end;
  sl.Free;
  BaseHullResistance := StrToIntDef(data.Values['HullResistance'], 1);
  HullResistance := BaseHullResistance;
  PrepareWeaponGroups;
end;

// PerformPreRenders
//
procedure TABAirplane.PerformPreRenders;
var
  i: Integer;
begin
  for i := 0 to EquipmentCount - 1 do
    Equipments[i].PerformPreRenders;
end;

// SyncFromObject
//
procedure TABAirplane.SyncFromObject(obj: TGLBaseSceneObject;
  aVelocity: Single);
begin
  position := obj.absolutePosition;
  Direction := obj.AbsoluteDirection;
  Up := obj.AbsoluteUp;
  velocity := VectorScale(Direction, aVelocity);
end;

// SyncToObject
//
procedure TABAirplane.SyncToObject(obj: TGLBaseSceneObject);
begin
  obj.position.DirectVector := position;
  obj.Direction.DirectVector := Direction;
  obj.Up.DirectVector := Up;
  obj.TransformationChanged;
end;

// SetSyncObject
//
procedure TABAirplane.SetSyncObject(obj: TGLBaseSceneObject);
begin
  if Assigned(FSyncObject) then
    TearDownSyncObject;
  FSyncObject := obj;
  if Assigned(FSyncObject) then
    SetupSyncObject;
end;

// SetupSyncObject
//
procedure TABAirplane.SetupSyncObject;
var
  i: Integer;
  source: TGLSourcePFXEffect;
begin
  Assert(FPFXSources = nil);
  Assert(SyncObject <> nil);

  FModel := ABEngine.FreeFormProxy(ModelName);
  SyncObject.AddChild(FModel);
  FModel.Direction.AsVector := ZHmgVector;
  FModel.Up.AsVector := YHmgVector;

  FPFXSmoke := TGLPerlinPFXManager.Create(nil);
  FPFXSmoke.ShareSprites := ABEngine.PFXSmoke;
  FPFXSmoke.Cadencer := ABEngine.Cadencer;
  FPFXSmoke.Renderer := ABEngine.PFXRenderer;
  FPFXSmoke.BlendingMode := bmTransparency;
  FPFXSmoke.ParticleSize := 5;
  FPFXSmoke.ColorInner.SetColor(1, 1, 1, 0.10);
  FPFXSmoke.LifeColors.Clear;
  with FPFXSmoke.LifeColors.Add do
  begin
    LifeTime := 0.4;
    ColorInner.SetColor(1, 1, 1, 0.55);
    SizeScale := 1;
  end;
  with FPFXSmoke.LifeColors.Add do
  begin
    LifeTime := 4;
    ColorInner.SetColor(1, 1, 1, 0);
    SizeScale := 6;
  end;

  FPFXSources := TGLPersistentObjectList.Create;
  for i := 0 to EngineCount - 1 do
  begin
    source := TGLSourcePFXEffect.Create(SyncObject.Effects);
    FPFXSources.Add(source);
    source.ParticleInterval := (0.02 + i * 0.05) / ABEngine.OptionsParticles;
    source.PositionDispersion := 0.5;
    source.PositionMode := spmRelative;
    source.InitialPosition.AsVector := Engines[i].position;
    source.InitialPosition.Z := source.InitialPosition.Z - 3;
    source.VelocityDispersion := 5;
    source.VelocityMode := svmRelative;
    source.Manager := FPFXSmoke;
  end;

  FPFXThrust := TGLPolygonPFXManager.Create(nil);
  FPFXThrust.Renderer := ABEngine.PFXRenderer;
  FPFXThrust.BlendingMode := bmAdditive;
  FPFXThrust.NbSides := 13;
  FPFXThrust.CreateParticles(EngineCount * 3);

  FSEEngine := TGLBSoundEmitter.Create(SyncObject.Behaviours);
  with FSEEngine do
  begin
    source.SoundLibrary := ABEngine.SoundLibrary;
    source.SoundName := 'Jet_Loop';
    source.MaxDistance := 2000;
    source.NbLoops := 999999;
    source.volume := ABEngine.EnginesVolume;
    Playing := True;
  end;

  FSEFire := TGLBSoundEmitter.Create(SyncObject.Behaviours);
  with FSEFire do
  begin
    source.SoundLibrary := ABEngine.SoundLibrary;
    source.SoundName := 'Fire_Loop';
    source.MaxDistance := 2000;
    source.NbLoops := 999999;
    source.volume := 1;
  end;

  FSEAirBrake := TGLBSoundEmitter.Create(SyncObject.Behaviours);
  with FSEAirBrake do
  begin
    source.SoundLibrary := ABEngine.SoundLibrary;
    source.SoundName := 'Wind_Loop';
    source.MaxDistance := 2000;
    source.NbLoops := 999999;
    source.volume := 1;
  end;

  for i := 0 to EquipmentCount - 1 do
    Equipments[i].SetupSyncObject;
end;

// TearDownSyncObject
//
procedure TABAirplane.TearDownSyncObject;
var
  i, k: Integer;
  behaviour: TGLBehaviour;
begin
  Assert(FPFXSources <> nil);

  for i := 0 to SyncObject.Behaviours.Count - 1 do
  begin
    behaviour := SyncObject.Behaviours[i];
    k := ABEngine.FSoundEmitters.IndexOfObject(behaviour);
    if k >= 0 then
      ABEngine.FSoundEmitters.Delete(k);
  end;

  for i := 0 to EquipmentCount - 1 do
    Equipments[i].TearDownSyncObject;

  FDamagePoint.Free;
  FDamagePoint := nil;
  FModel.Free;
  FModel := nil;
  FPFXSources.CleanFree;
  FPFXSources := nil;
  FPFXSmoke.AutoFreeWhenEmpty := True;
  FPFXSmoke := nil;
  FPFXThrust.Free;
  FPFXThrust := nil;
  FSEEngine.Free;
  FSEEngine := nil;
  FSEFire.Free;
  FSEFire := nil;
  FSEAirBrake.Free;
  FSEAirBrake := nil;
end;

// AddEquipment
//
function TABAirplane.AddEquipment(const typeName: String): TABEquipment;
var
  n: Integer;
  eqptClass: TABEquipmentClass;
begin
  n := Length(FEquipments);
  SetLength(FEquipments, n + 1);
  eqptClass := EquipmentClass(typeName);
  Assert(eqptClass <> nil, 'Unknown equipment class ' + typeName);
  Result := eqptClass.Create;
  Result.Airplane := Self;
  FEquipments[n] := Result;
end;

// EquipmentCount
//
function TABAirplane.EquipmentCount: Integer;
begin
  Result := Length(FEquipments);
end;

// ClearEquipements
//
procedure TABAirplane.ClearEquipements;
var
  i: Integer;
begin
  for i := Low(FEquipments) to High(FEquipments) do
    FEquipments[i].Free;
  SetLength(FEquipments, 0);
end;

// EquipementsHUDRender
//
procedure TABAirplane.EquipementsHUDRender(var rci: TGLRenderContextInfo);
var
  i: Integer;
begin
  for i := Low(FEquipments) to High(FEquipments) do
    FEquipments[i].HUDRender(rci);
end;

// ReplenishEquipments
//
procedure TABAirplane.ReplenishEquipments;
var
  i: Integer;
begin
  for i := Low(FEquipments) to High(FEquipments) do
    FEquipments[i].Replenish;
end;

// DepleteEquipments
//
procedure TABAirplane.DepleteEquipments;
var
  i: Integer;
begin
  for i := Low(FEquipments) to High(FEquipments) do
    FEquipments[i].Deplete;
end;

// Repair
//
procedure TABAirplane.Repair;
begin
  FHullResistance := FBaseHullResistance;
  FFireDamage := 0;
end;

// WeaponGroupAmmo
//
function TABAirplane.WeaponGroupAmmo(const name: String): Integer;
var
  i: Integer;
  eqpt: TABEquipment;
begin
  Result := 0;
  for i := Low(FEquipments) to High(FEquipments) do
  begin
    eqpt := FEquipments[i];
    if (eqpt.GroupName = name) and (eqpt is TABEqptWeapon) then
      Inc(Result, TABEqptWeapon(eqpt).AmmoCapacity);
  end;
end;

// PrepareWeaponGroups
//
procedure TABAirplane.PrepareWeaponGroups;
var
  i: Integer;
begin
  FWeaponGroups.Clear;
  FWeaponGroups.Sorted := True;
  FWeaponGroups.Duplicates := dupIgnore;
  for i := 0 to EquipmentCount - 1 do
    if Equipments[i] is TABEqptWeapon then
      FWeaponGroups.Add(Equipments[i].GroupName);
  i := FWeaponGroups.IndexOf('');
  if i > 0 then
    FWeaponGroups.Delete(i);
  if FWeaponGroups.Count > 0 then
    FCurrentWeaponGroup := FWeaponGroups[0]
  else
    FCurrentWeaponGroup := '';
end;

// SetModelVisible
//
procedure TABAirplane.SetModelVisible(val: Boolean);
begin
  if SyncObject = nil then
    Exit;
  SyncObject.Visible := val;
end;

// RenderWeaponsLoadout
//
procedure TABAirplane.RenderWeaponsLoadout(var rci: TGLRenderContextInfo;
  Canvas: TGLCanvas; posX, posY, scale: Single);
const
  cHullColor100: TGLColorVector = (x: 0.6; y: 0.6; Z: 1; W: 1);
  cHullColor0: TGLColorVector = (x: 1; y: 0.6; Z: 0.6; W: 1);
var
  i, j: Integer;
  libMat: TGLLibMaterial;
  eqpt: TABEquipment;
  eqptPosX, eqptPosY, s: Single;
  weapColor: TColor;
  GroupName: String;
begin
  libMat := ABEngine.TopDownTextureMaterial(ModelName, 256);

  glColor4fv(@clrGray);
  RenderSpriteQuad(rci, posX, posY, 2 * scale, libMat);

  s := libMat.Tag * 0.001 * scale;
  GroupName := CurrentWeaponGroup;
  for i := 0 to WeaponGroups.Count - 1 do
  begin
    if WeaponGroups[i] = GroupName then
      weapColor := clRed
    else
      weapColor := clWhite;
    Canvas.PenColor := weapColor;
    for j := 0 to EquipmentCount - 1 do
    begin
      eqpt := Equipments[j];
      if eqpt.GroupName = WeaponGroups[i] then
      begin
        eqptPosX := posX - eqpt.position.x * s;
        eqptPosY := posY - eqpt.position.Z * s;
        if eqpt is TABEqptGun then
        begin
          Canvas.MoveTo(eqptPosX, eqptPosY);
          Canvas.PenWidth := 2;
          Canvas.MoveToRel(0, -16);
          Canvas.LineToRel(0, 16);
          Canvas.PenWidth := 4;
          Canvas.LineToRel(0, 16);
        end
        else if (eqpt is TABEqptMissile) and (eqpt.Model <> nil) then
        begin
          Canvas.StopPrimitive;
          libMat := ABEngine.TopDownTextureMaterial(eqpt.ModelName);
          libMat.Material.FrontProperties.Emission.AsWinColor := weapColor;
          RenderSpriteQuad(rci, eqptPosX, eqptPosY, s / (libMat.Tag * 0.001) *
            3, libMat);
        end;
      end;
    end;
  end;
  Canvas.StopPrimitive;
end;

// RenderMessageLog
//
procedure TABAirplane.RenderMessageLog(var rci: TGLRenderContextInfo;
  Canvas: TGLCanvas);
var
  i, h, totH: Integer;
  sl: TStringList;
  f: Single;
  textRect: TRect;
  buf: String;
  pMess: PGameMessage;
  Color: TColor;
begin
  sl := TStringList.Create;
  GameEngine.FilterMessagesTo(Self, GameEngine.Ticks - 10 * 100, sl);

  if sl.Count > 0 then
  begin
    Canvas.PenColor := clBlack;
    Canvas.PenAlpha := 0.5;
    h := ABEngine.SmallFont.CharHeight + 3;
    totH := h * sl.Count;
    textRect.Left := 10;
    textRect.Top := 10;
    textRect.Right := 400;
    textRect.Bottom := 15 + totH;
    with textRect do
      Canvas.FillRect(Left, Top, Right, Bottom);
    Canvas.StopPrimitive;

    f := TGLSceneBuffer(rci.buffer).Width / Canvas.CanvasSizeX;
    glScissor(Round((textRect.Left + 3) * f), 0,
      Round((textRect.Right - textRect.Left - 6) * f),
      TGLSceneBuffer(rci.buffer).Height);
    glEnable(GL_SCISSOR_TEST);

    // canvas.PenColor:=clYellow; canvas.FillRect(0, 0, 1024, 768); canvas.StopPrimitive;

    for i := 0 to sl.Count - 1 do
    begin
      pMess := PGameMessage(sl.Objects[i]);
      f := pMess.Ticks * 0.01;
      buf := Format('%.2d:%.2d - %s', [Trunc(f * (1 / 60)),
        Trunc(Frac(f * (1 / 60)) * 60), sl[i]]);
      if (pMess.FromMobile = nil) then
        Color := clWhite
      else if pMess.FromMobile.team = team then
        Color := clLime
      else
        Color := clRed;
      ABEngine.SmallFont.TextOut(rci, 15, 15 + i * h, buf, Color);
    end;

    glDisable(GL_SCISSOR_TEST);
  end;
  sl.Free;
end;

// ------------------
// ------------------ TAirBlastEngine ------------------
// ------------------

// Create
//
constructor TAirBlastEngine.Create;
begin
  inherited;
  FOptions := TStringList.Create;
  FSoundEmitters := TStringList.Create;
  FSoundEmitters.Sorted := True;
  FSoundEmitters.Duplicates := dupAccept;
  F3DSoundEmitters := TStringList.Create;
  F3DSoundEmitters.Sorted := True;
  F3DSoundEmitters.Duplicates := dupAccept;
  FVoices := TStringList.Create;
  FVoices.Sorted := True;
  FVoices.Duplicates := dupError;
  FMusicChannel := -1;
  FRatings := TStringList.Create;

  FSmallFont := TGLWindowsBitmapFont.Create(nil);
  FSmallFont.Font.Size := 8;
  FSmallFont.Font.name := 'Courrier New';
  FSmallFont.Font.Style := [fsBold];

  FBigFont := TGLWindowsBitmapFont.Create(nil);
  FBigFont.Font.Size := 20;
  FBigFont.Font.name := 'Arial';
  FBigFont.Font.Style := [fsBold];
end;

// Destroy
//
destructor TAirBlastEngine.Destroy;
var
  i: Integer;
begin
  inherited;
  FSmallFont.Free;
  FBigFont.Free;
  FRatings.Free;
  for i := 0 to FSoundEmitters.Count - 1 do
    FSoundEmitters.Objects[i].Free;
  FSoundEmitters.Free;
  F3DSoundEmitters.Free;
  for i := 0 to FVoices.Count - 1 do
    FVoices.Objects[i].Free;
  FVoices.Free;
  FOptions.Free;
end;

// Startup
//
procedure TAirBlastEngine.Startup;
begin
  inherited;
  FGameResult := grUndetermined;
end;

// Pause
//
procedure TAirBlastEngine.Pause;
begin
  inherited;
  FSoundManager.Pause := True;
  PauseVoices;
end;

// Resume
//
procedure TAirBlastEngine.Resume;
begin
  inherited;
  FSoundManager.Pause := False;
  ResumeVoices;
end;

// Completed
//
procedure TAirBlastEngine.Completed;
var
  bestTeam, i, delta: Integer;
  scoreTie: Boolean;
begin
  inherited;
  bestTeam := 0;
  scoreTie := False;
  for i := 1 to TeamCount - 1 do
  begin
    delta := Teams[i].Score - Teams[bestTeam].Score;
    if delta > 0 then
    begin
      bestTeam := i;
      scoreTie := False;
    end
    else
      scoreTie := (delta = 0);
  end;
  if scoreTie and (Teams[bestTeam].Score = TeamByName('Player').Score) then
  begin
    FGameResult := grTie;
  end
  else if Teams[bestTeam].name = 'Player' then
  begin
    FGameResult := grVictory;
    PlayVoice('GameMenu', 'You have won the match')
  end
  else
  begin
    FGameResult := grDefeat;
    PlayVoice('GameMenu', 'You have lost the match');
  end;
end;

// Progress
//
procedure TAirBlastEngine.Progress(const deltaTime: Double);
var
  i: Integer;
begin
  inherited;

  for i := 0 to FVoices.Count - 1 do
    TVoice(FVoices.Objects[i]).Progress;
  for i := 0 to ViewerCamsCount - 1 do
    if not ViewerCams[i].Disabled then
      ViewerCams[i].Progress(deltaTime);

  if deltaTime > 0 then
  begin
    for i := 0 to SpawnPointsCount - 1 do
      if not SpawnPoints[i].Disabled then
        SpawnPoints[i].Progress(deltaTime);
  end;

  PerformPreRenders;
end;

// NotifyAllMobiles
//
procedure TAirBlastEngine.NotifyAllMobiles(aMobile: TMobile;
  operation: TGameOperation);
var
  i: Integer;
begin
  inherited;
  for i := 0 to SpawnPointsCount - 1 do
    SpawnPoints[i].Notification(aMobile, operation);
end;

// CheckTerrainCollision
//
procedure TAirBlastEngine.CheckTerrainCollision(mobile: TMobile);
var
  h: Single;
begin
  h := TerrainRenderer.InterpolatedHeight(mobile.position);
  if mobile.position.Z - h < mobile.Collision.radius then
  begin
    mobile.Notification(nil, goCollide);
  end;
end;

// DoGameCountDown
//
procedure TAirBlastEngine.DoGameCountDown(secondsRemaining: Integer);
begin
  case secondsRemaining of
    60:
      PlayVoice('GameMenu', '1 minute remaining');
    30:
      PlayVoice('GameMenu', '30 seconds remaining');
    1 .. 10:
      PlayVoice('GameMenu', IntToStr(secondsRemaining));
  end;
end;

// ObjectByName
//
function TAirBlastEngine.ObjectByName(const aName: String): TGameEngineObject;
begin
  Result := SpawnPointByName(aName);
  if Result = nil then
    Result := inherited ObjectByName(aName);
end;

// AddViewerCam
//
function TAirBlastEngine.AddViewerCam: TABViewerCam;
var
  n: Integer;
begin
  Result := TABViewerCam.Create;
  Result.FGameEngine := Self;
  n := Length(FViewerCams);
  SetLength(FViewerCams, n + 1);
  FViewerCams[n] := Result;
end;

// ViewerCamsCount
//
function TAirBlastEngine.ViewerCamsCount: Integer;
begin
  Result := Length(FViewerCams);
end;

// ClearViewerCams
//
procedure TAirBlastEngine.ClearViewerCams;
var
  i: Integer;
begin
  for i := 0 to High(FViewerCams) do
    FViewerCams[i].Free;
  SetLength(FViewerCams, 0);
end;

// LoadFromStrings
//
procedure TAirBlastEngine.LoadFromStrings(data: TStrings);
begin
  RandSeed := 0;
  Clear;
  AddFromStrings(data);
end;

// AddFromStrings
//
procedure TAirBlastEngine.AddFromStrings(data: TStrings);
var
  i, p: Integer;
  cmd: String;
  sl: TStringList;
  event: TABEventActions;
  bonus: TABBonus;
  hoop: TABHoop;
begin
  sl := TStringList.Create;
  try
    for i := 0 to data.Count - 1 do
    begin
      p := Pos(':', data[i]);
      if p < 1 then
        continue;
      cmd := LowerCase(Copy(data[i], 1, p - 1));
      sl.CommaText := Copy(data[i], p + 1, MaxInt);

      if cmd = 'airplane' then
      begin
        SpawnAirplane(sl);
      end
      else if cmd = 'team' then
      begin
        AddTeam(sl.Values['Name'], StrToIntDef(sl.Values['Score'], 0));
      end
      else if cmd = 'spawnpoint' then
      begin
        AddSpawnPoint.LoadFromStrings(sl);
      end
      else if cmd = 'event' then
      begin
        event := TABEventActions.Create;
        RegisterEvent(event);
        event.LoadFromStrings(sl);
      end
      else if cmd = 'bonus' then
      begin
        bonus := TABBonus.Create(Self);
        bonus.LoadFromStrings(sl);
      end
      else if cmd = 'hoop' then
      begin
        hoop := TABHoop.Create(Self);
        hoop.LoadFromStrings(sl);
      end
      else if cmd = 'countdown' then
      begin
        GameEndCountDown := StrToInt(sl[0]);
      end
      else if cmd = 'ratings' then
      begin
        FRatings.Assign(sl);
      end;
    end;
  finally
    sl.Free;
  end;
  Loaded;
end;

// SpawnAirplane
//
function TAirBlastEngine.SpawnAirplane(data: TStrings): TABAirplane;
var
  ctrlClass: TControlerClass;
  Controler: TControler;
  Airplane: TABAirplane;
  ctrlName: String;
begin
  Airplane := TABAirplane.Create(Self);
  Airplane.LoadFromFile(data.Values['Type']);
  Airplane.name := data.Values['Name'];
  Airplane.team := StrToIntDef(data.Values['Team'], 0);
  Airplane.position := PointMake(StringToVector3(data.Values['Position']));
  Airplane.velocity := PointMake(StringToVector3(data.Values['Velocity']));
  Airplane.SetOrientationFromVelocity(ZHmgVector);
  Airplane.Throttle := StrToFloatDef(data.Values['Throttle'], 0.7);
  Airplane.LeaderName := data.Values['Leader'];
  Airplane.SyncObject := TGLDummyCube.CreateAsChild(SceneRoot);
  Airplane.KillScore := StrToIntDef(data.Values['KillScore'], 1);
  case OptionsDifficultyOffset of
    - 2:
      Airplane.FBaseHullResistance := 3 * Airplane.FBaseHullResistance;
    -1:
      Airplane.FBaseHullResistance := (3 * Airplane.FBaseHullResistance) div 2;
    1:
      Airplane.FBaseHullResistance := (3 * Airplane.FBaseHullResistance) div 4;
    2:
      Airplane.FBaseHullResistance := Airplane.FBaseHullResistance div 2;
  end;
  Airplane.DestroyActions.CommaText := data.Values['DestroyActions'];

  ctrlName := data.Values['Controler'];
  if ctrlName <> '' then
  begin
    if ctrlName = 'UI' then
    begin
      Controler := TABControlerUI.Create;
      Controler.mobile := Airplane;
      TABControlerUI(Controler).ApplyGameEngineOptions;
      TABControlerUI(Controler).Active := not FUIDisabled;
    end
    else
    begin
      ctrlClass := ControlerClass(ctrlName);
      Assert(ctrlClass <> nil, 'Unknown controler: ' + ctrlName);
      Controler := ctrlClass.Create;
      Controler.mobile := Airplane;
      Controler.LoadFromString(data.Values['ControlerParams']);
    end;
  end;

  if Assigned(FOnSpawnAirplane) then
    FOnSpawnAirplane(Self, Airplane);

  Result := Airplane;
end;

// Clear
//
procedure TAirBlastEngine.Clear;
var
  i: Integer;
begin
  StopVoices;
  StopMusic;
  Stop2DSound;
  for i := 0 to F3DSoundEmitters.Count - 1 do
    TGLBSoundEmitter(F3DSoundEmitters.Objects[i]).Owner.Owner.Free;
  F3DSoundEmitters.Clear;
  for i := 0 to MobileCount - 1 do
    if (Mobiles[i] is TABAirplane) then
      TABAirplane(Mobiles[i]).SyncObject := nil;
  SetLength(FTeams, 0);
  ClearViewerCams;
  ClearSpawnPoints;
  FGameResult := grUndetermined;
  inherited;
  if Assigned(FSceneRoot) then
    SceneRoot.DeleteChildren;
  if Assigned(FSortedSceneRoot) then
    SortedSceneRoot.DeleteChildren;
end;

// ApplyOptions
//
procedure TAirBlastEngine.ApplyOptions;
var
  i: Integer;
  vol: Single;
begin
  // Difficulty -> ?

  vSpeedScaleUp := 1 + StrToInt(Options.Values['Speed']) * 0.25;

  case StrToIntDef(Options.Values['TerrainQuality'], 1) of
    0:
      begin // low
        TerrainRenderer.QualityDistance := 2500;
        TerrainRenderer.CLODPrecision := 10;
        TerrainRenderer.MaxCLODTriangles := 80000;
      end;
    2:
      begin // high
        TerrainRenderer.QualityDistance := 25000;
        TerrainRenderer.CLODPrecision := 4;
        TerrainRenderer.MaxCLODTriangles := 500000;
      end;
  else
    // normal
    TerrainRenderer.QualityDistance := 7000;
    TerrainRenderer.CLODPrecision := 5;
    TerrainRenderer.MaxCLODTriangles := 150000;
  end;

  case StrToIntDef(Options.Values['Particles'], 1) of
    0:
      begin
        FOptionsParticles := 0.7;
        PFXRenderer.ZSortAccuracy := saLow;
        PFXRenderer.ZMaxDistance := 10000;
      end;
    1:
      begin
        FOptionsParticles := 1;
        PFXRenderer.ZSortAccuracy := saOneTenth;
        PFXRenderer.ZMaxDistance := 15000;
      end;
    2:
      begin
        FOptionsParticles := 1.25;
        PFXRenderer.ZSortAccuracy := saOneHalf;
        PFXRenderer.ZMaxDistance := 20000;
      end;
  end;

  SoundManager.MasterVolume := StrToIntDef(Options.Values['MasterVolume'],
    100) * 0.01;
  EnginesVolume := StrToIntDef(Options.Values['EnginesVolume'], 100) * 0.01;
  if FMusicChannel <> -1 then
    FSOUND_SetVolume(FMusicChannel,
      Round(StrToIntDef(Options.Values['MusicVolume'], 100) * (255 / 100)));
  vol := StrToIntDef(Options.Values['VoiceVolume'], 100) * 0.01;
  for i := 0 to FVoices.Count - 1 do
    TVoice(FVoices.Objects[i]).volume := vol;

  for i := 0 to MobileCount - 1 do
    if (Mobiles[i] is TABAirplane) and (Mobiles[i].Controler is TABControlerUI)
    then
      TABControlerUI(Mobiles[i].Controler).ApplyGameEngineOptions;
end;

// OptionsifficultyOffset
//
function TAirBlastEngine.OptionsDifficultyOffset: Integer;
begin
  Result := StrToIntDef(Options.Values['Difficulty'], 2) - 2;
end;

// VideoModeStringToValues
//
procedure TAirBlastEngine.VideoModeStringToValues(const videoMode: String;
  var x, y, bpp: Integer);
var
  p, p2: Integer;
begin
  p := Pos('x', videoMode);
  p2 := Pos(' ', videoMode);
  x := StrToInt(Copy(videoMode, 1, p - 1));
  y := StrToInt(Copy(videoMode, p + 1, p2 - p - 1));
  bpp := StrToInt(Copy(videoMode, p2 + 1, 2));
end;

// OptionsScreenResolution
//
function TAirBlastEngine.OptionsScreenResolution: TResolution;
var
  x, y, bpp: Integer;
begin
  VideoModeStringToValues(Options.Values['VideoMode'], x, y, bpp);
  Result := GetIndexFromResolution(x, y, bpp);
end;

// OptionsFSAA
//
function TAirBlastEngine.OptionsFSAA: TGLAntiAliasing;
begin
  case StrToIntDef(Options.Values['FSAA'], 0) of
    1:
      Result := aa2x;
    2:
      Result := aa4x;
  else
    Result := aaDefault;
  end;
end;

// GetOrCreateSoundEmitter
//
function TAirBlastEngine.GetOrCreateSoundEmitter(const MobileName,
  sampleName: String): TGLBSoundEmitter;
var
  i: Integer;
  mobile: TMobile;
begin
  Result := nil;

  mobile := MobileByName(MobileName);
  Assert(mobile is TABAirplane);
  Assert(TABAirplane(mobile).SyncObject <> nil);

  i := FSoundEmitters.IndexOf(sampleName);
  if i >= 0 then
  begin
    // find 1st of name
    while (i > 0) and (FSoundEmitters[i - 1] = sampleName) do
      Dec(i);
    // find 1st not playing
    repeat
      Result := TGLBSoundEmitter(FSoundEmitters.Objects[i]);
      if Result.Playing then
      begin
        Result := nil;
        Inc(i);
      end
      else
        Break;
    until (i >= FSoundEmitters.Count) or (FSoundEmitters[i] <> sampleName);
  end;
  if Result = nil then
  begin
    // create a new emitter
    Result := TGLBSoundEmitter.Create(TABAirplane(mobile)
      .SyncObject.Behaviours);
    FSoundEmitters.AddObject(sampleName, Result);
    Result.source.SoundLibrary := SoundLibrary;
    Result.source.SoundName := sampleName;
    Result.source.MaxDistance := 50000;
  end
  else
  begin
    // relocate emitter
    TABAirplane(mobile).SyncObject.Behaviours.Add(Result);
  end;
end;

// GetOrCreate3DSoundEmitter
//
function TAirBlastEngine.GetOrCreate3DSoundEmitter(const sampleName: String)
  : TGLBSoundEmitter;
var
  i: Integer;
  dummy: TGLDummyCube;
begin
  Result := nil;
  i := F3DSoundEmitters.IndexOf(sampleName);
  if i >= 0 then
  begin
    // find 1st of name
    while (i > 0) and (F3DSoundEmitters[i - 1] = sampleName) do
      Dec(i);
    // find 1st not playing
    repeat
      Result := TGLBSoundEmitter(F3DSoundEmitters.Objects[i]);
      if Result.Playing then
      begin
        Result := nil;
        Inc(i);
      end
      else
        Break;
    until (i >= F3DSoundEmitters.Count) or (F3DSoundEmitters[i] <> sampleName);
  end;
  if Result = nil then
  begin
    // create a new emitter
    dummy := TGLDummyCube.CreateAsChild(SceneRoot);
    Result := TGLBSoundEmitter.Create(dummy.Behaviours);
    F3DSoundEmitters.AddObject(sampleName, Result);
    Result.source.SoundLibrary := SoundLibrary;
    Result.source.SoundName := sampleName;
    Result.source.MaxDistance := 50000;
  end;
end;

// SetEnginesVolume
//
procedure TAirBlastEngine.SetEnginesVolume(val: Single);
var
  i: Integer;
  air: TABAirplane;
begin
  FEnginesVolume := val;
  for i := 0 to MobileCount - 1 do
    if Mobiles[i] is TABAirplane then
    begin
      air := TABAirplane(Mobiles[i]);
      if air.FSEEngine <> nil then
        air.FSEEngine.source.volume := val;
    end;
end;

// PlaySound
//
procedure TAirBlastEngine.PlaySound(const MobileName, sampleName: String);
var
  emitter: TGLBSoundEmitter;
begin
  if MobileName = '' then
    emitter := GetOrCreateSoundEmitter('Player', sampleName)
  else
    emitter := GetOrCreateSoundEmitter(MobileName, sampleName);
  emitter.Playing := True;
end;

// Play3DSound
//
procedure TAirBlastEngine.Play3DSound(const sampleName: String;
  position, velocity: TGLVector);
var
  emitter: TGLBSoundEmitter;
  dummy: TGLDummyCube;
begin
  emitter := GetOrCreate3DSoundEmitter(sampleName);
  dummy := (emitter.Owner.Owner as TGLDummyCube);
  dummy.position.SetPoint(position);
  emitter.Playing := True;
end;

// PlayVoice
//
procedure TAirBlastEngine.PlayVoice(const voiceName, text: String);
var
  i: Integer;
  voice: TVoice;
begin
  i := FVoices.IndexOf(voiceName);
  if i < 0 then
  begin
    voice := TVoice.Create('Voices\' + voiceName);
    FVoices.AddObject(voiceName, voice);
    voice.volume := StrToIntDef(Options.Values['VoiceVolume'], 100) * 0.01;
  end
  else
    voice := TVoice(FVoices.Objects[i]);
  voice.Speak(text);
end;

// StopVoice
//
procedure TAirBlastEngine.StopVoice(const voiceName: String);
var
  i: Integer;
  voice: TVoice;
begin
  i := FVoices.IndexOf(voiceName);
  if i >= 0 then
  begin
    voice := TVoice(FVoices.Objects[i]);
    voice.Stop;
  end;
end;

// StopVoices
//
procedure TAirBlastEngine.StopVoices;
var
  i: Integer;
begin
  for i := 0 to FVoices.Count - 1 do
    TVoice(FVoices.Objects[i]).Stop;
end;

// PauseVoices
//
procedure TAirBlastEngine.PauseVoices;
var
  i: Integer;
begin
  for i := 0 to FVoices.Count - 1 do
    TVoice(FVoices.Objects[i]).Pause;
end;

// ResumeVoices
//
procedure TAirBlastEngine.ResumeVoices;
var
  i: Integer;
begin
  for i := 0 to FVoices.Count - 1 do
    TVoice(FVoices.Objects[i]).Resume;
end;

// PlayMusic
//
procedure TAirBlastEngine.PlayMusic(const musicName: String; loop: Boolean);
begin
  StartPlayingSound(FMusicSample, FMusicChannel, musicName, loop,
    StrToIntDef(Options.Values['MusicVolume'], 100) * 0.01);
end;

// StopMusic
//
procedure TAirBlastEngine.StopMusic;
begin
  StopPlayingSound(FMusicSample, FMusicChannel);
end;

// Play2DSound
//
procedure TAirBlastEngine.Play2DSound(const sampleName: String);
begin
  StartPlayingSound(F2DSoundSample, F2DSoundChannel, sampleName, False, 1);
end;

// Stop2DSound
//
procedure TAirBlastEngine.Stop2DSound;
begin
  StopPlayingSound(F2DSoundSample, F2DSoundChannel);
end;

// StartPlayingSound
//
procedure TAirBlastEngine.StartPlayingSound(var sample: PFSoundSample;
  var channel: Integer; const sampleName: String; loop: Boolean;
  volume: Single);
var
  s: TStream;
  sampleData: String;
  oldSample: PFSoundSample;
  loopOpt: Integer;
begin
  s := TFileStream.Create(sampleName, fmOpenRead);
  SetLength(sampleData, s.Size);
  s.Read(sampleData[1], s.Size);
  s.Free;

  oldSample := sample;
  if loop then
    loopOpt := FSOUND_LOOP_NORMAL
  else
    loopOpt := 0;
  sample := FSOUND_Sample_Load(FSOUND_FREE, PAnsiChar(sampleData),
    FSOUND_HW2D or loopOpt or FSOUND_LOADMEMORY, 0, Length(sampleData));
  if channel <> -1 then
    FSOUND_StopSound(channel);
  channel := FSOUND_PlaySound(FSOUND_FREE, sample);
  FSOUND_SetVolume(channel, Round(volume * 255));

  if Assigned(oldSample) then
    FSOUND_Sample_Free(oldSample);
end;

// StopPlayingSound
//
procedure TAirBlastEngine.StopPlayingSound(var sample: PFSoundSample;
  var channel: Integer);
begin
  if channel <> -1 then
  begin
    FSOUND_StopSound(channel);
    channel := -1;
  end;
  if Assigned(sample) then
  begin
    FSOUND_Sample_Free(sample);
    sample := nil;
  end;
end;

// CreateFirePoint
//
function TAirBlastEngine.CreateFirePoint(parent: TGLBaseSceneObject = nil;
  smoking: Boolean = True; rateBoost: Single = 1): TGLBaseSceneObject;
begin
  if parent = nil then
    parent := SceneRoot;
  Result := TGLDummyCube.CreateAsChild(parent);
  if smoking then
  begin
    with TGLSourcePFXEffect.Create(Result.Effects) do
    begin
      Manager := PFXSmoke;
      PositionDispersion := 2;
      PositionMode := spmRelative;
      VelocityMode := svmRelative;
      VelocityDispersion := 8;
      ParticleInterval := 0.3 / (OptionsParticles * rateBoost);
    end;
  end;
  with TGLSourcePFXEffect.Create(Result.Effects) do
  begin
    Manager := PFXFire;
    PositionDispersion := 1;
    PositionMode := spmRelative;
    VelocityMode := svmRelative;
    VelocityDispersion := 6;
    ParticleInterval := 0.015 / (OptionsParticles * rateBoost);
  end;
end;

// AdjustFirePointIntensity
//
procedure TAirBlastEngine.AdjustFirePointIntensity(fp: TGLBaseSceneObject;
  intensity: Single);
begin
  Assert(fp.Effects.Count = 2);
  TGLSourcePFXEffect(fp.Effects[0]).ParticleInterval :=
    0.10 / ((intensity * 0.5 + 0.5) * OptionsParticles);
  TGLSourcePFXEffect(fp.Effects[1]).ParticleInterval :=
    0.03 / ((intensity * 0.5 + 0.5) * OptionsParticles);
end;

// AirBurstDamage
//
procedure TAirBlastEngine.AirBurstDamage(const p: TGLVector; radius: Single;
  maxDamage, minDamage: Single; fromTeam: Integer);
var
  i: Integer;
  mobile: TMobile;
  Airplane: TABAirplane;
  d: Single;
begin
  for i := 0 to MobileCount - 1 do
  begin
    mobile := Mobiles[i];
    if mobile is TABAirplane then
    begin
      d := VectorDistance(mobile.position, p);
      if d < radius then
      begin
        Airplane := TABAirplane(mobile);
        Airplane.TakeDamage(Lerp(maxDamage, minDamage, d / radius), p,
          fromTeam);
      end;
    end;
  end;
end;

// MakeBoom
//
procedure TAirBlastEngine.MakeBoom(position: TGLVector;
  coreParticles, nbDebris: Integer);

  procedure SetupParticle(particle: TGLParticle; posDisp, velDisp: Single;
    timeOffset: Single);
  begin
    particle.posX := position.x + posDisp * (Random - 0.5);
    particle.posY := position.y + posDisp * (Random - 0.5);
    particle.PosZ := position.Z + posDisp * (Random - 0.5);
    particle.VelX := (Random - 0.5) * velDisp;
    particle.VelY := (Random - 0.5) * velDisp;
    particle.VelZ := (Random - 0.5) * velDisp;
    particle.CreationTime := particle.CreationTime - timeOffset;
  end;

var
  i: Integer;
  debris: TGLBaseSceneObject;
  list1, list2: TGLPersistentObjectList;
  event: TGameEventTerminator;
begin
  if coreParticles > 0 then
  begin
    coreParticles := Round(coreParticles * OptionsParticles);
    if coreParticles < 2 then
      coreParticles := 2;
    for i := 1 to coreParticles do
    begin
      SetupParticle(PFXSmoke.CreateParticle, 7, 50, 1);
      SetupParticle(PFXFire.CreateParticle, 7, 50, 0);
    end;
  end;

  if nbDebris > 0 then
  begin
    if nbDebris > 2 then
    begin
      nbDebris := Round(nbDebris * OptionsParticles);
      if nbDebris < 2 then
        nbDebris := 2;
    end;
    list1 := TGLPersistentObjectList.Create;
    list2 := TGLPersistentObjectList.Create;
    for i := 1 to nbDebris do
    begin
      debris := CreateFirePoint;
      AdjustFirePointIntensity(debris, 1);
      if Random < 0.5 then
        list1.Add(debris)
      else
        list2.Add(debris);
      debris.position.SetPoint(position);
      with GetOrCreateInertia(debris) do
      begin
        Mass := 1;
        TranslationSpeed.SetVector(Random - 0.5, Random - 0.5, Random - 0.5);
        TranslationSpeed.Normalize;
        TranslationSpeed.scale(50 + Random(40));
        TranslationDamping.Linear := 0.1;
      end;
      debris.OnProgress := Self.OnDebrisProgress;
    end;
    if list1.Count > 0 then
    begin
      event := TGameEventTerminator.Create;
      event.List := list1;
      event.EventTime := Ticks + 200 + Random(600);
      RegisterEvent(event);
    end
    else
      list1.Free;
    if list2.Count > 0 then
    begin
      event := TGameEventTerminator.Create;
      event.List := list2;
      event.EventTime := Ticks + 400 + Random(800);
      RegisterEvent(event);
    end
    else
      list2.Free;
  end;

  if Random < 0.5 then
    Play3DSound('Explosion', position, NullHmgVector)
  else
    Play3DSound('Explosion_Dry', position, NullHmgVector);
end;

// MakeDust
//
procedure TAirBlastEngine.MakeDust(position: TGLVector);
var
  n: Integer;
  part: TGLParticle;
begin
  n := 2 + Random(3);
  while n > 0 do
  begin
    part := PFXDust.CreateParticle;
    part.position := AffineVectorMake(position.x, position.y,
      TerrainRenderer.InterpolatedHeight(position) + 5);
    part.velocity := AffineVectorMake(10 * (Random - 0.5), 10 * (Random - 0.5),
      10 * Random);
    part.CreationTime := Cadencer.CurrentTime;
    Dec(n);
  end;
end;

// MakeSmoke
//
procedure TAirBlastEngine.MakeSmoke(position: TGLVector);
var
  n: Integer;
  part: TGLParticle;
begin
  n := 2 + Random(3);
  while n > 0 do
  begin
    part := PFXSmoke.CreateParticle;
    part.position := AffineVectorMake(position);
    part.velocity := AffineVectorMake(10 * (Random - 0.5), 10 * (Random - 0.5),
      10 * (Random - 0.5));
    part.CreationTime := Cadencer.CurrentTime;
    part := PFXFire.CreateParticle;
    part.position := AffineVectorMake(position);
    part.velocity := AffineVectorMake(10 * (Random - 0.5), 10 * (Random - 0.5),
      10 * (Random - 0.5));
    part.CreationTime := Cadencer.CurrentTime;
    Dec(n);
  end;
end;

// SetupEventsDebugStuff
//
procedure TAirBlastEngine.SetupEventsDebugStuff;
var
  i: Integer;
begin
  for i := 0 to Events.Count - 1 do
    if Events[i] is TABEventActions then
      TABEventActions(Events[i]).CreateDebugStuff;
end;

// PerformPreRenders
//
procedure TAirBlastEngine.PerformPreRenders;
var
  i: Integer;
begin
  for i := 0 to MobileCount - 1 do
    if Mobiles[i] is TABAirplane then
      TABAirplane(Mobiles[i]).PerformPreRenders;
end;

// OnDebrisProgress
//
procedure TAirBlastEngine.OnDebrisProgress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  h: Single;
  obj: TGLBaseSceneObject;
begin
  obj := (Sender as TGLBaseSceneObject);
  with GetOrCreateInertia(obj) do
  begin
    ApplyTranslationAcceleration(deltaTime, VectorMake(0, 0, -10, 0));
    h := obj.position.Z - TerrainRenderer.InterpolatedHeight
      (obj.position.DirectVector);
    if h < 0 then
    begin
      obj.position.Z := obj.position.Z - 2 * h;
      SurfaceBounce(ZHmgVector, Random);
      TranslationDamping.Linear := Random;
    end;
  end;
end;

// FreeFormProxy
//
function TAirBlastEngine.FreeFormProxy(const ModelName: String): TGLProxyObject;
begin
  Result := FreeFormProxy(ModelName, TGLProxyObject);
end;

// FreeFormProxy
//
function TAirBlastEngine.FreeFormProxy(const ModelName: String;
  proxyClass: TGLProxyObjectClass): TGLProxyObject;
var
  i: Integer;
  ff: TGLFreeForm;
begin
  ff := nil;
  for i := 0 to ProxiesRoot.Count - 1 do
  begin
    if ProxiesRoot.Children[i].name = ModelName then
    begin
      ff := (ProxiesRoot.Children[i] as TGLFreeForm);
      Break;
    end;
  end;
  if ff = nil then
  begin
    ff := TGLFreeForm.CreateAsChild(ProxiesRoot);
    ff.MaterialLibrary := MaterialLibrary;
    ff.LoadFromFile(ModelName);
  end;
  Result := proxyClass.Create(nil);
  Result.MasterObject := ff;
end;

// TopDownTextureMaterial
//
function TAirBlastEngine.TopDownTextureMaterial(const ModelName: String;
  const texSize: Integer = 128): TGLLibMaterial;
var
  matName: String;
  bmp: VCL.Graphics.TBitmap;
  s: Single;
begin
  matName := 'TDTM-' + IntToStr(texSize) + '-' + ModelName;
  Result := MaterialLibrary.LibMaterialByName(matName);
  if not Assigned(Result) then
  begin
    bmp := DMToolBox.CreateTopDownTexture(ModelName, texSize, s);
    try
      Result := MaterialLibrary.AddTextureMaterial(matName, bmp);
    finally
      bmp.Free;
    end;
    Result.Tag := Round(s * 1000);
    with Result.Material do
    begin
      BlendingMode := bmTransparency;
      FrontProperties.Ambient.Color := clrBlack;
      FrontProperties.Diffuse.Color := clrBlack;
      Texture.TextureFormat := tfAlpha;
      Texture.TextureMode := tmModulate;
      Texture.TextureWrap := twNone;
    end;
  end;
end;

// SpriteTextureMaterial
//
function TAirBlastEngine.SpriteTextureMaterial(const spriteName: String)
  : TGLLibMaterial;
var
  matName: String;
  gr: TGraphic;
begin
  matName := 'SPRT-' + spriteName;
  Result := MaterialLibrary.LibMaterialByName(matName);
  if not Assigned(Result) then
  begin
    gr := CreateGraphicFromFile('Textures\' + spriteName + '.bmp');
    try
      Result := MaterialLibrary.AddTextureMaterial(matName, gr);
    finally
      gr.Free;
    end;
    with Result.Material do
    begin
      BlendingMode := bmTransparency;
      FrontProperties.Ambient.Color := clrBlack;
      FrontProperties.Diffuse.Color := clrBlack;
      Texture.ImageAlpha := tiaAlphaFromIntensity;
      Texture.TextureFormat := tfAlpha;
      Texture.TextureMode := tmModulate;
      Texture.TextureWrap := twNone;
    end;
  end;
end;

// AddTeam
//
function TAirBlastEngine.AddTeam(const name: String;
  Score: Integer = 0): Integer;
begin
  Result := Length(FTeams);
  SetLength(FTeams, Result + 1);
  FTeams[Result].name := name;
  FTeams[Result].Score := Score;
end;

// TeamCount
//
function TAirBlastEngine.TeamCount: Integer;
begin
  Result := Length(FTeams);
end;

// TeamByName
//
function TAirBlastEngine.TeamByName(const aName: String): TABTeam;
var
  i: Integer;
begin
  for i := 0 to TeamCount - 1 do
  begin
    if Teams[i].name = aName then
    begin
      Result := Teams[i];
      Exit;
    end;
  end;
  Assert(False, 'Team not found ' + aName);
end;

// ClearTeams
//
procedure TAirBlastEngine.ClearTeams;
begin
  SetLength(FTeams, 0);
end;

// TeamScore
//
function TAirBlastEngine.TeamScore(team: Integer;
  scoreDelta: Integer = 0): Integer;
begin
  while TeamCount <= team do
    AddTeam('Team ' + Char(Ord('A') + team));
  Result := FTeams[team].Score + scoreDelta;
  FTeams[team].Score := Result;
end;

// TeamFireRecord
//
function TAirBlastEngine.TeamFireRecord(team: Integer; nb: Integer;
  what: TABFireRecordType): Integer;
begin
  while TeamCount <= team do
    AddTeam('Team ' + Char(Ord('A') + team));
  Result := FTeams[team].FireRecord[what] + nb;
  FTeams[team].FireRecord[what] := Result;
end;

// RatingForScore
//
function TAirBlastEngine.RatingForScore(aScore: Integer): String;
var
  i, p: Integer;
  buf: String;
begin
  if aScore <= 0 then
    Result := 'You were defeated!'
  else
    Result := 'You were victorous!';
  for i := 0 to Ratings.Count - 1 do
  begin
    buf := Ratings.Names[i];
    p := Pos(',', buf);
    if p <= 0 then
      continue;
    if (aScore >= StrToInt(Copy(buf, 1, p - 1))) and
      (aScore <= StrToInt(Copy(buf, p + 1, MaxInt))) then
    begin
      Result := Ratings.Values[buf];
      Break;
    end;
  end;
end;

// EnableUI
//
procedure TAirBlastEngine.EnableUI(const enable: Boolean);
var
  i: Integer;
begin
  FUIDisabled := not enable;
  for i := 0 to MobileCount - 1 do
    if Mobiles[i].Controler is TABControlerUI then
      TABControlerUI(Mobiles[i].Controler).Active := enable;
end;

// AddSpawnPoint
//
function TAirBlastEngine.AddSpawnPoint: TABSpawnPoint;
var
  n: Integer;
begin
  n := Length(FSpawnPoints);
  Result := TABSpawnPoint.Create(Self);
  SetLength(FSpawnPoints, n + 1);
  FSpawnPoints[n] := Result;
end;

// SpawnPointsCount
//
function TAirBlastEngine.SpawnPointsCount: Integer;
begin
  Result := Length(FSpawnPoints);
end;

// SpawnPointByName
//
function TAirBlastEngine.SpawnPointByName(const aName: String): TABSpawnPoint;
var
  i: Integer;
begin
  for i := 0 to High(FSpawnPoints) do
  begin
    Result := FSpawnPoints[i];
    if Result.name = aName then
      Exit;
  end;
  Result := nil;
end;

// ClearSpawnPoints
//
procedure TAirBlastEngine.ClearSpawnPoints;
var
  i: Integer;
begin
  for i := 0 to High(FSpawnPoints) do
    FSpawnPoints[i].Free;
  SetLength(FSpawnPoints, 0);
end;

// ViewerCamForMobile
//
function TAirBlastEngine.ViewerCamForMobile(const MobileName: String)
  : TABViewerCam;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to ViewerCamsCount - 1 do
  begin
    if ViewerCams[i].MobileName = MobileName then
    begin
      Result := ViewerCams[i];
      Break;
    end;
  end;
end;

// CycleCameraForMobile
//
procedure TAirBlastEngine.CycleCameraForMobile(const MobileName: String);
var
  vc: TABViewerCam;
begin
  vc := ViewerCamForMobile(MobileName);
  if Assigned(vc) then
    vc.CycleCamera;
end;

// ------------------
// ------------------ TABEquipment ------------------
// ------------------

// SaveToStrings
//
procedure TABEquipment.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['Model'] := ModelName;
  data.Values['Group'] := GroupName;
end;

// LoadFromStrings
//
procedure TABEquipment.LoadFromStrings(data: TStrings);
begin
  inherited;
  ModelName := data.Values['Model'];
  GroupName := data.Values['Group'];
end;

// PerformPreRenders
//
procedure TABEquipment.PerformPreRenders;
begin
  // nothing
end;

// CreateBufferGLCanvas
//
function TABEquipment.CreateBufferGLCanvas(var rci: TGLRenderContextInfo)
  : TGLCanvas;
var
  buffer: TGLSceneBuffer;
begin
  buffer := TGLSceneBuffer(rci.buffer);
  Result := TGLCanvas.Create(buffer.Width, buffer.Height);
end;

// HUDRender
//
procedure TABEquipment.HUDRender(var rci: TGLRenderContextInfo);
begin
  // nothing by default
end;

// Replenish
//
procedure TABEquipment.Replenish;
begin
  // respawn equipment model
  if (FModel = nil) and (FModelName <> '') and (Airplane <> nil) and
    (Airplane.SyncObject <> nil) then
    SetupSyncObject;
end;

// Deplete
//
procedure TABEquipment.Deplete;
begin
  // nothing
end;

// Selected
//
function TABEquipment.Selected: Boolean;
begin
  Result := (Airplane.CurrentWeaponGroup = GroupName);
end;

// SetupSyncObject
//
procedure TABEquipment.SetupSyncObject;
begin
  Assert(FModel = nil);
  Assert(Airplane <> nil);
  Assert(Airplane.SyncObject <> nil);

  if ModelName <> '' then
  begin
    FModel := Airplane.ABEngine.FreeFormProxy(ModelName);
    Airplane.SyncObject.AddChild(FModel);
    FModel.position.AsVector := position;
    FModel.Direction.AsVector := ZHmgVector;
    FModel.Up.AsVector := YHmgVector;
  end;
end;

// TearDownSyncObject
//
procedure TABEquipment.TearDownSyncObject;
begin
  FModel.Free;
  FModel := nil;
end;

// FirePrimary
//
procedure TABEquipment.FirePrimary;
begin
  // nothing
end;

// FireAlternate
//
procedure TABEquipment.FireAlternate;
begin
  // nothing
end;

// Notification
//
procedure TABEquipment.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  // nothing
end;

// ------------------
// ------------------ TABSpawnEntity ------------------
// ------------------

// Create
//
constructor TABSpawnEntity.Create(aSpawnPoint: TABSpawnPoint);
begin
  inherited Create;
  FSpawnPoint := aSpawnPoint;
  FSpawnedMobiles := TGLPersistentObjectList.Create;
end;

// Destroy
//
destructor TABSpawnEntity.Destroy;
begin
  inherited;
  FSpawnedMobiles.Free;
end;

// Progress
//
procedure TABSpawnEntity.Progress(const deltaTime: Double);
begin
  inherited;
  if (AmountRemaining > 0) and (FSpawnedMobiles.Count < MaxSimultaneous) then
  begin
    FDelayToNextSpawn := FDelayToNextSpawn - deltaTime;
    if DelayToNextSpawn <= 0 then
      SpawnEntity;
  end;
end;

// Notification
//
procedure TABSpawnEntity.Notification(aMobile: TMobile;
  operation: TGameOperation);
begin
  inherited;
  if operation = goRemove then
    FSpawnedMobiles.Remove(aMobile);
end;

// SaveToStrings
//
procedure TABSpawnEntity.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['Type'] := EntityType;
  data.Values['Data'] := EntityData;
  data.Values['Amount'] := IntToStr(amount);
  data.Values['MaxSimultaneous'] := IntToStr(FMaxSimultaneous);
  data.Values['SpawnDelay'] := FloatToStr(FSpawnDelay);
end;

// LoadFromStrings
//
procedure TABSpawnEntity.LoadFromStrings(data: TStrings);
begin
  inherited;
  EntityType := data.Values['Type'];
  EntityData := data.Values['Data'];
  amount := StrToIntDef(data.Values['Amount'], 1);
  AmountRemaining := amount;
  MaxSimultaneous := StrToIntDef(data.Values['MaxSimultaneous'], 1);
  SpawnDelay := StrToFloatDef(data.Values['SpawnDelay'], 1);
  DelayToNextSpawn := StrToFloatDef(data.Values['InitialSpawnDelay'],
    SpawnDelay);
  FCounter := 0;
end;

// SpawnEntity
//
procedure TABSpawnEntity.SpawnEntity;
var
  mobile: TMobile;
  data: TStringList;
begin
  Dec(FAmountRemaining);
  DelayToNextSpawn := SpawnDelay;

  data := TStringList.Create;
  data.CommaText := EntityData;

  Inc(FCounter);

  // spawn the entity...
  if CompareText(EntityType, 'airplane') = 0 then
  begin
    mobile := SpawnPoint.GameEngine.SpawnAirplane(data);
    mobile.position := SpawnPoint.position;
    if MaxSimultaneous > 1 then
      mobile.name := mobile.name + '-' + IntToStr(Counter);
    FSpawnedMobiles.Add(mobile);
  end;

  data.Free;
end;

// ------------------
// ------------------ TABSpawnPoint ------------------
// ------------------

// Create
//
constructor TABSpawnPoint.Create(aGameEngine: TAirBlastEngine);
begin
  inherited Create;
  FGameEngine := aGameEngine;
end;

// Destroy
//
destructor TABSpawnPoint.Destroy;
var
  i: Integer;
begin
  inherited;
  for i := 0 to High(FSpawnEntities) do
    FSpawnEntities[i].Free;
end;

// Progress
//
procedure TABSpawnPoint.Progress(const deltaTime: Double);
var
  i: Integer;
  entity: TABSpawnEntity;
begin
  inherited;
  if GameEngine.Status <> gesPlaying then
    Exit;
  for i := 0 to SpawnEntitiesCount - 1 do
  begin
    entity := SpawnEntities[i];
    if not entity.Disabled then
      entity.Progress(deltaTime);
  end;
end;

// Notification
//
procedure TABSpawnPoint.Notification(aMobile: TMobile;
  operation: TGameOperation);
var
  i: Integer;
begin
  inherited;
  for i := 0 to SpawnEntitiesCount - 1 do
    SpawnEntities[i].Notification(aMobile, operation);
end;

// SaveToStrings
//
procedure TABSpawnPoint.SaveToStrings(data: TStrings);
var
  i: Integer;
begin
  inherited;
  for i := 0 to SpawnEntitiesCount - 1 do
    data.Values['SpawnEntity' + IntToStr(i)] := SpawnEntities[i].SaveToString;
end;

// LoadFromStrings
//
procedure TABSpawnPoint.LoadFromStrings(data: TStrings);
var
  i: Integer;
  buf: String;
  sl: TStringList;
begin
  inherited;
  sl := TStringList.Create;
  i := 0;
  while True do
  begin
    buf := data.Values['SpawnEntity' + IntToStr(i)];
    Inc(i);
    if buf = '' then
      Break;
    sl.CommaText := buf;
    AddSpawnEntity.LoadFromStrings(sl);
  end;
  sl.Free;
end;

// AddSpawnEntity
//
function TABSpawnPoint.AddSpawnEntity: TABSpawnEntity;
var
  n: Integer;
begin
  n := Length(FSpawnEntities);
  Result := TABSpawnEntity.Create(Self);
  SetLength(FSpawnEntities, n + 1);
  FSpawnEntities[n] := Result;
end;

// SpawnEntitiesCount
//
function TABSpawnPoint.SpawnEntitiesCount: Integer;
begin
  Result := Length(FSpawnEntities);
end;

// Replenish
//
procedure TABSpawnPoint.Replenish;
var
  i: Integer;
begin
  for i := 0 to SpawnEntitiesCount - 1 do
    with SpawnEntities[i] do
      AmountRemaining := amount;
end;

// Exhausted
//
function TABSpawnPoint.Exhausted: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to SpawnEntitiesCount - 1 do
    with SpawnEntities[i] do
      if (AmountRemaining > 0) or (FSpawnedMobiles.Count = MaxSimultaneous) then
      begin
        Result := False;
        Break;
      end;
end;

// ------------------
// ------------------ TABViewerCam ------------------
// ------------------

// Create
//
constructor TABViewerCam.Create;
begin
  inherited;
  SetVector(FChaseOffset, 0, 3, -30);
  FTension := 0.99;
  FFreeDirection := XVector;
  FFreeDirectionTracker := FFreeDirection;
end;

// Destroy
//
destructor TABViewerCam.Destroy;
begin
  inherited;
  TearDownSyncObject;
end;

// SetupSyncObject
//
procedure TABViewerCam.SetupSyncObject;
begin
  if ViewerBuffer = nil then
    Exit;
  Assert(FCamera = nil);

  FDCTracker := TGLDummyCube.CreateAsChild(GameEngine.SceneRoot);
  FCamera := TGLCamera.CreateAsChild(FDCTracker);
  FCamera.DepthOfView := 80000;
  FCamera.CameraStyle := csInfinitePerspective;
  ViewerBuffer.BeforeRender := ViewerBeforeRender;
  ViewerBuffer.WrapUpRendering := ViewerWrapUpRender;
  ViewerBuffer.AfterRender := ViewerAfterRender;
  ViewerBuffer.Camera := FCamera;
end;

// TearDownSyncObject
//
procedure TABViewerCam.TearDownSyncObject;
begin
  ViewerBuffer.Camera := nil;
  FDCTracker.Free;
  FDCTracker := nil;
  FCamera := nil;
end;

// SetViewerBuffer
//
procedure TABViewerCam.SetViewerBuffer(newBuf: TGLSceneBuffer);
begin
  if ViewerBuffer <> nil then
    TearDownSyncObject;
  FViewerBuffer := newBuf;
  if ViewerBuffer <> nil then
    SetupSyncObject;
end;

// ViewerBeforeRender
//
procedure TABViewerCam.ViewerBeforeRender(Sender: TObject);
var
  mobile: TMobile;
begin
  if CamMode = vcmCockpit then
  begin
    mobile := GameEngine.MobileByName(MobileName);
    if (mobile is TABAirplane) then
      TABAirplane(mobile).SetModelVisible(False);
  end;
end;

// ViewerWrapUpRender
//
procedure TABViewerCam.ViewerWrapUpRender(Sender: TObject;
  var rci: TGLRenderContextInfo);
var
  player: TABAirplane;
  Canvas: TGLCanvas;
begin
  Assert(CurrentGLContext <> nil);
  if GameEngine.Status = gesPlaying then
  begin
    HUDRender(rci);
    player := TABAirplane(GameEngine.MobileByName('Player'));
    if (player <> nil) and (player.ClassType = TABAirplane) then
    begin
      Canvas := TGLCanvas.Create(1024, 768);
      player.RenderMessageLog(rci, Canvas);
      Canvas.Free;
    end;
  end;
end;

// ViewerAfterRender
//
procedure TABViewerCam.ViewerAfterRender(Sender: TObject);
var
  mobile: TMobile;
begin
  mobile := GameEngine.MobileByName(MobileName);
  if (mobile is TABAirplane) then
    TABAirplane(mobile).SetModelVisible(True);
end;

// Progress
//
procedure TABViewerCam.Progress(const deltaTime: Double);
var
  targetFocal, f: Single;
  mobile, target: TMobile;
  locCamMode: TViewerCamMode;
  terrain: TGLTerrainRenderer;
  camAbs: TGLVector;
begin
  if Camera = nil then
    Exit;

  if CamMode = vcmCockpit then
    targetFocal := ViewerBuffer.Height * (70 / 600)
  else
    targetFocal := ViewerBuffer.Height * (70 / 600);
  FCamera.FocalLength := Lerp(FCamera.FocalLength, targetFocal, 0.05);

  if not POVActive then
    f := 0
  else
  begin
    if POV > 180 then
      f := POV - 360
    else if (POV = 180) and (FPOVTracker < 0) then
      f := -180
    else
      f := POV
  end;
  FPOVTracker := Lerp(f, FPOVTracker, 0.95);

  mobile := GameEngine.MobileByName(MobileName);
  locCamMode := CamMode;
  if mobile = nil then
  begin
    mobile := GameEngine.MobileByName(MobileName + '-Agonizing');
    if (mobile <> nil) and (CamMode in [vcmCockpit, vcmChase]) then
      locCamMode := vcmDeathCam;
  end;
  if mobile <> nil then
  begin
    FDCTracker.position.SetPoint(mobile.position);
    FDCTracker.Direction.SetVector(mobile.Direction);
    FDCTracker.Up.SetVector(mobile.Up);
    FCamera.Direction.AsAffineVector := ZVector;
    FCamera.Up.AsAffineVector := YVector;
    case locCamMode of
      vcmCockpit:
        begin
          if Abs(FPOVTracker) > 1 then
            FCamera.Turn(FPOVTracker);
          FCamera.position.SetToZero;
          FCamera.TargetObject := nil;
        end;
      vcmChase:
        begin
          FCamera.position.SetPoint(ChaseOffset);
          FCamera.TargetObject := nil;
        end;
      vcmTarget:
        begin
          if mobile is TABAirplane then
            target := TABAirplane(mobile).CurrentTarget
          else
            target := nil;
          if Assigned(target) and (TABAirplane(mobile).SyncObject <> nil) then
          begin
            FCamera.position.AsVector := FDCTracker.AbsoluteToLocal
              (target.position);
            FCamera.position.AddScaledVector(40,
              VectorNormalize(FCamera.position.AsAffineVector));
            FCamera.position.AddScaledVector(4,
              FDCTracker.AbsoluteToLocal(ZHmgVector));
            FCamera.TargetObject := TABAirplane(mobile).SyncObject;
            FCamera.Up.AsAffineVector := ZVector;
          end
          else
            FCamMode := vcmCockpit;
        end;
      vcmFreeTarget:
        begin
          FDCTracker.position.AsVector := NullHmgPoint;
          FDCTracker.ResetRotations;
          FCamera.Up.AsAffineVector := ZVector;
          FCamera.position.SetPoint(VectorLerp(FreePosition,
            FCamera.position.AsAffineVector, Tension));
          if (mobile is TABAirplane) then
          begin
            FCamera.TargetObject := TABAirplane(mobile).SyncObject;
            SetVector(FFreeDirectionTracker,
              VectorNormalize(VectorSubtract(mobile.position,
              FCamera.absolutePosition)));
          end
          else
          begin
            FFreeDirectionTracker := VectorLerp(FreeDirection,
              FFreeDirectionTracker, Tension);
            FCamera.Direction.SetVector(FFreeDirectionTracker);
          end;
        end;
      vcmVanity:
        begin
          FCamera.TargetObject := nil;
          FVanity := VectorLerp(VanityOffset, FVanity, Tension);
          FCamera.position.SetPoint(VectorLerp(ChaseOffset,
            FCamera.position.AsAffineVector, Tension));
          FCamera.Up.AsAffineVector := YVector;
          FCamera.Direction.SetVector(VectorSubtract(FVanity,
            FCamera.position.AsAffineVector));
        end;
      vcmDeathCam:
        begin
          FCamera.TargetObject := nil;
          f := FCamera.position.VectorLength;
          if f < 1 then
            FCamera.position.SetPoint(10, 10, 10);
          // VectorScale(mobile.LeftVector, 5*Sign(Random-0.5)));
          if f < 500 then
            FCamera.position.scale(1.02);
          FDCTracker.Up.SetVector(ZVector);
          FCamera.position.Rotate(YVector, deltaTime * 0.5);
          FCamera.Up.AsAffineVector := YVector;
          FCamera.Direction.SetVector(VectorSubtract(NullHmgVector,
            FCamera.position.AsVector));
        end;
    end;
  end
  else
  begin
    if CamMode = vcmFreeTarget then
    begin
      FCamera.Up.AsAffineVector := ZVector;
      FCamera.position.SetPoint(VectorLerp(FreePosition,
        FCamera.position.AsAffineVector, Tension));
      FFreeDirectionTracker := VectorLerp(FreeDirection,
        FFreeDirectionTracker, Tension);
      FCamera.Direction.SetVector(FFreeDirectionTracker);
    end;
  end;
  camAbs := FCamera.absolutePosition;
  terrain := (GameEngine as TAirBlastEngine).TerrainRenderer;
  f := terrain.InterpolatedHeight(camAbs) + 30;
  if camAbs.Z < f then
  begin
    camAbs.Z := f;
    FCamera.absolutePosition := camAbs;
  end;
end;

// CycleCamera
//
procedure TABViewerCam.CycleCamera;
begin
  case CamMode of
    vcmCockpit:
      CamMode := vcmChase;
    vcmChase:
      CamMode := vcmTarget;
  else
    CamMode := vcmCockpit;
  end;
end;

// HUDRender
//
procedure TABViewerCam.HUDRender(var rci: TGLRenderContextInfo);
var
  mobile: TMobile;
  Canvas: TGLCanvas;
  i, W, t: Integer;
  x, y: Integer;
  buf: String;
  sunBlind: Single;
begin
  mobile := GameEngine.MobileByName(MobileName);
  case CamMode of
    vcmCockpit:
      begin
        if mobile is TABAirplane then
        begin
          TABAirplane(mobile).EquipementsHUDRender(rci);
          sunBlind := VectorDotProduct(mobile.Direction,
            VectorNormalize(VectorMake(-10000, 6250, 5600, 0)));
          if sunBlind > 0.90 then
          begin
            sunBlind := Sqrt((sunBlind - 0.90) * 9);
            if sunBlind > 0.05 then
            begin
              Canvas := TGLCanvas.Create(1024, 768);
              Canvas.PenColor := clWhite;
              Canvas.PenAlpha := sunBlind;
              Canvas.FillRect(0, 0, 1024, 768);
              Canvas.Free;
            end;
          end;
        end;
      end;
    vcmChase, vcmTarget:
      if mobile <> nil then
      begin
        Canvas := TGLCanvas.Create(1024, 768);
        with GameEngine.BigFont do
        begin
          W := TextWidth(cViewerCamModeName[CamMode]) div 2;
          TextOut(rci, 512 - W, 695, cViewerCamModeName[CamMode], clWhite);
          if (CamMode = vcmTarget) and (mobile is TABAirplane) and
            (TABAirplane(mobile).CurrentTarget <> nil) then
          begin
            buf := TABAirplane(mobile).CurrentTarget.name;
            TextOut(rci, 512 - TextWidth(buf) div 2, 730, buf, clWhite);
          end;
        end;
        Canvas.Free;
      end;
  end;
  if GameEngine.GameEndCountDown <> 0 then
  begin
    Canvas := TGLCanvas.Create(1024, 768);
    with GameEngine.BigFont do
    begin
      t := Trunc(GameEngine.GameEndCountDown);
      buf := Format('- %.2d:%.2d -', [t div 60, t mod 60]);
      W := TextWidth(buf);
      TextOut(rci, 512 - W div 2, 10, buf, clWhite);
    end;
    Canvas.Free;
  end;
  if GameEngine.TeamCount > 1 then
  begin
    Canvas := TGLCanvas.Create(1600, 1200);
    for i := 0 to GameEngine.TeamCount - 1 do
    begin
      x := 1150 + (i and 1) * 200;
      y := 10 + (i shr 1) * 20;
      with GameEngine.Teams[i] do
        buf := Format('%.3d %s', [Score, Name]);
      GameEngine.BigFont.TextOut(rci, x, y, buf, clWhite);
    end;
    Canvas.Free;
  end;
end;

// SetCamMode
//
procedure TABViewerCam.SetCamMode(const modeName: String);
var
  mode: TViewerCamMode;
begin
  for mode := Low(cViewerCamModeName) to High(cViewerCamModeName) do
  begin
    if modeName = cViewerCamModeName[mode] then
    begin
      CamMode := mode;
      Exit;
    end;
  end;
  Assert(False, 'Unknown CamMode ' + modeName);
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

RegisterEquipmentClass(TABEquipment);

finalization

FreeAndNil(vRegisteredEquipments);

end.
