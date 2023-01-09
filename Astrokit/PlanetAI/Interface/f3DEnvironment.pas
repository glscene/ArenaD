unit f3DEnvironment;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  System.Contnrs,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Menus,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.ToolWin,
  Vcl.Graphics,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,

  // AIPlanet
  cAIEnvironment,
  cAISatellites,
  cAISpace,
  vInterfaceClasses,
  cAITrees,
  cAIGrid,
  cAIFish,
  cAIBird,
  cAICoordinates,
  cAIExplosions,
  cAIBot,
  cAIEnvironmentStructures,
  cAIPosition,
  cAICrab,
  cAIHawk,
  cAITrex,
  cAIGrazer,
  cAIVibes,
  cAITool,
  cUtilities,
  cAIWeather,
  cAIShark,
  cAITurtle,
  cAITerrier,
  cAIFox,
  cAIRabbit,
  cAIGrass,
  cAIMouse,
  cAITiger,
  cAIDuck,
  cAIDolphin,
  cAIThings,
  cAILadybug,
  cAIFireTree,
  cAIMissileDefence,
  cAIAnt,
  cAIEvolvingTrees,
  // JVCL
  // JvEdit,
  // JvTypedEdit,

  GLS.PersistentClasses,
  GLS.VectorTypes,
  GLS.ScreenSaver,
  GLS.VectorGeometry,
  GLS.VectorLists,
  GLS.Scene,
  GLS.Objects,
  GLS.Texture,
  GLS.Material,
  GLS.Cadencer,
  GLS.SceneViewer,
  GLS.Color,
  GLS.ShadowVolume,
  GLS.Octree,
  GLS.Keyboard,
  GLS.FireFX,
  GLS.SkyDome,
  GLS.Mesh,
  GLS.VectorFileObjects,
  GLS.Particles,
  GLS.ParticleFX,
  GLS.SoundManager,
  GLS.HUDObjects,
  GLS.BitmapFont,
  GLS.WindowsFont,
  GLS.zBuffer,
  GLS.ThorFX,
  GLS.Selection,
  GLS.ProxyObjects,
  GLS.XCollection,
  GLS.File3DS,
  GLS.SoundFileObjects,
  Sounds.BASS,

  GLS.AVIRecorder,
  GLS.Coordinates,
  GLS.BaseClasses;

const
  cHeightDivision = 10;
  cFlatHeightDivision = 1;
  cTexSea = 0;
  cTexOcean = 1;
  cTexLake = 2;
  cTexPond = 3;
  cTexGrass = 4;
  cTexField = 8;
  cTexDirt = 6;
  cTexDesert = 7;
  cTexMoss = 5;
  cTexRock = 9;
  cTexGrassLake = 10;
  cTexSeaLake = 11;
  cTexGrassDesert = 12;
  cTexSeaOcean = 13;
  cTexRockLake = 14;
  cShadowDistance = 30;

type
  Tfm3DEnvironment = class(TForm)
    GLScene: TGLScene;
    GLCamera: TGLCamera;
    GLCadencer: TGLCadencer;
    GLSceneViewer: TGLSceneViewer;
    GLMaterialLibrary: TGLMaterialLibrary;

    PlanetModel: TGLFreeForm;
    MoonModel: TGLFreeForm;
    SunModel: TGLFreeForm;
    AsteroidModel: TGLFreeForm;
    Atmosphere: TGLFreeForm;
    SunAsteroidModel: TGLFreeForm;
    MoonAsteroidModel: TGLFreeForm;
    RainModel: TGLFreeForm;

    SkyDome: TGLSkyDome;
    GalaxyCube: TGLDummyCube;
    ProxyCube: TGLDummyCube;
    PlanetCursor: TGLSphere;
    AppleTreeModel: TGLFreeForm;
    CloudModel: TGLFreeForm;
    AppleModel: TGLFreeForm;
    OrangeModel: TGLFreeForm;
    SeedModel: TGLFreeForm;
    ModelCube: TGLDummyCube;
    FloatCube: TGLDummyCube;
    OrangeTreeModel: TGLFreeForm;
    CloudCube: TGLDummyCube;
    SatellitesCube: TGLDummyCube;
    LightsCube: TGLDummyCube;
    SpiritModel: TGLFreeForm;
    SpiritCube: TGLDummyCube;
    FlashLight: TGLLightSource;
    tbAtmosphere: TToolBar;
    panTools: TPanel;
    tbWater: TToolBar;
    tbWateringCan: TToolButton;
    tbSponge: TToolButton;
    ToolButton2: TToolButton;
    Panel4: TPanel;
    edWater: TEdit;
    panMenus: TPanel;
    StatusBar: TStatusBar;
    Panel2: TPanel;

    WaterUpDown: TUpDown;
    ToolButton3: TToolButton;
    tbHeat: TToolButton;
    tbCold: TToolButton;
    tbHumidifier: TToolButton;
    tbDehumidifier: TToolButton;
    tbCloud: TToolButton;
    tbGalaxy: TToolBar;
    tbBuildSun: TToolButton;
    tbBuildMoon: TToolButton;
    tbSettings: TToolBar;
    tbTools: TToolBar;
    tbStickyFit: TToolButton;
    tbShowCursor: TToolButton;
    tbFlashlight: TToolButton;
    tbFullscreen: TToolButton;
    tbAsteroid: TToolButton;
    ToolButton4: TToolButton;
    tbVisuals: TToolBar;
    tbShowClouds: TToolButton;
    tbShowSatellites: TToolButton;
    tbShowStars: TToolButton;
    tbShowWater: TToolButton;
    FishModel: TGLFreeForm;
    tbSpirits: TToolBar;
    tbSpiritGuy: TToolButton;
    FPSTimer: TTimer;
    WaterFastUpDown: TUpDown;
    tbSnapshot: TToolButton;
    ToolButton6: TToolButton;
    tbSplash: TToolButton;
    tbShowAtmosphere: TToolButton;
    ToolButton10: TToolButton;
    GLSoundLibrary: TGLSoundLibrary;
    SoundSystem: TGLDummyCube;
    GLPolygonPFXManager1: TGLPolygonPFXManager;
    SeedCube: TGLDummyCube;
    FruitCube: TGLDummyCube;
    ForestCube: TGLDummyCube;
    panMainMenu: TPanel;
    tbPlanet: TToolBar;
    tbGalaxyMenu: TToolButton;
    tbWaterMenu: TToolButton;
    tbLandMenu: TToolButton;
    tbAtmosphereMenu: TToolButton;
    tbFaunaMenu: TToolButton;
    tbCreaturesMenu: TToolButton;
    tbSpiritsMenu: TToolButton;
    tbCameraMenu: TToolButton;
    tbVisualsMenu: TToolButton;
    tbSettingsMenu: TToolButton;
    tbToolsMenu: TToolButton;
    ToolButton7: TToolButton;
    tbCameras: TToolBar;
    tbTrackSun: TToolButton;
    tbTrackMoon: TToolButton;
    tbTrackBird: TToolButton;
    tbTrackFish: TToolButton;
    tbTrackApple: TToolButton;
    tbTrackOrange: TToolButton;
    tbTrackCloud: TToolButton;
    tbTrackAsteroid: TToolButton;
    tbTrackSpirit: TToolButton;
    Label1: TLabel;
    ToolButton14: TToolButton;
    WaterBubble: TGLActor;
    BombModel: TGLFreeForm;
    CrabModel: TGLFreeForm;
    HawkModel: TGLFreeForm;
    GrazerModel: TGLFreeForm;
    TrexModel: TGLFreeForm;
    WeaponModel: TGLFreeForm;
    ShellModel: TGLFreeForm;
    BirdModels: TGLDummyCube;
    BirdFlap1: TGLFreeForm;
    BirdFlap2: TGLFreeForm;
    BirdFlap3: TGLFreeForm;
    BirdFlap4: TGLFreeForm;
    BirdSit: TGLFreeForm;
    BirdDead: TGLFreeForm;
    ExplosionModel: TGLFreeForm;
    tbSpherical: TToolButton;
    tbTrackCrab: TToolButton;
    tbTrackTrex: TToolButton;
    tbTrackGrazer: TToolButton;
    tbTrackHawk: TToolButton;
    tbTrackBall: TToolButton;
    Label4: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label5: TLabel;
    TrackLines: TGLLines;
    PredictLines: TGLLines;
    tbStormCloud: TToolButton;
    SharkModel: TGLFreeForm;
    tbTrackShark: TToolButton;
    tbTrackTurtle: TToolButton;
    TurtleModel: TGLFreeForm;
    Label8: TLabel;
    tbBall: TToolButton;
    tbBeaconDrain: TToolButton;
    tbBeaconBubble: TToolButton;
    imgDefaultTexture: TImage;
    BeaconModel: TGLFreeForm;
    TerrierModel: TGLFreeForm;
    tbTrackTerrier: TToolButton;
    EffectsCube: TGLDummyCube;
    tbControlBot: TToolButton;
    FoxModel: TGLFreeForm;
    RabbitModel: TGLFreeForm;
    GrassModel: TGLFreeForm;
    tbTrackFox: TToolButton;
    tbTrackRabbit: TToolButton;
    IcebergModel: TGLFreeForm;
    tbIceberg: TToolButton;
    SnowModel: TGLFreeForm;
    MouseModel: TGLFreeForm;
    TigerModel: TGLFreeForm;
    DuckModel: TGLFreeForm;
    Dolphins: TGLDummyCube;
    Dolphin1: TGLFreeForm;
    Dolphin2: TGLFreeForm;
    Dolphin3: TGLFreeForm;
    tbTrackTiger: TToolButton;
    tbTrackDuck: TToolButton;
    tbTrackDolphin: TToolButton;
    FishModels: TGLDummyCube;
    FishGirlModel: TGLFreeForm;
    AquaPlant: TGLFreeForm;
    Plants: TGLDummyCube;
    Tools: TGLDummyCube;
    WeatherCube: TGLDummyCube;
    tbUse1: TToolButton;
    tbFakeSun: TToolButton;
    tbBeaconOrange: TToolButton;
    tbUse2: TToolButton;
    tbUse3: TToolButton;
    tbUse4: TToolButton;
    tbUse5: TToolButton;
    tbKick: TToolButton;
    tbGrab: TToolButton;
    tbDrop: TToolButton;
    tbThrow: TToolButton;
    tbEat: TToolButton;
    tbObjectMenu: TToolButton;
    GLObjectText: TGLHUDText;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    Splitter3D: TSplitter;
    Animals: TGLDummyCube;
    Dolphin4: TGLFreeForm;
    cbAutoSnap: TCheckBox;
    tbBonk: TToolButton;
    tbGive: TToolButton;
    HUDCube: TGLDummyCube;
    LadyBugModel: TGLFreeForm;
    AntModel1: TGLFreeForm;
    tbBeaconApple: TToolButton;
    Ants: TGLDummyCube;
    AntModel2: TGLFreeForm;
    AntModel3: TGLFreeForm;
    CloudModelOld: TGLFreeForm;
    tbCameraLight: TToolButton;
    CameraLight: TGLLightSource;
    tbTrackLadybug: TToolButton;
    tbTrackAnt: TToolButton;
    tbRepeat: TToolButton;
    EvolvingTree: TGLFreeForm;
    EvolvingFruit: TGLFreeForm;
    EvolvingSeed: TGLFreeForm;
    ToolButton9: TToolButton;
    GLShadowVolume: TGLShadowVolume;
    tbVolumes: TToolButton;
    tbComplexify: TToolButton;
    tbPopBeacon: TToolButton;
    tbAudioMenu: TToolButton;
    tbAudio: TToolBar;
    Label32: TLabel;
    Label26: TLabel;
    tbTrackLines: TToolButton;
    tbPredictions: TToolButton;
    cbTrackNewThings: TCheckBox;
    Label31: TLabel;
    Label33: TLabel;
    tbVolume: TTrackBar;
    tbRestoreParent: TToolButton;
    cboxThings: TComboBox;
    AVIRecorder: TGLAVIRecorder;
    tbAVIMovie: TToolButton;
    FireTree: TGLFreeForm;
    tbRainCloud: TToolButton;
    tbSpeeches: TToolButton;
    tbShowFire: TToolButton;
    tbAVIFrame: TToolButton;
    tbAVIDirect: TToolButton;
    tbMissileDefence: TToolButton;
    ToolButton11: TToolButton;
    panCamera: TPanel;
    tbViews: TToolBar;
    tbCameraPlanet: TToolButton;
    tbFloatCamera: TToolButton;
    tbCameraTarget: TToolButton;
    tbCameraEyes: TToolButton;
    tbCameraGalaxy: TToolButton;
    tbCameraSatellite: TToolButton;
    tbCameraAvatar: TToolButton;
    tbZoomIn: TToolButton;
    tbZoomOut: TToolButton;
    tbPriorTarget: TToolButton;
    tbNextTarget: TToolButton;
    tbDisastersMenu: TToolButton;
    tbDisasters: TToolBar;
    tbLifeKiller: TToolButton;
    tbThingCeaser: TToolButton;
    tbPlantRemover: TToolButton;
    tbLightning: TToolButton;
    tbEarthquake: TToolButton;
    MissileDefence: TGLFreeForm;
    Missile: TGLFreeForm;
    Label19: TLabel;
    panSelect: TPanel;
    tbObjects: TToolBar;
    tbMouseView: TToolButton;
    Label22: TLabel;
    Label23: TLabel;
    tbHeal: TToolButton;
    tbHarm: TToolButton;
    tbDie: TToolButton;
    tbCease: TToolButton;
    Label30: TLabel;
    tbExtinction: TToolButton;
    tbJump: TToolButton;
    tbPerform0: TToolButton;
    tbPerform1: TToolButton;
    tbPerform2: TToolButton;
    tbPerform3: TToolButton;
    tbPerform4: TToolButton;
    tbPerform5: TToolButton;
    tbReport: TToolButton;
    tbReportAll: TToolButton;
    tbTrackWindow: TToolButton;
    ToolBar1: TToolBar;
    tbSelect: TToolButton;
    tbMove: TToolButton;
    Label20: TLabel;
    tbShadows: TToolButton;
    Label25: TLabel;
    Label34: TLabel;
    ToolButton5: TToolButton;
    panCreatures: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    tbCreatures: TToolBar;
    tbBird: TToolButton;
    tbFish: TToolButton;
    tbDuck: TToolButton;
    tbLadybug: TToolButton;
    tbHawk: TToolButton;
    tbTurtle: TToolButton;
    tbCrab: TToolButton;
    tbShark: TToolButton;
    tbAnt: TToolButton;
    tbGrazer: TToolButton;
    tbTrex: TToolButton;
    tbRabbit: TToolButton;
    tbTiger: TToolButton;
    tbMouse: TToolButton;
    tbTerrier: TToolButton;
    tbDolphin: TToolButton;
    tbFox: TToolButton;
    tbCreatureDeath: TToolButton;
    panLand: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    panFauna: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    tbLand: TToolBar;
    tbRaiseLand: TToolButton;
    tbLowerLand: TToolButton;
    tbMountain: TToolButton;
    tbValley: TToolButton;
    tbFlattenLand: TToolButton;
    tbLandDesert: TToolButton;
    tbLandDirt: TToolButton;
    tbLandField: TToolButton;
    tbLandGrass: TToolButton;
    tbWaterSea: TToolButton;
    tbFauna: TToolBar;
    tbPlantForest: TToolButton;
    tbEvolvingTree: TToolButton;
    tbAppleTree: TToolButton;
    tbOrangeTree: TToolButton;
    tbAquaPlant: TToolButton;
    tbGrass: TToolButton;
    tbFireTree: TToolButton;
    tbApple: TToolButton;
    tbEvolvingFruit: TToolButton;
    tbOrange: TToolButton;
    tbAppleSeed: TToolButton;
    tbOrangeSeed: TToolButton;
    tbEvolvingSeed: TToolButton;
    tbPlantClearer: TToolButton;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    tbBotSelect: TToolButton;
    tbHighDetail: TToolButton;
    Panel5: TPanel;
    Panel8: TPanel;
    tbNextKind: TToolButton;
    GLBass: TGLSMBASS;
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure tbWateringCanClick(Sender: TObject);
    procedure tbBuildMoonClick(Sender: TObject);
    procedure GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbBuildSunClick(Sender: TObject);
    procedure tbSpongeClick(Sender: TObject);
    procedure tbRaiseLandClick(Sender: TObject);
    procedure tbLowerLandClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FPSTimerTimer(Sender: TObject);
    procedure tbAppleTreeClick(Sender: TObject);
    procedure tbCloudClick(Sender: TObject);
    procedure tbAppleClick(Sender: TObject);
    procedure tbOrangeClick(Sender: TObject);
    procedure GLCadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure tbOrangeTreeClick(Sender: TObject);
    procedure tbOrangeSeedClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbFlattenLandClick(Sender: TObject);
    procedure tbMountainClick(Sender: TObject);
    procedure tbHeatClick(Sender: TObject);
    procedure tbAddRemoveWaterClick(Sender: TObject);
    procedure tbLandDesertClick(Sender: TObject);
    procedure tbLandDirtClick(Sender: TObject);
    procedure tbLandFieldClick(Sender: TObject);
    procedure tbLandGrassClick(Sender: TObject);
    procedure tbWaterSeaClick(Sender: TObject);
    procedure tbValleyClick(Sender: TObject);
    procedure tbColdClick(Sender: TObject);
    procedure tbHumidifierClick(Sender: TObject);
    procedure tbDehumidifierClick(Sender: TObject);
    procedure tbWaterMenuClick(Sender: TObject);
    procedure tbFaunaMenuClick(Sender: TObject);
    procedure tbLandMenuClick(Sender: TObject);
    procedure tbAtmosphereMenuClick(Sender: TObject);
    procedure tbGalaxyMenuClick(Sender: TObject);
    procedure tbCameraMenuClick(Sender: TObject);
    procedure tbSettingsMenuClick(Sender: TObject);
    procedure tbToolsMenuClick(Sender: TObject);
    procedure tbCameraPlanetClick(Sender: TObject);
    procedure tbCameraSatelliteClick(Sender: TObject);
    procedure tbCameraGalaxyClick(Sender: TObject);
    procedure tbAppleSeedClick(Sender: TObject);
    procedure tbOctreeClick(Sender: TObject);
    procedure tbShowCloudsClick(Sender: TObject);
    procedure tbShowSatellitesClick(Sender: TObject);
    procedure tbShowStarsClick(Sender: TObject);
    procedure tbStickyFitClick(Sender: TObject);
    procedure tbShowCursorClick(Sender: TObject);
    procedure tbFlashlightClick(Sender: TObject);
    procedure tbFullscreenClick(Sender: TObject);
    procedure tbCustomSunClick(Sender: TObject);
    procedure tbCustomMoonClick(Sender: TObject);
    procedure tbShowWaterClick(Sender: TObject);
    procedure tbVisualsMenuClick(Sender: TObject);
    procedure WaterUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure tbCreaturesMenuClick(Sender: TObject);
    procedure tbFishClick(Sender: TObject);
    procedure tbSpiritsMenuClick(Sender: TObject);
    procedure tbSpiritGuyClick(Sender: TObject);
    procedure tbSpiritGirlClick(Sender: TObject);
    procedure WaterFastUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure tbSnapshotClick(Sender: TObject);
    procedure tbBirdClick(Sender: TObject);
    procedure tbSplashClick(Sender: TObject);
    procedure tbStabalizeClick(Sender: TObject);
    procedure tbCameraAvatarClick(Sender: TObject);
    procedure tbShowAtmosphereClick(Sender: TObject);
    procedure tbAsteroidClick(Sender: TObject);
    procedure tbCameraTargetClick(Sender: TObject);
    procedure tbPriorTargetClick(Sender: TObject);
    procedure tbNextTargetClick(Sender: TObject);
    procedure tbTrackSunClick(Sender: TObject);
    procedure tbTrackMoonClick(Sender: TObject);
    procedure tbTrackBirdClick(Sender: TObject);
    procedure tbTrackFishClick(Sender: TObject);
    procedure tbTrackAppleClick(Sender: TObject);
    procedure tbTrackOrangeClick(Sender: TObject);
    procedure tbTrackCloudClick(Sender: TObject);
    procedure tbTrackAsteroidClick(Sender: TObject);
    procedure tbTrackSpiritClick(Sender: TObject);
    procedure tbControlBotClick(Sender: TObject);
    procedure tbBotPickupClick(Sender: TObject);
    procedure tbBotThrowClick(Sender: TObject);
    procedure tbCrabClick(Sender: TObject);
    procedure tbTrexClick(Sender: TObject);
    procedure tbGrazerClick(Sender: TObject);
    procedure tbHawkClick(Sender: TObject);
    procedure tbBallClick(Sender: TObject);
    procedure tbCubeClick(Sender: TObject);
    procedure tbWeaponClick(Sender: TObject);
    procedure cbTrackNewThingsClick(Sender: TObject);
    procedure tbSphericalClick(Sender: TObject);
    procedure tbTrackCrabClick(Sender: TObject);
    procedure tbTrackTrexClick(Sender: TObject);
    procedure tbTrackGrazerClick(Sender: TObject);
    procedure tbTrackHawkClick(Sender: TObject);
    procedure tbTrackBallClick(Sender: TObject);
    procedure tbPlantForestClick(Sender: TObject);
    procedure tbStormCloudClick(Sender: TObject);
    procedure tbSharkClick(Sender: TObject);
    procedure tbTurtleClick(Sender: TObject);
    procedure tbTrackSharkClick(Sender: TObject);
    procedure tbTrackTurtleClick(Sender: TObject);
    procedure tbBeaconBubbleClick(Sender: TObject);
    procedure tbBeaconDrainClick(Sender: TObject);
    procedure tbTerrierClick(Sender: TObject);
    procedure tbTrackTerrierClick(Sender: TObject);
    procedure tbRabbitClick(Sender: TObject);
    procedure tbFoxClick(Sender: TObject);
    procedure tbGrassClick(Sender: TObject);
    procedure tbTrackFoxClick(Sender: TObject);
    procedure tbTrackRabbitClick(Sender: TObject);
    procedure tbIcebergClick(Sender: TObject);
    procedure tbMouseClick(Sender: TObject);
    procedure tbTigerClick(Sender: TObject);
    procedure tbDuckClick(Sender: TObject);
    procedure tbDolphinClick(Sender: TObject);
    procedure tbCeaseClick(Sender: TObject);
    procedure tbTrackWindowClick(Sender: TObject);
    procedure tbTrackTigerClick(Sender: TObject);
    procedure tbTrackDuckClick(Sender: TObject);
    procedure tbTrackDolphinClick(Sender: TObject);
    procedure tbAquaPlantClick(Sender: TObject);
    procedure tbFakeSunClick(Sender: TObject);
    procedure tbBeaconOrangeClick(Sender: TObject);
    procedure tbSelectClick(Sender: TObject);
    procedure tbObjectMenuClick(Sender: TObject);
    procedure tbDieClick(Sender: TObject);
    procedure tbHealClick(Sender: TObject);
    procedure tbPerform1Click(Sender: TObject);
    procedure tbPerform0Click(Sender: TObject);
    procedure tbPerform2Click(Sender: TObject);
    procedure tbPerform3Click(Sender: TObject);
    procedure tbPerform4Click(Sender: TObject);
    procedure tbPerform5Click(Sender: TObject);
    procedure tbExtinctionClick(Sender: TObject);
    procedure GLSceneViewerDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tbGrabClick(Sender: TObject);
    procedure tbDropClick(Sender: TObject);
    procedure tbKickClick(Sender: TObject);
    procedure tbThrowClick(Sender: TObject);
    procedure tbEatClick(Sender: TObject);
    procedure tbUse1Click(Sender: TObject);
    procedure tbBonkClick(Sender: TObject);
    procedure tbGiveClick(Sender: TObject);
    procedure tbUse2Click(Sender: TObject);
    procedure tbUse3Click(Sender: TObject);
    procedure tbUse4Click(Sender: TObject);
    procedure tbUse5Click(Sender: TObject);
    procedure GLSceneViewerMouseEnter(Sender: TObject);
    procedure tbLadybugClick(Sender: TObject);
    procedure tbAntClick(Sender: TObject);
    procedure tbZoomInClick(Sender: TObject);
    procedure tbZoomOutClick(Sender: TObject);
    procedure tbBeaconAppleClick(Sender: TObject);
    procedure tbCameraLightClick(Sender: TObject);
    procedure tbFloatCameraClick(Sender: TObject);
    procedure GLSceneViewerMouseLeave(Sender: TObject);
    procedure tbTrackLadybugClick(Sender: TObject);
    procedure tbTrackAntClick(Sender: TObject);
    procedure tbEvolvingTreeClick(Sender: TObject);
    procedure tbEvolvingFruitClick(Sender: TObject);
    procedure tbEvolvingSeedClick(Sender: TObject);
    procedure tbJumpClick(Sender: TObject);
    procedure tbMoveClick(Sender: TObject);
    procedure tbVolumesClick(Sender: TObject);
    procedure tbComplexifyClick(Sender: TObject);
    procedure tbVolumeChange(Sender: TObject);
    procedure tbTrackLinesClick(Sender: TObject);
    procedure tbPredictionsClick(Sender: TObject);
    procedure tbPopBeaconClick(Sender: TObject);
    procedure tbAudioMenuClick(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure tbRestoreParentClick(Sender: TObject);
    procedure cboxThingsChange(Sender: TObject);
    procedure tbAVIMovieClick(Sender: TObject);
    procedure cbAutoSnapClick(Sender: TObject);
    procedure tbMouseViewClick(Sender: TObject);
    procedure tbPlantClearerClick(Sender: TObject);
    procedure tbFireTreeClick(Sender: TObject);
    procedure tbCreatureDeathClick(Sender: TObject);
    procedure tbRainCloudClick(Sender: TObject);
    procedure tbCameraEyesClick(Sender: TObject);
    procedure tbHarmClick(Sender: TObject);
    procedure tbReportAllClick(Sender: TObject);
    procedure tbReportClick(Sender: TObject);
    procedure tbSpeechesClick(Sender: TObject);
    procedure tbShowFireClick(Sender: TObject);
    procedure tbAVIFrameClick(Sender: TObject);
    procedure tbMissileDefenceClick(Sender: TObject);
    procedure tbDisastersMenuClick(Sender: TObject);
    procedure tbLightningClick(Sender: TObject);
    procedure tbThingCeaserClick(Sender: TObject);
    procedure tbEarthquakeClick(Sender: TObject);
    procedure tbLifeKillerClick(Sender: TObject);
    procedure tbPlantRemoverClick(Sender: TObject);
    procedure tbBotSelectClick(Sender: TObject);
    procedure tbHighDetailClick(Sender: TObject);
    procedure tbShadowsClick(Sender: TObject);
    procedure tbNextKindClick(Sender: TObject);
    procedure tbRestore2Click(Sender: TObject);
    // ----------------------------------------------------------------------------
  private
    fEnvironment: AIEnvironment;
    fMouseGridX: Integer;
    fMouseGridY: Integer;
    fPlanetGrid: TGridCrossoverList;
    fWaterGrid: TGridCrossoverList;
    fFocusGrid: AIGrid;
    fSatellites: TCrossoverList;
    fSpeakers: TCrossoverList;
    fSpeeches: TCrossoverList;

    mouse_x, mouse_y: Integer;
    PlanetHeight: Integer;
    PlanetWidth: Integer;
    PlanetRadius: Single;
    WaterRadius: Single;
    ControllingBot: Boolean;
    ControlBot: AIBot;
    Flying: Boolean;
    FlyingForwards: Boolean;
    (*
      Camera System:
      The Camera is set at the ViewPosition
      The ViewPosition chases the ViewDestination
      The FloatCube is set at the ViewTarget
      The ViewDestination is "near" the ViewTarget
      The Camera points at the FloatCube
    *)
    ViewPosition: AIPosition; // actual camera position
    ViewDestination: AIPosition; // camera destination
    ViewTarget: AIPosition; // camera target
    ViewTrackingSpeed: Single; // how fast the camera moves
    fViewZoom: Single; // zoom distance to target
    fViewOffset: Single; // offset from target
    ViewUp: TGLCoordinates; // TGLCamera.Up
    ViewAdjust: Single;
    FocusObject: TGLBaseSceneObject;
    Prediction: AIPosition; // used to predict positions

    TextureMap: array of array of array of TTexPoint;
    fCameraMode: eCamera;
    CameraShaking: Integer;
    DimpledLighting: Boolean;
    TargetToFollow: TCrossover;
    HiddenTarget: TCrossover;
    PlayTarget: TCrossover;
    SphereMode: Boolean;
    UnderWaterCam: Boolean;
    ValidCursor: Boolean;
    CursorGlow: Single;
    CursorGlowRate: Single;
    KBStopWatch: TStopWatch;
    WaterWaves: Single;
    WaterWaveRate: Single;
    // pointer to mesh data
    PlanetMesh: TGLMeshObject;
    WaterMesh: TGLMeshObject;
    PlanetVertices: TGLAffineVectorList;
    WaterVertices: TGLAffineVectorList;
    InvalidOctree: Boolean;
    fTool: eTool;
    LastTool: eTool;
    ToolIsActive: Boolean;
    WaterLevel: Single;
    WaterCan: Integer;
    WidthAngle: Single;
    HeightAngle: single;
    FrameRate: single;
    core: TGLVector;
    SoundVolume: Single;
    procedure LastAction(aAction: string);
    procedure BuildFromMap;
    procedure BuildPlanet(center: TGLVector; radius: single; Height: Integer;
      Width: Integer; Show: Boolean);
    procedure BuildWater(center: TGLVector; radius: single; Height: Integer;
      Width: Integer; Show: Boolean);
    procedure BuildAtmosphere(center: TGLVector; radius: single;
      Height: Integer; Width: Integer; Show: Boolean);
    procedure LoadMaterialLibrary;
    procedure LoadTexture(aTexName: string; aFile: string);
    procedure LoadModels;
    procedure LoadModel(aFreeForm: TGLFreeForm; aFile: string);
    procedure GenerateTextureMap;
    procedure CalculateTerrainSettings;
    procedure SetFaceTexture(aCrossover: TGridCrossover; newTexIndex: Integer;
      aFaceA, aFaceB: Integer);
    function GetTextureNumber(aGrid, aAdjacentGrid: AIGrid): Integer;
    procedure SetTool(aTool: eTool);
    procedure ApplyTool(aTool: eTool; aLocation: AIGrid);
    procedure ApplyUserInterface;
    procedure AllToolBarsInvisible;
    procedure UpdateGridHeight(aGrid: AIGrid);
    procedure SetGridHeightPoints(aGrid: AIGrid);
    procedure UpdateWaterHeight(aGrid: AIGrid);
    procedure SetWaterHeightPoints(aGrid: AIGrid);
    function CheckCradle: TCrossover;
    procedure CheckPurgatory;
    procedure CheckTrash;
    procedure RemoveLights;
    procedure AddStars;
    procedure AddNewTree(aKind: Integer; aLocation: AIGrid);
    procedure AddBeacon(aUsage: Integer; aLocation: AIGrid);
    procedure SetMouseGridX(X: Integer);
    procedure SetMouseGridY(Y: Integer);

    function BuildMoon(aMoon: AIMoon): TCrossover;
    function BuildSun(aSun: AISun): TCrossover;
    function BuildCloud(aCloud: AICloud): TCrossover;
    function BuildAppleTree(aTree: AITree): TCrossover;
    function BuildOrangeTree(aTree: AITree): TCrossover;
    function BuildApple(aApple: AIFruit): TCrossover;
    function BuildOrange(aOrange: AIFruit): TCrossover;
    function BuildSeed(aSeed: AISeed): TCrossover;
    function BuildFish(aFish: AIFish): TCrossover;
    function BuildBird(aBird: AIBird): TCrossover;
    function BuildAsteroid(aAsteroid: AIAsteroid): TCrossover;
    function BuildExplosion(aExplosion: AIExplosion): TCrossover;
    function BuildBot(aBot: AIBot): TCrossover;
    function BuildCrab(aCrab: AICrab): TCrossover;
    function BuildHawk(aHawk: AIHawk): TCrossover;
    function BuildGrazer(aGrazer: AIGrazer): TCrossover;
    function BuildTrex(aTrex: AITrex): TCrossover;
    function BuildVibe(aVibe: AIVibe): TCrossover;
    function BuildBall(aBall: AIBall): TCrossover;
    function BuildLightning(aLightning: AILightning): TCrossover;
    function BuildShark(aShark: AIShark): TCrossover;
    function BuildTurtle(aTurtle: AITurtle): TCrossover;
    function BuildBeacon(aBeacon: AIBeacon): TCrossover;
    function BuildTerrier(aTerrier: AITerrier): TCrossover;
    function BuildFox(aFox: AIFox): TCrossover;
    function BuildRabbit(aRabbit: AIRabbit): TCrossover;
    function BuildGrass(aGrass: AIGrass): TCrossover;
    function BuildIceberg(aIceberg: AIIceberg): TCrossover;
    function BuildMouse(aMouse: AIMouse): TCrossover;
    function BuildTiger(aTiger: AITiger): TCrossover;
    function BuildDuck(aDuck: AIDuck): TCrossover;
    function BuildDolphin(aDolphin: AIDolphin): TCrossover;
    function BuildAquaPlant(aAquaPlant: AIAquaPlant): TCrossover;
    function BuildLadybug(aLadybug: AILadybug): TCrossover;
    function BuildAnt(aAnt: AIAnt): TCrossover;
    function BuildEvolvingTree(aTree: AIEvolvingTree): TCrossover;
    function BuildEvolvingFruit(aFruit: AIEvolvingFruit): TCrossover;
    function BuildEvolvingSeed(aSeed: AIEvolvingSeed): TCrossover;
    function BuildFireTree(aFireTree: AIFireTree): TCrossover;
    function BuildSpeech(aSpeech: AISpeech): TCrossover;
    function BuildMissileDefence(aMissileDefence: AIMissileDefence): TCrossover;
    function BuildMissile(aMissile: AIMissile): TCrossover;

    procedure UpdateMoon(aCrossover: TCrossover);
    procedure UpdateSun(aCrossover: TCrossover);
    procedure UpdateCloud(aCrossover: TCrossover);
    procedure UpdateAppleTree(aCrossover: TCrossover);
    procedure UpdateOrangeTree(aCrossover: TCrossover);
    procedure UpdateApple(aCrossover: TCrossover);
    procedure UpdateOrange(aCrossover: TCrossover);
    procedure UpdateSeed(aCrossover: TCrossover);
    procedure UpdateFish(aCrossover: TCrossover);
    procedure UpdateBird(aCrossover: TCrossover);
    procedure UpdateAsteroid(aCrossover: TCrossover);
    procedure UpdateBot(aCrossover: TCrossover);
    procedure UpdateCrab(aCrossover: TCrossover);
    procedure UpdateHawk(aCrossover: TCrossover);
    procedure UpdateGrazer(aCrossover: TCrossover);
    procedure UpdateTrex(aCrossover: TCrossover);
    procedure UpdateExplosion(aCrossover: TCrossover);
    procedure UpdateBall(aCrossover: TCrossover);
    procedure UpdateShark(aCrossover: TCrossover);
    procedure UpdateTurtle(aCrossover: TCrossover);
    procedure UpdateBeacon(aCrossover: TCrossover);
    procedure UpdateTerrier(aCrossover: TCrossover);
    procedure UpdateFox(aCrossover: TCrossover);
    procedure UpdateRabbit(aCrossover: TCrossover);
    procedure UpdateGrass(aCrossover: TCrossover);
    procedure UpdateIceberg(aCrossover: TCrossover);
    procedure UpdateMouse(aCrossover: TCrossover);
    procedure UpdateTiger(aCrossover: TCrossover);
    procedure UpdateDuck(aCrossover: TCrossover);
    procedure UpdateDolphin(aCrossover: TCrossover);
    procedure UpdateAquaPlant(aCrossover: TCrossover);
    procedure UpdateLadybug(aCrossover: TCrossover);
    procedure UpdateAnt(aCrossover: TCrossover);
    procedure UpdateEvolvingTree(aCrossover: TCrossover);
    procedure UpdateEvolvingFruit(aCrossover: TCrossover);
    procedure UpdateEvolvingSeed(aCrossover: TCrossover);
    procedure UpdateFireTree(aCrossover: TCrossover);
    procedure UpdateSpeech(aCrossover: TCrossover);
    procedure UpdateMissileDefence(aCrossover: TCrossover);
    procedure UpdateMissile(aCrossover: TCrossover);

    procedure RefreshPlanet;
    procedure RefreshInterface;
    procedure RefreshSatellites;
    procedure RefreshSpeeches;
    procedure RefreshCursor;
    procedure ShowCursor;
    procedure HideCursor;
    procedure CheckKeys;
    procedure MoveCursor(aDirection: Integer); overload;
    procedure MoveCursor(aGrid: AIGrid); overload;
    procedure CalculateCursorPosition;
    procedure InvalidateLand;
    procedure DirectCamera(Grain: single);
    procedure FreeFloatCamera;
    procedure PlanetCamera;
    procedure AvatarCamera;
    procedure ChaseCamera;
    procedure EyesCamera;
    procedure SatelliteCamera;
    procedure SetCamera(aCameraMode: eCamera);
    procedure SetCameraByTarget;
    procedure ResetOffset;
    procedure SetViewZoom(aViewZoom: single);
    procedure SetViewOffset(aViewOffset: single);

    procedure LoadSounds;
    procedure LoadSound(aFileName: string);
    procedure GenerateSoundSystem(aNumberOfSpeakers: Integer);
    procedure PlaySound(aSoundIndex: Integer; aRepeat: Integer;
      aPosition: AIPosition); overload;

    // free floating coordinates
    procedure CoordinatesFromPosition(aPosition: AIPosition;
      aCoordinates: TGLCoordinates); overload;
    procedure CoordinatesFromPosition(aPosition: AIPosition;
      aDirection: TGLCoordinates; aCoordinates: TGLCoordinates); overload;
    procedure CoordinatesFromPosition(aPosition: AIPosition;
      aCoordinates: TGLCoordinates; aFactor: single); overload;
    procedure CoordinatesFromPosition(aPosition: AIPosition;
      aCoordinates: TGLCoordinates; aFactor: single;
      aOffset: TGLVector); overload;
    procedure CoordinatesFromPosition(aPosition: AIPosition;
      aDirection: TGLCoordinates; aCoordinates: TGLCoordinates;
      aFactor: single); overload;
    procedure CoordinatesFromPosition(aX, aY, aHeight: single;
      aCoordinates: TGLCoordinates); overload;
    procedure CoordinatesFromPosition(aOrigin: TAffineVector;
      var aVector: TAffineVector); overload;
    // includes proper flat positioning
    procedure PositionThing(aPosition: AIPosition;
      aThing: TGLBaseSceneObject); overload;
    procedure PositionThing(aPosition: AIPosition; aThing: TGLBaseSceneObject;
      aAngle: single); overload;
    procedure PositionThing(aPosition: AIPosition; aThing: TGLBaseSceneObject;
      aAngle: single; aFactor: single); overload;
    procedure SetEnvironment(aEnvironment: AIEnvironment);
    procedure SetPlanetVariables;
    procedure AddStormCloud(aLocation: AIGrid);
    procedure AddRainCloud(aLocation: AIGrid);
    procedure AddForest(aLocation: AIGrid);
    procedure AddGrass(aLocation: AIGrid);
    procedure AddLightning(aLocation: AIGrid);
    procedure AddToTrail(aPosition: AIPosition; aLines: TGLLines);
    procedure UpdateTrackingTrail;
    function FindObjectUnderMouse: pointer;
    procedure PickObjectWithMouse;
    /// function GetPickedObject(x, y: Integer): TGLBaseSceneObject;
    /// procedure DisplayMouseObjectInfo;
    procedure AutoSnap; // take a mini photo for animations
    procedure CheckToolRepeat;
    procedure BreakLimits(aKind: Integer);
    procedure SetFlatGridHeightPoints(aGrid: AIGrid);
    procedure SetFlatWaterHeightPoints(aGrid: AIGrid);
    // ----------------------------------------------------------------------------
  public
    LastActivity: string;
    LastTime: Integer;
    property Environment: AIEnvironment read fEnvironment write SetEnvironment;
    property MouseGridX: Integer read fMouseGridX write SetMouseGridX;
    property MouseGridY: Integer read fMouseGridY write SetMouseGridY;
    property PlanetGrid: TGridCrossoverList read fPlanetGrid;
    property WaterGrid: TGridCrossoverList read fWaterGrid;
    property Satellites: TCrossoverList read fSatellites;
    property Speakers: TCrossoverList read fSpeakers;
    property FocusGrid: AIGrid read fFocusGrid;
    property Tool: eTool read fTool write SetTool;
    property CameraMode: eCamera read fCameraMode write SetCamera;
    property ViewZoom: single read fViewZoom write SetViewZoom;
    property ViewOffset: single read fViewOffset write SetViewOffset;

    procedure Advance;
    procedure AdvanceHidden;
    procedure RefreshPlanetFull;
    procedure StickyFit; // switches to stickyfit mode
    procedure UnStickyFit; // switches to unstickyfit mode
    procedure Reset;
    procedure InitializeCameraSystem;
    procedure BuildGalaxy;
    procedure CleanGalaxy;
    procedure ReportUserEvent(aEvent: string);
    procedure PopUpTargetWindow;
    procedure FindTarget(aThing: AIThing);
    procedure EmptyAllSounds;
    procedure FullDisplay(aLines: TStrings);
    procedure InformOfStart;
    procedure InformOfStop;
    // if the scene goes black, call this
    procedure RestoreScene;
    procedure SetShadowMode(aMode: Boolean);
  end;

var
  fm3DEnvironment: Tfm3DEnvironment;

  // ----------------------------------------------------------------------------
implementation

{$R *.DFM}

uses
  fPlanet,
  fBuildProgress,
  fSatellite,
  fFirstForm,
  fImages,
  fPhotograph,
  cGlobals,
  cAIReality,
  cAILife;

const
  cMaxZoomOut = 50;
  cTwoPi = Pi * 2;
  cHalfPi = Pi / 2;

// ----------------------------------------------------------------------------
// FormCreate
// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  fPlanetGrid := TGridCrossoverList.Create;
  fWaterGrid := TGridCrossoverList.Create;
  fSatellites := TCrossoverList.Create;
  fSpeakers := TCrossoverList.Create;
  fSpeeches := TCrossoverList.Create;
  ViewPosition := AIPosition.Create(nil);
  ViewDestination := AIPosition.Create(nil);
  ViewTarget := AIPosition.Create(nil);
  Prediction := AIPosition.Create(nil);
  ViewUp := TGLCoordinates.Create(nil);
  ViewUp.Style := csVector;
  KBStopWatch := TStopWatch.Create;
  PlayTarget := nil;

  ViewPosition.SetProperties(1000, 0, 0);
  ViewDestination.SetProperties(1000, 0, 0);
  ViewTarget.SetProperties(1000, 0, 0);

  SphereMode := true;

  fmFirstForm.Construction.AddEvent('Loading files...');
  LoadMaterialLibrary;
  LoadModels;
  GenerateTextureMap;

  GLCamera.NearPlaneBias := 0.1;

  // turn sound on
  if not GLBass.Active then
  begin
    fmFirstForm.Construction.AddEvent('Activating GLBass...');
    GLBass.Active := true;
    if not GLBass.Active then
      fmFirstForm.Construction.AddEventFailure(' no sound support!');
  end;
  LoadSounds;
  fmFirstForm.Construction.AddEvent('Generating sound system...');
  GenerateSoundSystem(64);

  CleanGalaxy;
  AddStars;

  Tool := tSelect;
  LastTool := tSelect;
  HideCursor;
  WaterLevel := 2.5;
  WaterCan := 1;
  WaterUpDown.Position := WaterCan;
  edWater.Text := IntToStr(WaterCan);
  CursorGlow := 1.0;
  CursorGlowRate := 0.01;
  WaterWaves := 1.0;
  WaterWaveRate := 0.00001;
  Reset;

  panMenus.Height := 57;
  Atmosphere.Visible := tbShowAtmosphere.Down;
  SoundVolume := tbVolume.Position / 10.0;

  AllToolBarsInvisible;
  InitializeCameraSystem;

  for i := 0 to cLastThing do
    cboxThings.Items.Add(ThingName(i));
  cboxThings.ItemIndex := cEvolvingFruit;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetEnvironment(aEnvironment: AIEnvironment);
begin
  fEnvironment := aEnvironment;
  SetPlanetVariables;
  InitializeCameraSystem;
  SetShadowMode(Environment.Shadows);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetPlanetVariables;
begin
  PlanetHeight := Environment.Space.Height;
  PlanetWidth := Environment.Space.Width;
  PlanetRadius := Environment.Space.radius;
  WaterRadius := Environment.Space.radius + 0.075;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FormDestroy(Sender: TObject);
begin
  fPlanetGrid.Free;
  fWaterGrid.Free;
  fSatellites.Free;
  fSpeakers.Free;
  fSpeeches.Free;
  KBStopWatch.Free;

  ViewPosition.Free;
  ViewDestination.Free;
  ViewTarget.Free;
  ViewUp.Free;
  Prediction.Free;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FormShow(Sender: TObject);
begin
  ValidCursor := false;
  Caption := Environment.Name;
  ViewAdjust := 2.0;

  GLSceneViewer.Invalidate;
  GLSceneViewer.SetFocus;
  // resize the form so that it invalidates itself
  // this makes it refresh and align all panels properly
  Width := Width - 1;
  Width := Width + 1;
  Height := Height - 1;
  Height := Height + 1;
  Invalidate;
  GLCadencer.Enabled := true;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.Reset;
begin
  ValidCursor := false;
  ToolIsActive := false;
  CameraShaking := 0;
  DimpledLighting := true;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.InitializeCameraSystem;
begin
  ViewPosition.SetPosition(gHalfWorldWidth, gHalfWorldHeight, 50);
  ViewDestination.SetPosition(gHalfWorldWidth, gHalfWorldHeight, 50);
  ViewTarget.SetPosition(gHalfWorldWidth, gHalfWorldHeight, 50);

  CameraMode := camPlanet;
  ViewTrackingSpeed := 32;
  ViewZoom := 250;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.Advance;
var
  latestThing: pointer;
begin
  GLSceneViewer.Buffer.BeginUpdate;
  CalculateCursorPosition; // position the user cursor

  if ToolIsActive and ValidCursor then
    ApplyUserInterface; // use tool

  CheckPurgatory; // remove nonexistant things from view
  CheckTrash; // remove nonexistant things from view
  latestThing := CheckCradle; // add new things to view
  if cbTrackNewThings.Checked then
    if not(latestThing = nil)
    { and ((CameraMode = camPlanet) or (CameraMode = camFind)) } then
    begin
      CameraMode := camTarget;
      ResetOffset;
      TargetToFollow := latestThing;
    end;
  if Environment.Space.EventRound.Full then
    RefreshPlanet; // refresh grid surfaces, if changed
  RefreshSatellites; // position things
  RefreshSpeeches;
  RefreshInterface; // refresh stats etc
  if (CameraMode = camTarget) and (TargetToFollow <> nil) then
    UpdateTrackingTrail;
  if InvalidOctree and not ToolIsActive and (Environment.Space.EventQueue.Empty)
    and (Environment.Space.EventRound.Empty) then
  begin
    PlanetModel.BuildOctree;
    // PlanetModel.BuildSilhouetteConnectivityData;
    InvalidOctree := false;
  end;
  if cbAutoSnap.Checked then
    AutoSnap;
  if tbAVIDirect.Down then
  begin
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    GLCadencer.Progress;
    AVIRecorder.AddAVIFrame;
  end;
  GLSceneViewer.Buffer.EndUpdate;
  GLCadencer.Progress;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetCamera(aCameraMode: eCamera);
begin
  // prechange
  case fCameraMode of
    camEyes:
      begin
        if (HiddenTarget <> nil) then
          TGLBaseSceneObject(HiddenTarget.SubVisuals.Items[0]).Visible := true;
        HiddenTarget := nil;
      end;
  end;

  fCameraMode := aCameraMode;

  ViewAdjust := 0.001;

  // post change
  case fCameraMode of
    camPlanet:
      begin
        FocusObject := PlanetModel;
        ViewUp.SetVector(0, 1, 0);
        ViewDestination.Height := PlanetRadius * 30;
        ViewTrackingSpeed := 32;
        tbCameraPlanet.Down := true;
        TargetToFollow := nil;
        TrackLines.Visible := false;
        PredictLines.Visible := false;
        ResetOffset;
        ViewDestination.DirectionXY := HalfPi;
        ViewDestination.DirectionH := 0;
      end;

    camTarget:
      begin
        FocusObject := FloatCube;
        ViewUp.SetVector(0, 1, 0);
        ViewTrackingSpeed := 32;
        tbCameraTarget.Down := true;
        TrackLines.Nodes.Clear;
        if (tbTrackLines.Down) then
          TrackLines.Visible := true;
        if (tbPredictions.Down) then
          PredictLines.Visible := true;
      end;

    camEyes:
      begin
        if Assigned(TargetToFollow) then
        begin
          TGLBaseSceneObject(TargetToFollow.SubVisuals.Items[0])
            .Visible := false;
          HiddenTarget := TargetToFollow;
        end;
        FocusObject := FloatCube;
        ViewUp.SetVector(0, 1, 0);
        ViewTrackingSpeed := 1;
        tbCameraEyes.Down := true;
        TrackLines.Nodes.Clear;
        if (tbTrackLines.Down) then
          TrackLines.Visible := true;
        if (tbPredictions.Down) then
          PredictLines.Visible := true;
      end;

    camFree:
      begin
        tbFloatCamera.Down := true;
        FocusObject := FloatCube;
        ViewTrackingSpeed := 1.00; // proper setting
        ViewDestination.DirectionH := Pi; // looking down
        ViewDestination.DirectionXY := -HalfPi; // facing north
        TargetToFollow := nil;
        // the next line causes a bug, so it is a very good line to uncomment
        // for testing the error form.  switch to FreeCamera and then hold down
        // the middle mouse button until it crashes.
        // ViewTrackingSpeed := 0.01;
      end;

    camAvatar:
      begin
        FocusObject := FloatCube;
        GLCamera.SceneScale := 2.0;
        GLCamera.FocalLength := 50;
        tbCameraAvatar.Down := true;
        ViewTarget.Height := 0.75;
        ViewDestination.Height := 1.00;
        ViewTrackingSpeed := 32;
        ViewDestination.DirectionH := Pi; // looking down
        ViewDestination.DirectionXY := -HalfPi; // facing north
        tbCameraAvatar.Down := true;
        TargetToFollow := nil;
        TrackLines.Visible := false;
        PredictLines.Visible := false;
      end;

    camSatellite:
      begin
        FocusObject := PlanetModel;
        ViewUp.SetVector(0, 1, 0);
        ViewDestination.Height := PlanetRadius * 30;
        ViewTrackingSpeed := 32;
        tbCameraSatellite.Down := true;
        TargetToFollow := nil;
        ResetOffset;
        TrackLines.Visible := false;
        PredictLines.Visible := false;
        ViewDestination.DirectionXY := HalfPi;
        ViewDestination.DirectionH := 0;
      end;
  end;

  fmFirstForm.Construction.AddEvent('Changed Camera Mode = ' +
    CameraModeString(CameraMode));
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetCameraByTarget;
var
  myThing: AIThing;
begin
  if Assigned(TargetToFollow) then
  begin
    CameraMode := camTarget;
    myThing := TargetToFollow.Data;
    if ViewOffset < 100 then
      ViewOffset := 100;
    if myThing is AISatellite then
    begin
      if ViewOffset < 1500 then
        ViewOffset := 1500;
    end
    else if ViewOffset > 500 then
      ViewOffset := 500;
  end
  else
    CameraMode := camPlanet;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.DirectCamera(Grain: single);
var
  planeDistance: single;
  heightDistance: single;
begin
  if ViewPosition.HeightAbove > 50 then
    GLCamera.NearPlaneBias := 2
  else
    GLCamera.NearPlaneBias := 0.1;

  // calculate position of camera target and destination
  case CameraMode of
    camPlanet:
      PlanetCamera;
    camTarget:
      begin
        ChaseCamera;
        Grain := 1.0;
      end;
    camAvatar:
      AvatarCamera;
    camSatellite:
      SatelliteCamera;
    camFree:
      begin
        FreeFloatCamera;
        Grain := 1.0;
      end;
    camEyes:
      begin
        EyesCamera;
        Grain := 1.0;
      end;
  end;

  // distance from camera position to destination position
  // planeDistance  := ViewPosition.DistanceTo(ViewDestination);
  planeDistance := 1; // the distanceto function fucks up at poles!!!
  heightDistance := ViewPosition.DistanceToHeight(ViewDestination.Height);

  // move the camera towards its destination
  // eventually the ViewPosition will equal the ViewDestination (ie. camera stops moving)
  ViewPosition.MoveTowards(ViewDestination,
    sqrt(planeDistance / ViewTrackingSpeed) / Grain * 10);
  // move towards height
  ViewPosition.MoveTowardsHeight(ViewDestination.Height,
    sqrt(heightDistance / ViewTrackingSpeed) / Grain * 10);
  ViewPosition.Velocity.Zero;
  ViewPosition.Acceleration.Zero;
  if ViewPosition.Y < 5 then
  begin
    ViewPosition.Y := 5;
  end;
  if ViewPosition.Y > gWorldHeight - 5 then
  begin
    ViewPosition.Y := gWorldHeight - 5;
  end;
  ViewPosition.Fuel;

  // set the float cube position (camera is always targeting this)
  CoordinatesFromPosition(ViewTarget, FloatCube.Position); // , 0.5);

  // set the cameras position
  if SphereMode then
    CoordinatesFromPosition(ViewPosition, GLCamera.Position) // , 0.5)
  else
  begin
    PositionThing(ViewPosition, GLCamera);
    ViewUp.SetVector(0, 1, 0);
    GLCamera.Up.SetVector(0, 1, 0);
  end;

  Atmosphere.Material.FrontProperties.Diffuse.Alpha :=
    0.98 - (0.008 * Environment.Things.Tables[cSun].DistanceToNearest
    (ViewPosition));

  // set camera direction
  GLCamera.TargetObject := FocusObject;

  // set camera up
  GLCamera.Up.DirectX := AdjustValue(GLCamera.Up.DirectX, ViewUp.DirectX,
    ViewAdjust);
  GLCamera.Up.DirectY := AdjustValue(GLCamera.Up.DirectY, ViewUp.DirectY,
    ViewAdjust);
  GLCamera.Up.DirectZ := AdjustValue(GLCamera.Up.DirectZ, ViewUp.DirectZ,
    ViewAdjust);

  if ViewAdjust < 1 then
    ViewAdjust := ViewAdjust + 0.001;

  // camera light
  if tbCameraLight.Down then
  begin
    CameraLight.Shining := true;
    CameraLight.Position.SetPoint(GLCamera.Position.X, GLCamera.Position.Y,
      GLCamera.Position.Z);
    CameraLight.SpotDirection.SetVector(GLCamera.Direction.X,
      GLCamera.Direction.Y, GLCamera.Direction.Z);
  end;

  // filter visible objects
  SeedCube.Visible := (ViewPosition.Height < 200);
  FruitCube.Visible := (ViewPosition.Height < 500);

  // notify the camera
  GLCamera.TransformationChanged;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FreeFloatCamera;
begin
  // place the view target in front of the destination
  if (ViewDestination.Height < ViewDestination.Land) then
    ViewDestination.Height := ViewDestination.Land;
  ViewTarget.FullCopy(ViewDestination);
  ViewTarget.MoveFreely(1);

  ViewZoom := 0;

  // tilt the camera
  CoordinatesFromPosition(ViewTarget, ViewUp, FloatCube.Position);

  GLCamera.Up := ViewUp;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.PlanetCamera;
begin
  ViewDestination.Velocity.Zero;
  ViewDestination.Acceleration.Zero;
  ViewDestination.Fuel;
  if ViewDestination.Height < (ViewDestination.HighestHeight + 10) then
    ViewDestination.Height := (ViewDestination.HighestHeight + 10);

  if not SphereMode then
    FocusObject := FloatCube;

  ViewTarget.Velocity.Zero;
  ViewTarget.Acceleration.Zero;
  ViewTarget.X := ViewPosition.X;
  ViewTarget.Y := ViewPosition.Y;
  ViewTarget.Height := 0;

  ViewUp.SetVector(0, 1, 0);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.ChaseCamera;
var
  TargetPosition: AIPosition;
begin
  if not(TargetToFollow = nil) then
  begin
    TargetPosition := AIThing(TargetToFollow.Data).Position;
    FocusObject := TGLBaseSceneObject(TargetToFollow.SubVisuals[0]);

    if TargetPosition.Binding = bindLand then
      if ViewDestination.DirectionH > HalfPi then
        ViewDestination.DirectionH := HalfPi;

    ViewDestination.CopyCoords(TargetPosition);
    ViewDestination.MoveFreely5(ViewOffset);
    ViewDestination.Velocity.Zero;
    ViewDestination.Acceleration.Zero;
    ViewDestination.Fuel;
    ViewZoom := 0;

    StatusBar.Panels[2].Text := AIThing(TargetToFollow.Data).OneLineDisplay;

    if ViewOffset < 2 then
      ViewOffset := 2;

    CoordinatesFromPosition(ViewDestination, ViewUp, FloatCube.Position);
  end
  else
    CameraMode := camPlanet;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.EyesCamera;
var
  TargetPosition: AIPosition;
begin
  if not(HiddenTarget = nil) then
  begin
    TargetPosition := AIThing(HiddenTarget.Data).Position;
    FocusObject := FloatCube;

    ViewDestination.FullCopy(TargetPosition);
    ViewDestination.Height := ViewDestination.Height +
      ViewDestination.SizeH / 2;
    ViewDestination.Velocity.Zero;
    ViewDestination.Acceleration.Zero;
    ViewDestination.Fuel;
    ViewTarget.FullCopy(ViewDestination);
    ViewTarget.MoveFreely(ViewDestination.SizeY / 2);
    ViewTarget.Velocity.Zero;
    ViewTarget.Acceleration.Zero;
    ViewTarget.Fuel;
    ViewZoom := 0;

    GLCamera.NearPlaneBias := 0.001;

    StatusBar.Panels[2].Text := AIThing(TargetToFollow.Data).OneLineDisplay;

    CoordinatesFromPosition(ViewTarget, ViewUp, FloatCube.Position);
  end
  else
    CameraMode := camPlanet;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.AvatarCamera;
begin
  // place the view target in front of the destination
  ViewDestination.Velocity.Zero;
  ViewDestination.Acceleration.Zero;
  ViewDestination.Fuel;
  if (ViewDestination.Height < ViewDestination.Land + 12) then
    ViewDestination.Height := ViewDestination.Land + 12;
  ViewTarget.FullCopy(ViewDestination);
  ViewTarget.MoveFreely(1);

  ViewZoom := 0;

  // tilt the camera
  CoordinatesFromPosition(ViewTarget, ViewUp, FloatCube.Position);

  GLCamera.Up := ViewUp;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SatelliteCamera;
begin
  ViewDestination.DirectionXY := 0;
  ViewDestination.MoveBy(0.1);

  // place the view target in front of the destination
  ViewTarget.X := ViewDestination.X;
  ViewTarget.Y := ViewDestination.Y;
  ViewTarget.Height := 0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.ResetOffset;
begin
  ViewOffset := 25;
  ViewTarget.DirectionH := 0;
  ViewTarget.DirectionXY := 0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetViewZoom(aViewZoom: single);
begin
  fViewZoom := aViewZoom;

  if fViewZoom < 0.0 then
    fViewZoom := 0.0;
  if fViewZoom > 250.0 then
    fViewZoom := 250.0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetViewOffset(aViewOffset: single);
begin
  fViewOffset := aViewOffset;

  if fViewOffset < 0 then
    fViewOffset := 0;
  if fViewOffset > 5000.0 then
    fViewOffset := 5000.0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.ApplyUserInterface;
begin
  if not isKeyDown(VK_SHIFT) then
    ApplyTool(Tool, FocusGrid)
  else
    ApplyTool(OppositeTool(Tool), FocusGrid);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.CheckKeys;
begin
  // press ESC to leave fullscreen
  if not StatusBar.Visible and isKeyDown(VK_ESCAPE) then
  begin
    panMenus.Visible := true;
    StatusBar.Visible := true;
    BorderStyle := bsSizeable;
    WindowState := wsNormal;
    tbFullscreen.Down := false;
    panCamera.Visible := true;
    if tbStickyFit.Down then
      StickyFit;
  end;

  // switch to walking mode
  if isKeyDown(VK_SPACE) then
    fmFirstForm.RealityForm.FlipOnOffSwitch;

  // switch to walking mode
  if isKeyDown(VK_TAB) then
    CameraMode := camAvatar;

  // chase next target
  if isKeyDown(VK_SHIFT) then
  begin
    if isKeyDown('1') then
    begin
      if Satellites.SetCrossoverByKind(cSun) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('2') then
    begin
      if Satellites.SetCrossoverByKind(cMoon) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('3') then
    begin
      if Satellites.SetCrossoverByKind(cBird) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('4') then
    begin
      if Satellites.SetCrossoverByKind(cFish) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('5') then
    begin
      if Satellites.SetCrossoverByKind(cAppleTree) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('6') then
    begin
      if Satellites.SetCrossoverByKind(cOrangeTree) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('7') then
    begin
      if Satellites.SetCrossoverByKind(cCloud) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('8') then
    begin
      if Satellites.SetCrossoverByKind(cAsteroid) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;

    if isKeyDown('0') then
    begin
      if Satellites.SetCrossoverByKind(cBot) then
      begin
        TargetToFollow := Satellites.ActiveItem;
        SetCameraByTarget;
      end;
      KBStopWatch.Go;
    end;
  end;

  // chase next target
  if isKeyDown(']') then
  begin
    if Satellites.SetNextOrFirstActive then
      TargetToFollow := Satellites.ActiveItem
    else
      TargetToFollow := nil;

    SetCameraByTarget;
    KBStopWatch.Go;
  end;

  // chase prior target
  if isKeyDown('[') then
  begin
    if Satellites.SetPriorOrLastActive then
      TargetToFollow := Satellites.ActiveItem
    else
      TargetToFollow := nil;

    SetCameraByTarget;
    KBStopWatch.Go;
  end;

  // chase last target
  if isKeyDown('\') then
  begin
    if not Assigned(TargetToFollow) then
      TargetToFollow := Satellites.ActiveItem;

    SetCameraByTarget;
    KBStopWatch.Go;
  end;

  // planet mode
  if isKeyDown('p') then
    CameraMode := camPlanet;

  if ControllingBot then
  begin
    if isKeyDown(VK_LEFT) then
      ControlBot.Emotion := 'TURNLEFT';
    if isKeyDown(VK_RIGHT) then
      ControlBot.Emotion := 'TURNRIGHT';
    if isKeyDown('a') then
      ControlBot.Emotion := 'SHIFTLEFT';
    if isKeyDown('d') then
      ControlBot.Emotion := 'SHIFTRIGHT';
    if isKeyDown('h') then
      ControlBot.Jetpack := 'JETPACK';
    if isKeyDown(VK_UP) then
      ControlBot.Command := 'MOVE';
    if isKeyDown(VK_UP) and isKeyDown(VK_SHIFT) then
      ControlBot.Command := 'RUN';
    if isKeyDown(VK_DOWN) then
      ControlBot.Command := 'MOVEBACK';
    if isKeyDown('j') then
      ControlBot.Jetpack := 'JUMP';
    if isKeyDown('k') then
      ControlBot.Activity := 'KICK';
    if isKeyDown('m') then
      ControlBot.Activity := 'KICKRETURN';
    if isKeyDown('y') then
      ControlBot.Activity := 'GRAB';
    if isKeyDown('u') then
      ControlBot.Activity := 'DROP';
    if isKeyDown('l') then
      ControlBot.Activity := 'BONK';
    if isKeyDown(',') then
      ControlBot.Activity := 'EAT';
    if isKeyDown('.') then
      ControlBot.Activity := 'GIVE';
    if isKeyDown('o') then
      ControlBot.Activity := 'THROW';
    if isKeyDown('/') then
      ControlBot.Activity := 'USE';
    if isKeyDown('1') then
      ControlBot.Activity := 'USE1';
    if isKeyDown('2') then
      ControlBot.Activity := 'USE2';
    if isKeyDown('3') then
      ControlBot.Activity := 'USE3';
    if isKeyDown('4') then
      ControlBot.Activity := 'USE4';
    if isKeyDown('5') then
      ControlBot.Activity := 'USE5';
    if isKeyDown('n') then
      ControlBot.Activity := 'BOMB';
    exit;
  end;

  if (CameraMode = camAvatar) or (CameraMode = camFree) then
  begin
    // move forward
    if isKeyDown(VK_UP) or isKeyDown('w') then
    begin
      if isKeyDown(VK_SHIFT) then
        ViewDestination.MoveBy(0.5)
      else
        ViewDestination.MoveBy(0.1);
    end;
    // move backward
    if isKeyDown(VK_DOWN) or isKeyDown('s') then
    begin
      ViewDestination.MoveBy(-0.1);
    end;
    // turn left
    if isKeyDown(VK_LEFT) then
    begin
      ViewDestination.TurnLeft;
    end;
    // turn right
    if isKeyDown(VK_RIGHT) then
    begin
      ViewDestination.TurnRight;
    end;
    // shuffle left
    if isKeyDown('a') then
    begin
      ViewDestination.ApplyForce(ViewDestination.DirectionXY - cHalfPi, 0.1);
    end;
    // shuffle right
    if isKeyDown('d') then
    begin
      ViewDestination.ApplyForce(ViewDestination.DirectionXY + cHalfPi, 0.1);
    end;
    // move camera up
    if isKeyDown('r') then
    begin
      ViewDestination.Height := ViewDestination.Height + 1.0;
      ViewTarget.Height := ViewTarget.Height + 1.0;
    end;
    // move camera down
    if isKeyDown('f') then
    begin
      ViewDestination.Height := ViewDestination.Height - 1.0;
      ViewTarget.Height := ViewTarget.Height - 1.0;
    end;
    // look up
    if isKeyDown(VK_HOME) then
    begin
      ViewTarget.Height := ViewTarget.Height + 1;
    end;
    // look down
    if isKeyDown(VK_END) then
    begin
      ViewTarget.Height := ViewTarget.Height - 1;
    end;
  end;

  // keyboard commands to move around the planet
  if CameraMode = camPlanet then
  begin
    if isKeyDown('=') or isKeyDown('+') then
      ViewDestination.MoveHeight(-5);
    if isKeyDown('-') then
      ViewDestination.MoveHeight(5);
    if isKeyDown('w') or isKeyDown(VK_UP) then
      ViewDestination.MoveYNoPoles(-2.5);
    if isKeyDown('s') or isKeyDown(VK_DOWN) then
      ViewDestination.MoveYNoPoles(2.5);
    if isKeyDown(VK_LEFT) or isKeyDown('a') then
      if ViewDestination.DistanceTo(ViewTarget) <
        (Environment.Space.HalfWidthSingle - 2.5) then
        ViewDestination.MoveX(-2.5);
    if isKeyDown(VK_RIGHT) or isKeyDown('d') then
      if (ViewDestination.DistanceTo(ViewTarget) + 2.5) <
        (Environment.Space.HalfWidthSingle) then
        ViewDestination.MoveX(2.5);
  end;

  // target keys
  if CameraMode = camTarget then
  begin
    if isKeyDown('=') or isKeyDown('+') then
      ViewOffset := ViewOffset - 5;
    if isKeyDown('-') then
      ViewOffset := ViewOffset + 5;
    if isKeyDown(VK_UP) then
      ViewDestination.DirectionH := ViewDestination.DirectionH - ca5;
    if isKeyDown(VK_DOWN) then
      ViewDestination.DirectionH := ViewDestination.DirectionH + ca5;
    if isKeyDown(VK_RIGHT) then
      ViewDestination.DirectionXY := ViewDestination.DirectionXY - ca5;
    if isKeyDown(VK_LEFT) then
      ViewDestination.DirectionXY := ViewDestination.DirectionXY + ca5;
    if TargetToFollow = nil then
      exit;
    if isKeyDown('a') then
      AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaX(-0.05);
    if isKeyDown('d') then
      AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaX(0.05);
    if isKeyDown('w') then
      AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaY(-0.05);
    if isKeyDown('s') then
      AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaY(0.05);
    if isKeyDown('f') then
      AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaHeight(-0.05);
    if isKeyDown('r') then
      AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaHeight(0.05);
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.RefreshInterface;
begin
  if ValidCursor then
    StatusBar.Panels[1].Text := FocusGrid.OneLineDisplay
  else
    StatusBar.Panels[1].Text := '';

  if Assigned(TargetToFollow) then
    StatusBar.Panels[2].Text := AIThing(TargetToFollow.Data).OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.LoadMaterialLibrary;
begin
  fmFirstForm.Construction.AddUnderlinedEvent('Loading material library:');
  LoadTexture('landtex', 'textures\alltex.bmp');
  LoadTexture('sun', 'textures\sunfire.bmp');
  LoadTexture('moon', 'textures\moonshine.bmp');
  LoadTexture('highlighter', 'textures\highlighter.bmp');
  LoadTexture('cloud', 'textures\cloud-tex.bmp');
  LoadTexture('glacier', 'textures\glacier.bmp');
  LoadTexture('beachball', 'textures\beachball.jpg');
  LoadTexture('soccer', 'textures\soccer.jpg');
  LoadTexture('rock', 'textures\rock.jpg');
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.LoadTexture(aTexName: string; aFile: string);
begin
  // Loading aTexName texture from aFile...
  fmFirstForm.Construction.AddEvent('Loading texture ' + aTexName +
    ' from file: ' + aFile + '...');
  if FileExists(aFile) then
  begin
    with GLMaterialLibrary.AddTextureMaterial(aTexName, aFile) do
      Material.FrontProperties.Emission.Color := clrGray40;
    // Material.FrontProperties.Emission.Color:=clrGray60;
    // done.
    fmFirstForm.Construction.AddEventSuccess(' done.');
  end
  else
  begin
    with GLMaterialLibrary.AddTextureMaterial(aTexName,
      imgDefaultTexture.Picture.Bitmap) do
      Material.FrontProperties.Emission.Color := clrGray50;
    // not found.
    fmFirstForm.Construction.AddEventFailure(' not found!');
  end;
end;

// ----------------------------------------------------------------------------
// loads all the models
procedure Tfm3DEnvironment.LoadModels;
begin
  fmFirstForm.Construction.AddUnderlinedEvent('Loading models library:');
  LoadModel(AppleTreeModel, 'models\newtree.3ds');
  LoadModel(OrangeTreeModel, 'models\orangetree.3ds');
  LoadModel(AppleModel, 'models\fruit.3ds');
  LoadModel(OrangeModel, 'models\fruit.3ds');
  LoadModel(SeedModel, 'models\seed.3ds');
  LoadModel(SpiritModel, 'models\spirit.3ds');
  LoadModel(FishModel, 'models\fish.3ds');
  LoadModel(FishGirlModel, 'models\fish-female.3ds');
  LoadModel(AsteroidModel, 'models\asteroid.3ds');
  LoadModel(SunAsteroidModel, 'models\asteroid.3ds');
  LoadModel(MoonAsteroidModel, 'models\asteroid.3ds');
  LoadModel(RainModel, 'models\rain.3ds');
  LoadModel(SnowModel, 'models\rain.3ds');

  LoadModel(BombModel, 'models\dynamite.3ds');
  LoadModel(BirdDead, 'models\birddead.3ds');
  LoadModel(BirdFlap1, 'models\bird-1.3ds');
  LoadModel(BirdFlap2, 'models\bird-2.3ds');
  LoadModel(BirdFlap3, 'models\bird-3.3ds');
  LoadModel(BirdFlap4, 'models\bird-4.3ds');
  LoadModel(BirdSit, 'models\bird-sit.3ds');
  LoadModel(CrabModel, 'models\crab.3ds');
  LoadModel(HawkModel, 'models\hawk.3ds');
  LoadModel(GrazerModel, 'models\grazer.3ds');
  LoadModel(TrexModel, 'models\tyranno.3ds');
  LoadModel(WeaponModel, 'models\weapon.3ds');
  LoadModel(ShellModel, 'models\dynamite.3ds');
  LoadModel(SharkModel, 'models\shark.3ds');
  LoadModel(TurtleModel, 'models\turtle.3ds');
  LoadModel(BeaconModel, 'models\beacon.3ds');
  LoadModel(TerrierModel, 'models\terrier.3ds');
  LoadModel(FoxModel, 'models\terrier.3ds');
  LoadModel(RabbitModel, 'models\grazer.3ds');
  LoadModel(GrassModel, 'models\grassblade.3ds');
  LoadModel(IcebergModel, 'models\iceberg.3ds');
  LoadModel(MouseModel, 'models\grazer.3ds');
  LoadModel(TigerModel, 'models\grazer.3ds');
  LoadModel(DuckModel, 'models\duck.3ds');
  LoadModel(Dolphin1, 'models\dolphin1.3ds');
  LoadModel(Dolphin2, 'models\dolphin2.3ds');
  LoadModel(Dolphin3, 'models\dolphin3.3ds');
  LoadModel(Dolphin4, 'models\dolphin4.3ds');
  LoadModel(AquaPlant, 'models\aquaplant.3ds');
  LoadModel(LadyBugModel, 'models\ladybug.3ds');
  LoadModel(AntModel1, 'models\ant.3ds');
  LoadModel(AntModel2, 'models\ant2.3ds');
  LoadModel(AntModel3, 'models\ant3.3ds');
  LoadModel(CloudModel, 'models\cloud.3ds');
  LoadModel(EvolvingTree, 'models\newtree.3ds');
  LoadModel(EvolvingFruit, 'models\fruit.3ds');
  LoadModel(EvolvingSeed, 'models\seed.3ds');
  LoadModel(FireTree, 'models\appletree.3ds');
  LoadModel(MissileDefence, 'models\defence.3ds');
  LoadModel(Missile, 'models\dynamite.3ds');
end;

// ----------------------------------------------------------------------------
// this loads a single model into a freeform
// if the model is not found (file) then dont load.
procedure Tfm3DEnvironment.LoadModel(aFreeForm: TGLFreeForm; aFile: string);
begin
  // Loading model aFile...
  fmFirstForm.Construction.AddEvent('Loading model from file: ' + aFile
    + '...');
  if FileExists(aFile) then
  begin
    aFreeForm.LoadFromFile(aFile);
    fmFirstForm.Construction.AddEventSuccess(' done.');
  end
  else
    fmFirstForm.Construction.AddEventFailure(' not found!');
  aFreeForm.BuildSilhouetteConnectivityData;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.AddStars;
var
  X: Integer;
begin
  // create grey stars
  fmFirstForm.Construction.AddEvent('Adding stars...');
  for X := 0 to 6 do
    SkyDome.Stars.AddRandomStars(1000, RGB(50 + X * 25, 50 + X * 25,
      50 + X * 25), false);
  // create colored stars
  for X := 0 to 50 do
    SkyDome.Stars.AddRandomStars(10, RGB(Random(255), Random(255),
      Random(255)), false);
  fmFirstForm.Construction.AddEventSuccess(' done.');
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.CheckCradle: TCrossover;
var
  i: Integer;
  myThing: AIThing;
  myCount: Integer;
begin
  result := nil;

  myCount := Environment.Things.Cradle.Count;
  if not(myCount = 0) then
  begin
    // take new things from cradle
    for i := 0 to myCount - 1 do
    begin
      myThing := AIThing(Environment.Things.Cradle.Items[i]);
      case myThing.Kind of
        cApple:
          BuildApple(AIFruit(myThing));
        cOrange:
          BuildOrange(AIFruit(myThing));
        cAppleSeed:
          BuildSeed(AISeed(myThing));
        cOrangeSeed:
          BuildSeed(AISeed(myThing));
        cAppleTree:
          BuildAppleTree(AITree(myThing));
        cOrangeTree:
          BuildOrangeTree(AITree(myThing));
        cCloud:
          BuildCloud(AICloud(myThing));
        cFish:
          BuildFish(AIFish(myThing));
        cBird:
          result := BuildBird(AIBird(myThing));
        cBot:
          result := BuildBot(AIBot(myThing));
        cSun:
          result := BuildSun(AISun(myThing));
        cMoon:
          result := BuildMoon(AIMoon(myThing));
        cAsteroid:
          begin
            result := BuildAsteroid(AIAsteroid(myThing));
            if Tool = tAsteroid then
              result := nil;
          end;
        cTrex:
          result := BuildTrex(AITrex(myThing));
        cGrazer:
          result := BuildGrazer(AIGrazer(myThing));
        cHawk:
          result := BuildHawk(AIHawk(myThing));
        cCrab:
          result := BuildCrab(AICrab(myThing));
        cExplosion:
          result := BuildExplosion(AIExplosion(myThing));
        cBall:
          result := BuildBall(AIBall(myThing));
        cVibe:
          if Visible then
            BuildVibe(AIVibe(myThing));
        cLightning:
          result := BuildLightning(AILightning(myThing));
        cShark:
          result := BuildShark(AIShark(myThing));
        cTurtle:
          result := BuildTurtle(AITurtle(myThing));
        cBeacon:
          result := BuildBeacon(AIBeacon(myThing));
        cTerrier:
          result := BuildTerrier(AITerrier(myThing));
        cFox:
          result := BuildFox(AIFox(myThing));
        cRabbit:
          result := BuildRabbit(AIRabbit(myThing));
        cGrass:
          result := BuildGrass(AIGrass(myThing));
        cIceberg:
          result := BuildIceberg(AIIceberg(myThing));
        cMouse:
          result := BuildMouse(AIMouse(myThing));
        cTiger:
          result := BuildTiger(AITiger(myThing));
        cDuck:
          result := BuildDuck(AIDuck(myThing));
        cDolphin:
          result := BuildDolphin(AIDolphin(myThing));
        cAquaPlant:
          result := BuildAquaPlant(AIAquaPlant(myThing));
        cLadybug:
          result := BuildLadybug(AILadybug(myThing));
        cAnt:
          result := BuildAnt(AIAnt(myThing));
        cEvolvingTree:
          BuildEvolvingTree(AIEvolvingTree(myThing));
        cEvolvingFruit:
          BuildEvolvingFruit(AIEvolvingFruit(myThing));
        cEvolvingSeed:
          BuildEvolvingSeed(AIEvolvingSeed(myThing));
        cFireTree:
          BuildFireTree(AIFireTree(myThing));
        cSpeech:
          BuildSpeech(AISpeech(myThing));
        cMissileDefence:
          BuildMissileDefence(AIMissileDefence(myThing));
        cMissile:
          BuildMissile(AIMissile(myThing));
      end;
    end;
    Environment.Things.EmptyCradle;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.CheckPurgatory;
var
  i: Integer;
  myCrossover: TCrossover;
  myThing: AIThing;
  myCount: Integer;
begin
  myCount := Environment.Things.Purgatory.Count;
  // remove things in purgatory
  if not(myCount = 0) then
  begin
    for i := 0 to myCount - 1 do
    begin
      myThing := AIThing(Environment.Things.Purgatory.Items[i]);
      if myThing.Kind = cSpeech then
      begin
        myCrossover := fSpeeches.FindCrossoverByData(myThing);
        fSpeeches.Remove(myCrossover);
      end;

      // myCrossover := myThing.Crossover;
      myCrossover := Satellites.FindCrossoverByData(myThing);
      if Assigned(myCrossover) then
      begin
        if myCrossover.SubVisuals.Count > 0 then
          GLShadowVolume.Occluders.RemoveCaster
            (TGLBaseSceneObject(myCrossover.SubVisuals.Items[0]));
        if myThing.Kind = cSun then
          GLShadowVolume.Lights.RemoveCaster
            (TGLBaseSceneObject(myCrossover.SubVisuals.Items[1]));
        Satellites.Remove(myCrossover);
        if HiddenTarget = myCrossover then
          HiddenTarget := nil;
        if PlayTarget = myCrossover then
          PlayTarget := nil;
        // find the next kind of obj
        if TargetToFollow = myCrossover then
          if Satellites.SetReverseCrossoverByKind(myThing.Kind) then
          begin
            TargetToFollow := Satellites.ActiveItem;
            SetCameraByTarget;
          end;
        if TargetToFollow = myCrossover then
          TargetToFollow := nil;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.CheckTrash;
var
  i: Integer;
  myCrossover: TCrossover;
  myThing: AIThing;
  myCount: Integer;
begin
  myCount := Environment.Things.Trash.Count;
  // remove things in purgatory
  if not(myCount = 0) then
  begin
    for i := 0 to myCount - 1 do
    begin
      myThing := AIThing(Environment.Things.Trash.Items[i]);
      // myCrossover := myThing.Crossover;
      myCrossover := Satellites.FindCrossoverByData(myThing);
      if Assigned(myCrossover) then
      begin
        if myCrossover.SubVisuals.Count > 0 then
          GLShadowVolume.Occluders.RemoveCaster
            (TGLBaseSceneObject(myCrossover.SubVisuals.Items[0]));
        if myThing.Kind = cSun then
          GLShadowVolume.Lights.RemoveCaster
            (TGLBaseSceneObject(myCrossover.SubVisuals.Items[1]));
        Satellites.Remove(myCrossover);
        if HiddenTarget = myCrossover then
          HiddenTarget := nil;
        if PlayTarget = myCrossover then
          PlayTarget := nil;
        // find the next kind of obj
        if TargetToFollow = myCrossover then
          if Satellites.SetReverseCrossoverByKind(myThing.Kind) then
          begin
            TargetToFollow := Satellites.ActiveItem;
            SetCameraByTarget;
          end;
        if TargetToFollow = myCrossover then
          TargetToFollow := nil;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssLeft] then
  begin
    ToolIsActive := true;
    if Tool = tSelect then
      PickObjectWithMouse;
    if Tool = tMove then
    begin
      PlayTarget := Satellites.FindCrossoverByData(FindObjectUnderMouse);
    end;
  end;

  if (CameraMode = camAvatar) or (CameraMode = camFree) then
  begin
    if ssRight in Shift then
    begin
      ToolIsActive := false;
    end;
    if ssMiddle in Shift then
    begin
      Flying := true;
      FlyingForwards := false;
    end;
    if (Shift = [ssRight, ssLeft]) then
    begin
      Flying := true;
      FlyingForwards := true;
    end;
  end;

end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.GLSceneViewerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // stop using tool when user lifts mouse button
  if (CameraMode = camAvatar) or (CameraMode = camFree) then
  begin
    if Flying then
      Flying := false;
    if not(ssRight in Shift) then
      Screen.Cursor := crDefault;
  end;

  ToolIsActive := false;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.GLSceneViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  // move camera
  case CameraMode of
    camPlanet, camSatellite:
      if Shift = [ssRight] then
      begin
        ViewDestination.MoveX((mouse_x - X) / 16);
        if fmFirstForm.UserSettings.InvertPlanet then
          ViewDestination.MoveYNoPoles((mouse_y - Y) / 16)
        else
          ViewDestination.MoveYNoPoles((Y - mouse_y) / 16);
      end;

    camTarget:
      begin
        // rotate/move around target
        if Shift = [ssRight] then
        begin
          ViewDestination.DirectionXY := ViewDestination.DirectionXY +
            (mouse_x - X) / 64;
          if fmFirstForm.UserSettings.InvertMouse then
            ViewDestination.DirectionH := ViewDestination.DirectionH +
              (mouse_y - Y) / 64
          else
            ViewDestination.DirectionH := ViewDestination.DirectionH +
              (Y - mouse_y) / 64;
        end;
        // move targets position
        if (Tool = tSelect) and (Shift = [ssLeft]) and (Assigned(TargetToFollow))
        then
        begin
          // move by horizontal mouse movement
          AIThing(TargetToFollow.Data).Position.Velocity.ApplyAngularForce
            (ViewDestination.DirectionXY - HalfPi, (X - mouse_x) / 128);
          // move by vertical mouse movement along Y
          AIThing(TargetToFollow.Data).Position.Velocity.ApplyAngularForce
            (ViewDestination.DirectionXY, (Y - mouse_y) / 128 *
            cos(ViewDestination.DirectionH));
          // move by vertical mouse movement along Height
          AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaHeight
            ((mouse_y - Y) / 128 * sin(ViewDestination.DirectionH));
        end;
      end;

    camAvatar, camFree:
      if (Shift = [ssRight]) or (Shift = [ssRight, ssLeft]) then
      begin
        ViewDestination.DirectionXY := ViewDestination.DirectionXY -
          (mouse_x - X) / 64;
        if fmFirstForm.UserSettings.InvertMouse then
          ViewDestination.DirectionH := ViewDestination.DirectionH +
            (mouse_y - Y) / 128
        else
          ViewDestination.DirectionH := ViewDestination.DirectionH +
            (Y - mouse_y) / 128;
      end;
  end;

  // move tool
  if Tool = tMove then
  begin
    if (Shift = [ssLeft]) and (Assigned(PlayTarget)) then
    begin
      case CameraMode of
        camFree, camAvatar, camEyes:
          begin
            // move by horizontal mouse movement
            AIThing(PlayTarget.Data).Position.Velocity.ApplyAngularForce
              (ViewDestination.DirectionXY + HalfPi, (X - mouse_x) / 128.0);
            // move by vertical mouse movement along Y
            AIThing(PlayTarget.Data).Position.Velocity.ApplyAngularForce
              (ViewDestination.DirectionXY, (Y - mouse_y) / 128.0 *
              cos(ViewDestination.DirectionH));
            // move by vertical mouse movement along Height
            AIThing(PlayTarget.Data).Position.Velocity.AlterDeltaHeight
              ((mouse_y - Y) / 128.0 * sin(ViewDestination.DirectionH));
          end;
      else
        begin
          // move by horizontal mouse movement
          AIThing(PlayTarget.Data).Position.Velocity.ApplyAngularForce
            (ViewDestination.DirectionXY - HalfPi, (X - mouse_x) / 128.0);
          // move by vertical mouse movement along Y
          AIThing(PlayTarget.Data).Position.Velocity.ApplyAngularForce
            (ViewDestination.DirectionXY, (Y - mouse_y) / 128.0 *
            cos(ViewDestination.DirectionH));
          // move by vertical mouse movement along Height
          AIThing(PlayTarget.Data).Position.Velocity.AlterDeltaHeight
            ((mouse_y - Y) / 128.0 * sin(ViewDestination.DirectionH));
        end;
      end; // case
    end;
  end;

  // store position of mouse
  mouse_x := X;
  mouse_y := Y;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  myInvert: single;
begin
  myInvert := 1;
  if fmFirstForm.UserSettings.InvertMouseWheel then
    myInvert := -1;

  case CameraMode of
    camPlanet, camSatellite:
      begin
        ViewDestination.MoveHeight(myInvert * -1 * WheelDelta / 16);
        // if ViewPosition.HeightAbove < 15 then CameraMode := camAvatar;
      end;

    camTarget:
      ViewOffset := ViewOffset - myInvert * WheelDelta / 64;

    camAvatar:
      if WheelDelta < 0 then
        CameraMode := camPlanet;

    camFree:
      ViewDestination.MoveHeight(myInvert * -1 * WheelDelta / 32);
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.CalculateCursorPosition;
var
  rayStart, rayVector, iPoint, iNormal: TGLVector;
  myCrossover: TCrossover;
  triangle: TOctreeTriangleInfo;
  locRayStart, locRayVector: TGLVector;
begin
  SetVector(rayStart, GLCamera.AbsolutePosition);
  SetVector(rayVector, GLSceneViewer.Buffer.ScreenToVector
    (AffineVectorMake(mouse_x, GLSceneViewer.Height - mouse_y, 0)));

  NormalizeVector(rayVector);

  SetVector(locRayStart, PlanetModel.AbsoluteToLocal(rayStart));
  SetVector(locRayVector, PlanetModel.AbsoluteToLocal(rayVector));

  if PlanetModel.Octree.RayCastIntersect(locRayStart, locRayVector, @iPoint,
    @iNormal, @triangle) then
  begin
    myCrossover := PlanetGrid.FindCrossoverByVertexIndex(triangle.index);
    fFocusGrid := myCrossover.Data;
    ValidCursor := true;
    RefreshCursor;
  end
  else
  begin
    ValidCursor := false;
    RefreshCursor;
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildMoon(aMoon: AIMoon): TCrossover;
var
  mySphere: TGLSphere;
begin
  mySphere := TGLSphere(SatellitesCube.AddNewChild(TGLSphere));
  mySphere.radius := aMoon.Size; // 0.75;
  mySphere.Material.MaterialLibrary := GLMaterialLibrary;
  mySphere.Material.LibMaterialName := 'moon';
  mySphere.Material.FrontProperties.Emission.Color := clrBlack;

  GLShadowVolume.Occluders.AddCaster(mySphere);

  result := Satellites.NewCrossover;
  result.Data := aMoon;
  result.SubVisuals.Add(mySphere);
  aMoon.Crossover := result;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildSun(aSun: AISun): TCrossover;
var
  mySphere: TGLSphere;
  myLight: TGLLightSource;
  myFire: TGLFireFXManager;
  myFireFX: TGLBFireFX;
begin
  // create crossover
  result := Satellites.NewCrossover;
  result.Data := aSun;

  mySphere := TGLSphere(SatellitesCube.AddNewChild(TGLSphere));
  mySphere.radius := aSun.Size;

  mySphere.Material.MaterialLibrary := GLMaterialLibrary;
  mySphere.Material.LibMaterialName := 'sun';
  mySphere.Material.FrontProperties.Emission.Color := clrWhite;
  result.SubVisuals.Add(mySphere);

  // add sunlight
  myLight := TGLLightSource(LightsCube.AddNewChild(TGLLightSource));
  myLight.LightStyle := lsOmni;
  result.SubVisuals.Add(myLight);

  GLShadowVolume.Lights.AddCaster(myLight);

  // add fire to sun
  if tbShowFire.Down and mySphere.Effects.CanAdd(TGLBFireFX) then
  begin
    myFire := TGLFireFXManager.Create(self);
    myFire.OuterColor.Red := 0.9;
    myFire.FireRadius := mySphere.radius * 1.25;
    myFire.ParticleSize := mySphere.radius * 2;
    myFire.Cadencer := GLCadencer;
    myFireFX := TGLBFireFX.Create(nil);
    mySphere.Effects.Add(myFireFX);
    myFireFX.Manager := myFire;
    result.SubVisuals.Add(myFire);
  end;

  // add burning sound
  if GLBass.Active then
    with GetOrCreateSoundEmitter(TGLBaseSceneObject(mySphere)) do
    begin
      Source.SoundLibrary := GLSoundLibrary;
      Source.SoundName := GLSoundLibrary.Samples[1].Name;
      Source.NbLoops := 2;
      Playing := true;
    end;

  aSun.Crossover := result;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.RefreshSatellites;
var
  i: Integer;
  myCrossover: TCrossover;
  myThing: AIThing;
begin
  for i := 0 to Satellites.Count - 1 do
  begin
    myCrossover := TCrossover(Satellites.Items[i]);
    myThing := myCrossover.Data;
    case myThing.Kind of
      cAppleTree:
        UpdateAppleTree(myCrossover);
      cOrangeTree:
        UpdateOrangeTree(myCrossover);
      cCloud:
        if CloudCube.Visible then
          UpdateCloud(myCrossover);
      cFish:
        UpdateFish(myCrossover);
      cBird:
        UpdateBird(myCrossover);
      cBot:
        UpdateBot(myCrossover);
      cSun:
        UpdateSun(myCrossover);
      cMoon:
        UpdateMoon(myCrossover);
      cAsteroid:
        UpdateAsteroid(myCrossover);
      cApple:
        UpdateApple(myCrossover);
      cOrange:
        UpdateOrange(myCrossover);
      cAppleSeed:
        UpdateSeed(myCrossover);
      cOrangeSeed:
        UpdateSeed(myCrossover);
      cTrex:
        UpdateTrex(myCrossover);
      cShark:
        UpdateShark(myCrossover);
      cGrazer:
        UpdateGrazer(myCrossover);
      cTurtle:
        UpdateTurtle(myCrossover);
      cHawk:
        UpdateHawk(myCrossover);
      cCrab:
        UpdateCrab(myCrossover);
      cBall:
        UpdateBall(myCrossover);
      cExplosion:
        UpdateExplosion(myCrossover);
      cBeacon:
        UpdateBeacon(myCrossover);
      cTerrier:
        UpdateTerrier(myCrossover);
      cFox:
        UpdateFox(myCrossover);
      cRabbit:
        UpdateRabbit(myCrossover);
      cGrass:
        UpdateGrass(myCrossover);
      cIceberg:
        UpdateIceberg(myCrossover);
      cMouse:
        UpdateMouse(myCrossover);
      cTiger:
        UpdateTiger(myCrossover);
      cDuck:
        UpdateDuck(myCrossover);
      cDolphin:
        UpdateDolphin(myCrossover);
      cAquaPlant:
        UpdateAquaPlant(myCrossover);
      cLadybug:
        UpdateLadybug(myCrossover);
      cAnt:
        UpdateAnt(myCrossover);
      cEvolvingTree:
        UpdateEvolvingTree(myCrossover);
      cEvolvingFruit:
        UpdateEvolvingFruit(myCrossover);
      cEvolvingSeed:
        UpdateEvolvingSeed(myCrossover);
      cFireTree:
        UpdateFireTree(myCrossover);
      cSpeech:
        UpdateSpeech(myCrossover);
      cMissileDefence:
        UpdateMissileDefence(myCrossover);
      cMissile:
        UpdateMissile(myCrossover);
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbBuildMoonClick(Sender: TObject);
var
  myMoon: AIMoon;
begin
  // add first moon to top, second to bottom
  BreakLimits(cMoon);
  if not Environment.Things.CanAdd(cMoon) then
    exit;
  myMoon := AIMoon(Environment.Things.NewThing(cMoon));
  ReportUserEvent('Added moon: ' + myMoon.OneLineDisplay);
  fmFirstForm.Construction.AddEvent('Added moon.');
  LastAction('Added=moon');
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbBuildSunClick(Sender: TObject);
var
  mySun: AISun;
begin
  if not Environment.Things.CanAdd(cSun) then
  begin
    ShowMessage('Maximum four suns!');
    exit;
  end;

  mySun := AISun(Environment.Things.NewThing(cSun));
  if not(mySun = nil) then
    ReportUserEvent('Added Sun: ' + mySun.OneLineDisplay);
  fmFirstForm.Construction.AddEvent('Added sun.');
  LastAction('Added=sun');
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetMouseGridX(X: Integer);
begin
  fMouseGridX := X;

  if fMouseGridX > Environment.Space.Width - 1 then
    fMouseGridX := Environment.Space.Width - 1;
  if fMouseGridX < 0 then
    fMouseGridX := 0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetMouseGridY(Y: Integer);
begin
  fMouseGridY := Y;

  if fMouseGridY > Environment.Space.Height - 1 then
    fMouseGridY := Environment.Space.Height - 1;
  if fMouseGridY < 0 then
    fMouseGridY := 0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.ReportUserEvent(aEvent: string);
begin
  fmFirstForm.RealityForm.ManagerForm.EventsForm.AddEvent
    (fmFirstForm.RealityForm.Reality.Creator + ' -> ' + aEvent);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbWateringCanClick(Sender: TObject);
begin
  Tool := tWateringCan;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbSpongeClick(Sender: TObject);
begin
  Tool := tSponge;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbSplashClick(Sender: TObject);
begin
  Tool := tSplash;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbRaiseLandClick(Sender: TObject);
begin
  Tool := tRaiseLand;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbLowerLandClick(Sender: TObject);
begin
  Tool := tLowerLand;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateGridHeight(aGrid: AIGrid);
begin
  if SphereMode then
  begin
    SetGridHeightPoints(aGrid);

    // direct adjacents
    SetGridHeightPoints(aGrid.ConnectionUp);
    SetGridHeightPoints(aGrid.ConnectionDown);
    SetGridHeightPoints(aGrid.ConnectionLeft);
    SetGridHeightPoints(aGrid.ConnectionRight);

    // diagonal adjacents
    SetGridHeightPoints(aGrid.ConnectionUpLeft);
    SetGridHeightPoints(aGrid.ConnectionUpRight);
    SetGridHeightPoints(aGrid.ConnectionDownLeft);
    SetGridHeightPoints(aGrid.ConnectionDownRight);
    exit;
  end;

  // flat
  SetFlatGridHeightPoints(aGrid);
  SetFlatGridHeightPoints(aGrid.ConnectionUp);
  SetFlatGridHeightPoints(aGrid.ConnectionDown);
  SetFlatGridHeightPoints(aGrid.ConnectionLeft);
  SetFlatGridHeightPoints(aGrid.ConnectionRight);
  SetFlatGridHeightPoints(aGrid.ConnectionUpLeft);
  SetFlatGridHeightPoints(aGrid.ConnectionUpRight);
  SetFlatGridHeightPoints(aGrid.ConnectionDownLeft);
  SetFlatGridHeightPoints(aGrid.ConnectionDownRight);

end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetGridHeightPoints(aGrid: AIGrid);
var
  myCrossover: TGridCrossover;

  NormalMiddle, NormalUpLeft, NormalDownLeft, NormalUpRight, NormalDownRight
    : TAffineVector;
  NormalUp, NormalDown, NormalLeft, NormalRight: TAffineVector;

  // grid heights (mountains/valleys)
  HeightMiddle: single;
  HeightUpLeft: single;
  HeightUpRight: single;
  HeightDownLeft: single;
  HeightDownRight: single;
  HeightUp: single;
  HeightDown: single;
  HeightLeft: single;
  HeightRight: single;

  VertexMiddle, VertexUpLeft, VertexUpRight, VertexDownLeft, VertexDownRight
    : TAffineVector;
  VertexUp, VertexDown, VertexLeft, VertexRight: TAffineVector;
begin
  myCrossover := TGridCrossover(aGrid.Crossover);

  HeightMiddle := PlanetRadius + aGrid.Height / cHeightDivision;
  HeightUpLeft := PlanetRadius + aGrid.CornerValues[cHeightUpLeft] /
    cHeightDivision;
  HeightUpRight := PlanetRadius + aGrid.CornerValues[cHeightUpRight] /
    cHeightDivision;
  HeightDownLeft := PlanetRadius + aGrid.CornerValues[cHeightDownLeft] /
    cHeightDivision;
  HeightDownRight := PlanetRadius + aGrid.CornerValues[cHeightDownRight] /
    cHeightDivision;
  HeightUp := PlanetRadius + aGrid.CornerValues[cHeightUp] / cHeightDivision;
  HeightDown := PlanetRadius + aGrid.CornerValues[cHeightDown] /
    cHeightDivision;
  HeightLeft := PlanetRadius + aGrid.CornerValues[cHeightLeft] /
    cHeightDivision;
  HeightRight := PlanetRadius + aGrid.CornerValues[cHeightRight] /
    cHeightDivision;

  NormalMiddle := myCrossover.Normals[0];
  NormalUpLeft := myCrossover.Normals[1];
  NormalDownLeft := myCrossover.Normals[2];
  NormalUpRight := myCrossover.Normals[3];
  NormalDownRight := myCrossover.Normals[4];
  NormalUp := myCrossover.Normals[5];
  NormalDown := myCrossover.Normals[6];
  NormalLeft := myCrossover.Normals[7];
  NormalRight := myCrossover.Normals[8];

  VertexMiddle.X := (HeightMiddle) * NormalMiddle.X;
  VertexMiddle.Y := (HeightMiddle) * NormalMiddle.Y;
  VertexMiddle.Z := (HeightMiddle) * NormalMiddle.Z;

  VertexUpLeft.X := (HeightUpLeft) * NormalUpLeft.X;
  VertexUpLeft.Y := (HeightUpLeft) * NormalUpLeft.Y;
  VertexUpLeft.Z := (HeightUpLeft) * NormalUpLeft.Z;

  VertexDownLeft.X := (HeightDownLeft) * NormalDownLeft.X;
  VertexDownLeft.Y := (HeightDownLeft) * NormalDownLeft.Y;
  VertexDownLeft.Z := (HeightDownLeft) * NormalDownLeft.Z;

  VertexDownRight.X := (HeightDownRight) * NormalDownRight.X;
  VertexDownRight.Y := (HeightDownRight) * NormalDownRight.Y;
  VertexDownRight.Z := (HeightDownRight) * NormalDownRight.Z;

  VertexUpRight.X := (HeightUpRight) * NormalUpRight.X;
  VertexUpRight.Y := (HeightUpRight) * NormalUpRight.Y;
  VertexUpRight.Z := (HeightUpRight) * NormalUpRight.Z;

  VertexUp.X := (HeightUp) * NormalUp.X;
  VertexUp.Y := (HeightUp) * NormalUp.Y;
  VertexUp.Z := (HeightUp) * NormalUp.Z;

  VertexDown.X := (HeightDown) * NormalDown.X;
  VertexDown.Y := (HeightDown) * NormalDown.Y;
  VertexDown.Z := (HeightDown) * NormalDown.Z;

  VertexLeft.X := (HeightLeft) * NormalLeft.X;
  VertexLeft.Y := (HeightLeft) * NormalLeft.Y;
  VertexLeft.Z := (HeightLeft) * NormalLeft.Z;

  VertexRight.X := (HeightRight) * NormalRight.X;
  VertexRight.Y := (HeightRight) * NormalRight.Y;
  VertexRight.Z := (HeightRight) * NormalRight.Z;

  // 1 left triangle
  PlanetVertices.Items[myCrossover.Vertices[0][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[0][1]] := VertexUp;
  PlanetVertices.Items[myCrossover.Vertices[0][2]] := VertexUpRight;
  // 2 bottom triangle
  PlanetVertices.Items[myCrossover.Vertices[1][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[1][1]] := VertexUpRight;
  PlanetVertices.Items[myCrossover.Vertices[1][2]] := VertexRight;
  // 3 right triangle
  PlanetVertices.Items[myCrossover.Vertices[2][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[2][1]] := VertexRight;
  PlanetVertices.Items[myCrossover.Vertices[2][2]] := VertexDownRight;
  // 4 top triangle
  PlanetVertices.Items[myCrossover.Vertices[3][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[3][1]] := VertexDownRight;
  PlanetVertices.Items[myCrossover.Vertices[3][2]] := VertexDown;
  // 5 top triangle
  PlanetVertices.Items[myCrossover.Vertices[4][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[4][1]] := VertexDown;
  PlanetVertices.Items[myCrossover.Vertices[4][2]] := VertexDownLeft;
  // 6 top triangle
  PlanetVertices.Items[myCrossover.Vertices[5][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[5][1]] := VertexDownLeft;
  PlanetVertices.Items[myCrossover.Vertices[5][2]] := VertexLeft;
  // 7 top triangle
  PlanetVertices.Items[myCrossover.Vertices[6][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[6][1]] := VertexLeft;
  PlanetVertices.Items[myCrossover.Vertices[6][2]] := VertexUpLeft;
  // 8 top triangle
  PlanetVertices.Items[myCrossover.Vertices[7][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[7][1]] := VertexUpLeft;
  PlanetVertices.Items[myCrossover.Vertices[7][2]] := VertexUp;
  // shades sides of land, light looks more realistic, but reveals blockiness
  { // 1
    PlanetMesh.Normals.Items[myCrossover.Vertices[0][1]] := CalcPlaneNormal(VertexMiddle, VertexUpRight, VertexUp);
    PlanetMesh.Normals.Items[myCrossover.Vertices[0][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[0][1]];
    // 2
    PlanetMesh.Normals.Items[myCrossover.Vertices[1][1]] := CalcPlaneNormal(VertexMiddle, VertexRight, VertexUpRight);
    PlanetMesh.Normals.Items[myCrossover.Vertices[1][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[1][1]];
    // 3
    PlanetMesh.Normals.Items[myCrossover.Vertices[2][1]] := CalcPlaneNormal(VertexMiddle, VertexDownRight, VertexRight);
    PlanetMesh.Normals.Items[myCrossover.Vertices[2][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[2][1]];
    // 4
    PlanetMesh.Normals.Items[myCrossover.Vertices[3][1]] := CalcPlaneNormal(VertexMiddle, VertexDown, VertexDownRight);
    PlanetMesh.Normals.Items[myCrossover.Vertices[3][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[3][1]];
    // 5
    PlanetMesh.Normals.Items[myCrossover.Vertices[4][1]] := CalcPlaneNormal(VertexMiddle, VertexDownLeft, VertexDown);
    PlanetMesh.Normals.Items[myCrossover.Vertices[4][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[4][1]];
    // 6
    PlanetMesh.Normals.Items[myCrossover.Vertices[5][1]] := CalcPlaneNormal(VertexMiddle, VertexLeft, VertexDownLeft);
    PlanetMesh.Normals.Items[myCrossover.Vertices[5][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[5][1]];
    // 7
    PlanetMesh.Normals.Items[myCrossover.Vertices[6][1]] := CalcPlaneNormal(VertexMiddle, VertexUpLeft, VertexLeft);
    PlanetMesh.Normals.Items[myCrossover.Vertices[6][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[6][1]];
    // 8
    PlanetMesh.Normals.Items[myCrossover.Vertices[7][1]] := CalcPlaneNormal(VertexMiddle, VertexUp, VertexUpLeft);
    PlanetMesh.Normals.Items[myCrossover.Vertices[7][2]] := PlanetMesh.Normals.Items[myCrossover.Vertices[7][1]];
  }
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateWaterHeight(aGrid: AIGrid);
begin
  if SphereMode then
  begin
    SetWaterHeightPoints(aGrid);

    // direct adjacents
    // if not aGrid.ConnectionUp.Changed then
    SetWaterHeightPoints(aGrid.ConnectionUp);
    // if not aGrid.ConnectionDown.Changed then
    SetWaterHeightPoints(aGrid.ConnectionDown);
    // if not aGrid.ConnectionLeft.Changed then
    SetWaterHeightPoints(aGrid.ConnectionLeft);
    // if not aGrid.ConnectionRight.Changed then
    SetWaterHeightPoints(aGrid.ConnectionRight);

    // diagonal adjacents
    // if not aGrid.ConnectionUp.ConnectionLeft.Changed then
    SetWaterHeightPoints(aGrid.ConnectionUpLeft);
    // if not aGrid.ConnectionUp.ConnectionRight.Changed then
    SetWaterHeightPoints(aGrid.ConnectionUpRight);
    // if not aGrid.ConnectionDown.ConnectionLeft.Changed then
    SetWaterHeightPoints(aGrid.ConnectionDownLeft);
    // if not aGrid.ConnectionDown.ConnectionRight.Changed then
    SetWaterHeightPoints(aGrid.ConnectionDownRight);
    exit;
  end;

  // flat
  SetFlatWaterHeightPoints(aGrid);
  SetFlatWaterHeightPoints(aGrid.ConnectionUp);
  SetFlatWaterHeightPoints(aGrid.ConnectionDown);
  SetFlatWaterHeightPoints(aGrid.ConnectionLeft);
  SetFlatWaterHeightPoints(aGrid.ConnectionRight);
  SetFlatWaterHeightPoints(aGrid.ConnectionUpLeft);
  SetFlatWaterHeightPoints(aGrid.ConnectionUpRight);
  SetFlatWaterHeightPoints(aGrid.ConnectionDownLeft);
  SetFlatWaterHeightPoints(aGrid.ConnectionDownRight);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetWaterHeightPoints(aGrid: AIGrid);
var
  myCrossover: TGridCrossover;

  myMiddleNormal: TAffineVector;
  myUpLeftNormal: TAffineVector;
  myUpRightNormal: TAffineVector;
  myDownLeftNormal: TAffineVector;
  myDownRightNormal: TAffineVector;

  WaterMiddle: single;
  WaterUpLeft: single;
  WaterUpRight: single;
  WaterDownLeft: single;
  WaterDownRight: single;

  MiddleVertex: TAffineVector;
  UpLeftVertex: TAffineVector;
  UpRightVertex: TAffineVector;
  DownLeftVertex: TAffineVector;
  DownRightVertex: TAffineVector;
begin
  myCrossover := TGridCrossover(aGrid.WaterCrossover);

  WaterUpLeft := WaterRadius + (aGrid.CornerValues[cWaterUpLeft]) /
    cHeightDivision;
  WaterUpRight := WaterRadius + (aGrid.CornerValues[cWaterUpRight]) /
    cHeightDivision;
  WaterDownLeft := WaterRadius + (aGrid.CornerValues[cWaterDownLeft]) /
    cHeightDivision;
  WaterDownRight := WaterRadius + (aGrid.CornerValues[cWaterDownRight]) /
    cHeightDivision;
  WaterMiddle := WaterRadius + aGrid.Water / cHeightDivision;
  // WaterMiddle := Min(WaterUpLeft, WaterUpRight, WaterDownLeft, WaterDownRight);

  myMiddleNormal := myCrossover.Normals[0];
  myUpLeftNormal := myCrossover.Normals[1];
  myDownLeftNormal := myCrossover.Normals[2];
  myUpRightNormal := myCrossover.Normals[3];
  myDownRightNormal := myCrossover.Normals[4];

  MiddleVertex.X := WaterMiddle * myMiddleNormal.X;
  MiddleVertex.Y := WaterMiddle * myMiddleNormal.Y;
  MiddleVertex.Z := WaterMiddle * myMiddleNormal.Z;

  UpLeftVertex.X := WaterUpLeft * myUpLeftNormal.X;
  UpLeftVertex.Y := WaterUpLeft * myUpLeftNormal.Y;
  UpLeftVertex.Z := WaterUpLeft * myUpLeftNormal.Z;

  DownLeftVertex.X := WaterDownLeft * myDownLeftNormal.X;
  DownLeftVertex.Y := WaterDownLeft * myDownLeftNormal.Y;
  DownLeftVertex.Z := WaterDownLeft * myDownLeftNormal.Z;

  DownRightVertex.X := WaterDownRight * myDownRightNormal.X;
  DownRightVertex.Y := WaterDownRight * myDownRightNormal.Y;
  DownRightVertex.Z := WaterDownRight * myDownRightNormal.Z;

  UpRightVertex.X := WaterUpRight * myUpRightNormal.X;
  UpRightVertex.Y := WaterUpRight * myUpRightNormal.Y;
  UpRightVertex.Z := WaterUpRight * myUpRightNormal.Z;

  // left triangle
  WaterVertices.Items[myCrossover.Vertices[0][0]] := MiddleVertex;
  WaterVertices.Items[myCrossover.Vertices[0][1]] := DownLeftVertex;
  WaterVertices.Items[myCrossover.Vertices[0][2]] := UpLeftVertex;

  // bottom triangle
  WaterVertices.Items[myCrossover.Vertices[1][0]] := MiddleVertex;
  WaterVertices.Items[myCrossover.Vertices[1][1]] := DownRightVertex;
  WaterVertices.Items[myCrossover.Vertices[1][2]] := DownLeftVertex;

  // right triangle
  WaterVertices.Items[myCrossover.Vertices[2][0]] := MiddleVertex;
  WaterVertices.Items[myCrossover.Vertices[2][1]] := UpRightVertex;
  WaterVertices.Items[myCrossover.Vertices[2][2]] := DownRightVertex;

  // top triangle
  WaterVertices.Items[myCrossover.Vertices[3][0]] := MiddleVertex;
  WaterVertices.Items[myCrossover.Vertices[3][1]] := UpLeftVertex;
  WaterVertices.Items[myCrossover.Vertices[3][2]] := UpRightVertex;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropSpace;

  if tbAVIMovie.Down then
  begin
    AVIRecorder.CloseAVIFile();
    tbAVIMovie.Down := false;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FPSTimerTimer(Sender: TObject);
begin
  // update FPS and reset counter for the next second
  GLScene.Progress(0, 0);
  FrameRate := GLSceneViewer.FramesPerSecond;
  StatusBar.Panels[0].Text := Format('%.1f FPS', [FrameRate]);
  GLSceneViewer.ResetPerformanceMonitor;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateMoon(aCrossover: TCrossover);
var
  mySphere: TGLSphere;
  myMoon: AIMoon;
begin
  mySphere := TGLSphere(aCrossover.SubVisuals.Items[0]);
  myMoon := AIMoon(aCrossover.Data);

  PositionThing(myMoon.Position, mySphere);

  // make the Moon slowly roll and pitch (looks neat)
  mySphere.RollAngle := mySphere.RollAngle - Random(2) * 0.5;
  mySphere.PitchAngle := mySphere.PitchAngle + Random(2) * 0.5;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateSun(aCrossover: TCrossover);
var
  mySphere: TGLSphere;
  mySun: AISun;
  myLight: TGLLightSource;
begin
  mySphere := TGLSphere(aCrossover.SubVisuals.Items[0]);
  myLight := TGLLightSource(aCrossover.SubVisuals.Items[1]);
  mySun := AISun(aCrossover.Data);

  PositionThing(mySun.Position, mySphere);

  myLight.Position.X := mySphere.Position.X;
  myLight.Position.Y := mySphere.Position.Y;
  myLight.Position.Z := mySphere.Position.Z;

  // mySphere.RollAngle := mySphere.RollAngle + Random(2) * 0.5;
  // mySphere.PitchAngle := mySphere.PitchAngle + Random(2) * 0.5;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildCloud(aCloud: AICloud): TCrossover;
var
  myProxy: TGLProxyObject;
  myRain: TGLProxyObject;
begin
  // add cloud proxy
  myProxy := TGLProxyObject(CloudCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := CloudModel;
    ProxyOptions := [pooObjects];
    Up := CloudModel.Up;
  end;

  // add rain proxy
  myRain := TGLProxyObject(CloudCube.AddNewChild(TGLProxyObject));
  with myRain do
  begin
    MasterObject := RainModel;
    ProxyOptions := [pooObjects];
    Up := RainModel.Up;
    Visible := false;
    RollAngle := Random(360);
    PitchAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aCloud;
  result.SubVisuals.Add(myProxy);
  result.SubVisuals.Add(myRain);
  aCloud.Crossover := result;
  UpdateCloud(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateCloud(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myRain: TGLProxyObject;
  myCloud: AICloud;
  myScale: TGLVector;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myRain := TGLProxyObject(aCrossover.SubVisuals.Items[1]);
  myCloud := AICloud(aCrossover.Data);

  PositionThing(myCloud.Position, myProxy, 0);

  myScale := CloudModel.Scale.AsVector;
  // ScaleVector(myScale, 0.01 + 0.002 * myCloud.Water);
  ScaleVector(myScale, 0.5 + 0.1 * myCloud.Water);
  myProxy.Scale.AsVector := myScale;

  myProxy.RollAngle := myProxy.RollAngle + 0.2;

  if myCloud.Raining then
  begin
    if aCrossover.Height <= 0 then
    begin
      // snow code
      // if AIGrid(myCloud.Position.Location).Temperature = 0 then
      // myRain.MasterObject := SnowModel;
      aCrossover.Height := Variant(myCloud.Position.Height);
    end;
    aCrossover.Height := aCrossover.Height - 2;

    myRain.Visible := true;
    myRain.Position.X := (PlanetRadius + aCrossover.Height / 10) *
      myProxy.Direction.X;
    myRain.Position.Y := (PlanetRadius + aCrossover.Height / 10) *
      myProxy.Direction.Y;
    myRain.Position.Z := (PlanetRadius + aCrossover.Height / 10) *
      myProxy.Direction.Z;
    myRain.RollAngle := myRain.RollAngle + Random(32);
    myRain.PitchAngle := myRain.PitchAngle + Random(32);
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildAppleTree(aTree: AITree): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ForestCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := AppleTreeModel;
    ProxyOptions := [pooObjects];
    Up := AppleTreeModel.Up;
    RollAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aTree;
  result.SubVisuals.Add(myProxy);
  aTree.Crossover := result;
  UpdateAppleTree(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildOrangeTree(aTree: AITree): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ForestCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := OrangeTreeModel;
    ProxyOptions := [pooObjects];
    Up := OrangeTreeModel.Up;
    RollAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aTree;
  result.SubVisuals.Add(myProxy);
  aTree.Crossover := result;
  UpdateOrangeTree(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildApple(aApple: AIFruit): TCrossover;
var
  myProxy: TGLProxyObject;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLProxyObject(FruitCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := AppleModel;
    ProxyOptions := [pooObjects];

    Up := AppleModel.Up;
    myFactor := 0.04;
    myScale := AppleModel.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
    RollAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aApple;
  result.SubVisuals.Add(myProxy);
  aApple.Crossover := result;
  UpdateApple(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildOrange(aOrange: AIFruit): TCrossover;
var
  myProxy: TGLProxyObject;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLProxyObject(FruitCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := OrangeModel;
    ProxyOptions := [pooObjects];

    Up := OrangeModel.Up;
    myFactor := 0.04;
    myScale := OrangeModel.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
    RollAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aOrange;
  result.SubVisuals.Add(myProxy);
  aOrange.Crossover := result;
  UpdateOrange(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildSeed(aSeed: AISeed): TCrossover;
var
  myProxy: TGLProxyObject;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLProxyObject(SeedCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := SeedModel;
    ProxyOptions := [pooObjects];

    Up := SeedModel.Up;

    myFactor := 0.05;
    myScale := SeedModel.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;

    RollAngle := Random(360);
    PitchAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aSeed;
  result.SubVisuals.Add(myProxy);
  aSeed.Crossover := result;
  UpdateSeed(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildBot(aBot: AIBot): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(SpiritCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := SpiritModel;
    ProxyOptions := [pooObjects];
    Up := SpiritModel.Up;
  end;

  result := Satellites.NewCrossover;
  result.Data := aBot;
  result.SubVisuals.Add(myProxy);
  aBot.Crossover := result;
  UpdateBot(result);
end;

// ----------------------------------------------------------------------------
// called whenever a new fish is added
function Tfm3DEnvironment.BuildFish(aFish: AIFish): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    if aFish.Female then
      MasterObject := FishGirlModel
    else
      MasterObject := FishModel;
    ProxyOptions := [pooObjects];
    Up := FishModel.Up;
    RollAngle := Random(360);
  end;

  PlaySound(5, 1, aFish.Position);
  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aFish;
  result.SubVisuals.Add(myProxy);
  aFish.Crossover := result;
  UpdateFish(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildAsteroid(aAsteroid: AIAsteroid): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    if aAsteroid.Energy = 0 then
      MasterObject := AsteroidModel
    else if aAsteroid.Energy > 0 then
      MasterObject := SunAsteroidModel
    else
      MasterObject := MoonAsteroidModel;

    ProxyOptions := [pooObjects];
    Up := AsteroidModel.Up;
    RollAngle := Random(360);
    PitchAngle := Random(360);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aAsteroid;
  result.SubVisuals.Add(myProxy);
  aAsteroid.Crossover := result;
  UpdateAsteroid(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildExplosion(aExplosion: AIExplosion): TCrossover;
var
  myProxy: TGLProxyObject;
  myScale: TGLVector;
  myFactor: single;
  myFire: TGLFireFXManager;
  myFireFX: TGLBFireFX;
begin
  myProxy := TGLProxyObject(EffectsCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := ExplosionModel;
    ProxyOptions := [pooObjects];
    Up := ExplosionModel.Up;
    myFactor := 1;
    myScale := ExplosionModel.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
  end;

  result := Satellites.NewCrossover;
  result.Data := aExplosion;
  result.SubVisuals.Add(myProxy);
  aExplosion.Crossover := result;

  // add fire to sun
  if tbShowFire.Down and myProxy.Effects.CanAdd(TGLBFireFX) then
  begin
    myFire := TGLFireFXManager.Create(self);
    myFire.OuterColor.Red := 0.95;
    myFire.FireRadius := aExplosion.BlastRadius / 10;
    myFire.Cadencer := GLCadencer;
    myFireFX := TGLBFireFX.Create(nil);
    myProxy.Effects.Add(myFireFX);
    myFireFX.Manager := myFire;
    result.SubVisuals.Add(myFire);
  end;

  UpdateExplosion(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateExplosion(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myExplosion: AIExplosion;
  myFire: TGLFireFXManager;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myExplosion := AIExplosion(aCrossover.Data);

  PositionThing(myExplosion.Position, myProxy, 0, 0.25);

  if tbShowFire.Down then
  begin
    myFire := TGLFireFXManager(aCrossover.SubVisuals.Items[1]);
    myFire.ParticleSize := myExplosion.Strength * 200 + 0.5;
    myFire.FireDir.Assign(myProxy.Direction);
  end;

end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateAppleTree(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myTree: AITree;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myTree := AITree(aCrossover.Data);

  factor := myTree.Water + 0.1;
  Scale := AppleTreeModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myTree.Position, myProxy, 0, factor / 4);

  if myTree.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, QuarterPi);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateOrangeTree(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myTree: AITree;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myTree := AITree(aCrossover.Data);

  factor := myTree.Water + 0.01;
  Scale := OrangeTreeModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myTree.Position, myProxy, 0, factor / 4);

  if myTree.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, QuarterPi);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateApple(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myApple: AIFruit;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myApple := AIFruit(aCrossover.Data);

  PositionThing(myApple.Position, myProxy);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateOrange(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myOrange: AIFruit;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myOrange := AIFruit(aCrossover.Data);

  PositionThing(myOrange.Position, myProxy);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateSeed(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  mySeed: AISeed;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  mySeed := AISeed(aCrossover.Data);

  PositionThing(mySeed.Position, myProxy);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateBot(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myBot: AIBot;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myBot := AIBot(aCrossover.Data);

  factor := 0.4;
  Scale := SpiritModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myBot.Position, myProxy, HalfPi, factor);
end;

// ----------------------------------------------------------------------------
// called every round, to reposition the fish
procedure Tfm3DEnvironment.UpdateFish(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myFish: AIFish;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myFish := AIFish(aCrossover.Data);

  factor := myFish.Size / 4;
  Scale := FishModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myFish.Position, myProxy, HalfPi);

  if myFish.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, cHalfPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildBird(aBird: AIBird): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := BirdFlap2;
    ProxyOptions := [pooObjects, pooEffects];
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aBird;
  result.SubVisuals.Add(myProxy);
  aBird.Crossover := result;
  UpdateBird(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateBird(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myBird: AIBird;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myBird := AIBird(aCrossover.Data);

  if myBird.Flying then
  begin
    if (myBird.Position.Velocity.DeltaHeight > 0) or not(aCrossover.Height = 0)
    then
      aCrossover.Height := aCrossover.Height + 1;
    case aCrossover.Height of
      3:
        myProxy.MasterObject := BirdFlap1;
      9:
        myProxy.MasterObject := BirdFlap2;
      12:
        myProxy.MasterObject := BirdFlap3;
      14:
        myProxy.MasterObject := BirdFlap4;
      16:
        myProxy.MasterObject := BirdFlap3;
      18:
        begin
          myProxy.MasterObject := BirdFlap2;
          aCrossover.Height := 0;
        end;
    end;
  end
  else
    myProxy.MasterObject := BirdSit;

  if (myBird.Dead) then
    myProxy.MasterObject := BirdDead;

  factor := 0.2 + 0.0025 * myBird.Size;
  Scale := BirdFlap2.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myBird.Position, myProxy, HalfPi);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateAsteroid(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myAsteroid: AIAsteroid;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myAsteroid := AIAsteroid(aCrossover.Data);

  factor := 0.25 + 0.1 * myAsteroid.Size;
  Scale := AsteroidModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myAsteroid.Position, myProxy);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbAppleTreeClick(Sender: TObject);
begin
  Tool := tAppleTree;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCloudClick(Sender: TObject);
begin
  Tool := tCloud;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbAppleClick(Sender: TObject);
begin
  Tool := tApple;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbOrangeClick(Sender: TObject);
begin
  Tool := tOrange;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbFishClick(Sender: TObject);
begin
  LastAction('Tool=Fish');
  Tool := tFish;
  tbRepeat.Down := true;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbBirdClick(Sender: TObject);
begin
  LastAction('Tool=Bird');
  Tool := tBird;
  tbRepeat.Down := true;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbSpiritGuyClick(Sender: TObject);
begin
  Tool := tSpiritGuy;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbSpiritGirlClick(Sender: TObject);
begin
  Tool := tSpiritGirl;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.BuildGalaxy;
begin
  CameraMode := camPlanet;

  // clear everything
  fmFirstForm.Construction.AddEvent('Cleaning galaxy...');
  CleanGalaxy;

  SphereMode := Environment.Space.Spherical;
  tbSpherical.Down := SphereMode;

  // build planet
  fmFirstForm.Construction.AddEvent('Building planet...');
  BuildFromMap;

  // build new things
  fmFirstForm.Construction.AddEvent('Adding new things...');
  CheckCradle;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.CleanGalaxy;
begin
  core.X := 0;
  core.Y := 0;
  core.Z := 0;

  PlanetGrid.Clear; // clears the planet
  Satellites.Clear; // removes suns and moons, and sunlights+sunfires
  fFocusGrid := nil;

  PlanetModel.MeshObjects.Clear;
  SatellitesCube.DeleteChildren;
  ProxyCube.DeleteChildren;
  CloudCube.DeleteChildren;
  SpiritCube.DeleteChildren;
  SeedCube.DeleteChildren;
  FruitCube.DeleteChildren;
  ForestCube.DeleteChildren;

  RemoveLights;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.RemoveLights;
var
  myLight: TGLLightSource;
begin
  while LightsCube.Count > 0 do
  begin
    myLight := TGLLightSource(LightsCube.Children[0]);
    myLight.Free;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.BuildFromMap;
begin
  core.X := 0;
  core.Y := 0;
  core.Z := 0;

  SetPlanetVariables;

  HeightAngle := Pi / Environment.Space.Height;
  WidthAngle := cTwoPi / Environment.Space.Width;

  BuildPlanet(core, PlanetRadius, PlanetHeight, PlanetWidth, false);
  BuildWater(core, WaterRadius, PlanetHeight, PlanetWidth, false);
  BuildAtmosphere(core, PlanetRadius, PlanetHeight, PlanetWidth, false);
  CalculateTerrainSettings;
end;

// ----------------------------------------------------------------------------
// basic above-globe positioning
procedure Tfm3DEnvironment.CoordinatesFromPosition(aPosition: AIPosition;
  aCoordinates: TGLCoordinates);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;

  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision;

  aCoordinates.X := -1 * cos(myLatitude) * cos(myLongitude) * (myHeightOffset);
  aCoordinates.Y := -1 * sin(myLatitude) * (myHeightOffset);
  aCoordinates.Z := cos(myLatitude) * sin(myLongitude) * (myHeightOffset);

  if not SphereMode then
  begin
    aCoordinates.X := aPosition.X;
    aCoordinates.Y := aPosition.Y;
    aCoordinates.Z := aPosition.Height / cFlatHeightDivision;
  end;
end;

// ----------------------------------------------------------------------------
// basic above-globe positioning
procedure Tfm3DEnvironment.CoordinatesFromPosition(aX, aY, aHeight: single;
  aCoordinates: TGLCoordinates);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := aX / 10 * WidthAngle;
  myLatitude := aY / 10 * HeightAngle - cHalfPi;

  myHeightOffset := PlanetRadius + aHeight / cHeightDivision;

  aCoordinates.X := -1 * cos(myLatitude) * cos(myLongitude) * (myHeightOffset);
  aCoordinates.Y := -1 * sin(myLatitude) * (myHeightOffset);
  aCoordinates.Z := cos(myLatitude) * sin(myLongitude) * (myHeightOffset);

  if not SphereMode then
  begin
    aCoordinates.X := aX;
    aCoordinates.Y := aY;
    aCoordinates.Z := aHeight / cFlatHeightDivision;
  end;
end;

// ----------------------------------------------------------------------------
// basic above-globe positioning
procedure Tfm3DEnvironment.CoordinatesFromPosition(aOrigin: TAffineVector;
  var aVector: TAffineVector);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := aOrigin.X / 10 * WidthAngle;
  myLatitude := aOrigin.Y / 10 * HeightAngle - cHalfPi;

  myHeightOffset := PlanetRadius + aOrigin.Z / cHeightDivision;

  aVector.X := -1 * cos(myLatitude) * cos(myLongitude) * (myHeightOffset);
  aVector.Y := -1 * sin(myLatitude) * (myHeightOffset);
  aVector.Z := cos(myLatitude) * sin(myLongitude) * (myHeightOffset);

  if not SphereMode then
  begin
    aVector.X := aOrigin.X;
    aVector.Y := aOrigin.Y;
    aVector.Z := aOrigin.Z / cFlatHeightDivision;
  end;
end;

// ----------------------------------------------------------------------------
// above-globe positioning + factor
procedure Tfm3DEnvironment.CoordinatesFromPosition(aPosition: AIPosition;
  aCoordinates: TGLCoordinates; aFactor: single);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;

  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision + aFactor;

  aCoordinates.X := -1 * cos(myLatitude) * cos(myLongitude) * (myHeightOffset);
  aCoordinates.Y := -1 * sin(myLatitude) * (myHeightOffset);
  aCoordinates.Z := cos(myLatitude) * sin(myLongitude) * (myHeightOffset);

  if not SphereMode then
  begin
    aCoordinates.X := aPosition.X;
    aCoordinates.Y := aPosition.Y;
    aCoordinates.Z := aPosition.Height / cFlatHeightDivision + aFactor;
  end;
end;

// ----------------------------------------------------------------------------
// above-globe positioning + offset
procedure Tfm3DEnvironment.CoordinatesFromPosition(aPosition: AIPosition;
  aCoordinates: TGLCoordinates; aFactor: single; aOffset: TGLVector);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := (aPosition.X / 10 + aOffset.X) * WidthAngle;
  myLatitude := (aPosition.Y / 10 + aOffset.Y) * HeightAngle - cHalfPi;

  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision + aFactor
    + aOffset.Z;

  aCoordinates.X := -1 * cos(myLatitude) * cos(myLongitude) * (myHeightOffset);
  aCoordinates.Y := -1 * sin(myLatitude) * (myHeightOffset);
  aCoordinates.Z := cos(myLatitude) * sin(myLongitude) * (myHeightOffset);

  if not SphereMode then
  begin
    aCoordinates.X := aPosition.X;
    aCoordinates.Y := aPosition.Y;
    aCoordinates.Z := aPosition.Height / cFlatHeightDivision;
  end;
end;

// ----------------------------------------------------------------------------
// positioning with direction
procedure Tfm3DEnvironment.CoordinatesFromPosition(aPosition: AIPosition;
  aDirection: TGLCoordinates; aCoordinates: TGLCoordinates);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;

  aDirection.SetVector(cos(myLatitude) * cos(myLongitude) * -1,
    sin(myLatitude) * -1, cos(myLatitude) * sin(myLongitude));

  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision;

  aCoordinates.X := aDirection.X * (myHeightOffset);
  aCoordinates.Y := aDirection.Y * (myHeightOffset);
  aCoordinates.Z := aDirection.Z * (myHeightOffset);

  if not SphereMode then
  begin
    aCoordinates.X := aPosition.X;
    aCoordinates.Y := aPosition.Y;
    aCoordinates.Z := aPosition.Height / cFlatHeightDivision;
  end;
end;

// ----------------------------------------------------------------------------
// positioning with direction
procedure Tfm3DEnvironment.CoordinatesFromPosition(aPosition: AIPosition;
  aDirection: TGLCoordinates; aCoordinates: TGLCoordinates; aFactor: single);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
begin
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;

  aDirection.SetVector(cos(myLatitude) * cos(myLongitude) * -1,
    sin(myLatitude) * -1, cos(myLatitude) * sin(myLongitude));

  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision + aFactor;

  aCoordinates.X := aDirection.X * (myHeightOffset);
  aCoordinates.Y := aDirection.Y * (myHeightOffset);
  aCoordinates.Z := aDirection.Z * (myHeightOffset);

  if not SphereMode then
  begin
    aCoordinates.X := aPosition.X;
    aCoordinates.Y := aPosition.Y;
    aCoordinates.Z := aPosition.Height / cFlatHeightDivision;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.RefreshCursor;
var
  myNormal: TAffineVector;
begin
  if (Tool = tSelect) or (Tool = tMove) then
  begin
    PlanetCursor.Visible := false;
    exit;
  end;

  if ValidCursor then
  begin
    myNormal := TGridCrossover(FocusGrid.Crossover).Normals[0];

    PlanetCursor.Visible := tbShowCursor.Down;
    FlashLight.Shining := tbFlashlight.Down;
    CameraLight.Shining := tbCameraLight.Down;

    PlanetCursor.Direction.X := -1 * myNormal.X;
    PlanetCursor.Direction.Y := -1 * myNormal.Y;
    PlanetCursor.Direction.Z := myNormal.Z;

    FlashLight.SpotDirection.SetVector(myNormal.X, myNormal.Y, -1 * myNormal.Z);

    FlashLight.Position.X := PlanetCursor.Direction.X * PlanetRadius * 2;
    FlashLight.Position.Y := PlanetCursor.Direction.Y * PlanetRadius * 2;
    FlashLight.Position.Z := PlanetCursor.Direction.Z * PlanetRadius * 2;

    PlanetCursor.Position.X := PlanetCursor.Direction.X *
      (PlanetRadius + FocusGrid.Height / cHeightDivision);
    PlanetCursor.Position.Y := PlanetCursor.Direction.Y *
      (PlanetRadius + FocusGrid.Height / cHeightDivision);
    PlanetCursor.Position.Z := PlanetCursor.Direction.Z *
      (PlanetRadius + FocusGrid.Height / cHeightDivision);

    if not SphereMode then
    begin
      PlanetCursor.Position.X := FocusGrid.Coordinates.X * 10 + 5;
      PlanetCursor.Position.Y := FocusGrid.Coordinates.Y * 10 + 5;
      PlanetCursor.Position.Z := FocusGrid.Height / cFlatHeightDivision;
    end;

    if FocusObject = PlanetCursor then
    begin
      GLCamera.Position.X := FlashLight.Position.X + 5;
      GLCamera.Position.Y := FlashLight.Position.Y + 5;
      GLCamera.Position.Z := FlashLight.Position.Z + 5;
    end;
  end
  else
  begin
    PlanetCursor.Visible := false;
    FlashLight.Shining := false;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCameraPlanetClick(Sender: TObject);
begin
  CameraMode := camPlanet;
  if (ViewPosition.Y < 5) then
    ViewDestination.Y := Environment.Space.HalfHeightSingle;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbOrangeTreeClick(Sender: TObject);
begin
  Tool := tOrangeTree;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbOrangeSeedClick(Sender: TObject);
begin
  Tool := tOrangeSeed;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.GLCadencerProgress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  if not Visible then
    exit;

  RefreshSpeeches;

  if not KBStopWatch.Timing then
  begin
    if (KeyPressed <> -1) and Active then
      CheckKeys;
    if (Tool = tSelect) and (tbMouseView.Down) then
      // or not fmFirstForm.RealityForm.RealityClock.Enabled) then
      /// DisplayMouseObjectInfo;
  end;

  if Flying then
  begin
    if not isKeyDown(VK_SHIFT) then
    begin
      if FlyingForwards then
        ViewDestination.MoveBy(0.2)
      else
        ViewDestination.MoveBy(-0.2);
    end
    else
    begin
      if FlyingForwards then
        ViewDestination.MoveBy(0.5)
      else
        ViewDestination.MoveBy(-0.5);
    end;
  end;

  if UnderWaterCam <> ViewPosition.UnderWater then
  begin
    UnderWaterCam := ViewPosition.UnderWater;
    if UnderWaterCam and tbShowWater.Down then
    begin
      GLSceneViewer.Buffer.FogEnable := true;
      SkyDome.Visible := false;
      GLSceneViewer.Buffer.BackgroundColor := clNavy;
    end
    else
    begin
      GLSceneViewer.Buffer.FogEnable := false;
      if tbShowStars.Down then
        SkyDome.Visible := true;
      GLSceneViewer.Buffer.BackgroundColor := clBlack;
    end;
  end;

  if KBStopWatch.Timing and (KBStopWatch.CurrentTime > 200) then
    KBStopWatch.Stop;

  DirectCamera(FrameRate / 30);

  if not fmFirstForm.RealityForm.RealityClock.Enabled then
    CalculateCursorPosition;

  if PlanetCursor.Visible then
  begin
    GLSceneViewer.Cursor := crHandPoint;
    CursorGlow := CursorGlow + CursorGlowRate;
    if CursorGlow >= 1.0 then
      CursorGlowRate := -0.01;
    if CursorGlow <= 0.1 then
      CursorGlowRate := 0.01;
    PlanetCursor.Material.FrontProperties.Emission.Red := CursorGlow;
    PlanetCursor.Material.FrontProperties.Emission.Blue := CursorGlow;
    PlanetCursor.Material.FrontProperties.Emission.Green := CursorGlow;
  end
  else
  begin
    if (Tool <> tMove) then
      GLSceneViewer.Cursor := crDefault
    else
      GLSceneViewer.Cursor := crCross;
  end;

  GLSceneViewer.Buffer.Render;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCameraTargetClick(Sender: TObject);
begin
  if CameraMode = camEyes then
  begin
    CameraMode := camTarget;
    exit;
  end;

  // if user hasnt used lists form, then check for any target
  if Satellites.SetNextOrFirstActive then
  begin
    TargetToFollow := TCrossover(Satellites.ActiveItem);
    CameraMode := camTarget;
  end
  else
  // couldnt find a target, switch to planet mode
  begin
    tbCameraPlanet.Down := true;
    CameraMode := camPlanet;
  end;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCameraAvatarClick(Sender: TObject);
begin
  CameraMode := camAvatar;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCameraSatelliteClick(Sender: TObject);
begin
  CameraMode := camSatellite;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCameraGalaxyClick(Sender: TObject);
begin
  CameraMode := camPlanet;
  ViewDestination.SetPosition(ViewDestination.X, 10, PlanetRadius * 140);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbFullscreenClick(Sender: TObject);
begin
  Align := alNone;
  panMenus.Visible := false;
  StatusBar.Visible := false;
  BorderStyle := bsNone;
  tbStickyFit.Down := false;
  Splitter3D.Visible := false;
  panCamera.Visible := false;
  WindowState := wsMaximized;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbFlattenLandClick(Sender: TObject);
begin
  Tool := tFlattenLand;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbMountainClick(Sender: TObject);
begin
  Tool := tMountain;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.MoveCursor(aDirection: Integer);
begin
  fFocusGrid := FocusGrid.Connection(aDirection);
  ValidCursor := true;
  RefreshCursor;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.MoveCursor(aGrid: AIGrid);
begin
  fFocusGrid := aGrid;
  ValidCursor := true;
  RefreshCursor;
end;

// ----------------------------------------------------------------------------
// the ultimate planet builder
// builds a facegroup mesh inside a freeform
procedure Tfm3DEnvironment.BuildPlanet(center: TGLVector; radius: single;
  Height: Integer; Width: Integer; Show: Boolean);
var
  Latitude: Integer; // position along the height axis
  Longitude: Integer; // position along the width axis
  tex: Integer;

  // grid normal vectors
  MiddleNormal: TAffineVector;
  NormalUpLeft: TAffineVector;
  NormalDownLeft: TAffineVector;
  NormalUpRight: TAffineVector;
  NormalDownRight: TAffineVector;
  NormalUp: TAffineVector;
  NormalDown: TAffineVector;
  NormalLeft: TAffineVector;
  NormalRight: TAffineVector;

  // grid points
  MiddleVertex: TAffineVector;
  VertexUpLeft: TAffineVector;
  VertexDownLeft: TAffineVector;
  VertexUpRight: TAffineVector;
  VertexDownRight: TAffineVector;
  VertexUp: TAffineVector;
  VertexDown: TAffineVector;
  VertexLeft: TAffineVector;
  VertexRight: TAffineVector;

  // face groups for multi-material mesh
  fgLandTex: TFGVertexIndexList;

  // grid heights (mountains/valleys)
  HeightMiddle: single;
  HeightUpLeft: single;
  HeightUpRight: single;
  HeightDownLeft: single;
  HeightDownRight: single;
  HeightUp: single;
  HeightDown: single;
  HeightLeft: single;
  HeightRight: single;
  myX: single;
  myY: single;

  AngleStart, AngleFinish, AngleMiddle: single;
  SliceBegin, SliceFinish, SliceMiddle: single;

  cosAngleStart, cosAngleFinish, cosAngleMiddle: single;
  cosSliceBegin, cosSliceFinish, cosSliceMiddle: single;
  sinAngleStart, sinAngleFinish, sinAngleMiddle: single;
  sinSliceBegin, sinSliceFinish, sinSliceMiddle: single;

  myGrid: AIGrid;
  myCrossover: TGridCrossover;

  function AddToMesh(aVertice: TAffineVector; aTexPoint: TTexPoint;
    aNormal: TAffineVector): Integer;
  begin
    PlanetMesh.Vertices.Add(aVertice);
    PlanetMesh.TexCoords.Add(aTexPoint);
    PlanetMesh.Normals.Add(aNormal.X, aNormal.Y, aNormal.Z);
    // only using one facegroup, then using texture coordinates
    fgLandTex.Add(PlanetMesh.Vertices.Count - 1);
    result := PlanetMesh.Vertices.Count - 1;
  end;

begin
  // erase any previous planets
  PlanetModel.MeshObjects.Clear;
  // PlanetModel.ObjectStyle := [osDoesTemperWithColorsOrFaceWinding, osNoVisibilityCulling, osDirectDraw];

  // create the mesh
  PlanetMesh := TGLMeshObject.Create;
  PlanetMesh.Vertices.Clear;
  PlanetMesh.Normals.Clear;
  PlanetMesh.FaceGroups.Clear;
  PlanetMesh.TexCoords.Clear;
  PlanetMesh.Mode := momFaceGroups;
  PlanetVertices := PlanetMesh.Vertices;

  // create face groups
  fgLandTex := TFGVertexIndexList.CreateOwned(PlanetMesh.FaceGroups);

  // set face groups
  fgLandTex.MaterialName := PlanetModel.MaterialLibrary.Materials.
    Items[0].Name;

  fmFirstForm.Construction.AddEvent('Planet.Map: Height = ' + IntToStr(Height) +
    ' Width = ' + IntToStr(Width));

  // height loop
  // we start at the top of the map and go to the bottom, in width strips
  for Latitude := 0 to (Height) - 1 do
  begin
    // calculate the angles of top and bottom of grid
    AngleStart := Latitude * HeightAngle - cHalfPi;
    AngleFinish := AngleStart + HeightAngle;
    AngleMiddle := AngleStart + HeightAngle / 2;

    // width loop
    // for each line of height we are on (from the previous loop), draw
    // the length of the width (one full rotation about the sphere)
    for Longitude := 0 to (Width - 1) do
    begin
      // calculate the angular width of the grid
      SliceBegin := Longitude * WidthAngle;
      SliceFinish := SliceBegin + WidthAngle;
      SliceMiddle := SliceBegin + WidthAngle / 2;

      // get the material face group for this grid
      myGrid := Environment.Space.Map[Longitude][Latitude];

      // find the height field values on the map (mountains/valleys)
      HeightMiddle := radius + myGrid.Height / cHeightDivision;
      HeightUpLeft := radius + myGrid.CornerValues[cHeightUpLeft] /
        cHeightDivision;
      HeightUpRight := radius + myGrid.CornerValues[cHeightUpRight] /
        cHeightDivision;
      HeightDownLeft := radius + myGrid.CornerValues[cHeightDownLeft] /
        cHeightDivision;
      HeightDownRight := radius + myGrid.CornerValues[cHeightDownRight] /
        cHeightDivision;
      HeightUp := radius + myGrid.CornerValues[cHeightUp] / cHeightDivision;
      HeightDown := radius + myGrid.CornerValues[cHeightDown] / cHeightDivision;
      HeightLeft := radius + myGrid.CornerValues[cHeightLeft] / cHeightDivision;
      HeightRight := radius + myGrid.CornerValues[cHeightRight] /
        cHeightDivision;

      // create interface<->data link
      myCrossover := PlanetGrid.NewGridCrossover(9);
      myCrossover.Data := myGrid;
      myCrossover.LastState := lsSea; // myGrid.LandState;
      myCrossover.LastValue := myGrid.Height;
      myGrid.Crossover := myCrossover;

      cosAngleStart := cos(AngleStart);
      cosAngleFinish := cos(AngleFinish);
      cosAngleMiddle := cos(AngleMiddle);
      cosSliceBegin := cos(SliceBegin);
      cosSliceFinish := cos(SliceFinish);
      cosSliceMiddle := cos(SliceMiddle);
      sinAngleStart := sin(AngleStart);
      sinAngleFinish := sin(AngleFinish);
      sinAngleMiddle := sin(AngleMiddle);
      sinSliceBegin := sin(SliceBegin);
      sinSliceFinish := sin(SliceFinish);
      sinSliceMiddle := sin(SliceMiddle);

      // top left Vertex of grid
      NormalUpLeft.X := cosAngleStart * cosSliceBegin;
      NormalUpLeft.Y := sinAngleStart;
      NormalUpLeft.Z := cosAngleStart * sinSliceBegin;
      // bottom left Vertex of grid
      NormalDownLeft.X := cosAngleFinish * cosSliceBegin;
      NormalDownLeft.Y := sinAngleFinish;
      NormalDownLeft.Z := cosAngleFinish * sinSliceBegin;
      // top right Vertex of grid
      NormalUpRight.X := cosAngleStart * cosSliceFinish;
      NormalUpRight.Y := sinAngleStart;
      NormalUpRight.Z := cosAngleStart * sinSliceFinish;
      // bottom right Vertex of grid
      NormalDownRight.X := cosAngleFinish * cosSliceFinish;
      NormalDownRight.Y := sinAngleFinish;
      NormalDownRight.Z := cosAngleFinish * sinSliceFinish;
      // top Vertex of grid
      NormalUp.X := cosAngleStart * cosSliceMiddle;
      NormalUp.Y := sinAngleStart;
      NormalUp.Z := cosAngleStart * sinSliceMiddle;
      // bottom Vertex of grid
      NormalDown.X := cosAngleFinish * cosSliceMiddle;
      NormalDown.Y := sinAngleFinish;
      NormalDown.Z := cosAngleFinish * sinSliceMiddle;
      // left Vertex of grid
      NormalLeft.X := cosAngleMiddle * cosSliceBegin;
      NormalLeft.Y := sinAngleMiddle;
      NormalLeft.Z := cosAngleMiddle * sinSliceBegin;
      // right Vertex of grid
      NormalRight.X := cosAngleMiddle * cosSliceFinish;
      NormalRight.Y := sinAngleMiddle;
      NormalRight.Z := cosAngleMiddle * sinSliceFinish;
      // center Vertex of grid
      // this is the Vertex that corresponds to grid height; user can raise/lower it
      MiddleNormal.X := cosAngleMiddle * cosSliceMiddle;
      MiddleNormal.Y := sinAngleMiddle;
      MiddleNormal.Z := cosAngleMiddle * sinSliceMiddle;

      // create a square grid from eight triangles, all sharing the middle Vertex
      // start at top right and go clockwise, to bottom right, to bottom left, to top left

      // 1) triangle
      tex := GetTextureNumber(myGrid, myGrid.ConnectionUp);
      myCrossover.Vertices[0][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][0][0], MiddleNormal);
      myCrossover.Vertices[0][1] := AddToMesh(VertexUp, TextureMap[tex][0][1],
        NormalUp);
      myCrossover.Vertices[0][2] := AddToMesh(VertexUpRight,
        TextureMap[tex][0][2], NormalUpRight);

      // 2) triangle
      tex := GetTextureNumber(myGrid, myGrid.ConnectionRight);
      myCrossover.Vertices[1][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][1][0], MiddleNormal);
      myCrossover.Vertices[1][1] := AddToMesh(VertexUpRight,
        TextureMap[tex][1][1], NormalUpRight);
      myCrossover.Vertices[1][2] := AddToMesh(VertexRight,
        TextureMap[tex][1][2], NormalRight);

      // 3) triangle
      myCrossover.Vertices[2][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][2][0], MiddleNormal);
      myCrossover.Vertices[2][1] := AddToMesh(VertexRight,
        TextureMap[tex][2][1], NormalRight);
      myCrossover.Vertices[2][2] := AddToMesh(VertexDownRight,
        TextureMap[tex][2][2], NormalDownRight);

      // 4) triangle
      tex := GetTextureNumber(myGrid, myGrid.ConnectionDown);
      myCrossover.Vertices[3][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][3][0], MiddleNormal);
      myCrossover.Vertices[3][1] := AddToMesh(VertexDownRight,
        TextureMap[tex][3][1], NormalDownRight);
      myCrossover.Vertices[3][2] := AddToMesh(VertexDown, TextureMap[tex][3][2],
        NormalDown);

      // 5) triangle
      myCrossover.Vertices[4][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][4][0], MiddleNormal);
      myCrossover.Vertices[4][1] := AddToMesh(VertexDown, TextureMap[tex][4][1],
        NormalDown);
      myCrossover.Vertices[4][2] := AddToMesh(VertexDownLeft,
        TextureMap[tex][4][2], NormalDownLeft);

      // 6) triangle
      tex := GetTextureNumber(myGrid, myGrid.ConnectionLeft);
      myCrossover.Vertices[5][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][5][0], MiddleNormal);
      myCrossover.Vertices[5][1] := AddToMesh(VertexDownLeft,
        TextureMap[tex][5][1], NormalDownLeft);
      myCrossover.Vertices[5][2] := AddToMesh(VertexLeft, TextureMap[tex][5][2],
        NormalLeft);

      // 7) triangle
      myCrossover.Vertices[6][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][6][0], MiddleNormal);
      myCrossover.Vertices[6][1] := AddToMesh(VertexLeft, TextureMap[tex][6][1],
        NormalLeft);
      myCrossover.Vertices[6][2] := AddToMesh(VertexUpLeft,
        TextureMap[tex][6][2], NormalUpLeft);

      // 8) triangle
      tex := GetTextureNumber(myGrid, myGrid.ConnectionUp);
      myCrossover.Vertices[7][0] := AddToMesh(MiddleVertex,
        TextureMap[tex][7][0], MiddleNormal);
      myCrossover.Vertices[7][1] := AddToMesh(VertexUpLeft,
        TextureMap[tex][7][1], NormalUpLeft);
      myCrossover.Vertices[7][2] := AddToMesh(VertexUp, TextureMap[tex][7][2],
        NormalUp);

      myCrossover.Normals[0] := MiddleNormal;
      myCrossover.Normals[1] := NormalUpLeft;
      myCrossover.Normals[2] := NormalDownLeft;
      myCrossover.Normals[3] := NormalUpRight;
      myCrossover.Normals[4] := NormalDownRight;
      myCrossover.Normals[5] := NormalUp;
      myCrossover.Normals[6] := NormalDown;
      myCrossover.Normals[7] := NormalLeft;
      myCrossover.Normals[8] := NormalRight;

      if SphereMode then
        SetGridHeightPoints(myGrid);
      if not SphereMode then
        SetFlatGridHeightPoints(myGrid);
    end;
  end;

  fmFirstForm.Construction.AddEvent('Planet.Mesh: Triangles = ' +
    IntToStr(PlanetMesh.TriangleCount) + ' Vertices = ' +
    IntToStr(PlanetMesh.Vertices.Count));

  // add mesh to freeform (a freeform holds meshes)
  PlanetModel.MeshObjects.Add(PlanetMesh);
  PlanetModel.NormalsOrientation := mnoInvert;
  PlanetModel.StructureChanged;

  fmFirstForm.Construction.AddEvent('Planet.Freeform: Triangles = ' +
    IntToStr(PlanetModel.MeshObjects.TriangleCount));

  // build the octree for raycastintersect
  PlanetModel.BuildOctree;
  PlanetModel.BuildSilhouetteConnectivityData;
  InvalidOctree := false;
  fmFirstForm.Construction.AddEvent('Planet.BuildOctree: passed');
end;

// ----------------------------------------------------------------------------
// refresh the planet map
procedure Tfm3DEnvironment.RefreshPlanet;
var
  i: Integer;
  myCrossover: TGridCrossover;
  myWaterCrossover: TGridCrossover;
  myGrid: AIGrid;
  newTexIndex: Integer;
  changed: Boolean;
begin
  changed := false;

  for i := 0 to gSpace.EventRound.ActiveIndex - 1 do
  begin
    myGrid := AIGrid(gSpace.EventRound.Events[i].Target);
    myCrossover := myGrid.Crossover;
    myWaterCrossover := myGrid.WaterCrossover;

    // check for texture face change
    if (myGrid.changed) then
    begin
      myGrid.changed := false;

      newTexIndex := GetTextureNumber(myGrid, myGrid);
      if newTexIndex <> myCrossover.LastState then
      begin
        myCrossover.LastState := newTexIndex;
        changed := true;
        // set textures for each pair of triangles (up, down, left, right)
        // up
        SetFaceTexture(myCrossover, GetTextureNumber(myGrid,
          myGrid.ConnectionUp), 0, 7);
        // right
        SetFaceTexture(myCrossover, GetTextureNumber(myGrid,
          myGrid.ConnectionRight), 1, 2);
        // down
        SetFaceTexture(myCrossover, GetTextureNumber(myGrid,
          myGrid.ConnectionDown), 3, 4);
        // left
        SetFaceTexture(myCrossover, GetTextureNumber(myGrid,
          myGrid.ConnectionLeft), 5, 6);
        // adjust neighbouring cells
        SetFaceTexture(myGrid.ConnectionDown.Crossover,
          GetTextureNumber(myGrid.ConnectionDown, myGrid), 0, 7);
        SetFaceTexture(myGrid.ConnectionLeft.Crossover,
          GetTextureNumber(myGrid.ConnectionLeft, myGrid), 1, 2);
        SetFaceTexture(myGrid.ConnectionUp.Crossover,
          GetTextureNumber(myGrid.ConnectionUp, myGrid), 3, 4);
        SetFaceTexture(myGrid.ConnectionRight.Crossover,
          GetTextureNumber(myGrid.ConnectionRight, myGrid), 5, 6);
      end;
    end;

    // check for land height change
    if not(myGrid.Height = myCrossover.LastValue) then
    begin
      changed := true;
      InvalidOctree := true;
      UpdateGridHeight(myGrid);
      myCrossover.LastValue := myGrid.Height;
    end;

    // check for water change
    if not(myGrid.Water = myWaterCrossover.LastValue) then
    begin
      UpdateWaterHeight(myGrid);
      myWaterCrossover.LastValue := myGrid.Water;
    end;
  end;

  if changed then
    PlanetModel.StructureChanged;
end;

procedure Tfm3DEnvironment.SetFaceTexture(aCrossover: TGridCrossover;
  newTexIndex: Integer; aFaceA, aFaceB: Integer);
var
  myVect: TAffineVector;
begin
  myVect.X := TextureMap[newTexIndex][aFaceA][0].S;
  myVect.Y := TextureMap[newTexIndex][aFaceA][0].T;
  myVect.Z := 0;
  PlanetMesh.TexCoords.Items[aCrossover.Vertices[aFaceA][0]] := myVect;
  myVect.X := TextureMap[newTexIndex][aFaceA][1].S;
  myVect.Y := TextureMap[newTexIndex][aFaceA][1].T;
  myVect.Z := 0;
  PlanetMesh.TexCoords.Items[aCrossover.Vertices[aFaceA][1]] := myVect;
  myVect.X := TextureMap[newTexIndex][aFaceA][2].S;
  myVect.Y := TextureMap[newTexIndex][aFaceA][2].T;
  myVect.Z := 0;
  PlanetMesh.TexCoords.Items[aCrossover.Vertices[aFaceA][2]] := myVect;

  myVect.X := TextureMap[newTexIndex][aFaceB][0].S;
  myVect.Y := TextureMap[newTexIndex][aFaceB][0].T;
  myVect.Z := 0;
  PlanetMesh.TexCoords.Items[aCrossover.Vertices[aFaceB][0]] := myVect;
  myVect.X := TextureMap[newTexIndex][aFaceB][1].S;
  myVect.Y := TextureMap[newTexIndex][aFaceB][1].T;
  myVect.Z := 0;
  PlanetMesh.TexCoords.Items[aCrossover.Vertices[aFaceB][1]] := myVect;
  myVect.X := TextureMap[newTexIndex][aFaceB][2].S;
  myVect.Y := TextureMap[newTexIndex][aFaceB][2].T;
  myVect.Z := 0;
  PlanetMesh.TexCoords.Items[aCrossover.Vertices[aFaceB][2]] := myVect;
end;

function Tfm3DEnvironment.GetTextureNumber(aGrid, aAdjacentGrid
  : AIGrid): Integer;
var
  myAdjacent: Integer;
begin
  case aGrid.LandState of
    lsSea:
      result := cTexSea;
    lsLake:
      result := cTexLake;
    lsGrass:
      result := cTexGrass;
    lsPond:
      result := cTexLake;
    lsOcean:
      result := cTexSea;
    lsDesert:
      result := cTexDesert;
    lsField:
      result := cTexGrass;
    lsDirt:
      result := cTexGrass;
  else
    result := cTexSea;
  end;

  case aAdjacentGrid.LandState of
    lsSea:
      myAdjacent := cTexSea;
    lsLake:
      myAdjacent := cTexLake;
    lsGrass:
      myAdjacent := cTexGrass;
    lsPond:
      myAdjacent := cTexLake;
    lsOcean:
      myAdjacent := cTexSea;
    lsDesert:
      myAdjacent := cTexDesert;
    lsField:
      myAdjacent := cTexGrass;
    lsDirt:
      myAdjacent := cTexGrass;
  else
    myAdjacent := cTexSea;
  end;

  if myAdjacent = result then
    exit; // same texture

  case result of
    cTexLake:
      begin
        if myAdjacent = cTexSea then
          result := cTexSeaLake;
        if myAdjacent = cTexGrass then
          result := cTexGrassLake;
      end;
    cTexDesert:
      begin
        if myAdjacent = cTexGrass then
          result := cTexGrassDesert;
      end;
    cTexOcean:
      begin
        if myAdjacent = cTexSea then
          result := cTexSeaOcean;
      end;
  end;
end;

procedure Tfm3DEnvironment.SetTool(aTool: eTool);
begin
  fTool := aTool;
end;

procedure Tfm3DEnvironment.ApplyTool(aTool: eTool; aLocation: AIGrid);
begin
  // invalidates the land at cursor, for instant refresh
  TGridCrossover(PlanetGrid.FindCrossoverByData(aLocation)).LastState := -1;
  // TGridCrossover(PlanetGrid.FindCrossoverByData(aLocation)).ChangeTime := cStateChangeTime-1;

  case aTool of
    tWaterLeveller:
      begin
        aLocation.Height := aLocation.Water + WaterLevel + RandomSwing * 0.25;
      end;
    tWateringCan:
      aLocation.AlterWater(WaterCan);
    tSponge:
      aLocation.AlterWater(-1 * WaterCan);
    tHeater:
      aLocation.AlterTemperature(0.25);
    tCooler:
      aLocation.AlterTemperature(-0.25);
    tHumidifier:
      aLocation.AlterHumidity(0.25);
    tDehumidifier:
      aLocation.AlterHumidity(-0.25);
    tRaiseLand:
      aLocation.AlterHeight(0.5);
    tLowerLand:
      aLocation.AlterHeight(-0.5);
    tFlattenLand:
      aLocation.Height := Environment.Space.DefaultHeight;
    tMountain:
      aLocation.Height := cHeightCeiling;
    tValley:
      aLocation.Height := cHeightFloor;
    tSplash:
      aLocation.Splash(aLocation.SeaWater / 2);
    tForest:
      AddForest(aLocation);
    tAppleSeed:
      begin
        Environment.Things.NewThing(cAppleSeed, aLocation);
        CheckToolRepeat;
      end;
    tOrangeSeed:
      begin
        Environment.Things.NewThing(cOrangeSeed, aLocation);
        CheckToolRepeat;
      end;
    tAppleTree:
      begin
        AddNewTree(cAppleTree, aLocation);
        CheckToolRepeat;
      end;
    tOrangeTree:
      begin
        AddNewTree(cOrangeTree, aLocation);
        CheckToolRepeat;
      end;
    tApple:
      begin
        Environment.Things.NewThing(cApple, aLocation);
        CheckToolRepeat;
        LastAction('Add=Apple');
      end;
    tOrange:
      begin
        Environment.Things.NewThing(cOrange, aLocation);
        CheckToolRepeat;
        LastAction('Add=Orange');
      end;
    tCloud:
      begin
        Environment.Things.NewThing(cCloud, aLocation);
        CheckToolRepeat;
        LastAction('Add=Cloud');
      end;
    tFish:
      begin
        Environment.Things.NewThing(cFish, aLocation);
        CheckToolRepeat;
        LastAction('Add=Fish');
      end;
    tCrab:
      begin
        Environment.Things.NewThing(cCrab, aLocation);
        CheckToolRepeat;
        LastAction('Add=Crab');
      end;
    tHawk:
      begin
        Environment.Things.NewThing(cHawk, aLocation);
        CheckToolRepeat;
        LastAction('Add=Hawk');
      end;
    tShark:
      begin
        Environment.Things.NewThing(cShark, aLocation);
        CheckToolRepeat;
        LastAction('Add=Shark');
      end;
    tTurtle:
      begin
        Environment.Things.NewThing(cTurtle, aLocation);
        CheckToolRepeat;
        LastAction('Add=Turtle');
      end;
    tTrex:
      begin
        Environment.Things.NewThing(cTrex, aLocation);
        CheckToolRepeat;
        LastAction('Add=Trex');
      end;
    tGrazer:
      begin
        Environment.Things.NewThing(cGrazer, aLocation);
        CheckToolRepeat;
        LastAction('Add=Grazer');
      end;
    tBird:
      begin
        Environment.Things.NewThing(cBird, aLocation);
        CheckToolRepeat;
        LastAction('Add=Bird');
      end;
    tBall:
      begin
        BreakLimits(cBall);
        Environment.Things.NewThing(cBall, aLocation);
        CheckToolRepeat;
        LastAction('Add=Ball');
      end;
    tAsteroid:
      begin
        Environment.Things.NewThing(cAsteroid, aLocation);
        CheckToolRepeat;
        LastAction('Add=Asteroid');
      end;
    tStormCloud:
      begin
        AddStormCloud(aLocation);
        CheckToolRepeat;
        LastAction('Add=StormCloud');
      end;
    tRainCloud:
      begin
        AddRainCloud(aLocation);
        CheckToolRepeat;
        LastAction('Add=StormCloud');
      end;
    tBeaconDrain:
      begin
        AddBeacon(cBeaconDrain, aLocation);
        ToolIsActive := false;
        LastAction('Add=Drain');
      end;
    tBeaconBubble:
      begin
        AddBeacon(cBeaconBubble, aLocation);
        ToolIsActive := false;
        LastAction('Add=Bubble');
      end;
    tBeaconOrange:
      begin
        AddBeacon(cBeaconOrange, aLocation);
        ToolIsActive := false;
        LastAction('Add=OrangePop');
      end;
    tBeaconApple:
      begin
        AddBeacon(cBeaconApple, aLocation);
        ToolIsActive := false;
        LastAction('Add=ApplePop');
      end;
    tBeaconAny:
      begin
        AddBeacon(cBeaconAny, aLocation);
        ToolIsActive := false;
        LastAction('Add=AnyPop');
      end;
    tSpiritGuy:
      begin
        Environment.Things.NewThing(cBot, aLocation);
        ToolIsActive := false;
        LastAction('Add=Bot');
      end;
    tTerrier:
      begin
        Environment.Things.NewThing(cTerrier, aLocation);
        CheckToolRepeat;
      end;
    tFox:
      begin
        Environment.Things.NewThing(cFox, aLocation);
        CheckToolRepeat;
      end;
    tRabbit:
      begin
        Environment.Things.NewThing(cRabbit, aLocation);
        CheckToolRepeat;
      end;
    tGrass:
      begin
        AddGrass(aLocation);
        CheckToolRepeat;
      end;
    tMouse:
      begin
        Environment.Things.NewThing(cMouse, aLocation);
        CheckToolRepeat;
      end;
    tTiger:
      begin
        Environment.Things.NewThing(cTiger, aLocation);
        CheckToolRepeat;
      end;
    tDuck:
      begin
        Environment.Things.NewThing(cDuck, aLocation);
        CheckToolRepeat;
        LastAction('Add=Duck');
      end;
    tDolphin:
      begin
        Environment.Things.NewThing(cDolphin, aLocation);
        CheckToolRepeat;
        LastAction('Add=Dolphin');
      end;
    tAquaPlant:
      begin
        Environment.Things.NewThing(cAquaPlant, aLocation);
        CheckToolRepeat;
        LastAction('Add=AquaPlant');
      end;
    tLadybug:
      begin
        Environment.Things.NewThing(cLadybug, aLocation);
        CheckToolRepeat;
        LastAction('Add=LadyBug');
      end;
    tAnt:
      begin
        Environment.Things.NewThing(cAnt, aLocation);
        CheckToolRepeat;
        LastAction('Add=Ant');
      end;
    tIceberg:
      begin
        BreakLimits(cIceberg);
        Environment.Things.NewThing(cIceberg, aLocation);
        CheckToolRepeat;
        LastAction('Add=Iceberg');
      end;
    tEvolvingTree:
      begin
        AddNewTree(cEvolvingTree, aLocation);
        CheckToolRepeat;
        LastAction('Add=EvolveTree');
      end;
    tEvolvingFruit:
      begin
        Environment.Things.NewThing(cEvolvingFruit, aLocation);
        CheckToolRepeat;
        LastAction('Add=EvolveFruit');
      end;
    tEvolvingSeed:
      begin
        Environment.Things.NewThing(cEvolvingSeed, aLocation);
        CheckToolRepeat;
        LastAction('Add=EvolveSeed');
      end;
    tFireTree:
      begin
        Environment.Things.NewThing(cFireTree, aLocation);
        CheckToolRepeat;
        LastAction('Add=FireTree');
      end;
    tLightning:
      begin
        AddLightning(aLocation);
        ToolIsActive := false;
        LastAction('Add=Lightning');
      end;
    tMissileDefence:
      begin
        Environment.Things.NewThing(cMissileDefence, aLocation);
        CheckToolRepeat;
        LastAction('Add=Defence');
      end;
    tPlantClearer:
      begin
        Environment.Things.Existents.KillAllPlantsAtLocation(aLocation);
      end;
    tLifeKiller:
      begin
        Environment.Things.Existents.KillAllLifeAtLocation(aLocation);
      end;
    tThingCeaser:
      begin
        Environment.Things.Existents.CeaseEverythingLocation(aLocation);
      end;
  end;
  RefreshCursor;
end;

procedure Tfm3DEnvironment.AddBeacon(aUsage: Integer; aLocation: AIGrid);
var
  myBeacon: AIBeacon;
begin
  if not gThings.CanAdd(cBeacon) then
    exit;

  myBeacon := AIBeacon(gThings.NewThing(cBeacon, aLocation));
  myBeacon.Position.center;
  myBeacon.Usage := aUsage;
  if (myBeacon.Usage = cBeaconApple) then
    myBeacon.Position.Buoyancy := myBeacon.Position.Mass * 1.1;
  if (myBeacon.Usage = cBeaconAny) then
  begin
    myBeacon.Pop := cboxThings.ItemIndex;
    /// ?    myBeacon.Rate := edPopRate.Value;
  end;
end;

procedure Tfm3DEnvironment.AddStormCloud(aLocation: AIGrid);
var
  myCloud: AICloud;
begin
  if not gThings.CanAdd(cCloud) then
    exit;

  myCloud := AICloud(gThings.NewThing(cCloud, aLocation));
  if myCloud = nil then
    exit;
  myCloud.Storm := true;
  myCloud.Water := 4;
end;

procedure Tfm3DEnvironment.AddRainCloud(aLocation: AIGrid);
var
  myCloud: AICloud;
begin
  if not gThings.CanAdd(cCloud) then
    exit;

  myCloud := AICloud(gThings.NewThing(cCloud, aLocation));
  if myCloud = nil then
    exit;
  myCloud.Raining := true;
end;

procedure Tfm3DEnvironment.AddForest(aLocation: AIGrid);
begin
  case Random(3) of
    0:
      AddNewTree(cAppleTree, aLocation);
    1:
      AddNewTree(cOrangeTree, aLocation);
    2:
      AddNewTree(cEvolvingTree, aLocation);
  end;
end;

procedure Tfm3DEnvironment.AddNewTree(aKind: Integer; aLocation: AIGrid);
var
  myTree: AIThing;
  X, Y: single;
begin
  if not gThings.CanAdd(aKind) then
    exit;

  if aLocation.UnderWater then
    exit;

  X := aLocation.Coordinates.X * 10.0 + Random * 10.0;
  Y := aLocation.Coordinates.Y * 10.0 + Random * 10.0;

  if aLocation.DetermineWaterHeight(X, Y) > aLocation.DetermineLandHeight(X, Y)
  then
    exit;

  if not gThings.Tables[cAppleTree].HasKindWithinXY(cAppleTree, X, Y, 5) and
    not gThings.Tables[cOrangeTree].HasKindWithinXY(cOrangeTree, X, Y, 5) and
    not gThings.Tables[cEvolvingTree].HasKindWithinXY(cEvolvingTree, X, Y, 5)
    and not gThings.Tables[cFireTree].HasKindWithinXY(cFireTree, X, Y, 5) then
  begin
    myTree := AIThing(gThings.NewThing(aKind));
    if myTree <> nil then
      myTree.Position.SetPosition(X, Y, 0);
  end;
end;

procedure Tfm3DEnvironment.AddLightning(aLocation: AIGrid);
var
  myLightning: AILightning;
begin
  if not gThings.CanAdd(cLightning) then
    exit;

  myLightning := AILightning(gThings.NewThing(cLightning, aLocation));
  myLightning.Position.Height := myLightning.Position.Height + 100;
  myLightning.Position.Fuel;
end;

procedure Tfm3DEnvironment.AddGrass(aLocation: AIGrid);
var
  myGrass: AIGrass;
  X, Y: single;
begin
  if not gThings.CanAdd(cGrass) then
    exit;

  if aLocation.UnderWater then
    exit;

  X := aLocation.Coordinates.X * 10.0 + Random * 10.0;
  Y := aLocation.Coordinates.Y * 10.0 + Random * 10.0;

  if aLocation.DetermineWaterHeight(X, Y) > aLocation.DetermineLandHeight(X, Y)
  then
    exit;

  if not gThings.Existents.HasKindWithinXY(cGrass, X, Y, 1) then
  begin
    myGrass := AIGrass(gThings.NewThing(cGrass));
    if myGrass <> nil then
      myGrass.Position.SetPosition(X, Y, 0);
  end;
end;

procedure Tfm3DEnvironment.tbHeatClick(Sender: TObject);
begin
  Tool := tHeater;
end;

procedure Tfm3DEnvironment.tbAddRemoveWaterClick(Sender: TObject);
begin
  Tool := tWateringCan;
end;

procedure Tfm3DEnvironment.tbLandDesertClick(Sender: TObject);
begin
  Tool := tWaterLeveller;
  WaterLevel := 1;
end;

procedure Tfm3DEnvironment.tbLandDirtClick(Sender: TObject);
begin
  Tool := tWaterLeveller;
  WaterLevel := 2.5;
end;

procedure Tfm3DEnvironment.tbLandFieldClick(Sender: TObject);
begin
  Tool := tWaterLeveller;
  WaterLevel := 5.0;
end;

procedure Tfm3DEnvironment.tbLandGrassClick(Sender: TObject);
begin
  Tool := tWaterLeveller;
  WaterLevel := 7.5;
end;

procedure Tfm3DEnvironment.tbWaterSeaClick(Sender: TObject);
begin
  Tool := tWaterLeveller;
  WaterLevel := 15.0;
end;

procedure Tfm3DEnvironment.tbValleyClick(Sender: TObject);
begin
  Tool := tValley;
end;

procedure Tfm3DEnvironment.tbColdClick(Sender: TObject);
begin
  Tool := tCooler;
end;

procedure Tfm3DEnvironment.tbHumidifierClick(Sender: TObject);
begin
  Tool := tHumidifier;
end;

procedure Tfm3DEnvironment.tbDehumidifierClick(Sender: TObject);
begin
  Tool := tDehumidifier;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.AllToolBarsInvisible;
begin
  tbWater.Visible := false;
  panFauna.Visible := false;
  panCreatures.Visible := false;
  tbSpirits.Visible := false;
  panLand.Visible := false;
  tbAtmosphere.Visible := false;
  tbGalaxy.Visible := false;
  tbCameras.Visible := false;
  tbVisuals.Visible := false;
  tbSettings.Visible := false;
  tbTools.Visible := false;
  panSelect.Visible := false;
  tbAudio.Visible := false;
  tbDisasters.Visible := false;
end;

procedure Tfm3DEnvironment.tbWaterMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbWater.Align := alClient;
  tbWater.Visible := true;
  if tbWateringCan.Down then
    Tool := tWateringCan;
  if tbSponge.Down then
    Tool := tSponge;
  if tbSplash.Down then
    Tool := tSplash;
  if tbIceberg.Down then
    Tool := tIceberg;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbFaunaMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  panFauna.Align := alClient;
  panFauna.Visible := true;
  if tbPlantForest.Down then
    Tool := tForest;
  if tbAppleTree.Down then
    Tool := tAppleTree;
  if tbApple.Down then
    Tool := tApple;
  if tbAppleSeed.Down then
    Tool := tAppleSeed;
  if tbOrangeTree.Down then
    Tool := tOrangeTree;
  if tbOrange.Down then
    Tool := tOrange;
  if tbOrangeSeed.Down then
    Tool := tOrangeSeed;
  if tbGrass.Down then
    Tool := tGrass;
  if tbAquaPlant.Down then
    Tool := tAquaPlant;
  if tbEvolvingTree.Down then
    Tool := tEvolvingTree;
  if tbEvolvingFruit.Down then
    Tool := tEvolvingFruit;
  if tbEvolvingSeed.Down then
    Tool := tEvolvingSeed;
  if tbFireTree.Down then
    Tool := tFireTree;
  if tbPlantClearer.Down then
    Tool := tPlantClearer;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbCreaturesMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  panCreatures.Align := alClient;
  panCreatures.Visible := true;
  if tbFish.Down then
    Tool := tFish;
  if tbBird.Down then
    Tool := tBird;
  if tbCrab.Down then
    Tool := tCrab;
  if tbHawk.Down then
    Tool := tHawk;
  if tbGrazer.Down then
    Tool := tGrazer;
  if tbTrex.Down then
    Tool := tTrex;
  if tbShark.Down then
    Tool := tShark;
  if tbTurtle.Down then
    Tool := tTurtle;
  if tbTerrier.Down then
    Tool := tTerrier;
  if tbFox.Down then
    Tool := tFox;
  if tbRabbit.Down then
    Tool := tRabbit;
  if tbMouse.Down then
    Tool := tMouse;
  if tbTiger.Down then
    Tool := tTiger;
  if tbDuck.Down then
    Tool := tDuck;
  if tbDolphin.Down then
    Tool := tDolphin;
  if tbLadybug.Down then
    Tool := tLadybug;
  if tbAnt.Down then
    Tool := tAnt;
  if tbCreatureDeath.Down then
    Tool := tLifeKiller;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbSpiritsMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbSpirits.Align := alClient;
  tbSpirits.Visible := true;
  if tbSpiritGuy.Down then
    Tool := tSpiritGuy;
  if tbBotSelect.Down then
    Tool := tSelect;
  HideCursor;
end;

procedure Tfm3DEnvironment.tbLandMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  panLand.Align := alClient;
  panLand.Visible := true;
  Tool := tWaterLeveller;
  if tbRaiseLand.Down then
    Tool := tRaiseLand;
  if tbLowerLand.Down then
    Tool := tLowerLand;
  if tbFlattenLand.Down then
    Tool := tFlattenLand;
  if tbMountain.Down then
    Tool := tMountain;
  if tbValley.Down then
    Tool := tValley;
  if tbThingCeaser.Down then
    Tool := tThingCeaser;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbAtmosphereMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbAtmosphere.Align := alClient;
  tbAtmosphere.Visible := true;
  if tbHeat.Down then
    Tool := tHeater;
  if tbCold.Down then
    Tool := tCooler;
  if tbHumidifier.Down then
    Tool := tHumidifier;
  if tbDehumidifier.Down then
    Tool := tDehumidifier;
  if tbCloud.Down then
    Tool := tCloud;
  if tbStormCloud.Down then
    Tool := tStormCloud;
  if tbLightning.Down then
    Tool := tLightning;
  if tbRainCloud.Down then
    Tool := tRainCloud;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbGalaxyMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbGalaxy.Align := alClient;
  tbGalaxy.Visible := true;
  if tbAsteroid.Down then
    Tool := tAsteroid;
  if tbMissileDefence.Down then
    Tool := tMissileDefence;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbCameraMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbCameras.Align := alClient;
  tbCameras.Visible := true;
end;

procedure Tfm3DEnvironment.tbVisualsMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbVisuals.Align := alClient;
  tbVisuals.Visible := true;
end;

procedure Tfm3DEnvironment.tbSettingsMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbSettings.Align := alClient;
  tbSettings.Visible := true;
end;

procedure Tfm3DEnvironment.tbToolsMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbTools.Align := alClient;
  tbTools.Visible := true;
  if tbBall.Down then
    Tool := tBall;
  if tbBeaconDrain.Down then
    Tool := tBeaconDrain;
  if tbBeaconBubble.Down then
    Tool := tBeaconBubble;
  if tbBeaconOrange.Down then
    Tool := tBeaconOrange;
  if tbBeaconApple.Down then
    Tool := tBeaconApple;
  if tbPopBeacon.Down then
    Tool := tBeaconAny;
  ShowCursor;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbShowCloudsClick(Sender: TObject);
begin
  CloudCube.Visible := tbShowClouds.Down;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbShowSatellitesClick(Sender: TObject);
begin
  SatellitesCube.Visible := tbShowSatellites.Down;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbShowStarsClick(Sender: TObject);
begin
  SkyDome.Visible := tbShowStars.Down;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbShowWaterClick(Sender: TObject);
begin
  WaterBubble.Visible := tbShowWater.Down;
  UnderWaterCam := not ViewPosition.UnderWater;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbShowAtmosphereClick(Sender: TObject);
begin
  Atmosphere.Visible := tbShowAtmosphere.Down;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbStickyFitClick(Sender: TObject);
begin
  tbFullscreen.Down := false;
  if tbStickyFit.Down then
    StickyFit
  else
    UnStickyFit;
  fmFirstForm.UserSettings.ViewAligned := tbStickyFit.Down;
  fmFirstForm.UserSettings.ViewSizeX := Width;
  fmFirstForm.UserSettings.ViewSizeY := Height;
  fmFirstForm.UserSettings.SaveToRegistry;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbShowCursorClick(Sender: TObject);
begin
  PlanetCursor.Visible := tbShowCursor.Down;
  RefreshCursor;
end;

procedure Tfm3DEnvironment.tbFlashlightClick(Sender: TObject);
begin
  FlashLight.Shining := tbFlashlight.Down;
end;

procedure Tfm3DEnvironment.tbAppleSeedClick(Sender: TObject);
begin
  Tool := tAppleSeed;
end;

procedure Tfm3DEnvironment.tbOctreeClick(Sender: TObject);
begin
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCustomSunClick(Sender: TObject);
var
  mySun: AISun;
begin
  if Satellites.AmountOfData(AISun) < 4 then
  begin
    mySun := AISun(Environment.Things.NewThing(cSun));
    ReportUserEvent('Added Sun: ' + mySun.OneLineDisplay);
    fmFirstForm.RealityForm.ManagerForm.ListsForm.EditSatellite
      (AISatellite(mySun));
  end
  else
    ShowMessage('Maximum four suns!');
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbCustomMoonClick(Sender: TObject);
var
  myMoon: AIMoon;
begin
  // add first moon to top, second to bottom
  if not Environment.Things.Exists(cMoon) then
    myMoon := AIMoon(Environment.Things.NewThing(cMoon))
  else
    myMoon := AIMoon(Environment.Things.NewThing(cMoon));

  ReportUserEvent('Added moon: ' + myMoon.OneLineDisplay);
  fmFirstForm.RealityForm.ManagerForm.ListsForm.EditSatellite
    (AISatellite(myMoon));
end;

// ----------------------------------------------------------------------------
// builds the water form
// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.BuildWater(center: TGLVector; radius: single;
  Height: Integer; Width: Integer; Show: Boolean);
var
  // grid normal vectors
  NormalUpLeft: TAffineVector;
  NormalDownLeft: TAffineVector;
  NormalUpRight: TAffineVector;
  NormalDownRight: TAffineVector;
  MiddleNormal: TAffineVector;

  // grid points
  PointUpLeft: TAffineVector;
  PointDownLeft: TAffineVector;
  PointUpRight: TAffineVector;
  PointDownRight: TAffineVector;
  MiddlePoint: TAffineVector;

  // grid heights (mountains/valleys)
  WaterMiddle: single;
  WaterUpLeft: single;
  WaterUpRight: single;
  WaterDownLeft: single;
  WaterDownRight: single;

  Latitude: Integer; // position along the height axis
  Longitude: Integer; // position along the width axis

  AngleStart, AngleFinish, AngleMiddle: single;
  SliceBegin, SliceFinish, SliceMiddle: single;

  cosAngleStart, cosAngleFinish, cosAngleMiddle: single;
  cosSliceBegin, cosSliceFinish, cosSliceMiddle: single;
  sinAngleStart, sinAngleFinish, sinAngleMiddle: single;
  sinSliceBegin, sinSliceFinish, sinSliceMiddle: single;

  myGrid: AIGrid;
  myCrossover: TGridCrossover;

  function AddToMesh(aVertice: TAffineVector; aNormal: TAffineVector): Integer;
  begin
    WaterMesh.Vertices.Add(aVertice);
    WaterMesh.Normals.Add(aNormal.X, aNormal.Y, aNormal.Z);
    result := WaterMesh.Vertices.Count - 1;
  end;

begin
  // erase any previous water
  // WaterFreeForm.MeshObjects.Clear;
  WaterBubble.MeshObjects.Clear;

  // create the mesh
  WaterMesh := TGLMeshObject.Create;
  WaterMesh.Vertices.Clear;
  WaterMesh.Normals.Clear;
  WaterMesh.TexCoords.Clear;
  WaterMesh.Mode := momTriangles;
  WaterVertices := WaterMesh.Vertices;

  // height loop
  // we start at the top of the map and go to the bottom, in width strips
  for Latitude := 0 to (Height) - 1 do
  begin
    // calculate the angles of top and bottom of grid
    AngleStart := Latitude * HeightAngle - cHalfPi;
    AngleFinish := AngleStart + HeightAngle;
    AngleMiddle := AngleStart + HeightAngle / 2;

    // width loop
    // for each line of height we are on (from the previous loop), draw
    // the length of the width (one full rotation about the sphere)
    for Longitude := 0 to (Width - 1) do
    begin
      // calculate the angular width of the grid
      SliceBegin := Longitude * WidthAngle;
      SliceFinish := SliceBegin + WidthAngle;
      SliceMiddle := SliceBegin + WidthAngle / 2;

      // get the material face group for this grid
      myGrid := Environment.Space.Map[Longitude][Latitude];

      // find the Water values on the map
      WaterUpLeft := radius + (myGrid.CornerValues[cWaterUpLeft]) /
        cHeightDivision;
      WaterUpRight := radius + (myGrid.CornerValues[cWaterUpRight]) /
        cHeightDivision;
      WaterDownLeft := radius + (myGrid.CornerValues[cWaterDownLeft]) /
        cHeightDivision;
      WaterDownRight := radius + (myGrid.CornerValues[cWaterDownRight]) /
        cHeightDivision;
      WaterMiddle := Min(WaterUpLeft, WaterUpRight, WaterDownLeft,
        WaterDownRight);
      // WaterMiddle := Radius + myGrid.Water / cHeightDivision;

      // create interface<->data link
      myCrossover := WaterGrid.NewGridCrossover(6);
      myCrossover.Data := myGrid;
      myCrossover.LastValue := myGrid.Water;
      myGrid.WaterCrossover := myCrossover;

      // precalculate cos and sin values
      cosAngleStart := cos(AngleStart);
      cosAngleFinish := cos(AngleFinish);
      cosAngleMiddle := cos(AngleMiddle);
      cosSliceBegin := cos(SliceBegin);
      cosSliceFinish := cos(SliceFinish);
      cosSliceMiddle := cos(SliceMiddle);
      sinAngleStart := sin(AngleStart);
      sinAngleFinish := sin(AngleFinish);
      sinAngleMiddle := sin(AngleMiddle);
      sinSliceBegin := sin(SliceBegin);
      sinSliceFinish := sin(SliceFinish);
      sinSliceMiddle := sin(SliceMiddle);

      // top left point of grid
      NormalUpLeft.X := cosAngleStart * cosSliceBegin;
      NormalUpLeft.Y := sinAngleStart;
      NormalUpLeft.Z := cosAngleStart * sinSliceBegin;
      PointUpLeft.X := center.X + (WaterUpLeft) * NormalUpLeft.X;
      PointUpLeft.Y := center.Y + (WaterUpLeft) * NormalUpLeft.Y;
      PointUpLeft.Z := center.Z + (WaterUpLeft) * NormalUpLeft.Z;

      // bottom left point of grid
      NormalDownLeft.X := cosAngleFinish * cosSliceBegin;
      NormalDownLeft.Y := sinAngleFinish;
      NormalDownLeft.Z := cosAngleFinish * sinSliceBegin;
      PointDownLeft.X := center.X + (WaterDownLeft) * NormalDownLeft.X;
      PointDownLeft.Y := center.Y + (WaterDownLeft) * NormalDownLeft.Y;
      PointDownLeft.Z := center.Z + (WaterDownLeft) * NormalDownLeft.Z;

      // top right point of grid
      NormalUpRight.X := cosAngleStart * cosSliceFinish;
      NormalUpRight.Y := sinAngleStart;
      NormalUpRight.Z := cosAngleStart * sinSliceFinish;
      PointUpRight.X := center.X + (WaterUpRight) * NormalUpRight.X;
      PointUpRight.Y := center.Y + (WaterUpRight) * NormalUpRight.Y;
      PointUpRight.Z := center.Z + (WaterUpRight) * NormalUpRight.Z;

      // bottom right point of grid
      NormalDownRight.X := cosAngleFinish * cosSliceFinish;
      NormalDownRight.Y := sinAngleFinish;
      NormalDownRight.Z := cosAngleFinish * sinSliceFinish;
      PointDownRight.X := center.X + (WaterDownRight) * NormalDownRight.X;
      PointDownRight.Y := center.Y + (WaterDownRight) * NormalDownRight.Y;
      PointDownRight.Z := center.Z + (WaterDownRight) * NormalDownRight.Z;

      // center point of grid
      // this is the point that corresponds to grid Water; user can raise/lower it
      MiddleNormal.X := cosAngleMiddle * cosSliceMiddle;
      MiddleNormal.Y := sinAngleMiddle;
      MiddleNormal.Z := cosAngleMiddle * sinSliceMiddle;
      MiddlePoint.X := center.X + (WaterMiddle) * MiddleNormal.X;
      MiddlePoint.Y := center.Y + (WaterMiddle) * MiddleNormal.Y;
      MiddlePoint.Z := center.Z + (WaterMiddle) * MiddleNormal.Z;

      // create a square grid from four triangles, all sharing the middle point
      // left triangle
      myCrossover.Vertices[0][0] := AddToMesh(MiddlePoint, MiddleNormal);
      myCrossover.Vertices[0][1] := AddToMesh(PointDownLeft, NormalDownLeft);
      myCrossover.Vertices[0][2] := AddToMesh(PointUpLeft, NormalUpLeft);

      // bottom triangle
      myCrossover.Vertices[1][0] := AddToMesh(MiddlePoint, MiddleNormal);
      myCrossover.Vertices[1][1] := AddToMesh(PointDownRight, NormalDownRight);
      myCrossover.Vertices[1][2] := AddToMesh(PointDownLeft, NormalDownLeft);

      // right triangle
      myCrossover.Vertices[2][0] := AddToMesh(MiddlePoint, MiddleNormal);
      myCrossover.Vertices[2][1] := AddToMesh(PointUpRight, NormalUpRight);
      myCrossover.Vertices[2][2] := AddToMesh(PointDownRight, NormalDownRight);

      // top triangle
      myCrossover.Vertices[3][0] := AddToMesh(MiddlePoint, MiddleNormal);
      myCrossover.Vertices[3][1] := AddToMesh(PointUpLeft, NormalUpLeft);
      myCrossover.Vertices[3][2] := AddToMesh(PointUpRight, NormalUpRight);

      myCrossover.Normals[0] := MiddleNormal;
      myCrossover.Normals[1] := NormalUpLeft;
      myCrossover.Normals[2] := NormalDownLeft;
      myCrossover.Normals[3] := NormalUpRight;
      myCrossover.Normals[4] := NormalDownRight;
    end;
  end;

  fmFirstForm.Construction.AddEvent('Water.Mesh: Triangles = ' +
    IntToStr(WaterMesh.TriangleCount) + ' Vertices = ' +
    IntToStr(WaterMesh.Vertices.Count));

  // add mesh to freeform (a freeform holds meshes)
  WaterBubble.MeshObjects.Add(WaterMesh);
  WaterBubble.NormalsOrientation := mnoInvert;
  WaterBubble.StructureChanged;

  fmFirstForm.Construction.AddEvent('Water.Freeform: Triangles = ' +
    IntToStr(WaterBubble.MeshObjects.TriangleCount));

  for Longitude := 0 to (Width - 1) do
    for Latitude := 0 to (Height - 1) do
      SetWaterHeightPoints(Environment.Space.Map[Longitude][Latitude]);
end;

procedure Tfm3DEnvironment.WaterUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edWater.Text := IntToStr(WaterUpDown.Position);
  WaterCan := WaterUpDown.Position;
  WaterFastUpDown.Position := WaterUpDown.Position;
end;

procedure Tfm3DEnvironment.WaterFastUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edWater.Text := IntToStr(WaterFastUpDown.Position);
  WaterCan := WaterFastUpDown.Position;
  WaterUpDown.Position := WaterFastUpDown.Position;
end;

procedure Tfm3DEnvironment.tbSnapshotClick(Sender: TObject);
var
  myfmPhotograph: TfmPhotograph;
  // myJpeg: TJpegImage;
begin
  LastAction('snapshot');
  SetCurrentDir(ExtractFilePath(ParamStr(0)));

  myfmPhotograph := TfmPhotograph.Create(self);

  // set the photo
  // myfmPhotograph.imgPhoto.Picture.Bitmap.Width := GLSceneViewer.Buffer.Width;
  // myfmPhotograph.imgPhoto.Picture.Bitmap.Height := GLSceneViewer.Buffer.Height;
  // GLSceneViewer.Buffer.RenderToBitmap(TGLBitmap(myfmPhotograph.imgPhoto.Picture.Bitmap), 96);
  myfmPhotograph.edPhotoWidth.Text := IntToStr(GLSceneViewer.Buffer.Width);
  myfmPhotograph.edPhotoHeight.Text := IntToStr(GLSceneViewer.Buffer.Height);
  myfmPhotograph.edThumbWidth.Text :=
    IntToStr(GLSceneViewer.Buffer.Width div
    (GLSceneViewer.Buffer.Height div 64));
  myfmPhotograph.edThumbHeight.Text := IntToStr(64);

  if myfmPhotograph.ShowModal = mrOK then
  begin
    { myJpeg := TJpegImage.Create;
      myJpeg.Assign(myfmPhotoGraph.imgPhoto.Picture.Bitmap);
      myJpeg.SaveToFile(myfmPhotograph.edPhotograph.Text + '.jpg');
      myJpeg.Free; }
    GLSceneViewer.Buffer.RenderToFile(myfmPhotograph.edPhotograph.Text,
      StrToInt(myfmPhotograph.edPhotoWidth.Text),
      StrToInt(myfmPhotograph.edPhotoHeight.Text));
    if myfmPhotograph.cbCreateThumbnail.Checked then
    begin
      SkyDome.Visible := false;
      GLSceneViewer.Buffer.RenderToFile(myfmPhotograph.edThumbnail.Text,
        StrToInt(myfmPhotograph.edThumbWidth.Text),
        StrToInt(myfmPhotograph.edThumbHeight.Text));
      SkyDome.Visible := tbShowStars.Down;
    end;
    ShowMessage('Photograph saved (' + myfmPhotograph.edPhotograph.Text + ')');
  end;

  myfmPhotograph.Free;
end;

procedure Tfm3DEnvironment.tbStabalizeClick(Sender: TObject);
begin
end;

// ----------------------------------------------------------------------------
// builds the water form
procedure Tfm3DEnvironment.BuildAtmosphere(center: TGLVector; radius: single;
  Height: Integer; Width: Integer; Show: Boolean);
var
  // grid normal vectors
  NormalUpLeft: TGLVector;
  NormalDownLeft: TGLVector;
  NormalUpRight: TGLVector;
  NormalDownRight: TGLVector;
  MiddleNormal: TGLVector;

  // grid points
  PointUpLeft: TAffineVector;
  PointDownLeft: TAffineVector;
  PointUpRight: TAffineVector;
  PointDownRight: TAffineVector;
  MiddlePoint: TAffineVector;

  Mesh: TGLMeshObject;

  Top: single;

  Latitude: Integer; // position along the height axis
  Longitude: Integer; // position along the width axis

  AngleStart, AngleFinish, AngleMiddle: single;
  SliceBegin, SliceFinish, SliceMiddle: single;

  function AddToMesh(aVertice: TAffineVector; aNormal: TGLVector): Integer;
  begin
    Mesh.Vertices.Add(aVertice);
    Mesh.Normals.Add(aNormal.X, aNormal.Y, aNormal.Z);
    result := Mesh.Vertices.Count - 1;
  end;

begin
  // erase any previous planets
  Atmosphere.MeshObjects.Clear;

  // create the mesh
  Mesh := TGLMeshObject.Create;
  Mesh.Vertices.Clear;
  Mesh.Normals.Clear;
  Mesh.FaceGroups.Clear;
  Mesh.TexCoords.Clear;
  Mesh.Mode := momTriangles;

  Top := 50 / cHeightDivision;

  // height loop
  // we start at the top of the map and go to the bottom, in width strips
  for Latitude := 0 to (Height) - 1 do
  begin
    // calculate the angles of top and bottom of grid
    AngleStart := Latitude * HeightAngle - cHalfPi;
    AngleFinish := AngleStart + HeightAngle;
    AngleMiddle := AngleStart + HeightAngle / 2;

    // width loop
    // for each line of height we are on (from the previous loop), draw
    // the length of the width (one full rotation about the sphere)
    for Longitude := 0 to (Width - 1) do
    begin
      // calculate the angular width of the grid
      SliceBegin := Longitude * WidthAngle;
      SliceFinish := SliceBegin + WidthAngle;
      SliceMiddle := SliceBegin + WidthAngle / 2;

      // top left point of grid
      NormalUpLeft.X := cos(AngleStart) * cos(SliceBegin);
      NormalUpLeft.Y := sin(AngleStart);
      NormalUpLeft.Z := cos(AngleStart) * sin(SliceBegin);
      PointUpLeft.X := center.X + (radius + Top) * NormalUpLeft.X;
      PointUpLeft.Y := center.Y + (radius + Top) * NormalUpLeft.Y;
      PointUpLeft.Z := center.Z + (radius + Top) * NormalUpLeft.Z;

      // bottom left point of grid
      NormalDownLeft.X := cos(AngleFinish) * cos(SliceBegin);
      NormalDownLeft.Y := sin(AngleFinish);
      NormalDownLeft.Z := cos(AngleFinish) * sin(SliceBegin);
      PointDownLeft.X := center.X + (radius + Top) * NormalDownLeft.X;
      PointDownLeft.Y := center.Y + (radius + Top) * NormalDownLeft.Y;
      PointDownLeft.Z := center.Z + (radius + Top) * NormalDownLeft.Z;

      // top right point of grid
      NormalUpRight.X := cos(AngleStart) * cos(SliceFinish);
      NormalUpRight.Y := sin(AngleStart);
      NormalUpRight.Z := cos(AngleStart) * sin(SliceFinish);
      PointUpRight.X := center.X + (radius + Top) * NormalUpRight.X;
      PointUpRight.Y := center.Y + (radius + Top) * NormalUpRight.Y;
      PointUpRight.Z := center.Z + (radius + Top) * NormalUpRight.Z;

      // bottom right point of grid
      NormalDownRight.X := cos(AngleFinish) * cos(SliceFinish);
      NormalDownRight.Y := sin(AngleFinish);
      NormalDownRight.Z := cos(AngleFinish) * sin(SliceFinish);
      PointDownRight.X := center.X + (radius + Top) * NormalDownRight.X;
      PointDownRight.Y := center.Y + (radius + Top) * NormalDownRight.Y;
      PointDownRight.Z := center.Z + (radius + Top) * NormalDownRight.Z;

      // center point of grid
      // this is the point that corresponds to grid Water; user can raise/lower it
      MiddleNormal.X := cos(AngleMiddle) * cos(SliceMiddle);
      MiddleNormal.Y := sin(AngleMiddle);
      MiddleNormal.Z := cos(AngleMiddle) * sin(SliceMiddle);
      MiddlePoint.X := center.X + (radius + Top) * MiddleNormal.X;
      MiddlePoint.Y := center.Y + (radius + Top) * MiddleNormal.Y;
      MiddlePoint.Z := center.Z + (radius + Top) * MiddleNormal.Z;

      if not(Latitude = 0) and not(Latitude = Height - 1) then
      begin
        // create a square grid from four triangles, all sharing the middle point
        // left triangle
        AddToMesh(MiddlePoint, MiddleNormal);
        AddToMesh(PointDownLeft, NormalDownLeft);
        AddToMesh(PointUpLeft, NormalUpLeft);

        // bottom triangle
        AddToMesh(MiddlePoint, MiddleNormal);
        AddToMesh(PointDownRight, NormalDownRight);
        AddToMesh(PointDownLeft, NormalDownLeft);

        // right triangle
        AddToMesh(MiddlePoint, MiddleNormal);
        AddToMesh(PointUpRight, NormalUpRight);
        AddToMesh(PointDownRight, NormalDownRight);

        // top triangle
        AddToMesh(MiddlePoint, MiddleNormal);
        AddToMesh(PointUpLeft, NormalUpLeft);
        AddToMesh(PointUpRight, NormalUpRight);
      end;

      if (Latitude = 0) then
      begin
        AddToMesh(PointDownRight, NormalDownRight);
        AddToMesh(PointDownLeft, NormalDownLeft);
        AddToMesh(PointUpLeft, NormalUpLeft);
      end;

      if (Latitude = Height - 1) then
      begin
        AddToMesh(PointUpLeft, NormalUpLeft);
        AddToMesh(PointUpRight, NormalUpRight);
        AddToMesh(PointDownRight, NormalDownRight);
      end;
    end;
  end;

  // add mesh to freeform (a freeform holds meshes)
  Atmosphere.MeshObjects.Add(Mesh);
  Atmosphere.StructureChanged;
  fmFirstForm.Construction.AddEvent('Atmosphere.Freeform: Triangles = ' +
    IntToStr(Atmosphere.MeshObjects.TriangleCount));
end;

procedure Tfm3DEnvironment.InvalidateLand;
var
  X, Y: Integer;
begin
  for X := 0 to gSpace.WidthLoop do
    for Y := 0 to gSpace.HeightLoop do
    begin
      UpdateGridHeight(gSpace.Map[X][Y]);
      UpdateWaterHeight(gSpace.Map[X][Y]);
    end;
  PlanetModel.StructureChanged;
  WaterBubble.StructureChanged;
end;

procedure Tfm3DEnvironment.tbAsteroidClick(Sender: TObject);
begin
  Tool := tAsteroid;
  tbRepeat.Down := false;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.GenerateSoundSystem(aNumberOfSpeakers: Integer);
var
  i: Integer;
  myCrossover: TCrossover;
  mySpeaker: TGLDummyCube;
  mySound: TGLBSoundEmitter;
begin
  if not GLBass.Active then
    exit;

  fmFirstForm.Construction.AddEvent('Generating sound system...');
  for i := 0 to aNumberOfSpeakers - 1 do
  begin
    myCrossover := Speakers.NewCrossover;
    mySpeaker := TGLDummyCube(SoundSystem.AddNewChild(TGLDummyCube));

    mySound := GetOrCreateSoundEmitter(TGLBaseSceneObject(mySpeaker));
    mySound.Source.SoundLibrary := GLSoundLibrary;
    mySound.Source.NbLoops := 1;
    mySound.Playing := false;

    myCrossover.Visuals.Add(mySpeaker);

    fmFirstForm.Construction.AddEventSuccess(' ' + IntToStr(i));
  end;

  Speakers.SetFirstActive;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.PlaySound(aSoundIndex: Integer; aRepeat: Integer;
  aPosition: AIPosition);
var
  myCrossover: TCrossover;
  mySpeaker: TGLDummyCube;
  mySound: TGLBSoundEmitter;
begin
  if not GLBass.Active then
    exit;

  if not(aSoundIndex <= GLSoundLibrary.Samples.Count) then
    exit;

  // get next available speaker
  Speakers.SetNextOrFirstActive;
  myCrossover := TCrossover(Speakers.ActiveItem);
  mySpeaker := TGLDummyCube(myCrossover.Visuals.Items[0]);

  // position speaker
  PositionThing(aPosition, mySpeaker);
  // CoordinatesFromPosition(aPosition, mySpeaker.Position);

  // play sound
  mySound := GetOrCreateSoundEmitter(TGLBaseSceneObject(mySpeaker));
  mySound.Source.SoundName := GLSoundLibrary.Samples[aSoundIndex].Name;
  mySound.Playing := true;
  mySound.Source.Volume := SoundVolume;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.LoadSounds;
begin
  fmFirstForm.Construction.AddUnderlinedEvent('Loading sounds');

  LoadSound('audio\electronicping.wav'); // 0
  LoadSound('audio\fire.wav'); // 1
  LoadSound('audio\quake3.wav'); // 2
  LoadSound('audio\lightrainloop.wav'); // 3
  LoadSound('audio\nightengale.wav'); // 4
  LoadSound('audio\waterdrop.wav'); // 5
  LoadSound('audio\bird-die.wav'); // 6
  LoadSound('audio\incoming.wav'); // 7
  LoadSound('audio\cricket.wav'); // 8
  LoadSound('audio\crunch.wav'); // 9
  LoadSound('audio\explode.wav'); // 10
  LoadSound('audio\forest.wav'); // 11
  LoadSound('audio\hawk.wav'); // 12
  LoadSound('audio\lion.wav'); // 13
  LoadSound('audio\nightengale.wav'); // 14
  LoadSound('audio\ohhh.wav'); // 15
  LoadSound('audio\pigeon.wav'); // 16
  LoadSound('audio\sparrow.wav'); // 17
  LoadSound('audio\707kick.wav'); // 18
  LoadSound('audio\bliptick.wav'); // 19
  LoadSound('audio\snare1.wav'); // 20
  LoadSound('audio\rocksmash.wav'); // 21
  LoadSound('audio\throw.wav'); // 22
  LoadSound('audio\uproot.wav'); // 23
  LoadSound('audio\watersplash.wav'); // 24
  LoadSound('audio\mouse1.wav'); // 25
  LoadSound('audio\mouse2.wav'); // 26
  LoadSound('audio\tiger.wav'); // 27
  LoadSound('audio\quack.wav'); // 28
  LoadSound('audio\duckling.wav'); // 29
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.LoadSound(aFileName: string);
begin
  fmFirstForm.Construction.AddEvent('Loading sound from file ' + aFileName
    + '... ');
  if FileExists(aFileName) then
  begin
    GLSoundLibrary.Samples.Add.LoadFromFile(aFileName);
    fmFirstForm.Construction.AddEventSuccess(' done.');
  end
  else
    fmFirstForm.Construction.AddEventFailure(' not found!');
end;

procedure Tfm3DEnvironment.tbPriorTargetClick(Sender: TObject);
begin
  if Satellites.SetNextOrFirstActive then
    TargetToFollow := Satellites.ActiveItem
  else
    TargetToFollow := nil;

  SetCameraByTarget;
end;

procedure Tfm3DEnvironment.tbNextTargetClick(Sender: TObject);
begin
  if Satellites.SetPriorOrLastActive then
    TargetToFollow := Satellites.ActiveItem
  else
    TargetToFollow := nil;

  SetCameraByTarget;
end;

procedure Tfm3DEnvironment.tbTrackSunClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cSun) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackMoonClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cMoon) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackBirdClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cBird) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackFishClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cFish) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackAppleClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cAppleTree) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackOrangeClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cOrangeTree) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackCloudClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cCloud) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackAsteroidClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cAsteroid) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackSpiritClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cBot) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbControlBotClick(Sender: TObject);
begin
  if not Assigned(TargetToFollow) or (AIThing(TargetToFollow.Data).Kind <> cBot)
  then
    if Satellites.SetCrossoverByKind(cBot) then
    begin
      TargetToFollow := Satellites.ActiveItem;
      SetCameraByTarget;
    end;

  if Assigned(TargetToFollow) then
    if AIThing(TargetToFollow.Data).Kind = cBot then
    begin
      ControlBot := TargetToFollow.Data;
      ControllingBot := true;
      tbBotSelect.Down := true;
      Tool := tSelect;
      HideCursor;
    end
    else
    begin
      ControlBot := nil;
      ControllingBot := false;
    end;
end;

procedure Tfm3DEnvironment.tbBotPickupClick(Sender: TObject);
begin
  ControlBot.Command := 'GRAB';
end;

procedure Tfm3DEnvironment.tbBotThrowClick(Sender: TObject);
begin
  ControlBot.Command := 'DROP';
end;

procedure Tfm3DEnvironment.GenerateTextureMap;
var
  TexUpLeft: TTexPoint;
  TexDownLeft: TTexPoint;
  TexUpRight: TTexPoint;
  TexDownRight: TTexPoint;
  TexMiddle: TTexPoint;
  TexUp: TTexPoint;
  TexDown: TTexPoint;
  TexLeft: TTexPoint;
  TexRight: TTexPoint;

  tex: Integer;
  ShiftUp, ShiftDown, ShiftPixel: single;
begin
  ShiftPixel := 1.0 / 1024.0;

  TexDownLeft.S := 0.0 / 4 + ShiftPixel;
  TexDownLeft.T := 0.0 / 4 + ShiftPixel;
  TexDownRight.S := 1.0 / 4 - ShiftPixel;
  TexDownRight.T := 0.0 / 4 + ShiftPixel;
  TexUpRight.S := 1.0 / 4 - ShiftPixel;
  TexUpRight.T := 1.0 / 4 - ShiftPixel;
  TexUpLeft.S := 0.0 / 4 + ShiftPixel;
  TexUpLeft.T := 1.0 / 4 - ShiftPixel;
  TexMiddle.S := 0.5 / 4;
  TexMiddle.T := 0.5 / 4;
  TexUp.S := 0.5 / 4;
  TexUp.T := 1.0 / 4 - ShiftPixel;
  TexDown.S := 0.5 / 4;
  TexDown.T := 0.0 / 4 + ShiftPixel;
  TexLeft.S := 0.0 / 4 + ShiftPixel;
  TexLeft.T := 0.5 / 4;
  TexRight.S := 1.0 / 4 - ShiftPixel;
  TexRight.T := 0.5 / 4;

  SetLength(TextureMap, 16, 8, 3);

  for tex := 0 to 15 do
  begin
    ShiftUp := ((tex mod 4) * 1.0) / 4.0;
    ShiftDown := ((tex div 4) * 1.0) / 4.0;

    TextureMap[tex][0][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][0][1].S := TexUp.S + ShiftUp;
    TextureMap[tex][0][2].S := TexUpRight.S + ShiftUp;
    TextureMap[tex][0][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][0][1].T := TexUp.T + ShiftDown;
    TextureMap[tex][0][2].T := TexUpRight.T + ShiftDown;

    TextureMap[tex][1][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][1][1].S := TexUpRight.S + ShiftUp;
    TextureMap[tex][1][2].S := TexRight.S + ShiftUp;
    TextureMap[tex][1][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][1][1].T := TexUpRight.T + ShiftDown;
    TextureMap[tex][1][2].T := TexRight.T + ShiftDown;

    TextureMap[tex][2][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][2][1].S := TexRight.S + ShiftUp;
    TextureMap[tex][2][2].S := TexDownRight.S + ShiftUp;
    TextureMap[tex][2][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][2][1].T := TexRight.T + ShiftDown;
    TextureMap[tex][2][2].T := TexDownRight.T + ShiftDown;

    TextureMap[tex][3][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][3][1].S := TexDownRight.S + ShiftUp;
    TextureMap[tex][3][2].S := TexDown.S + ShiftUp;
    TextureMap[tex][3][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][3][1].T := TexDownRight.T + ShiftDown;
    TextureMap[tex][3][2].T := TexDown.T + ShiftDown;

    TextureMap[tex][4][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][4][1].S := TexDown.S + ShiftUp;
    TextureMap[tex][4][2].S := TexDownLeft.S + ShiftUp;
    TextureMap[tex][4][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][4][1].T := TexDown.T + ShiftDown;
    TextureMap[tex][4][2].T := TexDownLeft.T + ShiftDown;

    TextureMap[tex][5][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][5][1].S := TexDownLeft.S + ShiftUp;
    TextureMap[tex][5][2].S := TexLeft.S + ShiftUp;
    TextureMap[tex][5][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][5][1].T := TexDownLeft.T + ShiftDown;
    TextureMap[tex][5][2].T := TexLeft.T + ShiftDown;

    TextureMap[tex][6][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][6][1].S := TexLeft.S + ShiftUp;
    TextureMap[tex][6][2].S := TexUpLeft.S + ShiftUp;
    TextureMap[tex][6][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][6][1].T := TexLeft.T + ShiftDown;
    TextureMap[tex][6][2].T := TexUpLeft.T + ShiftDown;

    TextureMap[tex][7][0].S := TexMiddle.S + ShiftUp;
    TextureMap[tex][7][1].S := TexUpLeft.S + ShiftUp;
    TextureMap[tex][7][2].S := TexUp.S + ShiftUp;
    TextureMap[tex][7][0].T := TexMiddle.T + ShiftDown;
    TextureMap[tex][7][1].T := TexUpLeft.T + ShiftDown;
    TextureMap[tex][7][2].T := TexUp.T + ShiftDown;
  end;

end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildCrab(aCrab: AICrab): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := CrabModel;
    ProxyOptions := [pooObjects];
    Up := CrabModel.Up;
    PitchAngle := -90;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aCrab;
  result.SubVisuals.Add(myProxy);
  aCrab.Crossover := result;
  UpdateCrab(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateCrab(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myCrab: AICrab;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myCrab := AICrab(aCrossover.Data);

  if myCrab.Dead then
    myProxy.Up.SetVector(0, -1, 0);

  factor := 0.25 + 0.005 * myCrab.Size;
  Scale := CrabModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myCrab.Position, myProxy, HalfPi, -0.05);

  if myCrab.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, QuarterPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildHawk(aHawk: AIHawk): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := HawkModel;
    ProxyOptions := [pooObjects];
    Up := HawkModel.Up;
    PitchAngle := -90;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aHawk;
  result.SubVisuals.Add(myProxy);
  aHawk.Crossover := result;
  UpdateHawk(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateHawk(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myHawk: AIHawk;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myHawk := AIHawk(aCrossover.Data);

  factor := 0.5 + 0.005 * myHawk.Size;
  Scale := HawkModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myHawk.Position, myProxy, HalfPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildGrazer(aGrazer: AIGrazer): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := GrazerModel;
    ProxyOptions := [pooObjects];
    // Up := GrazerModel.Up;
    PitchAngle := 90;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aGrazer;
  result.SubVisuals.Add(myProxy);
  aGrazer.Crossover := result;
  UpdateGrazer(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateGrazer(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myGrazer: AIGrazer;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myGrazer := AIGrazer(aCrossover.Data);

  factor := myGrazer.Size;
  Scale := GrazerModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myGrazer.Position, myProxy, -HalfPi);

  if myGrazer.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, HalfPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildTrex(aTrex: AITrex): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := TrexModel;
    ProxyOptions := [pooObjects];
    PitchAngle := 90;
  end;

  result := Satellites.NewCrossover;
  result.Data := aTrex;
  result.SubVisuals.Add(myProxy);
  aTrex.Crossover := result;
  UpdateTrex(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateTrex(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myTrex: AITrex;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myTrex := AITrex(aCrossover.Data);

  factor := 0.9 + 0.004 * myTrex.Size;
  Scale := TrexModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myTrex.Position, myProxy, -HalfPi);

  if myTrex.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, HalfPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildVibe(aVibe: AIVibe): TCrossover;
begin
  case aVibe.EffectType of
    cEffectNoise:
      PlaySound(aVibe.EffectIndex, 0, aVibe.Position);
    cEffectShake:
      PlanetModel.Position.SetPoint(RandomSwing * 0.25, RandomSwing * 0.25,
        RandomSwing * 0.25);
    cEffectStopShake:
      PlanetModel.Position.SetPoint(0, 0, 0);
  end;

  result := nil;
end;

procedure Tfm3DEnvironment.tbCrabClick(Sender: TObject);
begin
  Tool := tCrab;
end;

procedure Tfm3DEnvironment.tbTrexClick(Sender: TObject);
begin
  Tool := tTrex;
end;

procedure Tfm3DEnvironment.tbGrazerClick(Sender: TObject);
begin
  Tool := tGrazer;
end;

procedure Tfm3DEnvironment.tbHawkClick(Sender: TObject);
begin
  Tool := tHawk;
  tbRepeat.Down := false;
end;

procedure Tfm3DEnvironment.tbBallClick(Sender: TObject);
begin
  Tool := tBall;
end;

procedure Tfm3DEnvironment.tbCubeClick(Sender: TObject);
begin
  Tool := tCube;
end;

procedure Tfm3DEnvironment.tbWeaponClick(Sender: TObject);
begin
  Tool := tWeapon;
end;

procedure Tfm3DEnvironment.cbTrackNewThingsClick(Sender: TObject);
begin
  GLSceneViewer.SetFocus;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildBall(aBall: AIBall): TCrossover;
var
  mySphere: TGLSphere;
begin
  // create crossover
  result := Satellites.NewCrossover;
  result.Data := aBall;
  mySphere := TGLSphere(ProxyCube.AddNewChild(TGLSphere));
  mySphere.radius := aBall.Position.SizeX / 6;
  mySphere.Slices := 16;
  mySphere.Stacks := 16;
  mySphere.Material.MaterialLibrary := GLMaterialLibrary;
  if (Random(3) <> 0) or (gThings.Counters[cBall] = 1) then
    mySphere.Material.LibMaterialName := 'beachball'
  else
    mySphere.Material.LibMaterialName := 'soccer';
  GLShadowVolume.Occluders.AddCaster(mySphere);
  result.SubVisuals.Add(mySphere);
  aBall.Crossover := result;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateBall(aCrossover: TCrossover);
var
  mySphere: TGLSphere;
  myBall: AIBall;
begin
  mySphere := TGLSphere(aCrossover.SubVisuals.Items[0]);
  myBall := AIBall(aCrossover.Data);

  if not(mySphere.radius = myBall.Position.SizeX / 6) then
    mySphere.radius := myBall.Position.SizeX / 6;

  if not myBall.Position.Carried then
  begin
    mySphere.RollAngle := mySphere.RollAngle + myBall.Position.Velocity.Strength
      * 16 / myBall.Position.SizeX;
    mySphere.PitchAngle := mySphere.PitchAngle +
      myBall.Position.Velocity.Strength * 8 / myBall.Position.SizeX;
  end;

  // PositionThing(myBall.Position, mySphere, 0, mySphere.Radius * 0.25);
  CoordinatesFromPosition(myBall.Position, mySphere.Position,
    mySphere.radius * 0.25);
end;

procedure Tfm3DEnvironment.tbSphericalClick(Sender: TObject);
begin
  SphereMode := tbSpherical.Down;
  Environment.Space.Spherical := SphereMode;

  CalculateTerrainSettings;

  InvalidateLand;
  RefreshPlanet;
  PlanetModel.BuildOctree;
  InvalidOctree := false;
  RefreshSatellites;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetFlatGridHeightPoints(aGrid: AIGrid);
var
  myCrossover: TGridCrossover;

  myX, myY: single;

  // grid heights (mountains/valleys)
  HeightMiddle: single;
  HeightUpLeft: single;
  HeightUpRight: single;
  HeightDownLeft: single;
  HeightDownRight: single;
  HeightUp: single;
  HeightDown: single;
  HeightLeft: single;
  HeightRight: single;

  VertexMiddle, VertexUpLeft, VertexUpRight, VertexDownLeft, VertexDownRight
    : TAffineVector;
  VertexUp, VertexDown, VertexLeft, VertexRight: TAffineVector;
begin
  myCrossover := TGridCrossover(aGrid.Crossover);

  HeightMiddle := aGrid.Height / cFlatHeightDivision;
  HeightUpLeft := aGrid.CornerValues[cHeightUpLeft] / cFlatHeightDivision;
  HeightUpRight := aGrid.CornerValues[cHeightUpRight] / cFlatHeightDivision;
  HeightDownLeft := aGrid.CornerValues[cHeightDownLeft] / cFlatHeightDivision;
  HeightDownRight := aGrid.CornerValues[cHeightDownRight] / cFlatHeightDivision;
  HeightUp := aGrid.CornerValues[cHeightUp] / cFlatHeightDivision;
  HeightDown := aGrid.CornerValues[cHeightDown] / cFlatHeightDivision;
  HeightLeft := aGrid.CornerValues[cHeightLeft] / cFlatHeightDivision;
  HeightRight := aGrid.CornerValues[cHeightRight] / cFlatHeightDivision;

  myX := aGrid.Coordinates.X * 10;
  myY := aGrid.Coordinates.Y * 10;

  VertexMiddle.X := myX + 5;
  VertexMiddle.Y := myY + 5;
  VertexMiddle.Z := (HeightMiddle);

  VertexUpLeft.X := myX;
  VertexUpLeft.Y := myY;
  VertexUpLeft.Z := (HeightUpLeft);

  VertexDownLeft.X := myX;
  VertexDownLeft.Y := myY + 10;
  VertexDownLeft.Z := (HeightDownLeft);

  VertexDownRight.X := myX + 10;
  VertexDownRight.Y := myY + 10;
  VertexDownRight.Z := (HeightDownRight);

  VertexUpRight.X := myX + 10;
  VertexUpRight.Y := myY;
  VertexUpRight.Z := (HeightUpRight);

  VertexUp.X := myX + 5;
  VertexUp.Y := myY;
  VertexUp.Z := (HeightUp);

  VertexDown.X := myX + 5;
  VertexDown.Y := myY + 10;
  VertexDown.Z := (HeightDown);

  VertexLeft.X := myX;
  VertexLeft.Y := myY + 5;
  VertexLeft.Z := (HeightLeft);

  VertexRight.X := myX + 10;
  VertexRight.Y := myY + 5;
  VertexRight.Z := (HeightRight);

  // 1 left triangle
  PlanetVertices.Items[myCrossover.Vertices[0][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[0][1]] := VertexUp;
  PlanetVertices.Items[myCrossover.Vertices[0][2]] := VertexUpRight;
  // 2 bottom triangle
  PlanetVertices.Items[myCrossover.Vertices[1][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[1][1]] := VertexUpRight;
  PlanetVertices.Items[myCrossover.Vertices[1][2]] := VertexRight;
  // 3 right triangle
  PlanetVertices.Items[myCrossover.Vertices[2][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[2][1]] := VertexRight;
  PlanetVertices.Items[myCrossover.Vertices[2][2]] := VertexDownRight;
  // 4 top triangle
  PlanetVertices.Items[myCrossover.Vertices[3][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[3][1]] := VertexDownRight;
  PlanetVertices.Items[myCrossover.Vertices[3][2]] := VertexDown;
  // 5 top triangle
  PlanetVertices.Items[myCrossover.Vertices[4][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[4][1]] := VertexDown;
  PlanetVertices.Items[myCrossover.Vertices[4][2]] := VertexDownLeft;
  // 6 top triangle
  PlanetVertices.Items[myCrossover.Vertices[5][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[5][1]] := VertexDownLeft;
  PlanetVertices.Items[myCrossover.Vertices[5][2]] := VertexLeft;
  // 7 top triangle
  PlanetVertices.Items[myCrossover.Vertices[6][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[6][1]] := VertexLeft;
  PlanetVertices.Items[myCrossover.Vertices[6][2]] := VertexUpLeft;
  // 8 top triangle
  PlanetVertices.Items[myCrossover.Vertices[7][0]] := VertexMiddle;
  PlanetVertices.Items[myCrossover.Vertices[7][1]] := VertexUpLeft;
  PlanetVertices.Items[myCrossover.Vertices[7][2]] := VertexUp;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.SetFlatWaterHeightPoints(aGrid: AIGrid);
var
  myCrossover: TGridCrossover;

  myX, myY: single;

  HeightMiddle: single;
  HeightUpLeft: single;
  HeightUpRight: single;
  HeightDownLeft: single;
  HeightDownRight: single;

  VertexMiddle, VertexUpLeft, VertexUpRight, VertexDownLeft, VertexDownRight
    : TAffineVector;
begin
  myCrossover := TGridCrossover(aGrid.WaterCrossover);

  myX := aGrid.Coordinates.X * 10;
  myY := aGrid.Coordinates.Y * 10;

  HeightUpLeft := (aGrid.CornerValues[cWaterUpLeft]) / cFlatHeightDivision;
  HeightUpRight := (aGrid.CornerValues[cWaterUpRight]) / cFlatHeightDivision;
  HeightDownLeft := (aGrid.CornerValues[cWaterDownLeft]) / cFlatHeightDivision;
  HeightDownRight := (aGrid.CornerValues[cWaterDownRight]) /
    cFlatHeightDivision;
  HeightMiddle := (aGrid.Water) / cFlatHeightDivision;

  VertexMiddle.X := myX + 5;
  VertexMiddle.Y := myY + 5;
  VertexMiddle.Z := (HeightMiddle);

  VertexUpLeft.X := myX;
  VertexUpLeft.Y := myY;
  VertexUpLeft.Z := (HeightUpLeft);

  VertexDownLeft.X := myX;
  VertexDownLeft.Y := myY + 10;
  VertexDownLeft.Z := (HeightDownLeft);

  VertexDownRight.X := myX + 10;
  VertexDownRight.Y := myY + 10;
  VertexDownRight.Z := (HeightDownRight);

  VertexUpRight.X := myX + 10;
  VertexUpRight.Y := myY;
  VertexUpRight.Z := (HeightUpRight);

  // left triangle
  WaterVertices.Items[myCrossover.Vertices[0][0]] := VertexMiddle;
  WaterVertices.Items[myCrossover.Vertices[0][1]] := VertexDownLeft;
  WaterVertices.Items[myCrossover.Vertices[0][2]] := VertexUpLeft;

  // bottom triangle
  WaterVertices.Items[myCrossover.Vertices[1][0]] := VertexMiddle;
  WaterVertices.Items[myCrossover.Vertices[1][1]] := VertexDownRight;
  WaterVertices.Items[myCrossover.Vertices[1][2]] := VertexDownLeft;

  // right triangle
  WaterVertices.Items[myCrossover.Vertices[2][0]] := VertexMiddle;
  WaterVertices.Items[myCrossover.Vertices[2][1]] := VertexUpRight;
  WaterVertices.Items[myCrossover.Vertices[2][2]] := VertexDownRight;

  // top triangle
  WaterVertices.Items[myCrossover.Vertices[3][0]] := VertexMiddle;
  WaterVertices.Items[myCrossover.Vertices[3][1]] := VertexUpLeft;
  WaterVertices.Items[myCrossover.Vertices[3][2]] := VertexUpRight;
end;

procedure Tfm3DEnvironment.tbTrackCrabClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cCrab) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackTrexClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cTrex) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackGrazerClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cGrazer) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackHawkClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cHawk) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackBallClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cBall) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbPlantForestClick(Sender: TObject);
begin
  Tool := tForest;
end;

procedure Tfm3DEnvironment.AddToTrail(aPosition: AIPosition; aLines: TGLLines);
var
  p, pt: TAffineVector;
  v: TGLVector;
begin
  p := aPosition.AsAffineVector;
  // PositionThing(p, pt);
  CoordinatesFromPosition(p, pt);

  v.X := pt.X;
  v.Y := pt.Y;
  v.Z := pt.Z;

  aLines.AddNode(0, 0, 0);
  aLines.Nodes.Last.AsVector := v;
  if aLines.Nodes.Count > 40 then // limit trail to 20 points
    aLines.Nodes[0].Free;
end;

procedure Tfm3DEnvironment.tbTrackLinesClick(Sender: TObject);
begin
  if not tbTrackLines.Down then
  begin
    TrackLines.Visible := false;
    fmFirstForm.Construction.AddEvent('Turned track lines off.');
  end
  else if (CameraMode = camTarget) then
  begin
    TrackLines.Visible := true;
    fmFirstForm.Construction.AddEvent('Turned track lines on.');
  end;
end;

procedure Tfm3DEnvironment.UpdateTrackingTrail;
var
  i, j, k: Integer;
  myPosition: AIPosition;
begin
  myPosition := AIThing(TargetToFollow.Data).Position;
  // add tracking trail
  AddToTrail(myPosition, TrackLines);

  // fade nodes forwards
  j := TrackLines.Nodes.Count;
  for i := 0 to j do
  begin
    k := j - i - 1;
    if k >= 0 then
      TGLLinesNode(TrackLines.Nodes[k]).Color.Alpha := 0.95 - i * 0.025;
  end;

  // recalculate predictions
  if PredictLines.Visible then
  begin
    PredictLines.Nodes.Clear;
    Prediction.FullCopy(myPosition);
    Prediction.Tangible := false;
    for i := 0 to 19 do
    begin
      Prediction.Fuel;
      AddToTrail(Prediction, PredictLines);
    end;
    // fade nodes backwards
    j := PredictLines.Nodes.Count;
    for i := j - 1 downto 0 do
    begin
      k := j - i - 1;
      if k >= 0 then
        TGLLinesNode(PredictLines.Nodes[k]).Color.Alpha := i * 0.05;
    end;
  end;
end;

procedure Tfm3DEnvironment.tbPredictionsClick(Sender: TObject);
begin
  if not tbPredictions.Down then
  begin
    PredictLines.Visible := false;
    PredictLines.Nodes.Clear;
    fmFirstForm.Construction.AddEvent('Turned predict lines off.');
  end
  else if (CameraMode = camTarget) then
  begin
    PredictLines.Visible := true;
    fmFirstForm.Construction.AddEvent('Turned predict lines on.');
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildLightning(aLightning: AILightning): TCrossover;
var
  myProxy: TGLProxyObject;
  myScale: TGLVector;
  myFactor: single;
  myThor: TGLThorFXManager;
  myThorFX: TGLBThorFX;
  myPos, myBottom: TAffineVector;
begin
  myProxy := TGLProxyObject(CloudCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := ExplosionModel;
    ProxyOptions := [pooObjects];
    Up := ExplosionModel.Up;
    myFactor := 1;
    myScale := ExplosionModel.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
  end;

  result := Satellites.NewCrossover;
  result.Data := aLightning;
  result.SubVisuals.Add(myProxy);
  aLightning.Crossover := result;

  myPos := aLightning.Position.AsAffineVector;
  myPos.Z := aLightning.Position.Land;
  CoordinatesFromPosition(myPos, myBottom);

  // add Thor to sun
  if myProxy.Effects.CanAdd(TGLBThorFX) then
  begin
    myThor := TGLThorFXManager.Create(self);
    myThor.Cadencer := GLCadencer;
    // PositionThing(aLightning.Position, myProxy);
    CoordinatesFromPosition(aLightning.Position, myProxy.Position);
    ScaleVector(myBottom, -1);
    myThor.Target.AsAffineVector := myBottom;
    myThor.GlowSize := 0.05;
    myThor.Wildness := 2;
    myThorFX := TGLBThorFX.Create(nil);
    myProxy.Effects.Add(myThorFX);
    myThorFX.Manager := myThor;
    result.SubVisuals.Add(myThor);
  end;

  PlaySound(10, 0, aLightning.Position);
end;

procedure Tfm3DEnvironment.tbStormCloudClick(Sender: TObject);
begin
  Tool := tStormCloud;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildShark(aShark: AIShark): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := SharkModel;
    ProxyOptions := [pooObjects];
    Up := SharkModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aShark;
  result.SubVisuals.Add(myProxy);
  aShark.Crossover := result;
  UpdateShark(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateShark(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myShark: AIShark;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myShark := AIShark(aCrossover.Data);

  factor := 0.01 + 0.01 * myShark.Size;
  Scale := SharkModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myShark.Position, myProxy, -HalfPi);
end;

procedure Tfm3DEnvironment.tbSharkClick(Sender: TObject);
begin
  Tool := tShark;
  tbRepeat.Down := false;
end;

procedure Tfm3DEnvironment.tbTurtleClick(Sender: TObject);
begin
  Tool := tTurtle;
  tbRepeat.Down := false;
end;

procedure Tfm3DEnvironment.tbTrackSharkClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cShark) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackTurtleClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cTurtle) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildTurtle(aTurtle: AITurtle): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := TurtleModel;
    ProxyOptions := [pooObjects];
    Up := TurtleModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aTurtle;
  result.SubVisuals.Add(myProxy);
  aTurtle.Crossover := result;
  UpdateTurtle(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateTurtle(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myTurtle: AITurtle;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myTurtle := AITurtle(aCrossover.Data);

  factor := 0.01 + 0.01 * myTurtle.Size;
  Scale := TurtleModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myTurtle.Position, myProxy, HalfPi);
end;

procedure Tfm3DEnvironment.tbBeaconBubbleClick(Sender: TObject);
begin
  Tool := tBeaconBubble;
end;

procedure Tfm3DEnvironment.tbBeaconDrainClick(Sender: TObject);
begin
  Tool := tBeaconDrain;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildBeacon(aBeacon: AIBeacon): TCrossover;
var
  myProxy: TGLProxyObject;
  Scale: TGLVector;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := BeaconModel;
    ProxyOptions := [pooObjects];
    Up := BeaconModel.Up;
  end;
  Scale := BeaconModel.Scale.AsVector;
  ScaleVector(Scale, 0.1);
  myProxy.Scale.AsVector := Scale;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aBeacon;
  result.SubVisuals.Add(myProxy);
  aBeacon.Crossover := result;
  UpdateBeacon(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateBeacon(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myBeacon: AIBeacon;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myBeacon := AIBeacon(aCrossover.Data);

  myProxy.RollAngle := myProxy.RollAngle + 1;
  myProxy.PitchAngle := myProxy.PitchAngle + 2;

  // PositionThing(myBeacon.Position, myProxy);
  CoordinatesFromPosition(myBeacon.Position, myProxy.Position, 0.1);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildTerrier(aTerrier: AITerrier): TCrossover;
var
  myProxy: TGLProxyObject;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := TerrierModel;
    ProxyOptions := [pooObjects];
    Up := TerrierModel.Up;
  end;

  factor := 0.3; // + 0.01 * myTerrier.Size;
  Scale := TerrierModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aTerrier;
  result.SubVisuals.Add(myProxy);
  aTerrier.Crossover := result;
  UpdateTerrier(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildTiger(aTiger: AITiger): TCrossover;

var
  myProxy: TGLProxyObject;

begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := TigerModel;
    ProxyOptions := [pooObjects];
    Up := TigerModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aTiger;
  result.SubVisuals.Add(myProxy);
  aTiger.Crossover := result;
  UpdateTiger(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateTerrier(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myTerrier: AITerrier;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myTerrier := AITerrier(aCrossover.Data);

  myProxy.Up.SetToZero;
  CoordinatesFromPosition(myTerrier.Position, myProxy.Direction,
    myProxy.Position, 0.3);
  myProxy.Up.Rotate(myProxy.Direction.AsAffineVector,
    myTerrier.Position.DirectionXY - HalfPi);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateTiger(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myTiger: AITiger;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myTiger := AITiger(aCrossover.Data);

  factor := 1.25; { * myTiger.Size; }
  Scale := TigerModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myTiger.Position, myProxy, -HalfPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildDuck(aDuck: AIDuck): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    { if aDuck.Female then
      MasterObject := DuckFemale
      else }
    MasterObject := DuckModel;
    ProxyOptions := [pooObjects];
    Up := DuckModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aDuck;
  result.SubVisuals.Add(myProxy);
  aDuck.Crossover := result;
  UpdateDuck(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateDuck(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myDuck: AIDuck;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myDuck := AIDuck(aCrossover.Data);

  factor := myDuck.Size / 5;
  Scale := DuckModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myDuck.Position, myProxy, Pi, -0.05);

  if myDuck.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, cHalfPi);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.tbTerrierClick(Sender: TObject);
begin
  Tool := tTerrier;
end;

procedure Tfm3DEnvironment.tbTrackTerrierClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cTerrier) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildFox(aFox: AIFox): TCrossover;
var
  myProxy: TGLProxyObject;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := FoxModel;
    ProxyOptions := [pooObjects];
    Up := FoxModel.Up;
  end;

  factor := 0.3; // + 0.01 * myFox.Size;
  Scale := FoxModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aFox;
  result.SubVisuals.Add(myProxy);
  aFox.Crossover := result;
  UpdateFox(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateFox(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myFox: AIFox;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myFox := AIFox(aCrossover.Data);

  if myFox.Alive then
    PositionThing(myFox.Position, myProxy, -HalfPi, 0.25)
  else
  begin
    PositionThing(myFox.Position, myProxy, -HalfPi, 0.05);
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, HalfPi);
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildRabbit(aRabbit: AIRabbit): TCrossover;
var
  myProxy: TGLProxyObject;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := RabbitModel;
    ProxyOptions := [pooObjects];
    Up := RabbitModel.Up;
  end;

  factor := 0.3; // + 0.01 * myRabbit.Size;
  Scale := RabbitModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aRabbit;
  result.SubVisuals.Add(myProxy);
  aRabbit.Crossover := result;
  UpdateRabbit(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateRabbit(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myRabbit: AIRabbit;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myRabbit := AIRabbit(aCrossover.Data);

  PositionThing(myRabbit.Position, myProxy, -HalfPi);

  if myRabbit.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, HalfPi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildGrass(aGrass: AIGrass): TCrossover;
var
  myProxy: TGLProxyObject;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := GrassModel;
    ProxyOptions := [pooObjects];
    Up := GrassModel.Up;
    RollAngle := Random(360);
  end;

  factor := 0.3; // + 0.01 * myGrass.Size;
  Scale := GrassModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aGrass;
  result.SubVisuals.Add(myProxy);
  aGrass.Crossover := result;
  UpdateGrass(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateGrass(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myGrass: AIGrass;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myGrass := AIGrass(aCrossover.Data);

  factor := myGrass.Water;
  Scale := GrassModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myGrass.Position, myProxy, 0, -0.05);
  // CoordinatesFromPosition(myGrass.Position, myProxy.Direction, myProxy.Position, -0.05);
end;

procedure Tfm3DEnvironment.tbRabbitClick(Sender: TObject);
begin
  Tool := tRabbit;
end;

procedure Tfm3DEnvironment.tbFoxClick(Sender: TObject);
begin
  Tool := tFox;
end;

procedure Tfm3DEnvironment.tbGrassClick(Sender: TObject);
begin
  Tool := tGrass;
end;

procedure Tfm3DEnvironment.tbTrackFoxClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cFox) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackRabbitClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cRabbit) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildIceberg(aIceberg: AIIceberg): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(EffectsCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := IcebergModel;
    ProxyOptions := [pooObjects];
    Up := IcebergModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aIceberg;
  result.SubVisuals.Add(myProxy);
  aIceberg.Crossover := result;
  UpdateIceberg(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateIceberg(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myIceberg: AIIceberg;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myIceberg := AIIceberg(aCrossover.Data);

  factor := 0.4 * myIceberg.Position.SizeH;
  Scale := IcebergModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myIceberg.Position, myProxy);
end;

procedure Tfm3DEnvironment.tbIcebergClick(Sender: TObject);
begin
  Tool := tIceberg;
  tbRepeat.Down := false;
end;

procedure Tfm3DEnvironment.tbTigerClick(Sender: TObject);
begin
  Tool := tTiger;
end;

procedure Tfm3DEnvironment.tbMouseClick(Sender: TObject);
begin
  Tool := tMouse;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildMouse(aMouse: AIMouse): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(EffectsCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := MouseModel;
    ProxyOptions := [pooObjects];
    Up := MouseModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aMouse;
  result.SubVisuals.Add(myProxy);
  aMouse.Crossover := result;
  UpdateMouse(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateMouse(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myMouse: AIMouse;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myMouse := AIMouse(aCrossover.Data);

  factor := 0.75 * myMouse.Position.SizeH;
  Scale := MouseModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myMouse.Position, myProxy, -HalfPi);

  if myMouse.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, HalfPi);
end;

procedure Tfm3DEnvironment.tbDuckClick(Sender: TObject);
begin
  LastAction('Tool=Duck');
  Tool := tDuck;
end;

procedure Tfm3DEnvironment.AdvanceHidden;
begin
  CheckCradle;
  CheckPurgatory;
  CheckTrash;
end;

procedure Tfm3DEnvironment.RefreshPlanetFull;
var
  i, j: Integer;
  myGrid: AIGrid;
begin
  for i := 0 to gSpace.WidthLoop do
    for j := 0 to gSpace.HeightLoop do
    begin
      myGrid := gSpace.Map[i][j];
      UpdateGridHeight(myGrid);
      UpdateWaterHeight(myGrid);
      TGridCrossover(myGrid.Crossover).LastValue := myGrid.Height;
      TGridCrossover(myGrid.WaterCrossover).LastValue := myGrid.Water;
    end;

  PlanetModel.Position.SetPoint(0, 0, 0);
  EmptyAllSounds;
  InvalidOctree := true;
  PlanetModel.StructureChanged;
  WaterBubble.StructureChanged;
  RefreshSatellites;
end;

procedure Tfm3DEnvironment.tbDolphinClick(Sender: TObject);
begin
  Tool := tDolphin;
  tbRepeat.Down := false;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildDolphin(aDolphin: AIDolphin): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := Dolphin1;
    ProxyOptions := [pooObjects];
    Up := Dolphin1.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aDolphin;
  result.SubVisuals.Add(myProxy);
  aDolphin.Crossover := result;
  UpdateDolphin(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateDolphin(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myDolphin: AIDolphin;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myDolphin := AIDolphin(aCrossover.Data);

  case myDolphin.Flipper of
    cFlipperUp:
      myProxy.MasterObject := Dolphin1;
    cFlipperFlat:
      myProxy.MasterObject := Dolphin2;
    cFlipperDown:
      myProxy.MasterObject := Dolphin4;
    cFlipperJump:
      myProxy.MasterObject := Dolphin3;
  end;

  factor := 0.5;
  Scale := Dolphin1.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myDolphin.Position, myProxy, Pi);
end;

procedure Tfm3DEnvironment.tbCeaseClick(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    LastAction('Cease: ' + AIThing(TargetToFollow.Data).OneLineDisplay);
    AIThing(TargetToFollow.Data).Cease;
  end;
end;

procedure Tfm3DEnvironment.tbTrackWindowClick(Sender: TObject);
begin
  LastAction('PopupTargetWindow');
  PopUpTargetWindow;
end;

procedure Tfm3DEnvironment.PopUpTargetWindow;
begin
  if TargetToFollow <> nil then
  begin
    fmFirstForm.RealityForm.ManagerForm.SpiritWindows.AddSpirit
      (TargetToFollow.Data, true);
  end;
end;

procedure Tfm3DEnvironment.FindTarget(aThing: AIThing);
var
  myTarget: TCrossover;
begin
  if Satellites.SetCrossoverByData(aThing) then
  begin
    myTarget := Satellites.ActiveItem;
    if myTarget <> TargetToFollow then
    begin
      TargetToFollow := myTarget;
      SetCameraByTarget;
    end;
  end;
end;

procedure Tfm3DEnvironment.tbTrackTigerClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cTiger) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackDuckClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cDuck) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackDolphinClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cDolphin) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbAquaPlantClick(Sender: TObject);
begin
  Tool := tAquaPlant;
end;

procedure Tfm3DEnvironment.tbFakeSunClick(Sender: TObject);
var
  mySun: AISun;
begin
  if not Environment.Things.CanAdd(cSun) then
  begin
    ShowMessage('Maximum four suns!');
    exit;
  end;

  mySun := AISun(Environment.Things.NewThing(cSun));
  if not(mySun = nil) then
  begin
    mySun.Rate := 0;
    mySun.radius := 0;
    mySun.Position.SetPosition(gHalfWorldWidth, gHalfWorldHeight, 420);
    mySun.Position.Velocity.Zero;
    mySun.Position.Acceleration.Zero;
    ReportUserEvent('Added Frozen Sun: ' + mySun.OneLineDisplay);
    fmFirstForm.Construction.AddEvent('Added fake sun.');
    LastAction('Added=fakesun');
  end;
end;

procedure Tfm3DEnvironment.tbBeaconOrangeClick(Sender: TObject);
begin
  Tool := tBeaconOrange;
end;

procedure Tfm3DEnvironment.tbSelectClick(Sender: TObject);
begin
  LastAction('Tool=Select');
  tbSelect.Down := true;
  Tool := tSelect;
  HideCursor;
end;

{
  function Tfm3DEnvironment.GetPickedObject(x, y: Integer): TGLBaseSceneObject;
  var
  pkList : TGLPickList;
  i : integer;
  shadowMode: TGLShadowVolumeMode;
  begin
  shadowMode := GLShadowVolume.Mode;
  GLShadowVolume.Mode := svmOff;
  i := 0;
  with GLSceneViewer.Buffer do
  begin
  pkList:=GetPickedObjects(Rect(x-1, y-1, x+1, y+1));
  try
  if pkList.Count>0 then
  begin
  Result:=pkList.Hit[0];
  while not
  ((result is TGLProxyObject)
  or (result is TGLSphere))
  and (pkList.Count>i+1) do
  begin
  inc(i);
  result := pkList.Hit[i];
  end;
  end
  else Result:=nil;
  finally
  pkList.Free;
  end;
  end;
  GLShadowVolume.Mode := shadowMode;
  end;
}

procedure Tfm3DEnvironment.PickObjectWithMouse;
begin
  FindTarget(FindObjectUnderMouse);
end;

function Tfm3DEnvironment.FindObjectUnderMouse: pointer;
var
  myCrossover: TCrossover;
  myVisual: TGLBaseSceneObject;
begin
  result := nil;
  /// Old  myVisual := GetPickedObject(Mouse_x, mouse_y);

  myCrossover := Satellites.FindCrossoverByVisualOrSubVisual(myVisual);

  if myCrossover <> nil then
    result := myCrossover.Data;
end;

procedure Tfm3DEnvironment.tbObjectMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  panSelect.Align := alClient;
  panSelect.Visible := true;
  if tbSelect.Down then
    Tool := tSelect;
  if tbMove.Down then
    Tool := tMove;
  HideCursor;
end;

procedure Tfm3DEnvironment.tbDieClick(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    LastAction('Die: ' + AIThing(TargetToFollow.Data).OneLineDisplay);
    if (AIThing(TargetToFollow.Data) is AILivingThing) then
      AILivingThing(TargetToFollow.Data).Die;
  end;
end;

procedure Tfm3DEnvironment.tbHealClick(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    if (AIThing(TargetToFollow.Data) is AILivingThing) then
      AILivingThing(TargetToFollow.Data).Health :=
        AILivingThing(TargetToFollow.Data).Health + 256;
  end;
end;

procedure Tfm3DEnvironment.tbPerform0Click(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Perform(0);
  end;
end;

procedure Tfm3DEnvironment.tbPerform1Click(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Perform(1);
  end;
end;

procedure Tfm3DEnvironment.tbPerform2Click(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Perform(2);
  end;
end;

procedure Tfm3DEnvironment.tbPerform3Click(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Perform(3);
  end;
end;

procedure Tfm3DEnvironment.tbPerform4Click(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Perform(4);
  end;
end;

procedure Tfm3DEnvironment.tbPerform5Click(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Perform(5);
  end;
end;

procedure Tfm3DEnvironment.tbExtinctionClick(Sender: TObject);
var
  myKind: Integer;
begin
  if (TargetToFollow <> nil) then
  begin
    myKind := AIThing(TargetToFollow.Data).Kind;
    if (MessageDlg('Are you sure you want an extinction of ' +
      ThingNamePlural(myKind) + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)
    then
    begin
      LastAction('Extinction: ' + ThingNamePlural(myKind));
      gThings.Tables[myKind].KillEverything;
    end;
  end;
end;

procedure Tfm3DEnvironment.HideCursor;
begin
  RefreshCursor;
end;

procedure Tfm3DEnvironment.ShowCursor;
begin
  RefreshCursor;
end;

{
  procedure Tfm3DEnvironment.DisplayMouseObjectInfo;
  var
  myThing: AIThing;
  objPos, winPos : TAffineVector;
  myCrossover: TCrossover;
  myVisual: TGLBaseSceneObject;
  begin
  myVisual := GetPickedObject(Mouse_x, mouse_y);

  myThing := nil;
  myCrossover := Satellites.FindCrossoverByVisualOrSubVisual(myVisual);
  if myCrossover <> nil then
  myThing := myCrossover.Data;

  if myThing <> nil then
  begin
  GLObjectText.Text := myThing.OneLineDisplay;
  setvector(objpos, myVisual.absoluteposition);
  winpos := glsceneviewer.buffer.worldtoscreen(objpos);
  GLObjectText.position.x := winpos[0];
  GLObjectText.position.y := GLSceneViewer.Height-winpos[1] - 16;
  GLObjectText.Visible := true;
  end
  else
  GLObjectText.Visible := false;
  end;
}

procedure Tfm3DEnvironment.GLSceneViewerDblClick(Sender: TObject);
begin
  if Tool = tSelect then
    PopUpTargetWindow;
end;

procedure Tfm3DEnvironment.FormResize(Sender: TObject);
begin
  if Width > 850 then
  begin
    panMenus.Height := 90;
    panMainMenu.Height := 40;
    panCamera.Height := 28;
    Splitter3D.Top := 250;
  end
  else
  begin
    panMenus.Height := 90 + 60;
    panMainMenu.Height := 80;
    panCamera.Height := 28 + 28;
    Splitter3D.Top := 250;
  end;
  fmFirstForm.UserSettings.ViewSizeX := Width;
  fmFirstForm.UserSettings.ViewSizeY := Height;
  fmFirstForm.UserSettings.SaveToRegistry;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildAquaPlant(aAquaPlant: AIAquaPlant): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := AquaPlant;
    ProxyOptions := [pooObjects];
    Up := AquaPlant.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  myProxy.Scale.Scale(0.5);
  myProxy.RollAngle := Random(360);

  result := Satellites.NewCrossover;
  result.Data := aAquaPlant;
  result.SubVisuals.Add(myProxy);
  aAquaPlant.Crossover := result;
  UpdateAquaPlant(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateAquaPlant(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myAquaPlant: AIAquaPlant;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myAquaPlant := AIAquaPlant(aCrossover.Data);

  PositionThing(myAquaPlant.Position, myProxy, 0, 0.26);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.AutoSnap;
begin
  /// was...  if gReality.Time mod StrToInt(edAutoSnap.Text) = 0 then
  if gReality.Time = 0 then
  begin
    SkyDome.Visible := false;
    SetCurrentDir(ExtractFilePath(ParamStr(0)));
    GLSceneViewer.Buffer.RenderToFile('photos\snap' + IntToStr(gReality.Time) +
      '.bmp', GLSceneViewer.Buffer.Width div
      (GLSceneViewer.Buffer.Height div 64), 64);
    SkyDome.Visible := tbShowStars.Down;
  end;
end;

procedure Tfm3DEnvironment.tbGrabClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'GRAB';
end;

procedure Tfm3DEnvironment.tbDropClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'DROP';
end;

procedure Tfm3DEnvironment.tbKickClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'KICK';
end;

procedure Tfm3DEnvironment.tbThrowClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'THROW';
end;

procedure Tfm3DEnvironment.tbEatClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'EAT';
end;

procedure Tfm3DEnvironment.tbUse1Click(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'USE1';
end;

procedure Tfm3DEnvironment.tbBonkClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'BONK';
end;

procedure Tfm3DEnvironment.tbGiveClick(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'GIVE';
end;

procedure Tfm3DEnvironment.tbUse2Click(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'USE2';
end;

procedure Tfm3DEnvironment.tbUse3Click(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'USE3';
end;

procedure Tfm3DEnvironment.tbUse4Click(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'USE4';
end;

procedure Tfm3DEnvironment.tbUse5Click(Sender: TObject);
begin
  if ControllingBot then
    ControlBot.Activity := 'USE5';
end;

procedure Tfm3DEnvironment.GLSceneViewerMouseEnter(Sender: TObject);
begin
  GLSceneViewer.SetFocus;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildLadybug(aLadybug: AILadybug): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := LadyBugModel;
    ProxyOptions := [pooObjects];
    Up := LadyBugModel.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aLadybug;
  result.SubVisuals.Add(myProxy);
  aLadybug.Crossover := result;
  UpdateLadybug(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateLadybug(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myLadybug: AILadybug;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myLadybug := AILadybug(aCrossover.Data);

  factor := 0.005;
  Scale := LadyBugModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myLadybug.Position, myProxy, -HalfPi, -0.01);

  if myLadybug.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, Pi);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildAnt(aAnt: AIAnt): TCrossover;
var
  myProxy: TGLProxyObject;
begin
  myProxy := TGLProxyObject(ProxyCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := AntModel1;
    ProxyOptions := [pooObjects];
    Up := AntModel1.Up;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aAnt;
  result.SubVisuals.Add(myProxy);
  aAnt.Crossover := result;
  UpdateAnt(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateAnt(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myAnt: AIAnt;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myAnt := AIAnt(aCrossover.Data);

  factor := 0.05;
  Scale := AntModel1.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  if myAnt.Position.Binding = bindLand then
  begin
    aCrossover.Height := aCrossover.Height + 1;
    case aCrossover.Height of
      3:
        myProxy.MasterObject := AntModel1;
      6:
        myProxy.MasterObject := AntModel2;
      9:
        myProxy.MasterObject := AntModel1;
      12:
        begin
          myProxy.MasterObject := AntModel3;
          aCrossover.Height := 0;
        end;
    end;
  end;

  PositionThing(myAnt.Position, myProxy, -HalfPi);
end;

procedure Tfm3DEnvironment.tbLadybugClick(Sender: TObject);
begin
  Tool := tLadybug;
end;

procedure Tfm3DEnvironment.tbAntClick(Sender: TObject);
begin
  Tool := tAnt;
end;

procedure Tfm3DEnvironment.tbZoomInClick(Sender: TObject);
begin
  case CameraMode of
    camPlanet, camSatellite:
      begin
        ViewDestination.MoveHeight(-20);
        if ViewPosition.HeightAbove < 15 then
          CameraMode := camAvatar;
      end;
    camTarget:
      ViewOffset := ViewOffset - 20;
  end;
end;

procedure Tfm3DEnvironment.tbZoomOutClick(Sender: TObject);
begin
  case CameraMode of
    camPlanet, camSatellite:
      begin
        ViewDestination.MoveHeight(20);
      end;
    camTarget:
      ViewOffset := ViewOffset + 20;
    camAvatar:
      CameraMode := camPlanet;
  end;
end;

procedure Tfm3DEnvironment.tbBeaconAppleClick(Sender: TObject);
begin
  Tool := tBeaconApple;
end;

procedure Tfm3DEnvironment.StickyFit;
begin
  Align := alClient;
  WindowState := wsNormal;
  BorderIcons := BorderIcons - [biMaximize];
  tbStickyFit.Down := true;
end;

procedure Tfm3DEnvironment.UnStickyFit;
begin
  Align := alNone;
  BorderIcons := BorderIcons + [biMaximize];
  tbStickyFit.Down := false;
end;

procedure Tfm3DEnvironment.InformOfStart;
begin
  Tool := LastTool;
  ShowCursor;
  RefreshCursor;
end;

procedure Tfm3DEnvironment.InformOfStop;
begin
  HideCursor;
  RefreshCursor;
  if Tool <> tSelect then
    LastTool := Tool;
  Tool := tSelect;
end;

procedure Tfm3DEnvironment.EmptyAllSounds;
var
  i: Integer;
  mySpeaker: TGLDummyCube;
  mySound: TGLBSoundEmitter;
begin
  if not GLBass.Active then
    exit;

  for i := 0 to SoundSystem.Count - 1 do
  begin
    mySpeaker := TGLDummyCube(SoundSystem.Children[i]);

    mySound := GetOrCreateSoundEmitter(TGLBaseSceneObject(mySpeaker));
    mySound.Playing := false;
  end;

  Speakers.SetFirstActive;
end;

procedure Tfm3DEnvironment.tbEarthquakeClick(Sender: TObject);
var
  myEarthquake: AIEarthquake;
begin
  if gThings.Counters[cEarthquake] > 0 then
    myEarthquake := gThings.Tables[cEarthquake].FirstOfKind(cEarthquake)
  else
    myEarthquake := AIEarthquake(gThings.NewThing(cEarthquake));
  if Assigned(myEarthquake) then
  begin
    myEarthquake.Rumble := myEarthquake.Rumble + 2;
  end;
end;

procedure Tfm3DEnvironment.tbCameraLightClick(Sender: TObject);
begin
  CameraLight.Shining := tbCameraLight.Down;
end;

procedure Tfm3DEnvironment.CalculateTerrainSettings;
begin
  if SphereMode then
  begin
    PlanetModel.NormalsOrientation := mnoInvert;
    WaterBubble.NormalsOrientation := mnoInvert;
    PlanetModel.Up.SetVector(0, -1, 0);
    WaterBubble.Up.SetVector(0, -1, 0);
  end
  else
  begin
    PlanetModel.NormalsOrientation := mnoDefault;
    WaterBubble.NormalsOrientation := mnoDefault;
    PlanetModel.Up.SetVector(0, 1, 0);
    WaterBubble.Up.SetVector(0, 1, 0);
  end;
end;

// ----------------------------------------------------------------------------
// above-globe positioning
procedure Tfm3DEnvironment.PositionThing(aPosition: AIPosition;
  aThing: TGLBaseSceneObject);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
  myCosLat, myCosLong, mySinLong, mySinLat: single;
begin
  // flat
  { if not SphereMode then
    begin
    aThing.Position.X := aPosition.X;
    aThing.Position.Y := aPosition.Y;
    aThing.Position.Z := aPosition.Height/cFlatHeightDivision;
    aThing.Direction.SetVector(0,1,0);
    exit;
    end; }
  // spherical
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;
  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision;
  myCosLong := cos(myLongitude);
  myCosLat := cos(myLatitude);
  mySinLong := sin(myLongitude);
  mySinLat := sin(myLatitude);
  // set direction
  aThing.Direction.SetVector(myCosLat * myCosLong * -1, mySinLat * -1,
    myCosLat * mySinLong);
  // set rotation
  aThing.Position.X := -1 * myCosLat * myCosLong * (myHeightOffset);
  aThing.Position.Y := -1 * mySinLat * (myHeightOffset);
  aThing.Position.Z := myCosLat * mySinLong * (myHeightOffset);
end;

// ----------------------------------------------------------------------------
// above-globe positioning + factor
procedure Tfm3DEnvironment.PositionThing(aPosition: AIPosition;
  aThing: TGLBaseSceneObject; aAngle: single);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
  myCosLat, myCosLong, mySinLong, mySinLat: single;
begin
  // flat
  { if not SphereMode then
    begin
    aThing.Position.X := aPosition.X;
    aThing.Position.Y := aPosition.Y;
    aThing.Position.Z := aPosition.Height/cFlatHeightDivision;
    aThing.Direction.SetVector(0,1,0);
    aThing.Up.SetToZero;
    aThing.Up.Rotate(aThing.Direction.AsAffineVector, TwoPi-aPosition.DirectionXY+aAngle);
    exit;
    end; }
  // spherical
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;
  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision;
  myCosLong := cos(myLongitude);
  myCosLat := cos(myLatitude);
  mySinLong := sin(myLongitude);
  mySinLat := sin(myLatitude);
  // set direction
  aThing.Up.SetToZero;
  aThing.Direction.SetVector(myCosLat * myCosLong * -1, mySinLat * -1,
    myCosLat * mySinLong);
  // set rotation
  aThing.Position.X := -1 * myCosLat * myCosLong * (myHeightOffset);
  aThing.Position.Y := -1 * mySinLat * (myHeightOffset);
  aThing.Position.Z := myCosLat * mySinLong * (myHeightOffset);
  aThing.Up.Rotate(aThing.Direction.AsAffineVector, aPosition.DirectionXY
    + aAngle);
end;

// ----------------------------------------------------------------------------
// above-globe positioning + factor
procedure Tfm3DEnvironment.PositionThing(aPosition: AIPosition;
  aThing: TGLBaseSceneObject; aAngle: single; aFactor: single);
var
  myLongitude: single;
  myLatitude: single;
  myHeightOffset: single;
  myCosLat, myCosLong, mySinLong, mySinLat: single;
begin
  // flat
  { if not SphereMode then
    begin
    aThing.Position.X := aPosition.X;
    aThing.Position.Y := aPosition.Y;
    aThing.Position.Z := aPosition.Height/cFlatHeightDivision+aFactor;
    aThing.Direction.SetVector(0,1,0);
    aThing.Up.SetToZero;
    aThing.Up.Rotate(aThing.Direction.AsAffineVector, TwoPi-aPosition.DirectionXY+aAngle);
    exit;
    end; }
  // spherical
  myLongitude := aPosition.X / 10 * WidthAngle;
  myLatitude := aPosition.Y / 10 * HeightAngle - cHalfPi;
  myHeightOffset := PlanetRadius + aPosition.Height / cHeightDivision + aFactor;
  myCosLong := cos(myLongitude);
  myCosLat := cos(myLatitude);
  mySinLong := sin(myLongitude);
  mySinLat := sin(myLatitude);
  // set direction
  aThing.Up.SetToZero;
  aThing.Direction.SetVector(myCosLat * myCosLong * -1, mySinLat * -1,
    myCosLat * mySinLong);
  // set rotation
  aThing.Position.X := -1 * myCosLat * myCosLong * (myHeightOffset);
  aThing.Position.Y := -1 * mySinLat * (myHeightOffset);
  aThing.Position.Z := myCosLat * mySinLong * (myHeightOffset);
  aThing.Up.Rotate(aThing.Direction.AsAffineVector, aPosition.DirectionXY
    + aAngle);
end;

procedure Tfm3DEnvironment.tbFloatCameraClick(Sender: TObject);
begin
  CameraMode := camFree;
end;

procedure Tfm3DEnvironment.GLSceneViewerMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure Tfm3DEnvironment.RestoreScene;
begin
  OrangeTreeModel.StructureChanged;
  OrangeTreeModel.Material.Texture.Disabled := true;
  OrangeTreeModel.Material.Texture.Disabled := false;
end;

procedure Tfm3DEnvironment.tbTrackLadybugClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cLadybug) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbTrackAntClick(Sender: TObject);
begin
  if Satellites.SetCrossoverByKind(cAnt) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.CheckToolRepeat;
begin
  if not tbRepeat.Down then
    ToolIsActive := false;
end;

procedure Tfm3DEnvironment.BreakLimits(aKind: Integer);
begin
  if not gThings.CanAdd(aKind) then
    gThings.Maximums[aKind] := gThings.Maximums[aKind] + 1;
end;

// =========================EVOLUTION TREES====================
// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildEvolvingTree(aTree: AIEvolvingTree): TCrossover;
var
  myProxy: TGLColorProxy;
begin
  myProxy := TGLColorProxy(ForestCube.AddNewChild(TGLColorProxy));
  with myProxy do
  begin
    MasterObject := EvolvingTree;
    ProxyOptions := [pooObjects];
    Up := EvolvingTree.Up;
    RollAngle := Random(360);

    FrontColor.Diffuse.Red := aTree.DNA.Red;
    FrontColor.Diffuse.Blue := aTree.DNA.Blue;
    FrontColor.Diffuse.Green := aTree.DNA.Green;
    FrontColor.Emission.Red := aTree.DNA.Red / 2;
    FrontColor.Emission.Blue := aTree.DNA.Blue / 2;
    FrontColor.Emission.Green := aTree.DNA.Green / 2;
    FrontColor.Ambient.Red := aTree.DNA.Red / 4;
    FrontColor.Ambient.Blue := aTree.DNA.Blue / 4;
    FrontColor.Ambient.Green := aTree.DNA.Green / 4;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aTree;
  result.SubVisuals.Add(myProxy);
  aTree.Crossover := result;
  UpdateEvolvingTree(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildEvolvingFruit(aFruit: AIEvolvingFruit)
  : TCrossover;
var
  myProxy: TGLColorProxy;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLColorProxy(FruitCube.AddNewChild(TGLColorProxy));
  with myProxy do
  begin
    MasterObject := EvolvingFruit;
    ProxyOptions := [pooObjects];

    Up := EvolvingFruit.Up;
    myFactor := 0.04;
    myScale := AppleModel.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
    RollAngle := Random(360);

    FrontColor.Diffuse.Red := aFruit.DNA.Red;
    FrontColor.Diffuse.Blue := aFruit.DNA.Blue;
    FrontColor.Diffuse.Green := aFruit.DNA.Green;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aFruit;
  result.SubVisuals.Add(myProxy);
  aFruit.Crossover := result;
  UpdateEvolvingFruit(result);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildEvolvingSeed(aSeed: AIEvolvingSeed): TCrossover;
var
  myProxy: TGLColorProxy;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLColorProxy(SeedCube.AddNewChild(TGLColorProxy));
  with myProxy do
  begin
    MasterObject := EvolvingSeed;
    ProxyOptions := [pooObjects];

    Up := SeedModel.Up;

    myFactor := 0.05;
    myScale := EvolvingSeed.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;

    RollAngle := Random(360);
    PitchAngle := Random(360);

    FrontColor.Diffuse.Red := aSeed.DNA.Red;
    FrontColor.Diffuse.Blue := aSeed.DNA.Blue;
    FrontColor.Diffuse.Green := aSeed.DNA.Green;
    FrontColor.Emission.Red := aSeed.DNA.Red / 10;
    FrontColor.Emission.Blue := aSeed.DNA.Blue / 10;
    FrontColor.Emission.Green := aSeed.DNA.Green / 10;
    FrontColor.Ambient.Red := aSeed.DNA.Red / 10;
    FrontColor.Ambient.Blue := aSeed.DNA.Blue / 10;
    FrontColor.Ambient.Green := aSeed.DNA.Green / 10;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aSeed;
  result.SubVisuals.Add(myProxy);
  aSeed.Crossover := result;
  UpdateEvolvingSeed(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateEvolvingTree(aCrossover: TCrossover);
var
  myProxy: TGLColorProxy;
  myTree: AIEvolvingTree;
  Scale: TGLVector;
  factor: single;
begin
  myProxy := TGLColorProxy(aCrossover.SubVisuals.Items[0]);
  myTree := AIEvolvingTree(aCrossover.Data);

  factor := myTree.Water + 0.1;
  Scale := AppleTreeModel.Scale.AsVector;
  ScaleVector(Scale, factor);
  myProxy.Scale.AsVector := Scale;

  PositionThing(myTree.Position, myProxy, 0, factor / 4);

  if myTree.Dead then
    myProxy.Direction.Rotate(myProxy.Up.AsAffineVector, QuarterPi);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateEvolvingFruit(aCrossover: TCrossover);
var
  myProxy: TGLColorProxy;
  myFruit: AIEvolvingFruit;
begin
  myProxy := TGLColorProxy(aCrossover.SubVisuals.Items[0]);
  myFruit := AIEvolvingFruit(aCrossover.Data);

  PositionThing(myFruit.Position, myProxy);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateEvolvingSeed(aCrossover: TCrossover);
var
  myProxy: TGLColorProxy;
  mySeed: AIEvolvingSeed;
begin
  myProxy := TGLColorProxy(aCrossover.SubVisuals.Items[0]);
  mySeed := AIEvolvingSeed(aCrossover.Data);

  PositionThing(mySeed.Position, myProxy);
end;

procedure Tfm3DEnvironment.tbEvolvingTreeClick(Sender: TObject);
begin
  Tool := tEvolvingTree;
end;

procedure Tfm3DEnvironment.tbEvolvingFruitClick(Sender: TObject);
begin
  Tool := tEvolvingFruit;
end;

procedure Tfm3DEnvironment.tbEvolvingSeedClick(Sender: TObject);
begin
  Tool := tEvolvingSeed;
end;

procedure Tfm3DEnvironment.tbJumpClick(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    AIThing(TargetToFollow.Data).Position.Velocity.AlterDeltaHeight(0.5);
  end;
end;

procedure Tfm3DEnvironment.tbMoveClick(Sender: TObject);
begin
  LastAction('Tool=Move');
  Tool := tMove;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.FullDisplay(aLines: TStrings);
begin
  aLines.Add('ViewPosition');
  aLines.Add('------------------------');
  ViewPosition.FullDisplay(aLines);
  aLines.Add('ViewDestination');
  aLines.Add('------------------------');
  ViewDestination.FullDisplay(aLines);
  aLines.Add('ViewTarget');
  aLines.Add('------------------------');
  ViewTarget.FullDisplay(aLines);
  aLines.Add('ViewTrackingSpeed: ' + Format('%0.2f', [ViewTrackingSpeed]));
  aLines.Add('ViewZoom: ' + Format('%0.2f', [fViewZoom]));
  aLines.Add('ViewOffset: ' + Format('%0.2f', [fViewOffset]));
  aLines.Add('ViewAdjust: ' + Format('%0.2f', [ViewAdjust]));
end;

procedure Tfm3DEnvironment.tbVolumesClick(Sender: TObject);
begin
  with GLShadowVolume do
    if tbVolumes.Down then
    begin
      fmFirstForm.Construction.AddEvent('Turned shadow volumes on.');
      Options := Options + [svoShowVolumes];
    end
    else
    begin
      fmFirstForm.Construction.AddEvent('Turned shadow volumes off.');
      Options := Options - [svoShowVolumes];
    end;
end;

procedure Tfm3DEnvironment.SetShadowMode(aMode: Boolean);
begin
  if not aMode then
  begin
    fmFirstForm.Construction.AddEvent('Turned shadows off.');
    GLShadowVolume.Mode := svmOff;
  end
  else
  begin
    fmFirstForm.Construction.AddEvent('Turned shadows on.');
    GLShadowVolume.Mode := svmDarkening;
  end;
  tbShadows.Down := Environment.Shadows;
end;

procedure Tfm3DEnvironment.tbComplexifyClick(Sender: TObject);
begin
  if tbComplexify.Down then
  begin
    fmFirstForm.Construction.AddEvent('Turned multicast shadows on.');
    ForestCube.MoveTo(GLShadowVolume);
    FruitCube.MoveTo(GLShadowVolume);
    ProxyCube.MoveTo(GLShadowVolume);
    CloudCube.MoveTo(GLShadowVolume);
  end
  else
  begin
    fmFirstForm.Construction.AddEvent('Turned multicast shadows off.');
    ForestCube.MoveTo(GalaxyCube);
    FruitCube.MoveTo(GalaxyCube);
    ProxyCube.MoveTo(GalaxyCube);
    CloudCube.MoveTo(GalaxyCube);
  end;
end;

procedure Tfm3DEnvironment.tbVolumeChange(Sender: TObject);
begin
  SoundVolume := tbVolume.Position / 10.0;
  GLSceneViewer.SetFocus;
end;

procedure Tfm3DEnvironment.tbPopBeaconClick(Sender: TObject);
begin
  Tool := tBeaconAny;
  GLSceneViewer.SetFocus;
end;

procedure Tfm3DEnvironment.tbAudioMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbAudio.Align := alClient;
  tbAudio.Visible := true;
end;

procedure Tfm3DEnvironment.StatusBarClick(Sender: TObject);
begin
  fmFirstForm.RealityForm.BringToFront;
  fmFirstForm.RealityForm.ManagerForm.BringToFront;
  BringToFront;
end;

procedure Tfm3DEnvironment.tbRestoreParentClick(Sender: TObject);
begin
  fmFirstForm.RealityForm.BringToFront;
  fmFirstForm.RealityForm.ManagerForm.BringToFront;
  BringToFront;
end;

procedure Tfm3DEnvironment.cboxThingsChange(Sender: TObject);
begin
  GLSceneViewer.SetFocus;
end;

procedure Tfm3DEnvironment.tbHighDetailClick(Sender: TObject);
begin
  if tbHighDetail.Down then
  begin
    // high res models
    LoadModel(AppleModel, 'models\fruit2.3ds');
    LoadModel(OrangeModel, 'models\fruit2.3ds');
    LoadModel(EvolvingFruit, 'models\fruit2.3ds');
  end
  else
  begin
    // low res models
    LoadModel(AppleModel, 'models\fruit.3ds');
    LoadModel(OrangeModel, 'models\fruit.3ds');
    LoadModel(EvolvingFruit, 'models\fruit.3ds');
  end;
end;

procedure Tfm3DEnvironment.tbAVIMovieClick(Sender: TObject);
begin
  LastAction('AVI-Start');
  BorderStyle := bsSingle;
  tbStickyFit.Enabled := false;
  tbFullscreen.Enabled := false;
  AVIRecorder.Height := GLSceneViewer.Height;
  AVIRecorder.Width := GLSceneViewer.Width;
  AVIRecorder.CreateAVIFile();
  tbAVIMovie.Visible := false;
  tbAVIDirect.Down := true;
  tbAVIDirect.Visible := true;
  tbAVIFrame.Visible := true;
end;

procedure Tfm3DEnvironment.LastAction(aAction: string);
begin
  LastActivity := aAction;
  LastTime := gReality.Time;
end;

procedure Tfm3DEnvironment.cbAutoSnapClick(Sender: TObject);
begin
  LastAction('Autosnap');
end;

procedure Tfm3DEnvironment.tbMouseViewClick(Sender: TObject);
begin
  LastAction('MouseView');
  if not tbMouseView.Down then
    GLObjectText.Visible := false;
end;

procedure Tfm3DEnvironment.tbPlantClearerClick(Sender: TObject);
begin
  Tool := tPlantClearer;
end;

procedure Tfm3DEnvironment.tbFireTreeClick(Sender: TObject);
begin
  Tool := tFireTree;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildFireTree(aFireTree: AIFireTree): TCrossover;
var
  myProxy: TGLColorProxy;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLColorProxy(ForestCube.AddNewChild(TGLColorProxy));
  with myProxy do
  begin
    MasterObject := FireTree;
    ProxyOptions := [pooObjects];
    Up := FireTree.Up;
    myFactor := 0.05;
    myScale := FireTree.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
    FrontColor.Assign(FireTree.Material.FrontProperties);
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aFireTree;
  result.SubVisuals.Add(myProxy);
  aFireTree.Crossover := result;
  UpdateFireTree(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateFireTree(aCrossover: TCrossover);
var
  myProxy: TGLColorProxy;
  myFireTree: AIFireTree;
begin
  myProxy := TGLColorProxy(aCrossover.SubVisuals.Items[0]);
  myFireTree := AIFireTree(aCrossover.Data);

  myProxy.FrontColor.Diffuse.Red := myFireTree.Fire / cBurnDown;
  myProxy.FrontColor.Ambient.Red := myFireTree.Fire / cBurnDown;
  // myProxy.FrontColor.Emission.Red := myFireTree.Fire / cBurnDown;

  PositionThing(myFireTree.Position, myProxy, 0, -0.15);
end;

procedure Tfm3DEnvironment.tbLightningClick(Sender: TObject);
begin
  Tool := tLightning;
end;

procedure Tfm3DEnvironment.tbCreatureDeathClick(Sender: TObject);
begin
  Tool := tLifeKiller;
end;

procedure Tfm3DEnvironment.tbThingCeaserClick(Sender: TObject);
begin
  Tool := tThingCeaser;
end;

procedure Tfm3DEnvironment.tbRainCloudClick(Sender: TObject);
begin
  Tool := tRainCloud;
end;

procedure Tfm3DEnvironment.tbCameraEyesClick(Sender: TObject);
begin
  if (TargetToFollow = nil) then
  begin
    if Satellites.SetNextOrFirstActive then
      TargetToFollow := TCrossover(Satellites.ActiveItem);
  end;

  if CameraMode = camEyes then
    if Satellites.SetPriorOrLastActive then
      TargetToFollow := Satellites.ActiveItem
    else
      TargetToFollow := nil;

  if (TargetToFollow <> nil) then
  begin
    CameraMode := camEyes;
  end
  else
  // couldnt find a target, switch to planet mode
  begin
    tbCameraPlanet.Down := true;
    CameraMode := camPlanet;
  end;
end;

procedure Tfm3DEnvironment.tbHarmClick(Sender: TObject);
begin
  if TargetToFollow <> nil then
  begin
    if (AIThing(TargetToFollow.Data) is AILivingThing) then
      AILivingThing(TargetToFollow.Data).Health :=
        AILivingThing(TargetToFollow.Data).Health - 256;
  end;
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildSpeech(aSpeech: AISpeech): TCrossover;
var
  myHUDText: TGLHUDText;
begin
  myHUDText := TGLHUDText(HUDCube.AddNewChild(TGLHUDText));
  with myHUDText do
  begin
    Text := aSpeech.Text;
    BitmapFont := GLWindowsBitmapFont1;
    Visible := true;
  end;

  result := fSpeeches.NewCrossover;
  result.Data := aSpeech;
  result.SubVisuals.Add(myHUDText);
  aSpeech.Crossover := result;
  UpdateSpeech(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateSpeech(aCrossover: TCrossover);
var
  myHUDText: TGLHUDText;
  mySpeech: AISpeech;
  objpos, winpos: TAffineVector;
begin
  myHUDText := TGLHUDText(aCrossover.SubVisuals.Items[0]);
  mySpeech := AISpeech(aCrossover.Data);
  PositionThing(mySpeech.Position, myHUDText);
  SetVector(objpos, myHUDText.AbsolutePosition);
  winpos := GLSceneViewer.Buffer.worldtoscreen(objpos);
  myHUDText.Position.X := winpos.X;
  myHUDText.Position.Y := GLSceneViewer.Height - winpos.Y - 16 +
    mySpeech.Age div 2;
  myHUDText.Position.Z := 0;
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.RefreshSpeeches;
var
  i: Integer;
  myCrossover: TCrossover;
begin
  for i := 0 to fSpeeches.Count - 1 do
  begin
    myCrossover := TCrossover(fSpeeches.Items[i]);
    UpdateSpeech(myCrossover);
  end;
end;

procedure Tfm3DEnvironment.tbReportAllClick(Sender: TObject);
begin
  Environment.Things.Tangibles.ReportAllCreatures;
end;

procedure Tfm3DEnvironment.tbReportClick(Sender: TObject);
begin
  if TargetToFollow <> nil then
    AIThing(TargetToFollow.Data).Report;
end;

procedure Tfm3DEnvironment.tbSpeechesClick(Sender: TObject);
begin
  HUDCube.Visible := tbSpeeches.Down;
end;

procedure Tfm3DEnvironment.tbShowFireClick(Sender: TObject);
begin
  if tbShowFire.Down then
    fmFirstForm.Construction.AddEvent('Disabled fireFX.')
  else
    fmFirstForm.Construction.AddEvent('Enabled fireFX.');
  tbShowFire.Enabled := false;
end;

procedure Tfm3DEnvironment.tbAVIFrameClick(Sender: TObject);
begin
  AVIRecorder.AddAVIFrame;
end;

procedure Tfm3DEnvironment.tbMissileDefenceClick(Sender: TObject);
begin
  tbRepeat.Down := false;
  Tool := tMissileDefence;
end;

procedure Tfm3DEnvironment.tbDisastersMenuClick(Sender: TObject);
begin
  AllToolBarsInvisible;
  tbDisasters.Align := alClient;
  tbDisasters.Visible := true;
  if tbLightning.Down then
    Tool := tLightning;
  if tbPlantRemover.Down then
    Tool := tPlantClearer;
  if tbLifeKiller.Down then
    Tool := tLifeKiller;
  if tbThingCeaser.Down then
    Tool := tThingCeaser;
  ShowCursor;
end;

procedure Tfm3DEnvironment.tbLifeKillerClick(Sender: TObject);
begin
  Tool := tLifeKiller;
end;

procedure Tfm3DEnvironment.tbPlantRemoverClick(Sender: TObject);
begin
  Tool := tPlantClearer;
end;

procedure Tfm3DEnvironment.tbBotSelectClick(Sender: TObject);
begin
  LastAction('Tool=Select');
  tbSelect.Down := true;
  Tool := tSelect;
  HideCursor;
end;

procedure Tfm3DEnvironment.tbShadowsClick(Sender: TObject);
begin
  Environment.Shadows := tbShadows.Down;
  SetShadowMode(Environment.Shadows);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildMissileDefence(aMissileDefence: AIMissileDefence)
  : TCrossover;
var
  myProxy: TGLColorProxy;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLColorProxy(SatellitesCube.AddNewChild(TGLColorProxy));
  with myProxy do
  begin
    MasterObject := MissileDefence;
    ProxyOptions := [pooObjects];
    Up := MissileDefence.Up;
    myFactor := 0.3;
    myScale := MissileDefence.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
    FrontColor.Assign(MissileDefence.Material.FrontProperties);
  end;
  GLShadowVolume.Occluders.AddCaster(myProxy);
  result := Satellites.NewCrossover;
  result.Data := aMissileDefence;
  result.SubVisuals.Add(myProxy);
  aMissileDefence.Crossover := result;
  UpdateMissileDefence(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateMissileDefence(aCrossover: TCrossover);
var
  myProxy: TGLColorProxy;
  myMissileDefence: AIMissileDefence;
begin
  myProxy := TGLColorProxy(aCrossover.SubVisuals.Items[0]);
  myMissileDefence := AIMissileDefence(aCrossover.Data);

  myProxy.FrontColor.Diffuse.Red := myMissileDefence.Priority;
  myProxy.FrontColor.Diffuse.Blue := myMissileDefence.Priority;
  myProxy.FrontColor.Ambient.Red := myMissileDefence.Priority;
  myProxy.FrontColor.Emission.Red := myMissileDefence.Priority / 2;

  PositionThing(myMissileDefence.Position, myProxy, 0);
end;

// ----------------------------------------------------------------------------
function Tfm3DEnvironment.BuildMissile(aMissile: AIMissile): TCrossover;
var
  myProxy: TGLProxyObject;
  myScale: TGLVector;
  myFactor: single;
begin
  myProxy := TGLProxyObject(SatellitesCube.AddNewChild(TGLProxyObject));
  with myProxy do
  begin
    MasterObject := Missile;
    ProxyOptions := [pooObjects];
    Up := Missile.Up;
    myFactor := 0.2;
    myScale := Missile.Scale.AsVector;
    ScaleVector(myScale, myFactor);
    Scale.AsVector := myScale;
  end;

  GLShadowVolume.Occluders.AddCaster(myProxy);

  result := Satellites.NewCrossover;
  result.Data := aMissile;
  result.SubVisuals.Add(myProxy);
  aMissile.Crossover := result;
  UpdateMissile(result);
end;

// ----------------------------------------------------------------------------
procedure Tfm3DEnvironment.UpdateMissile(aCrossover: TCrossover);
var
  myProxy: TGLProxyObject;
  myMissile: AIMissile;
begin
  myProxy := TGLProxyObject(aCrossover.SubVisuals.Items[0]);
  myMissile := AIMissile(aCrossover.Data);

  PositionThing(myMissile.Position, myProxy, 0, -0.15);
end;

procedure Tfm3DEnvironment.tbNextKindClick(Sender: TObject);
begin
  if TargetToFollow = nil then
    exit;

  if Satellites.SetCrossoverByKind(AIThing(TargetToFollow.Data).Kind) then
  begin
    TargetToFollow := Satellites.ActiveItem;
    SetCameraByTarget;
  end;
end;

procedure Tfm3DEnvironment.tbRestore2Click(Sender: TObject);
begin
  fmFirstForm.RealityForm.BringToFront;
  fmFirstForm.RealityForm.ManagerForm.BringToFront;
  BringToFront;
end;

end.
