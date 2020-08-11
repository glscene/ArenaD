unit FABCreator;

// Need to Mix the data requirements from "Earth Demo" and  "Planet Frenzy" Demo

{ "Planet Frenzy" Demo. http://jdelauney.free.fr/glscene/planetfrenzy
 Version : PRE-ALPHA 0.1

  An idea of Alexandre Hirzel
  Purpose: Shows GLScene users and developers around the world!
  Eric Grange (chief GLScene maintainer) is a 'type 0' so is displayed in a
  different colour!
  Credits :
    Aaron Hochwimmer :  Asteroid Maker
    Blaise Bernier :  SystemSolar class, SunBurst's Trick
    StuartGooding   TDOT3BumpShader
    Eric Grange :
     The atmospheric effect is rendered in GLDirectOpenGL1Render, which essentially
     renders a disk, with color of the vertices computed via ray-tracing. Not that
     the tesselation of the disk has been hand-optimized so as to reduce CPU use
     while retaining quality. On anything >1 GHz, the rendering is fill-rate
     limited on a GeForce 4 Ti 4200.   
     Stars support is built into the TGLSkyDome, but constellations are rendered
     via a TGLLines, which is filled in the LoadConstellationLines method.   
     http://glscene.org

 TO DO :
    - Create Atmosphere per planet data
     --Bump Mapping to increase Texture 'Depth'
     ..Change "Clouds" per Object Velocity
     ...Layers of Clouds rotate counter each other..or faster..or Turbulent 'spots'
    - Display Document per DocIndex..
     .. dunno what that is, except just a link to launch a .html or .txt page
    - Add Legend for space entities and constellations (THudText)
    - Calculate Orbits (with TGLMovementPath and TGLLine)
     ..Orbit Elements: USolarSystem
    -+-TGLLine : Display 'connecting lines' as they rotate
    - Add More user interactive facts like :
        * you point and click on a planet, draw a TGLArrow, point and click on
          target planet you see real Distance.
    - Add Credits Part (like in DemoScene)
    - Add "Messiers" Objects
    - Add "Milkyway"
    - Add Space Shuttle .. Artificial Satelites: DIY with 3ds
    - Add Mission Simulation (Lambert's Maths)..DWS .. Eris' Reaver
}

(*
Object: MaterialLibrary: M1
         |_LibMatName :MultiPassMat

TexCombineShader : ?  Tex0-> dot3 tex0 Texture Combiner

MultiMaterialShader
         |_MaterialLibrary : M2
(Makes a Pass for EVERY material in its ASSIGNED MatLib (M2))

MaterialLibrary : M2 : None
... M2.Add

MaterialLibrary : M1
         |_MultiPassMat
             |_Shader: MultiMaterialShader
... M1.Add Specular
             |_Tex2: Spec2
*)
{-----------------------------------------------------------------------------
 Unit Name: GLSpaceEntities
 Author: J.Delauney
 Purpose: Custom "Space" GLObject for better integrating with GLScene
           - Multiple planets, Moons,... with their individual properties
           - One Space object per orbit, unlimited orbit per Planet & for Sun
 History:  "Main Idea From Blaise Bernier"
-----------------------------------------------------------------------------}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.Imaging.PNGimage,
  // bmp is internal.. nothing needed

  USolarSystem, //Eric: TOrbitalElementsData
    {USolarSystem.pas,  Orbit Elements for Rotation}

  GLS.VectorTypes,
  GLS.PersistentClasses,
  GLS.Scene,
  GLS.VectorGeometry, GLS.Objects, GLS.VectorFileObjects, GLS.GeomObjects,
  GLS.Texture, GLS.Cadencer,  GLS.File3DS,GLS.SceneViewer, GLS.LensFlare, GLS.Particles,

  ///UFireFxBase,// MRQZZZ 5/5/2003
  ///UGLImposter,
  GLS.BitmapFont, GLS.WindowsFont, GLS.Coordinates, GLS.BaseClasses,
  GLS.Material, GLS.Imposter, GLS.Color, GLS.FileTGA;

  //GLS.HUDObjects;
  //TGLHUDSprite = class (TGLSprite)
  //TGLSprite = class (TGLSceneObject)

Type
  TVersionData = record
      MajorVersion  : byte;
      MinorVersion  : byte;
      Author   : String[26]; //Ivan Lee Herring, 04Jul2004
    end;
  TSystemData = record
      NbSun      : byte;     //ONLY 1 allowed so far
      NbPlanet   : byte;
      NbAsteroid : Byte;
      NbComet    : Byte;
      NbDebris   : Byte;
    end;

   TSunData = record   // Also Equal to material texture
     {NOT 8.3 NAME only ..ONLY .jpg Expected: .bmp  .tif  .tga .png ignored}
      SunName          : String[255] ;
      Radius           : Double;
      ObjectRotation   : Double;
      AxisTilt         : Double;
      nbS3ds           : Byte;
      DocIndex         : Byte;
      SystemObjectScale      : Double; // Sun ONLY
      SystemDistanceScale    : Double; // Sun ONLY
    end;

   TPlanetData = record
      Name             : String[255]; {Planet.jpg .. Planet_Bump.jpg}
      Radius           : Double;
      ObjectRotation   : Double;
      AxisTilt         : Double;
      nbRings          : Byte;
      nbMoons          : Byte;
      nbS3ds           : Byte;
      DocIndex         : Byte;
      Albedo,  OrbitRotation      : Double;
      aDistance,aDistanceVar      : Double; //aConstEdit aVarEdit
      Inclination,InclinationVar  : Double; //iConstEdit iVarEdit
      Eccentricity , EVar, EMax   : Double; //eConstEdit eVarEdit EMaxEdit
      nLongitude, nLongitudeVar   : Double; //NConstEdit NVarEdit
      wPerihelion,wPerihelionVar  : Double; //wConstEdit wVarEdit
      mAnomaly, mAnomalyVar       : Double; //MConstEdit MVarEdit
      Mass, Density            : Double;
      Atmosphere, VelocityType : Byte;
      Velocity, VelocityDir    : Double;
      (*
       Which way does the wind blow Given a direction .. From or To that direction
       0 to 100 or 1 to 100 is that 100 or 101
      *)
    end;
   TMoonRingData = record //3ds files and DebrisAsteroid  too
      Name            : String[255];{Planet_Moon.jpg}
      Radius          : Double;
      ObjectRotation  : Double;
      AxisTilt        : Double;
      S3dsTex         :Boolean;
      DocIndex        : Byte;
      RCDType,RCDCount:Integer;
      RCDXYSize, RCDZSize, RCDPosition : Double;

      Albedo,  OrbitRotation      : Double;
      aDistance,aDistanceVar      : Double;
      Inclination,InclinationVar  : Double;
      Eccentricity , EVar, EMax   : Double;
      nLongitude, nLongitudeVar   : Double;
      wPerihelion,wPerihelionVar  : Double;
      mAnomaly, mAnomalyVar       : Double;

      Mass, Density  : Double;
      Atmosphere, VelocityType : Byte;
      Velocity, VelocityDir     : Double;
    end;

   TACDData = record   //Asteroid Comet Debris sphere..NOT DebrisAsteroid
      Name          : String[255];
      Radius          : Double;
      ObjectRotation    : Double;
      AxisTilt        : Double;
      nbS3ds             : Byte;
      DocIndex          : Byte;
      
      RCDType,RCDCount  :Integer;
      RCDXYSize, RCDZSize, RCDPosition : Double;

      Albedo,  OrbitRotation      : Double;
      aDistance,aDistanceVar      : Double;
      Inclination,InclinationVar  : Double;
      Eccentricity , EVar, EMax   : Double;
      nLongitude, nLongitudeVar   : Double;
      wPerihelion,wPerihelionVar  : Double;
      mAnomaly, mAnomalyVar       : Double;

      Mass, Density  : Double;
      Atmosphere, VelocityType : Byte;
      Velocity, VelocityDir     : Double;
    end;



  TGLSun=Class(TGLSphere)
   Private
    FExtraData : TSunData;
   public
    property ExtraData : TSunData read FExtraData write FExtraData;
  end;

  TGLPlanet=Class(TGLSphere)
   Private
    FExtraData : TPlanetData;
   public
    property ExtraData : TPlanetData read FExtraData write FExtraData;
  end;

  TGLMoon=Class(TGLSphere)
   Private
    FExtraData : TMoonRingData;
   public
    property ExtraData : TMoonRingData read FExtraData write FExtraData;
  end;

  TGLRing=Class(TGLDisk)
   Private
    FExtraData : TMoonRingData;
   public
    property ExtraData : TMoonRingData read FExtraData write FExtraData;
  end;
  TGLRingSphere=Class(TGLSphere)
   Private
    FExtraData : TMoonRingData;
   public
    property ExtraData : TMoonRingData read FExtraData write FExtraData;
  end;
  TGLRingFreeForm=Class(TGLFreeForm)
   Private
    FExtraData : TMoonRingData;
   public
    property ExtraData : TMoonRingData read FExtraData write FExtraData;
  end;
  TGLS3ds=Class(TGLFreeForm)
   Private
    FExtraData : TMoonRingData;
   public
    property ExtraData : TMoonRingData read FExtraData write FExtraData;
  end;

  TGLAsteroid=Class(TGLSphere)
   Private
    FExtraData : TACDData;
   public
    property ExtraData : TACDData read FExtraData write FExtraData;
  end;

  TGLComet=Class(TGLSphere)
   Private
    FExtraData : TACDData;
   public
    property ExtraData : TACDData read FExtraData write FExtraData;
  end;

    TGLDebris=Class(TGLSphere)
   Private
    FExtraData : TACDData;
   public
    property ExtraData : TACDData read FExtraData write FExtraData;
  end;
  TGLDebrisFreeForm=Class(TGLFreeForm)
   Private
    FExtraData : TMoonRingData;
   public
    property ExtraData : TMoonRingData read FExtraData write FExtraData;
  end;

type
  TABCreatorFrm = class(TForm)
    GLSceneViewerA: TGLSceneViewer;
    GLCadencerA: TGLCadencer;
    GLMaterialLibraryA: TGLMaterialLibrary;
    GLSceneA: TGLScene;
    DCSolarSystem: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    SunShineFlare: TGLLensFlare;
    GLCamera: TGLCamera;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    TimerA: TTimer;
    PopupMenuA: TPopupMenu;
    DisplayToolbar1: TMenuItem;
    FullScreen1: TMenuItem;
    Exit1: TMenuItem;
    DisplayFPS1: TMenuItem;
    TextureLoading1: TMenuItem;
    MoonsLoadFakeTexture: TMenuItem;
    PlanetsLoadFakeTexture: TMenuItem;
    AsteroidsLoadFakeTexture: TMenuItem;
    S3dsLoadFakeTexture: TMenuItem;
    MoonScaling1: TMenuItem;
    MoonScalex10: TMenuItem;
    MoonScalex0: TMenuItem;
    MoonScalex50: TMenuItem;
    CometSprite: TGLSprite;
    CometGLMaterialLibrary: TGLMaterialLibrary;
    DCComet: TGLDummyCube;
    DebrisLoadFakeTexture: TMenuItem;
    RingsLoadFakeTexture: TMenuItem;
    CometsLoadFakeTexture: TMenuItem;
    SpudVersionConvertor1: TMenuItem;
    DCLabels: TGLDummyCube;
    DCOrbitTrails: TGLDummyCube;
    WindowsBitmapFontA: TGLWindowsBitmapFont;
    FontDialogA: TFontDialog;
    SelectFontMenu: TMenuItem;
    OrbitLines: TGLLines;
    GLFlatTextLabel: TGLFlatText;
    SolarDataPanel: TPanel;
    ToolBarGB: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    CameraDistanceLabel: TLabel;
    Label22: TLabel;
    TimeLabel: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Label19: TLabel;
    S3dsScalerLabel: TLabel;
    SunShineLabel: TLabel;
    CFLLabel: TLabel;
    S3dsScalerScaleLabel: TLabel;
    HourLabel: TLabel;
    LabelLabel: TLabel;
    SunRG: TRadioGroup;
    CometRG: TRadioGroup;
    DebrisRG: TRadioGroup;
    AsteroidRG: TRadioGroup;
    OrbitGroupBox: TGroupBox;
    OrbitRotationEdit: TEdit;
    iConstEdit: TEdit;
    aConstEdit: TEdit;
    eConstEdit: TEdit;
    eVarEdit: TEdit;
    EMaxEdit: TEdit;
    GroupBox6: TGroupBox;
    MoonsLabel: TLabel;
    RingsLabel: TLabel;
    Label4: TLabel;
    Label16: TLabel;
    Label14: TLabel;
    Label10: TLabel;
    Label17: TLabel;
    nbS3dLabel: TLabel;
    RadiusEdit: TEdit;
    ObjectRotationEdit: TEdit;
    AxisTiltEdit: TEdit;
    nbRingsEdit: TEdit;
    nbMoonsEdit: TEdit;
    NameEdit: TEdit;
    DocIndexEdit: TEdit;
    ScaleObjectEdit: TEdit;
    nbS3dsEdit: TEdit;
    nbS3dsCB: TCheckBox;
    ScaleDistanceEdit: TEdit;
    RCDTypeEdit: TEdit;
    SSORG: TRadioGroup;
    PlanetEdit: TEdit;
    PlanetUpDown: TUpDown;
    AsteroidUpDown: TUpDown;
    AsteroidEdit: TEdit;
    CometUpDown: TUpDown;
    CometEdit: TEdit;
    DebrisEdit: TEdit;
    DebrisUpDown: TUpDown;
    RingsEdit: TEdit;
    RingsUpDown: TUpDown;
    MoonsEdit: TEdit;
    MoonsUpDown: TUpDown;
    PlanetsRG: TRadioGroup;
    CFLTrackBar: TTrackBar;
    TimeTrackBar: TTrackBar;
    PlanetPickerCB: TComboBox;
    SunShineCB: TCheckBox;
    SunShineTB: TTrackBar;
    BtnPanel: TPanel;
    HelpBtn: TSpeedButton;
    StoreBtn: TSpeedButton;
    ShowBtn: TSpeedButton;
    RunBtn: TSpeedButton;
    StopBtn: TSpeedButton;
    ClearBtn: TSpeedButton;
    LoadBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    PrintBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    AS3dsEdit: TEdit;
    AS3dsUpDown: TUpDown;
    CS3dsEdit: TEdit;
    CS3dsUpDown: TUpDown;
    DS3dsEdit: TEdit;
    DS3dsUpDown: TUpDown;
    Edit4: TEdit;
    SS3dsUpDown: TUpDown;
    PS3dsUpDown: TUpDown;
    PS3dsEdit: TEdit;
    PickActiveCB: TCheckBox;
    LabelsOnCB: TCheckBox;
    UseOrbitalElementsCB: TCheckBox;
    OrbitTrailsOnCB: TCheckBox;
    DocIndexLinkCB: TCheckBox;
    AtmosphereOnCB: TCheckBox;
    S3dsScalerTB: TTrackBar;
    CameraDistanceUpDown: TUpDown;
    S3dsScalerScalerTB: TTrackBar;
    HoursTimeTrackBar: TTrackBar;
    LabelTB: TTrackBar;
    aVarEdit: TEdit;
    wVarEdit: TEdit;
    wConstEdit: TEdit;
    NVarEdit: TEdit;
    NConstEdit: TEdit;
    MVarEdit: TEdit;
    MConstEdit: TEdit;
    RCDCountEdit: TEdit;
    RCDXYSizeEdit: TEdit;
    RCDZSizeEdit: TEdit;
    RCDPositionEdit: TEdit;
    iVarEdit: TEdit;
    AlbedoEdit: TEdit;
    VelocityEdit: TEdit;
    AtmosphereCB: TComboBox;
    MassEdit: TEdit;
    DensityEdit: TEdit;
    VelocityTypeEdit: TEdit;
    VelocityDirEdit: TEdit;
    SunScaling1: TMenuItem;
    SunScale20: TMenuItem;
    SunScale200: TMenuItem;
    SunScale2000: TMenuItem;
    OrbitTrails1: TMenuItem;
    OrbitTrails36: TMenuItem;
    OrbitTrails360: TMenuItem;
    OrbitTrails1000: TMenuItem;
    OrbitTrails3600: TMenuItem;
    DateTimePicker1: TDateTimePicker;
    DatePickerCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
procedure ClearData;
procedure ClearDataEdits;
Procedure CreateGLSolarSystem(filename:string);
{procedure GLCometParticlesActivateParticle(Sender: TObject;
            particle: TGLBaseSceneObject);
procedure CometSpriteProgress(Sender: TObject;
          const deltaTime,  newTime: Double);}
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
Procedure SaveGLSolarSystem(filename:string);
    procedure PlanetsRGClick(Sender: TObject);
    procedure StoreBtnClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CFLTrackBarChange(Sender: TObject);
    procedure TimeTrackBarChange(Sender: TObject);
    procedure GLCadencerAProgress(Sender: TObject; const deltaTime,
              newTime: Double);
procedure AddToTrail(const p : TVector);

    procedure SunShineCBClick(Sender: TObject);
    procedure SunShineTBChange(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure GLSceneViewerAMouseDown(Sender: TObject;
                Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
procedure DataDisplayer(Switch,Spec,Species,SubSpecies,Spec3ds:Integer);

    procedure GLSceneViewerAMouseEnter(Sender: TObject);
    procedure GLSceneViewerAMouseMove(Sender: TObject; Shift: TShiftState;
              X, Y: Integer);
    procedure GLSceneViewerAMouseUp(Sender: TObject; Button: TMouseButton;
               Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
              WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLSceneViewerABeforeRender(Sender: TObject);
    procedure TimerATimer(Sender: TObject);
    procedure DisplayToolbar1Click(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PlanetPickerCBChange(Sender: TObject);
    procedure GLSceneViewerADblClick(Sender: TObject);
    procedure S3dsScalerTBChange(Sender: TObject);
    procedure CameraDistanceUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DisplayFPS1Click(Sender: TObject);
    procedure MoonsLoadFakeTextureClick(Sender: TObject);
    procedure PlanetsLoadFakeTextureClick(Sender: TObject);
    procedure AsteroidsLoadFakeTextureClick(Sender: TObject);
    procedure S3dsLoadFakeTextureClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PickActiveCBClick(Sender: TObject);
    procedure DocIndexLinkCBClick(Sender: TObject);
    procedure AtmosphereOnCBClick(Sender: TObject);
    procedure UseOrbitalElementsCBClick(Sender: TObject);
    procedure LabelsOnCBClick(Sender: TObject);
    procedure OrbitTrailsOnCBClick(Sender: TObject);
    procedure MoonScalex0Click(Sender: TObject);
    procedure MoonScalex10Click(Sender: TObject);
    procedure MoonScalex50Click(Sender: TObject);
    procedure RingsLoadFakeTextureClick(Sender: TObject);
    procedure CometsLoadFakeTextureClick(Sender: TObject);
    procedure DebrisLoadFakeTextureClick(Sender: TObject);
    procedure SpudVersionConvertor1Click(Sender: TObject);
    procedure SelectFontMenuClick(Sender: TObject);
    procedure LabelTBChange(Sender: TObject);
procedure ToggleToolbarDisplay;
    procedure SunScale20Click(Sender: TObject);
    procedure SunScale200Click(Sender: TObject);
    procedure SunScale2000Click(Sender: TObject);
    procedure OrbitTrails36Click(Sender: TObject);
    procedure OrbitTrails360Click(Sender: TObject);
    procedure OrbitTrails1000Click(Sender: TObject);
    procedure OrbitTrails3600Click(Sender: TObject);
    procedure DatePickerCBClick(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);

  private
     

  public
     
    LabelSelected, CometFiring, CometTrailing,
    Running, PlanetsLoaded:Boolean;
    PickedObjA : TGLBaseSceneObject;//TGLCustomSceneObject;
    PickedObj : TGLCustomSceneObject;
    VersionDataTmp  : TVersionData;
    SystemDataTmp   : TSystemData;
    {? These data arrays are duplicates of data stored with/in Objects ?
     These are used... data in objects is ignored... but are loaded in}
    SunDataTmp      : TSunData;
    PlanetDataTmpArray     : Array of TPlanetData;
                           {Planet    Which one}
      MoonDataTmpArray     :Array of  Array of  TMoonRingData;
      RingDataTmpArray     :Array of  Array of  TMoonRingData;
 ImposterBuilder : TGLImposterBuilder;
                      {Object   Which Object    Which S3ds}
      S3dsDataTmpArray     :Array of Array of  Array of  TMoonRingData;
    AsteroidDataTmpArray   : Array of TACDData;
    CometDataTmpArray      : Array of TACDData;
/// FX : TFireFxDummyCubeBase;
    DebrisDataTmpArray     : Array of TACDData;
    //USolarSystem
    OrbitalElementsDataTmpArray     :Array of Array of  Array of  TOrbitalElementsData;

    ColorArray             : Array of TColorVector;
    S3dsScaler,
    //SolarScaleDivisor  and SolarDistance SCALE the Planet size and Distance
    //Read from Data as Sun ScaleObjectEdit: Earth Diameter
    //Change Scale to change Object when running
    SolarScaleDivisor,
    //Read from Data as Sun ScaleDistanceEdit: a kludged divisor
    //change x,y,z when running
    SolarDistance,{Default 10,000 ? Range: 100 .. 100,000}
      //Sun  Radius:=((SunDataTmp.Radius)/(SolarScaleDivisor))/200;
      //All others Radius:=(PlanetDataTmpArray[i].Radius)/(SolarScaleDivisor);
      // x:={((SundataTmp.Radius)/(SolarScaleDivisor))+}
      // ((PlanetDataTmpArray[i].Radius)/(SolarScaleDivisor/2))
      //+((PlanetDataTmpArray[i].distance/SolarDistance)) ;
    CameraFocalLength, { 50 Camera.FocalLength .. 10,000}
    OrbitalTime,
    SolarTimeMultiplier:Double; {1 0..729 Speed of rotation
    from 0 to __ days per frame per second ?}
    //RingType, CometType, DebrisType,
    MaxLines,
    PlanetToOrbitTrail,
    SunScale,MoonScale,mx, my, dmx, dmy : Integer;
  end;

var
  ABCreatorFrm: TABCreatorFrm;

implementation

uses
  uSahObjects{Debris Field Asteroid maker}
  {uSpaceEntities, Classes.. definitions added in here}
  ///SpudVCFrm;  {Orbit Elements Input AND Version Convertor}
  //uGlobals
  ;

var
  EarthModelPath : String;

{$R *.DFM}

procedure TABCreatorFrm.FormCreate(Sender: TObject);
begin
 { top := ABCreatorFormY;
  left := ABCreatorFormX; }
  if FileExists(ExtractFilePath(ParamStr(0))+'GLSceneSpace.hlp') THEN
    Application.HelpFile := ExtractFilePath(ParamStr(0))+ 'GLSceneSpace.hlp';
  EarthModelPath:=ExtractFilePath(ParamStr(0))+'EarthModel\';
  {Timer1.Enabled:=False;
  GLCadencer1.Enabled:=False; }
  OrbitalTime:=  Now-2;// 2 days back
  MoonScale:= 10;
  SunScale:= 200;
  MaxLines:=360;
  //RingType:=0;  CometType:=0; DebrisType:=0;
  PlanetToOrbitTrail:=0; {Basically null ..no}
  OrbitLines.AddNode(0, 0, 0);
  OrbitLines.ObjectStyle:=OrbitLines.ObjectStyle+[osDirectDraw];
  SetLength(ColorArray,10);
  ColorArray[0]:=clrRed;
  ColorArray[1]:=clrLimeGreen;
  ColorArray[2]:=clrNeonBlue;
  ColorArray[3]:=clrScarlet;
  ColorArray[4]:=clrMediumAquamarine;
  ColorArray[5]:=clrMediumSlateBlue;
  ColorArray[6]:=clrFlesh;
  ColorArray[7]:=clrPlum;
  ColorArray[8]:=clrLightSteelBlue;
  ColorArray[9]:=clrSienna;
  VersionDataTmp.MajorVersion:=10;
  VersionDataTmp.MinorVersion:=1;
  VersionDataTmp.Author:='GLS Team, 14Oct2015';
 // HUDLabel.Visible:=False;
   Randomize;
   CometTrailing:=False;
   CometFiring:=False;
   LabelSelected:=False;
  RCDTypeEdit.Visible:=False;
     RCDCountEdit.Visible:= False;
     RCDXYSizeEdit.Visible:= False;
     RCDZSizeEdit.Visible:= False;
     RCDPositionEdit.Visible:= False;
  ClearBtnClick(Sender);
end;
procedure TABCreatorFrm.FormShow(Sender: TObject);
begin
  dmx:=1; dmy:=1;//To get the Flare to Display at Startup
  //GLSceneViewer1.SetFocus;
end;

procedure TABCreatorFrm.FormClose(Sender: TObject; var Action: TCloseAction);
var j:Integer;
begin
  TimerA.Enabled:=False;
  GLCadencerA.Enabled:=False;
  Running:=False;
  PlanetsLoaded:=False;
  If CometFiring then
  begin
    ///Fx.FxEnabled:=False;
    ///Fx.destroy;
  end;
  DCSolarSystem.DeleteChildren;


  for j:=DCComet.Count-1 downto 1 do
  begin
    DCComet.Children[j].Visible:=False;
    DCComet.Children[j].Free;
  end;

   PlanetToOrbitTrail:=0; {Basically null ..no}
   OrbitTrailsOnCB.Checked:=False;
    for j:= OrbitLines.Nodes.Count-1 downto 0 do
    OrbitLines.Nodes[j].Free;

  SetLength(PlanetDataTmpArray,0);
    SetLength(RingDataTmpArray,0,0);
    SetLength(MoonDataTmpArray,0,0);
    SetLength(S3dsDataTmpArray,0,0,0);
  SetLength(AsteroidDataTmpArray,0);
  SetLength(CometDataTmpArray,0);
  SetLength(DebrisDataTmpArray,0);
  SetLength(ColorArray,0);
  GLMaterialLibraryA.Materials.Clear;
 CometGLMaterialLibrary.Materials.Clear;
 { ABCreatorFormY := ABCreatorForm.top;
  ABCreatorFormX := ABCreatorForm.left;}
end;
procedure TABCreatorFrm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TABCreatorFrm.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(2000);
end;

procedure TABCreatorFrm.ClearBtnClick(Sender: TObject);
var j:Integer;
begin
  glsceneA.BeginUpdate;
  Running:=False;
  PlanetsLoaded:=False;
   PlanetToOrbitTrail:=0; {Basically null ..no}
   OrbitTrailsOnCB.Checked:=False;
   for j:= OrbitLines.Nodes.Count-1 downto 0 do
      OrbitLines.Nodes[j].Free;
    OrbitLines.AddNode(0, 0, 0);
  for j:=DCComet.Count-1 downto 1 do
  begin  {Leave the 1 REAL one there always}
    DCComet.Children[j].Visible:=False;
    DCComet.Children[j].Free;
  end;
  DCComet.Children[0].Visible:=False;
  If CometFiring then
  begin
    ///Fx.FxEnabled:=False;
    ///Fx.destroy;
  end;
  CometFiring:=False;
  PlanetPickerCB.ItemIndex:=0;
  GLCamera.TargetObject:=DCSolarSystem;
    // Goran - move GLCamera back to CameraRoot
  if (GLCamera.Parent <> GLSceneA.Objects) and Assigned(GLCamera.Parent)  then
  begin
    GLCamera.Parent.Remove(GLCamera, False);
    GLSceneA.Objects.AddChild(GLCamera);
  end;    // Goran


  LabelSelected:=False;
  LabelsOnCB.Checked:=False;
  GLFlatTextLabel.Visible:=False;
  if (GLFlatTextLabel.Parent <> DCLabels) and Assigned(GLFlatTextLabel.Parent)  then
  begin
    GLFlatTextLabel.Parent.Remove(GLFlatTextLabel, False);
    DCLabels.AddChild(GLFlatTextLabel);
    GLFlatTextLabel.Text:='Sun';
  end;

  ClearData;
  ClearDataEdits;
  PlanetPickerCB.Items.Clear;
  PlanetPickerCB.Items.Add('Sun');
  PlanetPickerCB.ItemIndex:=0;
  //RingType:=0;  CometType:=0; DebrisType:=0;
  CameraFocalLength:=50;
  CFLTrackBar.Position:=50;
  GLCamera.FocalLength:=CameraFocalLength;
  SolarTimeMultiplier:=1;
  TimeTrackBar.Position:=1;
  GLCamera.Position.x:=0;
  GLCamera.Position.y:=0;
  GLCamera.Position.z:=-20;
  CameraDistanceLabel.Caption:='20.00';
  DebrisRG.Itemindex:=0;
  CometRG.Itemindex:=0;
  AsteroidRG.Itemindex:=0;
  PlanetsRG.Itemindex:=0;
  SSORG.ItemIndex:=1;SSORG.ItemIndex:=0; //to force change
  SunRG.Itemindex:=1;SunRG.Itemindex:=0; //to force change
  SunShineTB.Position:=100;
  SunShineCB.Checked:=True;
  S3dsScaler:=1;
  S3dsScalerScalerTB.Position:=100;
  S3dsScalerTB.Position:=100;
  glsceneA.EndUpdate;
  GLSceneViewerA.Invalidate;
  Running:=True;
end;
procedure TABCreatorFrm.ClearData;
var
  DCCenter        : TGLBaseSceneObject;
begin
  DCSolarSystem.DeleteChildren;
  GLMaterialLibraryA.Materials.Clear;
      SystemDataTmp.NbSun :=1;
      SystemDataTmp.NbPlanet :=0;
      SystemDataTmp.NbAsteroid :=0;
      SystemDataTmp.NbComet  :=0;
      SystemDataTmp.NbDebris :=0;
      {Just junk to keep from crashing}
      SunDataTmp.SunName  :='Sun';
      SunDataTmp.Radius :=10000;
      SunDataTmp.ObjectRotation :=24;
      SunDataTmp.AxisTilt       :=0;
      SunDataTmp.nbS3ds         :=0;
      SunDataTmp.DocIndex       :=1;
      SunDataTmp.SystemObjectScale:=12756;
      SunDataTmp.SystemDistanceScale:=10000;
  SolarScaleDivisor:=12756;
  SolarDistance:=10000;
    DCCenter:=TGLDummyCube.Create(self);
    DCCenter.Name:='DC'+SunDataTmp.SunName;
    DCSolarSystem.AddChild(DCCenter);
  SetLength(PlanetDataTmpArray,0);
   PlanetUpDown.Position:=0;
  SetLength(RingDataTmpArray,0,0);
   RingsUpDown.Position:=0;
  SetLength(MoonDataTmpArray,0,0);
   MoonsUpDown.Position:=0;
  SetLength(S3dsDataTmpArray,0,0,0);
   SS3dsUpDown.Position:=0;
   PS3dsUpDown.Position:=0;
   AS3dsUpDown.Position:=0;
   CS3dsUpDown.Position:=0;
   DS3dsUpDown.Position:=0;
  SetLength(AsteroidDataTmpArray,0);
   AsteroidUpDown.Position:=0;
  SetLength(CometDataTmpArray,0);
   CometUpDown.Position:=0;
  SetLength(DebrisDataTmpArray,0);
   DebrisUpDown.Position:=0;
end;

procedure TABCreatorFrm.ClearDataEdits;
begin
  NameEdit.Text:= 'Sun';
  RadiusEdit.Text:= '10000';
  ObjectRotationEdit.Text:= '24';
  AxisTiltEdit.Text:= '0';
  nbRingsEdit.Text:= '0';
  nbMoonsEdit.Text:= '0';
  nbS3dsEdit.Text:= '0';
  nbS3dsCB.Checked:=False;

  DocIndexEdit.Text:= '1';
  ScaleObjectEdit.Text:= '12756';
  ScaleDistanceEdit.Text:= '10000';

RCDTypeEdit.Text:= '0';
RCDCountEdit.Text:= '0';
RCDXYSizeEdit.Text:= '0';
RCDZSizeEdit.Text:= '0';
RCDPositionEdit.Text:= '0';

  OrbitRotationEdit.Text:= '365';


  MassEdit.Text:= '0';
  DensityEdit.Text:= '0';
  AlbedoEdit.Text:= '0';
  AtmosphereCB.ItemIndex:=0;
  VelocityEdit.Text:= '0';
  VelocityTypeEdit.Text:= '0';
  VelocityDirEdit.Text:= '0';
  
  NConstEdit.Text:= '0';
  NVarEdit.Text:= '0';
  iConstEdit.Text:= '0'; //InclinationEdit.Text:= '0';
  iVarEdit.Text:= '0';
  wConstEdit.Text:= '0';
  wVarEdit.Text:= '0';
  aConstEdit.Text:= '20000'; //DistanceEdit.Text:= '20000';
  aVarEdit.Text:= '0';
  eConstEdit.Text:= '0'; //EccentricityEdit.Text:= '0';
  eVarEdit.Text:= '0';  //  EMinEdit.Text:= '0';
    EMaxEdit.Text:= '0';
  MConstEdit.Text:= '0';
  MVarEdit.Text:= '0';  
end;


{-----------------------------------------------------------------------------
  Procedure   : TABCreatorForm.CreateGLSolarSystem
  Date        : 17/07/2003
  Arguments   : filename:string
  Result      : None
  Description : Load & Create a GL System Solar
                Multiple planets, Moons,... with their individual properties
                One Space object per orbit, unlimited orbiters per Planet
-----------------------------------------------------------------------------}
procedure TABCreatorFrm.LoadBtnClick(Sender: TObject);
begin
  OpenDialog1.Filter:='System Parameter Universal Definition(*.spud)|*.spud';
  OpenDialog1.InitialDir:=ExtractFilePath(EarthModelPath);
  if OpenDialog1.Execute then
  begin
    {On a fast system.. never even seen}
    ABCreatorFrm.Caption:='Loading';
    application.ProcessMessages;
    ClearBtnClick(Sender);
    EarthModelPath:=ExtractFilePath(OpenDialog1.FileName);
    CreateGLSolarSystem(OpenDialog1.FileName);
    {Got here without crashing so Loaded is true}
     If PlanetsLoaded=False then ClearBtnClick(Sender);
    {Quickly changed to FPS, although loaded it takes a while to
    'create' the spheres and textures.. so this shows...}
    ABCreatorFrm.Caption:='A.B. Creator D. E. Prime';
  end;
end;
{This should be divided into Loading Data file and Setting up GLScene objects
then it could be split from Viewer and be a Loader.. if required}
{GetPitchAngle  FRotation.X;
GetTurnAngle   FRotation.Y;
GetRollAngle    FRotation.Z;}

procedure TABCreatorFrm.CreateGLSolarSystem(filename:string);
var  RingType,
  LevelCount,Level2Count,i,j,k:integer;
  CheckVersionDataTmp  : TVersionData;
  DCCenter        : TGLBaseSceneObject;
  SPSun           : TGLBaseSceneObject;
  SPPlanet        : TGLBaseSceneObject;
  SPMoon          : TGLBaseSceneObject;
  DIRing          : TGLBaseSceneObject;
  SPRing          : TGLBaseSceneObject;
  FFRing          : TGLBaseSceneObject;
  FFS3ds          : TGLFreeForm;
  SPAsteroid      : TGLBaseSceneObject;
  spr : TGLSprite;
  SPComet         : TGLBaseSceneObject;
   L : TGLLibMaterial;
   st: string;
  SPDebris        : TGLBaseSceneObject;
  FFDebris        : TGLBaseSceneObject;
  x,y,z :Double;
  F               : file;
  libMat : TGLLibMaterial;

  Temp	:TMeshObject;
  Proxyi: Integer;
  proxy : TGLProxyObject;
  Proxys : TVector;
  Proxyr,Proxyf : Double;
  Proxyscale: Single;
  a,b    :double;
  c,s    :double;
  cb,sb  :double;
begin
  glsceneA.BeginUpdate;
  PlanetsLoaded:=False;
  {Clear and Free ALL Children of  DCSolarSystem }
  CometSprite.Visible:=False;
  DCSolarSystem.DeleteChildren;
  for j:=DCComet.Count-1 downto 1 do
  begin
    DCComet.Children[j].Visible:=False;
    DCComet.Children[j].Free;
  end;

  PlanetPickerCB.Items.Clear; {This loads All new ones}
  LevelCount:=0;{Used to Place Planets, Comets, Asteroids, Debris}
  Level2Count:=-1;{and Children of the Korn}
  Assignfile(f,filename);
  reset(f,1);
  BlockRead(f,CheckVersionDataTmp,sizeof(TVersionData));
  {Check Version for Changes to Perform}
  if ((VersionDataTmp.MajorVersion = CheckVersionDataTmp.MajorVersion)
    and (VersionDataTmp.MinorVersion = CheckVersionDataTmp.MinorVersion))
  then
  begin end
  else
  begin  {When this is Possible.. there needs to be a File Convertor}
    ShowMessage(Inttostr(CheckVersionDataTmp.MajorVersion)+'.'+
    Inttostr(CheckVersionDataTmp.MinorVersion)
    +' Version Mismatch '+ Inttostr(VersionDataTmp.MajorVersion)+'.'+
    Inttostr(VersionDataTmp.MinorVersion));
    Closefile(f);
    glsceneA.EndUpdate;
    exit;
  end;
  BlockRead(f,SystemDataTmp,sizeof(TSystemData));
  {Set Arrays}
  SetLength(PlanetDataTmpArray,SystemDataTmp.NbPlanet);
  SetLength(MoonDataTmpArray,SystemDataTmp.NbPlanet,0);
  SetLength(RingDataTmpArray,SystemDataTmp.NbPlanet,0);
  SetLength(S3dsDataTmpArray,5,0,0);
  SetLength(S3dsDataTmpArray[0],1,0);
  SetLength(S3dsDataTmpArray[1],SystemDataTmp.NbPlanet,0);
  SetLength(S3dsDataTmpArray[2],SystemDataTmp.NbAsteroid,0);
  SetLength(S3dsDataTmpArray[3],SystemDataTmp.NbComet,0);
  SetLength(S3dsDataTmpArray[4],SystemDataTmp.NbDebris,0);
  SetLength(AsteroidDataTmpArray,SystemDataTmp.NbAsteroid);
  SetLength(CometDataTmpArray,SystemDataTmp.NbComet);
  SetLength(DebrisDataTmpArray,SystemDataTmp.NbDebris);
  //------- Loading & Create Sun -------------------------------------
  Blockread(f,SunDataTmp,sizeof(TSunData));
  SolarScaleDivisor:=SunDataTmp.SystemObjectScale;
  SolarDistance:=SunDataTmp.SystemDistanceScale;

  SPSun:=TGLSun.Create(Self);
  with (SPSun As TGLSun) do
  begin
    ExtraData:=SunDataTmp;
    Name:='SP'+SunDataTmp.SunName;
    PlanetPickerCB.Items.Add(SunDataTmp.SunName);
      {0.27...   200 is Arbitrary seems to work for Earth Solar system}
    Radius:=((SunDataTmp.Radius)/(SolarScaleDivisor))/SunScale;
    PitchAngle:=SunDataTmp.AxisTilt;
    TurnAngle:=24/SunDataTmp.ObjectRotation;
    Stacks:=32;
    Slices:=32;
    Tag:=1;
    Hint:=inttostr(0);     //jpg tga png bmp
    If FileExists(EarthModelPath+SunDataTmp.SunName+'.jpg') then
    begin {Create the matlib}
      GLMaterialLibraryA.AddTextureMaterial(
         SunDataTmp.SunName,EarthModelPath+SunDataTmp.SunName+'.jpg');
         Material.MaterialLibrary:=GLMaterialLibraryA;
      Material.LibMaterialName:=SunDataTmp.SunName;
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.Disabled:=False;
    end else
    begin
      {Set some  kinda Color to the Sphere}
      Material.FrontProperties.Diffuse.Color:=clrYellow;
    end;
      {Make a Sun Flare.. Made it Permanent}
    NameEdit.Text:=SunDataTmp.SunName;
  end;
  DCCenter:=TGLDummyCube.Create(self);
  DCCenter.Name:='DC'+SunDataTmp.SunName;
  DCSolarSystem.AddChild(DCCenter);
  DCSolarSystem.children[0].AddChild(SPSun); // 0 is the Sun
  //------- Load & Create S3ds ---------------------------------
  SetLength(S3dsDataTmpArray[0,0],SunDataTmp.nbS3ds);
    //----------- Load & Create FFS3ds ------------------------------------------
  for j:=0 to SunDataTmp.nbS3ds-1 do
  begin       //  FFS3ds          : TGLFreeForm;
    BlockRead(f,S3dsDataTmpArray[0,0,j],Sizeof(TMoonRingData));
    DCCenter:=TGLDummyCube.Create(self);
    DCCenter.Name:='DC'+S3dsDataTmpArray[0,0,j].Name;
    DCCenter.TurnAngle:=365/S3dsDataTmpArray[0,0,j].OrbitRotation;
    DCCenter.PitchAngle:=S3dsDataTmpArray[0,0,j].Inclination;
    DCSolarSystem.children[0].children[0].AddChild(DCCenter);
    inc(Level2Count);
    If (not (FileExists(S3dsDataTmpArray[0,0,j].Name+'.3ds')) ) then
    begin
      ShowMessage(S3dsDataTmpArray[0,0,j].Name+'.3ds'+' Not Found Exiting');
      closefile(f);
      glsceneA.EndUpdate;
      exit;
    end;
    {But it Would crash later when Rotating.. DO NOT ADD if NOT THERE!
    Maybe create an "asteroid" freeform}
    FFS3ds:=TGLS3ds.Create(self);
    with (FFS3ds As TGLS3ds) do
    begin          {SunDataTmp}
      ExtraData:=S3dsDataTmpArray[0,0,j];
      Name:='FF'+S3dsDataTmpArray[0,0,j].Name;
      Tag:=8;
      Hint:='0,0,'+inttostr(j);
      FFS3ds.LoadFromFile(S3dsDataTmpArray[0,0,j].Name+'.3ds');
      Scale.X:=(S3dsDataTmpArray[0,0,j].Radius);
      Scale.Y:=(S3dsDataTmpArray[0,0,j].Radius);
      Scale.Z:=(S3dsDataTmpArray[0,0,j].Radius);
      //Radius:=(PlanetDataTmpArray[i].Radius)/(SolarScaleDivisor);
      with Up do
      begin
        X:=0;Y:=1.0;Z:=0;
      end;
      PitchAngle:=S3dsDataTmpArray[0,0,j].AxisTilt;
      TurnAngle:=24/S3dsDataTmpArray[0,0,j].ObjectRotation;
      {a 3ds loads its own Texture...
          but HOW do you KNOW it has One?  it wont be NameMap.jpg !}
      if (S3dsDataTmpArray[0,0,j].S3dsTex) then
      begin
        with GLMaterialLibraryA do
        begin
          FFS3ds.Material.MaterialLibrary:=GLMaterialLibraryA;
          libMat:=Materials.Add;
          FFS3ds.Material.LibMaterialName:=libMat.Name;
          libMat.Material.FrontProperties.Diffuse.Red:=0;
         {for i:=0 to Materials.Count-1 do
          with Materials[i].Material do BackProperties.Assign(FrontProperties);}
        end;
        {Material.MaterialLibrary:=GLMaterialLibrary;
        Material.LibMaterialName:=S3dsDataTmpArray[1,i,j].Name;
        Material.Texture.TextureMode:=tmDecal;
        Material.Texture.Disabled:=False;}
      end else
      begin
        If FileExists(EarthModelPath+S3dsDataTmpArray[0,0,j].Name+'.jpg') then
        begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
             S3dsDataTmpArray[0,0,j].Name,EarthModelPath+S3dsDataTmpArray[0,0,j].Name+'.jpg');
          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=S3dsDataTmpArray[0,0,j].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
        end else
        begin   {Set some  kinda Color to the FFS3ds}
          If ((S3dsLoadFakeTexture.Checked)and
             (FileExists(EarthModelPath+'allfake.jpg'))) then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
             S3dsDataTmpArray[0,0,j].Name,EarthModelPath+'allfake.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=S3dsDataTmpArray[0,0,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
        end;
      end;
    end;{FFS3ds}

    DCSolarSystem.children[0].children[0].Children[Level2Count].AddChild(FFS3ds);
    x:=(S3dsDataTmpArray[0,0,j].aDistance/(SolarDistance));
    y:=0; z:=0;
    DCSolarSystem.children[0].children[0].Children[Level2Count].children[0].Translate(x,y,z);
  end;{ for j:=0   FFS3ds}

  //------- Load & Create planets ---------------------------------
  for i:=0 to SystemDataTmp.NbPlanet-1 do
  begin
    //------- Planet ----------------
    Blockread(f,PlanetdataTmpArray[i],sizeof(TPlanetData));
    DCCenter:=TGLDummyCube.Create(self);
    DCCenter.Name:='DC'+PlanetDataTmpArray[i].Name;
    DCCenter.TurnAngle:=365/PlanetDataTmpArray[i].OrbitRotation;
    DCCenter.PitchAngle:=PlanetDataTmpArray[i].Inclination;
    PlanetPickerCB.Items.Add(PlanetDataTmpArray[i].Name);
    DCSolarSystem.AddChild(DCCenter);
    inc(LevelCount);
    Level2Count:=-1; {Reset each Loop to place the Rings and Moons}
    SPPlanet:=TGLPlanet.Create(self);
    with (SPPlanet as TGLPlanet) do
    begin
      ExtraData:=PlanetDataTmpArray[i];
      Name:='SP'+PlanetDataTmpArray[i].Name;
      Tag:=2;
      Hint:=inttostr(i);
      Radius:=(PlanetDataTmpArray[i].Radius)/(SolarScaleDivisor);
      Stacks:=32;
      Slices:=32;
      with Up do
      begin
        X:=0;Y:=1.0;Z:=0;
      end;
      PitchAngle:=PlanetDataTmpArray[i].AxisTilt;
      TurnAngle:=24/PlanetDataTmpArray[i].ObjectRotation;
      //RollAngle:=0;
      If FileExists(EarthModelPath+PlanetDataTmpArray[i].Name+'.jpg') then
      begin {Create the matlib}
        GLMaterialLibraryA.AddTextureMaterial(
           PlanetDataTmpArray[i].Name,EarthModelPath+PlanetDataTmpArray[i].Name+'.jpg');

        Material.MaterialLibrary:=GLMaterialLibraryA;
        Material.LibMaterialName:=PlanetdataTmpArray[i].Name;
        Material.Texture.TextureMode:=tmDecal;
        Material.Texture.Disabled:=False;
      end else
      begin           {Set some  kinda Color to the Sphere}
        If ((PlanetsLoadFakeTexture.Checked)and
             (FileExists(EarthModelPath+'allfake.jpg'))) then
        begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
             PlanetDataTmpArray[i].Name,EarthModelPath+'allfake.jpg');
          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=PlanetDataTmpArray[i].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
        end else
          Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
      end;
    end;

    DCSolarSystem.children[LevelCount].AddChild(SPPlanet);
    // Add must add Orbit eccentricity
    //Eccentricity.. until location is computed per frame
    x:= ((PlanetDataTmpArray[i].Radius)/(SolarScaleDivisor))
       +((PlanetDataTmpArray[i].aDistance/SolarDistance)) ;
     // showmessage(floattostr(x));
      //63.44  66.71
    y:=0;
    z:=0;
    DCSolarSystem.children[LevelCount].Children[0].Translate(x,y,z);

    // if Ring Load Ring
    //----------- Load & Create SPRing ------------------------------------------
    SetLength(RingDataTmpArray[i],PlanetDataTmpArray[i].nbRings);
    for j:=0 to PlanetDataTmpArray[i].nbRings-1 do
    begin
      BlockRead(f,RingDataTmpArray[i,j],Sizeof(TMoonRingData));
      DCCenter:=TGLDummyCube.Create(self);
      DCCenter.Name:='DC'+RingDataTmpArray[i,j].Name;
      DCCenter.TurnAngle:=365/RingDataTmpArray[i,j].OrbitRotation;
      DCCenter.PitchAngle:=RingDataTmpArray[i,j].Inclination;
      //Place Rings and Moons on the Planet Sphere
      DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
      inc(Level2Count);
      //RingType
      RingType:=Trunc(RingDataTmpArray[i,j].RCDType);
      If (RingDataTmpArray[i,j].RCDType)=0 then
      begin
        DIRing:=TGLRing.Create(self);
        with (DIRing As TGLRing) do
        begin
          ExtraData:=RingDataTmpArray[i,j];
          Name:='DI'+RingDataTmpArray[i,j].Name;
          Tag:=6;
          Hint:=inttostr(i)+','+inttostr(j);
          {Distance +or-  1/2 Radius }
          InnerRadius:=(RingDataTmpArray[i,j].aDistance-
          RingDataTmpArray[i,j].Radius)
          /(SolarScaleDivisor);
          OuterRadius:=(RingDataTmpArray[i,j].aDistance+
          RingDataTmpArray[i,j].Radius)
          /(SolarScaleDivisor);
          with Up do
          begin
            X:=0;Y:=1.0;Z:=0;
          end;
          Slices:=32;
          PitchAngle:=RingDataTmpArray[i,j].AxisTilt;
          TurnAngle:=24/RingDataTmpArray[i,j].ObjectRotation;
          If FileExists(EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg') then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
             RingDataTmpArray[i,j].Name,EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=RingDataTmpArray[i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          begin           {Set some  kinda Color to the Ring}
            Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
            Material.BackProperties.Diffuse.Color:=Material.FrontProperties.Diffuse.Color;
          end;
          Material.FaceCulling:=fcNoCull;//Trying to make 2 sided rings
          {Material.BackProperties:=Material.FrontProperties; }
        end;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(DIRing);
      end else
      If (RingDataTmpArray[i,j].RCDType)=1 then
      {SPRing   TGLRingSphere}
      begin
        SPRing:=TGLRingSphere.Create(self);
        with (SPRing As TGLRingSphere) do
        begin
          ExtraData:=RingDataTmpArray[i,j];
          Name:='SP'+RingDataTmpArray[i,j].Name;
          Tag:=6;
          Hint:=inttostr(i)+','+inttostr(j);
          {Radius and Distance}
          Radius:=RingDataTmpArray[i,j].Radius/(SolarScaleDivisor);
          //InnerRadius:=RingDataTmpArray[i,j].EMin/(SolarScaleDivisor);
          //OuterRadius:=RingDataTmpArray[i,j].EMax/(SolarScaleDivisor);
          with Up do
          begin
            X:=0;Y:=1.0;Z:=0;
          end;
          TopCap:=ctCenter;          {?}
          Top:=Round(RingDataTmpArray[i,j].RCDXYSize);
          BottomCap:=ctCenter;
          Bottom:=-Round(RingDataTmpArray[i,j].RCDXYSize);
          Stacks:=32;
          Slices:=32;
          PitchAngle:=RingDataTmpArray[i,j].AxisTilt;
          TurnAngle:=24/RingDataTmpArray[i,j].ObjectRotation;
          If FileExists(EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg') then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
             RingDataTmpArray[i,j].Name,EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=RingDataTmpArray[i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          begin           {Set some  kinda Color to the Ring}
            Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
            Material.BackProperties.Diffuse.Color:=Material.FrontProperties.Diffuse.Color;
          end;
          Material.FaceCulling:=fcNoCull;
          {Material.BackProperties:=Material.FrontProperties; }
        end;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(SPRing);
      end else

      If Trunc(RingDataTmpArray[i,j].RCDType)=2 then
      {FFRing TGLRingFreeForm=Class(TGLFreeForm)}
      begin
        FFRing:=TGLRingFreeForm.Create(self);
        with (FFRing As TGLRingFreeForm) do
        begin
          ExtraData:=RingDataTmpArray[i,j];
          Name:='FF'+RingDataTmpArray[i,j].Name;
          Tag:=6;
          Hint:=inttostr(i)+','+inttostr(j);
          Temp:=TMeshObject.CreateOwned((FFRing As TGLRingFreeForm){MasterAsteroidF}.MeshObjects);
                             //0.2,1,-1     Defaults
                            // 0.7,2,3
          BuildPotatoid(Temp,0.7,3,2); //Variables?
          Scale.X:=//0.05;
          RingDataTmpArray[i,j].RCDXYSize+0.00007;
          //(RingDataTmpArray[i,j].Radius);
          Scale.Y:=//0.05;
          RingDataTmpArray[i,j].RCDXYSize+0.00007;
          //(RingDataTmpArray[i,j].Radius);
          Scale.Z:=//0.05;
          RingDataTmpArray[i,j].RCDXYSize+0.00007;
          //(RingDataTmpArray[i,j].Radius);
          with Up do
          begin
            X:=0;Y:=1.0;Z:=0;
          end;

          //Top:=Round(RingDataTmpArray[i,j].RCDXYSize);
          PitchAngle:=RingDataTmpArray[i,j].AxisTilt;
          TurnAngle:=24/RingDataTmpArray[i,j].ObjectRotation;
          If FileExists(EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg') then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
            RingDataTmpArray[i,j].Name,EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=RingDataTmpArray[i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          begin           {Set some  kinda Color to the Ring}
            Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
            Material.BackProperties.Diffuse.Color:=Material.FrontProperties.Diffuse.Color;
          end;
          Material.FaceCulling:=fcNoCull;
          {Material.BackProperties:=Material.FrontProperties; }
        end;{with FF}
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFRing);
        x:= 0;
        {((PlanetdataTmpArray[i].Radius)/(SolarScaleDivisor))
        +(RingDataTmpArray[i,j].adistance/(SolarDistance));}  // Ratio of 10 it's for a better view
        y:=0; z:=0;
        //0,0,0 = hide inside ProxyMaster planet
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);


        //Create Proxy Asteroids
        //Number, +- Size Variation, Color..Spatial Range: Size of the 'Field'
        for Proxyi:=1 to (RingDataTmpArray[i,j].RCDCount) do
        begin
          // spawn a FractalTree using proxy objects
          // Proxyr:=Random(round(RingDataTmpArray[i,j].Mass));
          // create a new proxy and set its MasterObject property
          proxy := TGLProxyObject(
             DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddNewChild(TGLProxyObject));
          with proxy do
          begin
            ProxyOptions:=[pooObjects];
            MasterObject:=FFRing;//Asteroids{FreeForm};
            Visible:=True;
            Tag:=21;
            Hint:=inttostr(Proxyi);
            Name:=RingDataTmpArray[i,j].Name+inttostr(Proxyi);
            // retrieve reference attitude
            Direction:=FFRing.Direction;
            Up:=FFRing.Up;
            // randomize scale
            ///Proxys:=FFRing.Scale.AsVector;  {0.02  0.002}
            //Proxyr:= Proxys[1];//?
            //Proxyf:=(Proxyr+1);
            //ScaleVector(Proxys, Proxyf);
            //Scale.AsVector:=Proxys;
            //Scale:=FFRing.Scale;
            //TurnAngle:=random(360);
            //0.007  avoids 0
            Proxyscale:=0.007+Random(Round(RingDataTmpArray[i,j].RCDZSize));
            Scale.x:=FFRing.Scale.x*Proxyscale;
            Scale.y:=FFRing.Scale.y*Proxyscale;
            Scale.z:=FFRing.Scale.z*Proxyscale;
            // randomize position

            a:=random*2*pi;
            b:=random*pi-pi/2;
            SinCosine(a,s,c);
            SinCosine(b,sb,cb);
            Position.x := c*cb*
              //(RingDataTmpArray[i,j].RCDPosition);
              (RingDataTmpArray[i,j].adistance/(SolarDistance));
              //Change from a sphere to a squashed ring
            Position.y:=(random-random)
            // /2;//s*cb*(RingDataTmpArray[i,j].Mass);
               /(RingDataTmpArray[i,j].RCDPosition);
            Position.z:=
              sb*
              //(RingDataTmpArray[i,j].RCDPosition);
               (RingDataTmpArray[i,j].adistance/(SolarDistance));

            DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[Proxyi].Translate(x,y,z);

            // randomize orientation
            RollAngle:=Random(360);
            TransformationChanged;
          end;{with Proxy}
        end;{for Proxy}

      end else

      //Must have a 'catch-all' for anything else
      //If Trunc(RingDataTmpArray[i,j].Eccentricity)=3 then
      {FFRing TGLRingFreeForm=Class(TGLFreeForm)}
      begin
        FFRing:=TGLRingFreeForm.Create(self);
        with (FFRing As TGLRingFreeForm) do
        begin
          ExtraData:=RingDataTmpArray[i,j];
          Name:='FF'+RingDataTmpArray[i,j].Name;
          Tag:=6;
          Hint:=inttostr(i)+','+inttostr(j);
          Temp:=TMeshObject.CreateOwned((FFRing As TGLRingFreeForm){MasterAsteroidF}.MeshObjects);
          BuildPotatoid(Temp,0.7,3,2);
          Scale.X:= RingDataTmpArray[i,j].RCDXYSize+0.00007;
          //(RingDataTmpArray[i,j].Radius);
          Scale.Y:= RingDataTmpArray[i,j].RCDXYSize+0.00007;
          //(RingDataTmpArray[i,j].Radius);
          Scale.Z:= RingDataTmpArray[i,j].RCDXYSize+0.00007;
          //(RingDataTmpArray[i,j].Radius);
          with Up do
          begin
            X:=0;Y:=1.0;Z:=0;
          end;

          //Top:=Round(RingDataTmpArray[i,j].RCDXYSize);
          PitchAngle:=RingDataTmpArray[i,j].AxisTilt;
          TurnAngle:=24/RingDataTmpArray[i,j].ObjectRotation;
          If FileExists(EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg') then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
            RingDataTmpArray[i,j].Name,EarthModelPath+PlanetDataTmpArray[i].Name+'-'+RingDataTmpArray[i,j].Name+'.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=RingDataTmpArray[i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          begin           {Set some  kinda Color to the Ring}
            Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
            Material.BackProperties.Diffuse.Color:=Material.FrontProperties.Diffuse.Color;
          end;
          Material.FaceCulling:=fcNoCull;
          {Material.BackProperties:=Material.FrontProperties; }
        end;{with FF}
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFRing);
        x:= 0;
        {((PlanetdataTmpArray[i].Radius)/(SolarScaleDivisor))
        +(RingDataTmpArray[i,j].distance/(SolarDistance));}  // Ratio of 10 it's for a better view
        y:=0; z:=0;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);

///  ImposterBuilder:=TGLImposterBuilder(GLSceneA.Objects.AddNewChildFirst(TGLImposterBuilder));
{
  with ImposterBuilder do begin
    Tolerance:=1;
    MinTexSize:=16;
    MaxTexSize:=64;
    Enabled:=True;
  end;
}
    for Proxyi:=1 to trunc(RingDataTmpArray[i,j].RCDCount) do
    with TGLImposter({ImposterObjects}DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddNewChild(TGLImposter)) do
    begin
      Builder:=ImposterBuilder;
      //AlphaTest:=True;
      Position.SetPoint(0,0,-Proxyi);
      AddNewChild(TGLFreeForm);
    end;
      end;{FFRing Eccentricty}

    end;{TGLRing}
    //----------- Load & Create Moon ------------------------------------------
    SetLength(MoonDataTmpArray[i],PlanetDataTmpArray[i].nbmoons);
    for j:=0 to PlanetDataTmpArray[i].nbmoons-1 do
    begin
      BlockRead(f,MoonDataTmpArray[i,j],Sizeof(TMoonRingData));
      DCCenter:=TGLDummyCube.Create(self);
      DCCenter.Name:='DC'+MoonDataTmpArray[i,j].Name;
      DCCenter.TurnAngle:=365/MoonDataTmpArray[i,j].OrbitRotation;
      DCCenter.PitchAngle:=MoonDataTmpArray[i,j].Inclination;
      DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
      inc(Level2Count);
      SPMoon:=TGLMoon.Create(self);
      with (SPMoon As TGLMoon) do
      begin
        ExtraData:=MoonDataTmpArray[i,j];
        Name:='SP'+MoonDataTmpArray[i,j].Name;
      Tag:=7;
      Hint:=inttostr(i)+','+inttostr(j);
        Radius:=(MoonDataTmpArray[i,j].Radius)/(SolarScaleDivisor);
        with Up do begin X:=0;Y:=1.0;Z:=0; end;
        PitchAngle:=MoonDataTmpArray[i,j].AxisTilt;
        TurnAngle:=24/MoonDataTmpArray[i,j].ObjectRotation;
        Stacks:=32;
        Slices:=32;
        Material.MaterialLibrary:=GLMaterialLibraryA;
        Material.LibMaterialName:=MoonDataTmpArray[i,j].Name;
        If FileExists(EarthModelPath+PlanetDataTmpArray[i].Name+'-'+MoonDataTmpArray[i,j].Name+'.jpg') then
        begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
             MoonDataTmpArray[i,j].Name,EarthModelPath+PlanetDataTmpArray[i].Name+'-'+MoonDataTmpArray[i,j].Name+'.jpg');

          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=MoonDataTmpArray[i,j].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
        end else
        begin           {Set some  kinda Color to the Sphere}
          If ((MoonsLoadFakeTexture.Checked)and
             (FileExists(EarthModelPath+'allfake.jpg'))) then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
             MoonDataTmpArray[i,j].Name,EarthModelPath+'allfake.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=MoonDataTmpArray[i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
        end;
      end;

      DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(SPMoon);
      x:=((PlanetdataTmpArray[i].Radius)/(SolarScaleDivisor))
        +((MoonDataTmpArray[i,j].Radius)/(SolarScaleDivisor))
        +(MoonDataTmpArray[i,j].aDistance/(SolarDistance/MoonScale));  // Ratio of 10 it's for a better view
      y:=0; z:=0;
      DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);
    end;{Moon}

    //----------- Load & Create FFS3ds ------------------------------------------
    SetLength(S3dsDataTmpArray[1,i],PlanetdataTmpArray[i].nbS3ds);
    for j:=0 to PlanetDataTmpArray[i].nbS3ds-1 do
    begin       {  FFS3ds          : TGLFreeForm;}
      BlockRead(f,S3dsDataTmpArray[1,i,j],Sizeof(TMoonRingData));
      DCCenter:=TGLDummyCube.Create(self);
      DCCenter.Name:='DC'+S3dsDataTmpArray[1,i,j].Name;
      DCCenter.TurnAngle:=365/S3dsDataTmpArray[1,i,j].OrbitRotation;
      DCCenter.PitchAngle:=S3dsDataTmpArray[1,i,j].Inclination;
      DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
      inc(Level2Count);
      If (not (FileExists(S3dsDataTmpArray[1,i,j].Name+'.3ds')) ) then
      begin
        ShowMessage(S3dsDataTmpArray[1,i,j].Name+'.3ds'+' Not Found Exiting');
        closefile(f);
        glsceneA.EndUpdate;
        exit;
      End;
      FFS3ds:=TGLS3ds.Create(self);
      with (FFS3ds As TGLS3ds) do
      begin
        ExtraData:=S3dsDataTmpArray[1,i,j];
        Name:='FF'+S3dsDataTmpArray[1,i,j].Name;
      Tag:=8;
      Hint:='1'+inttostr(i)+','+inttostr(j);
        FFS3ds.LoadFromFile(S3dsDataTmpArray[1,i,j].Name);
        Scale.X:=(S3dsDataTmpArray[1,i,j].Radius);
        Scale.Y:=(S3dsDataTmpArray[1,i,j].Radius);
        Scale.Z:=(S3dsDataTmpArray[1,i,j].Radius);
        with Up do begin X:=0;Y:=1.0;Z:=0; end;
        PitchAngle:=S3dsDataTmpArray[1,i,j].AxisTilt;
        TurnAngle:=24/S3dsDataTmpArray[1,i,j].ObjectRotation;
        {a 3ds loads its own Texture...
          but HOW do you KNOW it has One?  it wont be NameMap.jpg !}
        If (S3dsDataTmpArray[1,i,j].S3dsTex)
        then
        begin
          with GLMaterialLibraryA do
          begin
            FFS3ds.Material.MaterialLibrary:=GLMaterialLibraryA;
            libMat:=Materials.Add;
            FFS3ds.Material.LibMaterialName:=libMat.Name;
            libMat.Material.FrontProperties.Diffuse.Red:=0;
           {for i:=0 to Materials.Count-1 do
            with Materials[i].Material do BackProperties.Assign(FrontProperties);}
          end;
        end else
        begin
          If FileExists(EarthModelPath+S3dsDataTmpArray[1,i,j].Name+'.jpg') then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
             S3dsDataTmpArray[1,i,j].Name,EarthModelPath+S3dsDataTmpArray[1,i,j].Name+'.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=S3dsDataTmpArray[1,i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          begin           {Set some  kinda Color to the FFS3ds}
            If ((S3dsLoadFakeTexture.Checked)and
             (FileExists(EarthModelPath+'allfake.jpg'))) then
            begin {Create the matlib}
              GLMaterialLibraryA.AddTextureMaterial(
              S3dsDataTmpArray[1,i,j].Name,EarthModelPath+'allfake.jpg');
              Material.MaterialLibrary:=GLMaterialLibraryA;
              Material.LibMaterialName:=S3dsDataTmpArray[1,i,j].Name;
              Material.Texture.TextureMode:=tmDecal;
              Material.Texture.Disabled:=False;
            end else
            Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
          end;
        end;
      end;

      DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFS3ds);
      x:=(S3dsDataTmpArray[1,i,j].aDistance/(SolarDistance));
      y:=0; z:=0;
      DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);
    end;{FFS3ds}
  end;{Planets}

  (*
  //------- Load & Create Asteroids ---------------------------------
  for i:=0 to SystemDataTmp.NbAsteroid-1 do
  begin
    //------- Asteroids ----------------
    Blockread(f,AsteroidDataTmpArray[i],sizeof(TACDData));
    DCCenter:=TGLDummyCube.Create(self);
    DCCenter.Name:='DC'+AsteroidDataTmpArray[i].Name;
    DCCenter.TurnAngle:=365/AsteroidDataTmpArray[i].OrbitRotation;
    DCCenter.PitchAngle:=AsteroidDataTmpArray[i].Inclination;
    PlanetPickerCB.Items.Add(AsteroidDataTmpArray[i].Name);
    DCSolarSystem.AddChild(DCCenter);
    inc(LevelCount);
    Level2Count:=-1;
    SPAsteroid:=TGLAsteroid.Create(self);
    With (SPAsteroid as TGLAsteroid) do
    begin
      ExtraData:=AsteroidDataTmpArray[i];
      Name:='SP'+AsteroidDataTmpArray[i].Name;
      Tag:=3;
      Hint:=inttostr(i);//+','+inttostr(j);
      Radius:=(AsteroidDataTmpArray[i].Radius)/(SolarScaleDivisor);
      Stacks:=32;
      Slices:=32;
      with Up do begin X:=0;Y:=1.0;Z:=0; end;
      PitchAngle:=AsteroidDataTmpArray[i].AxisTilt;
      TurnAngle:=24/AsteroidDataTmpArray[i].ObjectRotation;
      If FileExists(EarthModelPath+AsteroiddataTmpArray[i].Name+'.jpg') then
      begin {Create the matlib}
        GLMaterialLibraryA.AddTextureMaterial(
             AsteroiddataTmpArray[i].Name,EarthModelPath+AsteroiddataTmpArray[i].Name+'.jpg');

        Material.MaterialLibrary:=GLMaterialLibraryA;
        Material.LibMaterialName:=AsteroiddataTmpArray[i].Name;
        Material.Texture.TextureMode:=tmDecal;
        Material.Texture.Disabled:=False;
      end else
      begin           {Set some  kinda Color to the Sphere}
        If ((AsteroidsLoadFakeTexture.Checked)and
             (FileExists(EarthModelPath+'allfake.jpg'))) then
        begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
          AsteroiddataTmpArray[i].Name,EarthModelPath+'allfake.jpg');
          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=AsteroiddataTmpArray[i].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
        end else
        Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
      end;

      DCSolarSystem.children[LevelCount].AddChild(SPAsteroid);

      // Add must add Orbit eccentricity
      x:=((SundataTmp.Radius)/(SolarScaleDivisor))
      +((AsteroidDataTmpArray[i].Radius)/(SolarScaleDivisor))
      +(AsteroidDataTmpArray[i].aDistance/(SolarDistance));
      y:=0;
      z:=0;
      DCSolarSystem.children[LevelCount].Children[0].Translate(x,y,z);
    end;
    //----------- Load & Create FFS3ds ------------------------------------------
    SetLength(S3dsDataTmpArray[2,i],AsteroiddataTmpArray[i].nbS3ds);
    for j:=0 to AsteroiddataTmpArray[i].nbS3ds-1 do
    begin       //  FFS3ds          : TGLFreeForm;
      BlockRead(f,S3dsDataTmpArray[2,i,j],Sizeof(TMoonRingData));
      DCCenter:=TGLDummyCube.Create(self);
      DCCenter.Name:='DC'+S3dsDataTmpArray[2,i,j].Name;
      DCCenter.TurnAngle:=365/S3dsDataTmpArray[2,i,j].OrbitRotation;
      DCCenter.PitchAngle:=S3dsDataTmpArray[2,i,j].Inclination;
      DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
      inc(Level2Count);
      If (not (FileExists(S3dsDataTmpArray[2,i,j].Name+'.3ds')) ) then
      begin
        ShowMessage(S3dsDataTmpArray[2,i,j].Name+'.3ds'+' Not Found Exiting');
        closefile(f);
        glsceneA.EndUpdate;
        exit;
      End;
      FFS3ds:=TGLS3ds.Create(self);
      with (FFS3ds As TGLS3ds) do
      begin
        ExtraData:=S3dsDataTmpArray[2,i,j];
        Name:='FF'+S3dsDataTmpArray[2,i,j].Name;
      Tag:=8;
      Hint:='2'+inttostr(i)+','+inttostr(j);
        FFS3ds.LoadFromFile(S3dsDataTmpArray[2,i,j].Name);
        Scale.X:=(S3dsDataTmpArray[2,i,j].Radius);
        Scale.Y:=(S3dsDataTmpArray[2,i,j].Radius);
        Scale.Z:=(S3dsDataTmpArray[2,i,j].Radius);
        with Up do begin X:=0;Y:=1.0;Z:=0; end;
        PitchAngle:=S3dsDataTmpArray[2,i,j].AxisTilt;
        TurnAngle:=24/S3dsDataTmpArray[2,i,j].ObjectRotation;
        {a 3ds loads its own Texture...
          but HOW do you KNOW it has One?  it wont be NameMap.jpg !}
        If (S3dsDataTmpArray[2,i,j].S3dsTex)
        then
        begin
          with GLMaterialLibraryA do
          begin
            FFS3ds.Material.MaterialLibrary:=GLMaterialLibraryA;
            libMat:=Materials.Add;
            FFS3ds.Material.LibMaterialName:=libMat.Name;
            libMat.Material.FrontProperties.Diffuse.Red:=0;
            {for i:=0 to Materials.Count-1 do
             with Materials[i].Material do BackProperties.Assign(FrontProperties);}
          end;
        end else
        begin
          If FileExists(EarthModelPath+S3dsDataTmpArray[2,i,j].Name+'.jpg') then
          begin {Create the matlib}
            GLMaterialLibraryA.AddTextureMaterial(
              S3dsDataTmpArray[2,i,j].Name,EarthModelPath+S3dsDataTmpArray[2,i,j].Name+'.jpg');
            Material.MaterialLibrary:=GLMaterialLibraryA;
            Material.LibMaterialName:=S3dsDataTmpArray[2,i,j].Name;
            Material.Texture.TextureMode:=tmDecal;
            Material.Texture.Disabled:=False;
          end else
          begin           {Set some  kinda Color to the FFS3ds}
            If ((S3dsLoadFakeTexture.Checked)and
             (FileExists(EarthModelPath+'allfake.jpg'))) then
            begin {Create the matlib}
              GLMaterialLibraryA.AddTextureMaterial(
              S3dsDataTmpArray[2,i,j].Name,EarthModelPath+'allfake.jpg');
              Material.MaterialLibrary:=GLMaterialLibraryA;
              Material.LibMaterialName:=S3dsDataTmpArray[2,i,j].Name;
              Material.Texture.TextureMode:=tmDecal;
              Material.Texture.Disabled:=False;
            end else
            Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
          end;
        end;
      end;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFS3ds);
        x:=(S3dsDataTmpArray[2,i,j].aDistance/(SolarDistance));
        y:=0; z:=0;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);
    end;   //FFS3ds
  end; //Asteroid
  *)
  (*
  //------- Load & Create NbComet ---------------------------------
  for i:=0 to SystemDataTmp.NbComet-1 do
  begin
    //------- NbComet ----------------
    //Currently Creates a DCCube..Sphere AND Comet Sprites
    Blockread(f,CometDataTmpArray[i],sizeof(TACDData));
    DCCenter:=TGLDummyCube.Create(self);
    DCCenter.Name:='DC'+CometDataTmpArray[i].Name;//+inttostr(i);
    DCCenter.TurnAngle:=365/CometDataTmpArray[i].OrbitRotation;
    DCCenter.PitchAngle:=CometDataTmpArray[i].Inclination;
    PlanetPickerCB.Items.Add(CometDataTmpArray[i].Name);//+inttostr(i));
    DCSolarSystem.AddChild(DCCenter);
    inc(LevelCount);
    Level2Count:=-1;
    {Just do it..Create a Comet Sphere}
    SPComet:=TGLComet.Create(self);
    with (SPComet as TGLComet) do
    begin
      ExtraData:=CometDataTmpArray[i];
      Name:='SP'+CometDataTmpArray[i].Name;//+inttostr(i);
      Tag:=4;
      Hint:=inttostr(i);//+','+inttostr(j);
      Radius:=(CometDataTmpArray[i].Radius)/(SolarScaleDivisor);
      Stacks:=32;
      Slices:=32;
      with Up do
      begin
        X:=0;Y:=1.0;Z:=0;
      end;
      PitchAngle:=CometDataTmpArray[i].AxisTilt;
      TurnAngle:=24/CometDataTmpArray[i].ObjectRotation;
      If FileExists(EarthModelPath+CometDataTmpArray[i].Name+'.jpg') then
      begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
             CometDataTmpArray[i].Name,EarthModelPath+CometDataTmpArray[i].Name+'.jpg');
          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=CometDataTmpArray[i].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
      end else
      begin           {Set some  kinda Color to the Sphere}
        Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
      end;
      DCSolarSystem.children[LevelCount].AddChild(SPComet);
      // Add must add Orbit eccentricity
      x:=((SundataTmp.Radius)/(SolarScaleDivisor))
      +((CometDataTmpArray[i].Radius)/(SolarScaleDivisor))
      +(CometDataTmpArray[i].aDistance/(SolarDistance));
      y:=0;
      z:=0;
      DCSolarSystem.children[LevelCount].Children[0].Translate(x,y,z);

      CometGLMaterialLibrary.Materials[0].Material.Texture.Image.LoadFromFile(EarthModelPath+'_Flare1.bmp');

      if Trunc(CometDataTmpArray[i].RCDType)=1 then
      begin
        {Just show the Fireball}
        DCSolarSystem.children[LevelCount].Children[0].Visible:=False;
        {Add the Fire FX to the Sphere}
        //CometGLMaterialLibrary.Materials[0].Material.Texture.Image.LoadFromFile(EarthModelPath+'_Flare1.bmp');

        for j := 1 to 10 do
        begin
              st := 'boom'+inttostr(j)+'.jpg';
              //st := 'smoke'+inttostr(t)+'.jpg';
              L := CometGLMaterialLibrary.AddTextureMaterial(st,EarthModelPath + st,true);
              L.Material.BlendingMode := bmAdditive;
              L.Material.Texture.Disabled := false;
              L.Material.Texture.ImageAlpha := tiaAlphaFromIntensity;
              L.Material.Texture.TextureMode := tmReplace;
        end;

        ///Fx := TFireFxDummyCubeBase.Create(
        //ParentObject,
        //SpritesParentObject: TGLBaseSceneObject;
        //AOwner: TComponent
        DCSolarSystem.children[LevelCount].Children[0];
        ///DCSolarSystem.children[LevelCount].se Self);
        ///
         ///Fx.FxMatLib := CometGLMaterialLibrary;
         ///Fx.FxMatIndexStart := 0;//0;  //it already has 1
         ///Fx.FxMatIndexEnd := 10;//9;
         ///Fx.FxSpritesCount := 11;
         ///Fx.Tag:=25; //Meaningless, Sprites tagged in UFireFxBase.pas
         //Makevector(Fx.FXStartSize,0.5,0.5,0);

         {
         MakeVector(Fx.FXStartSize,10,10,0);
         }

         //Makevector(Fx.FXDeltaSize,0.001,0.001,0);

         {
         Makevector(Fx.FXDeltaSize,0.01,0.01,0);  //0.001
         Makevector(Fx.FXAccel,105,10,0);     //0,1,0
         }

         //MakeVector(Fx.FXStartSpeed,2,2,2);

         {
         Fx.FxTkEmissiondelay :=80;// 80;
         Fx.FxTkUpdatedelay   := 10;
         Fx.FxMatIndexIncCoeff :=0.01;// 0.01;
         Fx.FXDeltaRotation :=0.2;
         Fx.FxMatRepeatCount := 1;
         Fx.FxEnabled :=true;// not Fx.FxEnabled;
         }
         //GLLightSource1.Shining := Fx.FxEnabled;
         CometFiring:=true;
        end
        else
        if Trunc(CometDataTmpArray[i].RCDType)=2 then
        begin
          //---------- DCComet and Sprite
          // New sprites are created by duplicating the template CometSprite
            {Create Particles PFX for the 'Trail'}
          CometSprite.Visible:=True;
          for j:=1 to trunc(CometDataTmpArray[i].RCDCount) do
          begin   {Real: CometSprite 19 Hint 1}
            spr:=TGLSprite(DCComet.AddNewChild(TGLSprite));
            spr.Assign(CometSprite);
            spr.Name:= CometDataTmpArray[i].Name+inttostr(j{DCComet.Count});
            spr.Hint:=inttostr(j{DCComet.Count});
            spr.Tag:=19;
            spr.Visible:=True;
          end;
          CometSprite.Visible:=False;
          If DCComet.Count>1 then  CometTrailing:=True;
        end;
      end;

      //----------- Load & Create FFS3ds ------------------------------------------
      SetLength(S3dsDataTmpArray[3,i],CometDataTmpArray[i].nbS3ds);
      for j:=0 to CometDataTmpArray[i].nbS3ds-1 do
      begin       {  FFS3ds          : TGLFreeForm;}
        BlockRead(f,S3dsDataTmpArray[3,i,j],Sizeof(TMoonRingData));
        DCCenter:=TGLDummyCube.Create(self);
        DCCenter.Name:='DC'+S3dsDataTmpArray[3,i,j].Name;
        DCCenter.TurnAngle:=365/S3dsDataTmpArray[3,i,j].OrbitRotation;
        DCCenter.PitchAngle:=S3dsDataTmpArray[3,i,j].Inclination;
        DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
        inc(Level2Count);
        if (not (FileExists(S3dsDataTmpArray[3,i,j].Name+'.3ds'))) then
        begin
          ShowMessage(S3dsDataTmpArray[3,i,j].Name+'.3ds'+' Not Found Exiting');
          closefile(f);
          glsceneA.EndUpdate;
          exit;
        end;
        FFS3ds:=TGLS3ds.Create(self);
        with (FFS3ds As TGLS3ds) do
        begin
          ExtraData:=S3dsDataTmpArray[3,i,j];
          Name:='FF'+S3dsDataTmpArray[3,i,j].Name;
          Tag:=8;
          Hint:='3'+inttostr(i)+','+inttostr(j);
          FFS3ds.LoadFromFile(S3dsDataTmpArray[3,i,j].Name);
          Scale.X:=(S3dsDataTmpArray[3,i,j].Radius);
          Scale.Y:=(S3dsDataTmpArray[3,i,j].Radius);
          Scale.Z:=(S3dsDataTmpArray[3,i,j].Radius);
          with Up do
          begin
            X:=0;Y:=1.0;Z:=0;
          end;
          PitchAngle:=S3dsDataTmpArray[3,i,j].AxisTilt;
          TurnAngle:=24/S3dsDataTmpArray[3,i,j].ObjectRotation;
          {a 3ds loads its own Texture...
            but HOW do you KNOW it has One?  it wont be NameMap.jpg !}
          if (S3dsDataTmpArray[3,i,j].S3dsTex)
          then
          begin
            with GLMaterialLibraryA do
            begin
              FFS3ds.Material.MaterialLibrary:=GLMaterialLibraryA;
              libMat:=Materials.Add;
              FFS3ds.Material.LibMaterialName:=libMat.Name;
              libMat.Material.FrontProperties.Diffuse.Red:=0;
             {for i:=0 to Materials.Count-1 do
              with Materials[i].Material do BackProperties.Assign(FrontProperties);}
            end;
          end else
          begin
            if FileExists(EarthModelPath+S3dsDataTmpArray[3,i,j].Name+'.jpg') then
            begin {Create the matlib}
              GLMaterialLibraryA.AddTextureMaterial(
                 S3dsDataTmpArray[3,i,j].Name,EarthModelPath+S3dsDataTmpArray[3,i,j].Name+'.jpg');
              Material.MaterialLibrary:=GLMaterialLibraryA;
              Material.LibMaterialName:=S3dsDataTmpArray[3,i,j].Name;
              Material.Texture.TextureMode:=tmDecal;
              Material.Texture.Disabled:=False;
            end else
            begin           {Set some  kinda Color to the FFS3ds}
              if ((S3dsLoadFakeTexture.Checked)and
                 (FileExists(EarthModelPath+'allfake.jpg'))) then
              begin {Create the matlib}
                GLMaterialLibraryA.AddTextureMaterial(
                 S3dsDataTmpArray[3,i,j].Name,EarthModelPath+'allfake.jpg');
                Material.MaterialLibrary:=GLMaterialLibraryA;
                Material.LibMaterialName:=S3dsDataTmpArray[3,i,j].Name;
                Material.Texture.TextureMode:=tmDecal;
                Material.Texture.Disabled:=False;
              end else
              Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
            end;
          end;
        end;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFS3ds);
        x:=(S3dsDataTmpArray[3,i,j].aDistance/(SolarDistance));
        y:=0; z:=0;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);
      end; //FFS3ds
    end; //NbComet
  *)

    (*
    //------- Load & Create NbDebris ---------------------------------
    for i:=0 to SystemDataTmp.NbDebris-1 do
    begin
      //------- NbDebris ----------------
      {do not need the Sphere...
       and the FF could be hidden inside sun or something}
      Blockread(f,DebrisDataTmpArray[i],sizeof(TACDData));
      DCCenter:=TGLDummyCube.Create(self);
      DCCenter.Name:='DC'+DebrisDataTmpArray[i].Name;
      DCCenter.TurnAngle:=365/DebrisDataTmpArray[i].OrbitRotation;
      DCCenter.PitchAngle:=DebrisDataTmpArray[i].Inclination;
      PlanetPickerCB.Items.Add(DebrisDataTmpArray[i].Name);
      DCSolarSystem.AddChild(DCCenter);
      inc(LevelCount);
      Level2Count:=-1;
      SPDebris:=TGLDebris.Create(self);
      With (SPDebris as TGLDebris) do
      begin
        ExtraData:=DebrisDataTmpArray[i];
        Name:='SP'+DebrisDataTmpArray[i].Name;
        Tag:=5;
        Hint:=inttostr(i);//+','+inttostr(j);
        Radius:=(DebrisDataTmpArray[i].Radius)/(SolarScaleDivisor);
        Stacks:=32;
        Slices:=32;
        with Up do begin X:=0;Y:=1.0;Z:=0; end;
        PitchAngle:=DebrisDataTmpArray[i].AxisTilt;
        TurnAngle:=24/DebrisDataTmpArray[i].ObjectRotation;
        If FileExists(EarthModelPath+DebrisDataTmpArray[i].Name+'.jpg') then
        begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
               DebrisDataTmpArray[i].Name,EarthModelPath+DebrisDataTmpArray[i].Name+'.jpg');

          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=DebrisDataTmpArray[i].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
        end else
        begin           {Set some  kinda Color to the Sphere}
          Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
        end;

        DCSolarSystem.children[LevelCount].AddChild(SPDebris);

        // Add must add Orbit eccentricity
        x:=((SundataTmp.Radius)/(SolarScaleDivisor))
        +((DebrisDataTmpArray[i].Radius)/(SolarScaleDivisor))
        +((DebrisDataTmpArray[i].aDistance/SolarDistance));
        y:=0;
        z:=0;
        DCSolarSystem.children[LevelCount].Children[0].Translate(x,y,z);
        {Create Proxy Asteroids for the Debris Field}
      end;
      {Create a Debris Field from Asteroids}
      {FFDebris  TGLDebrisFreeForm}
      DCCenter:=TGLDummyCube.Create(self);
      DCCenter.Name:='DC'+DebrisDataTmpArray[i].Name+inttostr(i);
      DCCenter.TurnAngle:=365/DebrisDataTmpArray[i].OrbitRotation;
      DCCenter.PitchAngle:=DebrisDataTmpArray[i].Inclination;
      DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
      inc(Level2Count);
      FFDebris:=TGLDebrisFreeForm.Create(self);
      with (FFDebris As TGLDebrisFreeForm) do
      begin
        //ExtraData:=DebrisDataTmpArray[i];
        Name:='FF'+DebrisDataTmpArray[i].Name;
        Tag:=10;
        Hint:=inttostr(i);//+','+inttostr(j);
        Temp:=TGLMeshObject.CreateOwned((FFDebris As TGLDebrisFreeForm){MasterAsteroidF}.MeshObjects);
        BuildPotatoid(Temp,0.5,3,2);
        Scale.X:=          DebrisDataTmpArray[i].RCDXYSize+0.00007;
        //(DebrisDataTmpArray[i].Radius);
        Scale.Y:=DebrisDataTmpArray[i].RCDXYSize+0.00007;
        //(DebrisDataTmpArray[i].Radius);
        Scale.Z:=DebrisDataTmpArray[i].RCDXYSize+0.00007;
        //(DebrisDataTmpArray[i].Radius);
        with Up do begin X:=0;Y:=1.0;Z:=0; end;

        //Top:=Round(DebrisDataTmpArray[i].Mass);
        PitchAngle:=DebrisDataTmpArray[i].AxisTilt;
        TurnAngle:=24/DebrisDataTmpArray[i].ObjectRotation;
        If FileExists(EarthModelPath+DebrisDataTmpArray[i].Name+'.jpg') then
        begin {Create the matlib}
          GLMaterialLibraryA.AddTextureMaterial(
          DebrisDataTmpArray[i].Name,EarthModelPath+DebrisDataTmpArray[i].Name+'.jpg');
          Material.MaterialLibrary:=GLMaterialLibraryA;
          Material.LibMaterialName:=DebrisDataTmpArray[i].Name;
          Material.Texture.TextureMode:=tmDecal;
          Material.Texture.Disabled:=False;
        end else
        begin           {Set some  kinda Color to the Ring}
          Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
          Material.BackProperties.Diffuse.Color:=Material.FrontProperties.Diffuse.Color;
        end;
        Material.FaceCulling:=fcNoCull;
            {Material.BackProperties:=Material.FrontProperties; }
      end;{with FF}
      DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFDebris);
      x:= 0;
          {((PlanetdataTmpArray[i].Radius)/(SolarScaleDivisor))
          +(RingDataTmpArray[i,j].distance/(SolarDistance));}  // Ratio of 10 it's for a better view
      y:=0; z:=0;
      DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);


        {Create Proxy Asteroids for the Debris Field}
      for Proxyi:=1 to trunc(DebrisDataTmpArray[i].RCDCount) do
      begin
          // spawn a FractalTree using proxy objects
         // Proxyr:=Random(round(RingDataTmpArray[i,j].Mass));
          // create a new proxy and set its MasterObject property
        proxy:=TGLProxyObject(DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddNewChild(TGLProxyObject));
        with proxy do
        begin
          ProxyOptions:=[pooObjects];
          MasterObject:=FFDebris;//Asteroids{FreeForm};
          Visible:=True;
          Direction:=FFDebris.Direction;
          Up:=FFDebris.Up;
        Tag:=22;
        Hint:=inttostr(Proxyi);
        Name:=DebrisDataTmpArray[i].Name+inttostr(Proxyi);
          Proxyscale:=Random(Round(DebrisDataTmpArray[i].RCDZSize))+0.00007;
          Scale.x:=FFDebris.Scale.x*Proxyscale;
          Scale.y:=FFDebris.Scale.y*Proxyscale;
          Scale.z:=FFDebris.Scale.z*Proxyscale;
          a:=random*2*pi;
          b:=random*pi-pi/2;
          SinCos(a,s,c);
          SinCos(b,sb,cb);
          {wide circle}
          Position.x:=c*cb*(DebrisDataTmpArray[i].RCDPosition)*random*2 ;
          Position.y:=s*cb*(DebrisDataTmpArray[i].RCDPosition)*random-random ;
          Position.z:=sb*(DebrisDataTmpArray[i].RCDPosition)*random-random ;
          DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[Proxyi].Translate(x,y,z);
            // randomize orientation
          RollAngle:=Random(360);
          TransformationChanged;
        end;{with Proxy}
      end;{for Proxy}
      //for i:=0 to 1 do begin {Test loop}end;

      //----------- Load & Create FFS3ds ------------------------------------------
      SetLength(S3dsDataTmpArray[4,i],DebrisDataTmpArray[i].nbS3ds);
      for j:=0 to DebrisDataTmpArray[i].nbS3ds-1 do
      begin       //  FFS3ds          : TGLFreeForm;
        BlockRead(f,S3dsDataTmpArray[4,i,j],Sizeof(TMoonRingData));
        DCCenter:=TGLDummyCube.Create(self);
        DCCenter.Name:='DC'+S3dsDataTmpArray[4,i,j].Name;
        DCCenter.TurnAngle:=365/S3dsDataTmpArray[4,i,j].OrbitRotation;
        DCCenter.PitchAngle:=S3dsDataTmpArray[4,i,j].Inclination;
        DCSolarSystem.children[LevelCount].children[0].AddChild(DCCenter);
        inc(Level2Count);
        If (not (FileExists(S3dsDataTmpArray[4,i,j].Name+'.3ds')) ) then
        begin
          ShowMessage(S3dsDataTmpArray[4,i,j].Name+'.3ds'+' Not Found Exiting');
          closefile(f);
          glsceneA.EndUpdate;
          exit;
        End;
        FFS3ds:=TGLS3ds.Create(self);
        with (FFS3ds As TGLS3ds) do
        begin
          ExtraData:=S3dsDataTmpArray[4,i,j];
          Name:='FF'+S3dsDataTmpArray[4,i,j].Name;
        Tag:=8;
        Hint:='4'+inttostr(i)+','+inttostr(j);
          FFS3ds.LoadFromFile(S3dsDataTmpArray[4,i,j].Name);
          Scale.X:=(S3dsDataTmpArray[4,i,j].Radius);
          Scale.Y:=(S3dsDataTmpArray[4,i,j].Radius);
          Scale.Z:=(S3dsDataTmpArray[4,i,j].Radius);
          with Up do begin X:=0;Y:=1.0;Z:=0; end;
          PitchAngle:=S3dsDataTmpArray[4,i,j].AxisTilt;
          TurnAngle:=24/S3dsDataTmpArray[4,i,j].ObjectRotation;
          {a 3ds loads its own Texture...
            but HOW do you KNOW it has One?  it wont be NameMap.jpg !}
          If (S3dsDataTmpArray[4,i,j].S3dsTex)
          then
          begin
            with GLMaterialLibraryA do
            begin
              FFS3ds.Material.MaterialLibrary:=GLMaterialLibraryA;
              libMat:=Materials.Add;
              FFS3ds.Material.LibMaterialName:=libMat.Name;
              libMat.Material.FrontProperties.Diffuse.Red:=0;
              {for i:=0 to Materials.Count-1 do
              with Materials[i].Material do BackProperties.Assign(FrontProperties);}
            end;
          end else
          begin
            If FileExists(EarthModelPath+S3dsDataTmpArray[4,i,j].Name+'.jpg') then
            begin {Create the matlib}
              GLMaterialLibraryA.AddTextureMaterial(
               S3dsDataTmpArray[4,i,j].Name,EarthModelPath+S3dsDataTmpArray[4,i,j].Name+'.jpg');
              Material.MaterialLibrary:=GLMaterialLibraryA;
              Material.LibMaterialName:=S3dsDataTmpArray[4,i,j].Name;
              Material.Texture.TextureMode:=tmDecal;
              Material.Texture.Disabled:=False;
            end else
            begin           {Set some  kinda Color to the FFS3ds}
              If ((S3dsLoadFakeTexture.Checked)and
               (FileExists(EarthModelPath+'allfake.jpg'))) then
              begin {Create the matlib}
                GLMaterialLibraryA.AddTextureMaterial(
                S3dsDataTmpArray[4,i,j].Name,EarthModelPath+'allfake.jpg');
                Material.MaterialLibrary:=GLMaterialLibraryA;
                Material.LibMaterialName:=S3dsDataTmpArray[4,i,j].Name;
                Material.Texture.TextureMode:=tmDecal;
                Material.Texture.Disabled:=False;
              end else
              Material.FrontProperties.Diffuse.Color:=ColorArray[Random(11)];{0..10}
            end;
          end;
        end;{FFS3ds}

        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].AddChild(FFS3ds);
        x:=(S3dsDataTmpArray[4,i,j].aDistance/(SolarDistance));
        y:=0; z:=0;
        DCSolarSystem.children[LevelCount].children[0].Children[Level2Count].children[0].Translate(x,y,z);
    end;
  end;  //NbDebris
  *)
  CloseFile(f);
  GLsceneA.EndUpdate;
  GLSceneViewerA.Invalidate;
  SSORG.ItemIndex:=0;
  SunRG.Itemindex:=0;
  PlanetPickerCB.ItemIndex:=0;
  PlanetsLoaded:=True;//To check for S3ds loaded ok
end;


{---------------------------------------------------}
{procedure TABCreatorForm.GLCometParticlesActivateParticle(Sender: TObject;
            particle: TGLBaseSceneObject);
procedure TABCreatorForm.CometSpriteProgress(Sender: TObject;
          const deltaTime,  newTime: Double);}
{---------------------------------------------------}
(*
procedure TABCreatorForm.GLCometParticlesActivateParticle(Sender: TObject;
            particle: TGLBaseSceneObject);
begin
   // this event is called when a particle is activated,
   // ie. just before it will be rendered
   with TGLSprite(particle) do begin
      with Material.FrontProperties do begin
         // we pick a random color
         Emission.Color:=PointMake(Random, Random, Random);
         // our halo starts transparent
         Diffuse.Alpha:=0;
      end;
      // this is our "birth time"
      TagFloat:=GLCadencerA.CurrentTime;
   end;
end;
      {Create Particles PFX for the 'Trail'}
      //CometDataTmpArray[i].Mass
      //CometDataTmpArray[i].Density
      //CometDataTmpArray[i].Albedo
procedure TABCreatorForm.CometSpriteProgress(Sender: TObject;
          const deltaTime,  newTime: Double);
var
   life : Double;
{
Texture Disabled:=FalseTexture Image is (TGLTextureImage)
  ImageClassName  PicFile Image
..\..\media\Flare1.bmp ..flare.jpg has 'corona'
Create in Cadencer NOT Timer..
Use a LIMITED number of particles ?
Life> ? is SET in File Load from some Comet item
Color set from file..+- small random
Position is Set by Current Comet Position...
the Sprites just get dropped off at that location.. the Trail
}
begin
   with TGLSprite(Sender) do begin
      // calculate for how long we've been living
      life:=(newTime-TagFloat);
      {10 is a Variable}
      if life>10 then
         // old particle to kill
         GLCometParticles.KillParticle(TGLSprite(Sender))
      else if life<1 then
         // baby particles become brighter in their 1st second of life...
         Material.FrontProperties.Diffuse.Alpha:=life
      else // ...and slowly disappear in the darkness
                                        {9 is Variable-1}
         Material.FrontProperties.Diffuse.Alpha:=(9-life)/9;
   end;
end;
*)

{---------------------------------------------------}
{---------------------------------------------------}
procedure TABCreatorFrm.SaveBtnClick(Sender: TObject);
begin
  SaveDialog1.Filter:='System Parameter Universal Definition(*.spud)|*.spud';
  SaveDialog1.InitialDir:=ExtractFilePath(EarthModelPath);
  if SaveDialog1.Execute then
  begin
    application.ProcessMessages;
    SaveGLSolarSystem(SaveDialog1.FileName);
  end;
end;
Procedure TABCreatorFrm.SaveGLSolarSystem(filename:string);
var
  i,j:integer;
  F  : file;
begin
  Assignfile(f,filename);
  rewrite(f,1);
  Blockwrite(f,VersionDataTmp,sizeof(TVersionData));
  Blockwrite(f,SystemDataTmp,sizeof(TSystemData));

  Blockwrite(f,SunDataTmp,sizeof(TSunData));
    for j:=0 to SunDataTmp.nbS3ds-1 do
         Blockwrite(f,S3dsDataTmpArray[0,0,j],Sizeof(TMoonRingData));
  for i:=0 to SystemDataTmp.NbPlanet-1 do
  begin
    Blockwrite(f,PlanetdataTmpArray[i],sizeof(TPlanetData));
    for j:=0 to PlanetDataTmpArray[i].nbRings-1 do
         Blockwrite(f,RingDataTmpArray[i,j],Sizeof(TMoonRingData));
    for j:=0 to PlanetDataTmpArray[i].nbmoons-1 do
         Blockwrite(f,MoonDataTmpArray[i,j],Sizeof(TMoonRingData));
    for j:=0 to PlanetDataTmpArray[i].nbS3ds-1 do
         Blockwrite(f,S3dsDataTmpArray[1,i,j],Sizeof(TMoonRingData));
  end;

  for i:=0 to SystemDataTmp.NbAsteroid-1 do
  begin
    Blockwrite(f,AsteroidDataTmpArray[i],sizeof(TACDData));
    for j:=0 to AsteroidDataTmpArray[i].nbS3ds-1 do
         Blockwrite(f,S3dsDataTmpArray[2,i,j],Sizeof(TMoonRingData));
  end;
  for i:=0 to SystemDataTmp.NbComet-1 do
  begin
    Blockwrite(f,CometDataTmpArray[i],sizeof(TACDData));
    for j:=0 to CometDataTmpArray[i].nbS3ds-1 do
         Blockwrite(f,S3dsDataTmpArray[3,i,j],Sizeof(TMoonRingData));
  end;
  for i:=0 to SystemDataTmp.NbDebris-1 do
  begin
    Blockwrite(f,DebrisDataTmpArray[i],sizeof(TACDData));
    for j:=0 to DebrisDataTmpArray[i].nbS3ds-1 do
         Blockwrite(f,S3dsDataTmpArray[4,i,j],Sizeof(TMoonRingData));
  end;
  closefile(f);
end;

procedure TABCreatorFrm.PlanetsRGClick(Sender: TObject);
var tempbool:Boolean;
begin
  {only sun has the scale}
  ScaleDistanceEdit.Visible:= ((SSORG.Itemindex=0)and(SunRG.Itemindex=0));
  ScaleObjectEdit.Visible:= ((SSORG.Itemindex=0)and(SunRG.Itemindex=0));
  {everytjing else has these 2}
  MassEdit.Visible:= (not((SSORG.Itemindex=0)and(SunRG.Itemindex=0)));
  DensityEdit.Visible:= (not((SSORG.Itemindex=0)and(SunRG.Itemindex=0)));
  //Base objects can have S3ds orbiters
  nbS3dsEdit.Visible:=
  ((SSORG.Itemindex=0)and (SunRG.Itemindex=0))
  or((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=0))
  or ((SSORG.Itemindex=2)and(AsteroidRG.Itemindex=0))
  or ((SSORG.Itemindex=3)and(CometRG.Itemindex=0))
  or((SSORG.Itemindex=4)and(DebrisRG.Itemindex=0));
  //Only Planet: Moons and Rings DO NOT have 3ds Anything
  nbS3dLabel.Visible:=
  (not  ((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=1))
   or((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=2)));
  {Only the S3ds object can set the Texture available CB}
  nbS3dsCB.Visible:=
  ((SSORG.Itemindex=0)and (SunRG.Itemindex=1))
  or((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=3))
  or ((SSORG.Itemindex=2)and(AsteroidRG.Itemindex=1))
  or ((SSORG.Itemindex=3)and(CometRG.Itemindex=1))
  or((SSORG.Itemindex=4)and(DebrisRG.Itemindex=1));

  //Sun has NO orbit, but its S3ds does
  OrbitGroupBox.Visible:= ((SSORG.Itemindex>0) or
  ((SSORG.Itemindex=0)and(SunRG.Itemindex=1)));
  //only planets have Rings and moons
  nbMoonsEdit.Visible:= ((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=0));
  MoonsLabel.Visible:= ((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=0));
  nbRingsEdit.Visible:= ((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=0));
  RingsLabel.Visible:= ((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=0));
  //Only  Comets, Debris and Planet:Rings REQUIRE more data

  tempbool:=
  (  ((SSORG.Itemindex=1)and (PlanetsRG.Itemindex=1))
   or((SSORG.Itemindex=3)and (CometRG.Itemindex  =0))
   or((SSORG.Itemindex=4)and (DebrisRG.Itemindex  =0))   );
     RCDTypeEdit.Visible:= tempbool;
     RCDCountEdit.Visible:= tempbool;
     RCDXYSizeEdit.Visible:= tempbool;
     RCDZSizeEdit.Visible:= tempbool;
     RCDPositionEdit.Visible:= tempbool;
end;

procedure TABCreatorFrm.StoreBtnClick(Sender: TObject);
begin
  //GLCadencer1.Enabled:=False;
  Case SSORG.ItemIndex of
  0:
    Case SunRG.ItemIndex of
    0:Begin
      SunDataTmp.SunName  :=(NameEdit.Text);
      SunDataTmp.Radius :=strtofloat(RadiusEdit.Text);
      SunDataTmp.ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      SunDataTmp.AxisTilt :=strtofloat(AxisTiltEdit.Text);
      SunDataTmp.nbS3ds        :=strtoint(nbS3dsEdit.Text);
     SetLength(S3dsDataTmpArray,5,0,0);
     SetLength(S3dsDataTmpArray[0],1,0);
     SetLength(S3dsDataTmpArray[0,0],SunDataTmp.nbS3ds);
      SunDataTmp.DocIndex :=strtoint(DocIndexEdit.Text);
      SunDataTmp.SystemObjectScale :=strtofloat(ScaleObjectEdit.Text);
      SunDataTmp.SystemDistanceScale :=strtofloat(ScaleDistanceEdit.Text);

      SystemDataTmp.NbSun :=1; {Waiting to do Dual Sun Systems...}
      SystemDataTmp.NbPlanet :=PlanetUpDown.Position;
     SetLength(PlanetDataTmpArray,PlanetUpDown.Position);
     SetLength(S3dsDataTmpArray[1],PlanetUpDown.Position);
     SetLength(RingDataTmpArray,PlanetUpDown.Position);
     SetLength(MoonDataTmpArray,PlanetUpDown.Position);
      SystemDataTmp.NbAsteroid :=AsteroidUpDown.Position;
     SetLength(AsteroidDataTmpArray,AsteroidUpDown.Position);
     SetLength(S3dsDataTmpArray[2],AsteroidUpDown.Position);
      SystemDataTmp.NbComet  :=CometUpDown.Position;
     SetLength(CometDataTmpArray,CometUpDown.Position);
     SetLength(S3dsDataTmpArray[3],CometUpDown.Position);
      SystemDataTmp.NbDebris :=DebrisUpDown.Position;
     SetLength(DebrisDataTmpArray,DebrisUpDown.Position);
     SetLength(S3dsDataTmpArray[4],DebrisUpDown.Position);
    end;
    1:
    begin
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Name:=NameEdit.Text;
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].S3dsTex:=nbS3dsCB.Checked;
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Density   :=strtofloat(DensityEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);

      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);

      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
    end;
    end;{SunRG Case}
  1:
    Case PlanetsRG.ItemIndex of
    0:Begin
      PlanetDataTmpArray[PlanetUpDown.Position-1].Name:=NameEdit.Text;
      PlanetDataTmpArray[PlanetUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].nbRings        :=strtoint(nbRingsEdit.Text);
   SetLength(RingDataTmpArray[PlanetUpDown.Position-1],
     PlanetDataTmpArray[PlanetUpDown.Position-1].nbRings);
      PlanetDataTmpArray[PlanetUpDown.Position-1].nbMoons        :=strtoint(nbMoonsEdit.Text);
   SetLength(MoonDataTmpArray[PlanetUpDown.Position-1],
     PlanetDataTmpArray[PlanetUpDown.Position-1].nbMoons);
      PlanetDataTmpArray[PlanetUpDown.Position-1].nbS3ds        :=strtoint(nbS3dsEdit.Text);
   SetLength(S3dsDataTmpArray[1,PlanetUpDown.Position-1],
     PlanetDataTmpArray[PlanetUpDown.Position-1].nbS3ds);
      PlanetDataTmpArray[PlanetUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      PlanetDataTmpArray[PlanetUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);

      PlanetDataTmpArray[PlanetUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      PlanetDataTmpArray[PlanetUpDown.Position-1].Atmosphere :=AtmosphereCB.ItemIndex;
      end;
    1:Begin {  RingDataTmpArray     : Array of Array of  TRingData;}
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Name:=NameEdit.Text;
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);

      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].OrbitRotation            :=strtofloat(OrbitRotationEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);

      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Atmosphere :=AtmosphereCB.ItemIndex;
    end;
    2:Begin   {  MoonDataTmpArray     : Array of Array of  TMoonData;}
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Name:=NameEdit.Text;
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].OrbitRotation            :=strtofloat(OrbitRotationEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].nLongitudeVar    :=strtofloat(nvarEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].wPerihelionVar    :=strtofloat(wvarEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].mAnomalyVar    :=strtofloat(mvarEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
    end;
    3:Begin   {  S3dsDataTmpArray     :Array of Array of Array of  TMoonData;}
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Name:=NameEdit.Text;
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].S3dsTex:=nbS3dsCB.Checked;
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);

      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].OrbitRotation     :=strtofloat(OrbitRotationEdit.Text);

      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
    end;
    end;
  2:
    Case AsteroidRG.ItemIndex of
    0:Begin    {AsteroidDataTmpArray   : Array of TMoonData;}
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Name:=NameEdit.Text;
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].nbS3ds        :=strtoint(nbS3dsEdit.Text);
   SetLength(S3dsDataTmpArray[2,AsteroidUpDown.Position-1],
     AsteroidDataTmpArray[AsteroidUpDown.Position-1].nbS3ds);

      AsteroidDataTmpArray[AsteroidUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);


      AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);

      AsteroidDataTmpArray[AsteroidUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      AsteroidDataTmpArray[AsteroidUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
    end;
    1:Begin   {  S3dsDataTmpArray     :Array of Array of Array of  TMoonData;}
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Name:=NameEdit.Text;
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].S3dsTex:=nbS3dsCB.Checked;
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);

      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
    end;
    end;
  3:
    Case CometRG.ItemIndex of
    0:Begin
   {CometDataTmpArray   : Array of TMoonData;}
      CometDataTmpArray[CometUpDown.Position-1].Name:=NameEdit.Text;
      CometDataTmpArray[CometUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].nbS3ds        :=strtoint(nbS3dsEdit.Text);
   SetLength(S3dsDataTmpArray[3,
     CometUpDown.Position-1],
     CometDataTmpArray[CometUpDown.Position-1].nbS3ds);
      CometDataTmpArray[CometUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      CometDataTmpArray[CometUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      CometDataTmpArray[CometUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);

      CometDataTmpArray[CometUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
      CometDataTmpArray[CometUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      CometDataTmpArray[CometUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
    End;
    1:Begin   {  S3dsDataTmpArray     :Array of Array of Array of  TMoonData;}
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Name:=NameEdit.Text;
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].S3dsTex:=nbS3dsCB.Checked;
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);

      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);

      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
    end;
    end;
  4:
    Case DebrisRG.ItemIndex of
    0:Begin
    {DebrisDataTmpArray   : Array of TMoonData;}
      DebrisDataTmpArray[DebrisUpDown.Position-1].Name:=NameEdit.Text;
      DebrisDataTmpArray[DebrisUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].nbS3ds        :=strtoint(nbS3dsEdit.Text);
   SetLength(S3dsDataTmpArray[4,
     DebrisUpDown.Position-1],
     DebrisDataTmpArray[DebrisUpDown.Position-1].nbS3ds);
      DebrisDataTmpArray[DebrisUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      DebrisDataTmpArray[DebrisUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);

      DebrisDataTmpArray[DebrisUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
      DebrisDataTmpArray[DebrisUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      DebrisDataTmpArray[DebrisUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
    End;
    1:Begin   {  S3dsDataTmpArray     :Array of Array of Array of  TMoonData;}
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Name:=NameEdit.Text;
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Radius       :=strtofloat(RadiusEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].ObjectRotation :=strtofloat(ObjectRotationEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].AxisTilt       :=strtofloat(AxisTiltEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].S3dsTex:=nbS3dsCB.Checked;
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].DocIndex        :=strtoint(DocIndexEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Mass            :=strtofloat(MassEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Density            :=strtofloat(DensityEdit.Text);

      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDType            :=strtoint(RCDTypeEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDCount            :=strtoint(RCDCountEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDXYSize            :=strtofloat(RCDXYSizeEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDZSize            :=strtofloat(RCDZSizeEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDPosition            :=strtofloat(RCDPositionEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Albedo            :=strtofloat(AlbedoEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].OrbitRotation  :=strtofloat(OrbitRotationEdit.Text);

      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].aDistance       :=strtofloat(aConstEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].aDistanceVar       :=strtofloat(aVarEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Inclination    :=strtofloat(iConstEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].InclinationVar    :=strtofloat(iVarEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Eccentricity    :=strtofloat(eConstEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].EVar            :=strtofloat(EvarEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].EMax           :=strtofloat(EMaxEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].nLongitude    :=strtofloat(nConstEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].nLongitudeVar    :=strtofloat(nVarEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].wPerihelion    :=strtofloat(wConstEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].wPerihelionVar    :=strtofloat(wVarEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].mAnomaly    :=strtofloat(mConstEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].mAnomalyVar    :=strtofloat(mVarEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].VelocityType     :=strtoint(VelocityTypeEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Velocity     :=strtofloat(VelocityEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].VelocityDir     :=strtofloat(VelocityDirEdit.Text);
      S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Atmosphere:=AtmosphereCB.ItemIndex;
    end;
    end;
  end;
end;


procedure TABCreatorFrm.ShowBtnClick(Sender: TObject);
begin {a Brainiac could Get Save and Set the data...}
nbS3dsCB.Checked:=False;{S3dsTex}
  Case SSORG.ItemIndex of
  0:
    Case SunRG.ItemIndex of
    0:Begin
      NameEdit.Text:=SunDataTmp.SunName;
      RadiusEdit.Text:=Floattostr(SunDataTmp.Radius);
      ObjectRotationEdit.Text:= Floattostr(SunDataTmp.ObjectRotation);
      AxisTiltEdit.Text:= Floattostr(SunDataTmp.AxisTilt);
      SS3dsUpDown.Position:=SunDataTmp.NbS3ds;
      nbS3dsEdit.Text:= Inttostr(SunDataTmp.NbS3ds);
      DocIndexEdit.Text:= Inttostr(SunDataTmp.DocIndex);
      ScaleObjectEdit.Text:= Floattostr(SunDataTmp.SystemObjectScale);
      ScaleDistanceEdit.Text:= Floattostr(SunDataTmp.SystemDistanceScale);
      PlanetUpDown.Position:=SystemDataTmp.NbPlanet;
      AsteroidUpDown.Position:=SystemDataTmp.NbAsteroid;
      CometUpDown.Position:=SystemDataTmp.NbComet;
      DebrisUpDown.Position:=SystemDataTmp.NbDebris;
    end;
    1:Begin {  S3dsDataTmpArray     :Array of Array of Array of  S3dsDataTmpArray;}
      NameEdit.Text:=S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].AxisTilt);
      nbS3dsCB.Checked:=S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].S3dsTex;
      DocIndexEdit.Text:= Inttostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= Floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= Floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= Floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].EMax);

      NConstEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].nLongitude);
      NVarEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].wPerihelionVar);
      MConstEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].mAnomaly);
      MVarEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].mAnomalyVar);


      VelocityTypeEdit.Text:= Inttostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= S3dsDataTmpArray[0,0,SS3dsUpDown.Position-1].Atmosphere;
    end;
  end;
  1:
    Case PlanetsRG.ItemIndex of
    0:Begin
      NameEdit.Text:=PlanetDataTmpArray[PlanetUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].AxisTilt);
      nbRingsEdit.Text:= inttostr(PlanetDataTmpArray[PlanetUpDown.Position-1].nbRings);
      nbMoonsEdit.Text:= inttostr(PlanetDataTmpArray[PlanetUpDown.Position-1].nbMoons);
      nbS3dsEdit.Text:= Inttostr(PlanetDataTmpArray[PlanetUpDown.Position-1].NbS3ds);
      DocIndexEdit.Text:= Inttostr(PlanetDataTmpArray[PlanetUpDown.Position-1].DocIndex);

      AlbedoEdit.Text:= Floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].EMax);
      NConstEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].nLongitude);
      NVarEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].wPerihelionVar);
      MConstEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].mAnomaly);
      MVarEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= Inttostr(PlanetDataTmpArray[PlanetUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(PlanetDataTmpArray[PlanetUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= PlanetDataTmpArray[PlanetUpDown.Position-1].Atmosphere;
    end;
    1:Begin {  RingDataTmpArray     : Array of Array of  TRingData;}
      NameEdit.Text:=RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].AxisTilt);
      {S3dsTex}
      DocIndexEdit.Text:= Inttostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].EMax);
      NConstEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].nLongitude);
      NVarEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= Inttostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= RingDataTmpArray[PlanetUpDown.Position-1,RingsUpDown.Position-1].Atmosphere;
    end;
    2:Begin   {  MoonDataTmpArray     : Array of Array of  TMoonData;}
      NameEdit.Text:=MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].AxisTilt);
      {S3dsTex}
      DocIndexEdit.Text:= Inttostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].EMax);
      nConstEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].nLongitude);
      nVarEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= Inttostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= MoonDataTmpArray[PlanetUpDown.Position-1,MoonsUpDown.Position-1].Atmosphere;
    end;
    3:Begin   {  S3dsDataTmpArray     :Array of Array of Array of  S3dsDataTmpArray;}
      NameEdit.Text:=S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].AxisTilt);
      nbS3dsCB.Checked:=S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].S3dsTex;
      DocIndexEdit.Text:= Inttostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].EMax);
      nConstEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].nLongitude);
      nVarEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= Inttostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= S3dsDataTmpArray[1,PlanetUpDown.Position-1,PS3dsUpDown.Position-1].Atmosphere;
    end;
  end;
  2:
    Case AsteroidRG.ItemIndex of
    0:begin   {AsteroidDataTmpArray   : Array of ;}
      NameEdit.Text:=AsteroidDataTmpArray[AsteroidUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].AxisTilt);
      nbS3dsEdit.Text:= Inttostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].NbS3ds);
      DocIndexEdit.Text:= Inttostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].RCDPosition);


      AlbedoEdit.Text:= Floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].EMax);
      nConstEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].nLongitude);
      nVarEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= Inttostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(AsteroidDataTmpArray[AsteroidUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= AsteroidDataTmpArray[AsteroidUpDown.Position-1].Atmosphere;
    end;
    1:begin
      NameEdit.Text:=S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].AxisTilt);
      nbS3dsCB.Checked:=S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].S3dsTex;
      DocIndexEdit.Text:= Inttostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].EMax);
      nConstEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].nLongitude);
      nVarEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].mAnomalyVar);

      VelocityTypeEdit.Text:= Inttostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= S3dsDataTmpArray[2,AsteroidUpDown.Position-1,AS3dsUpDown.Position-1].Atmosphere;
    end;
  end;
  3:
    case CometRG.ItemIndex of
    0:begin  {CometDataTmpArray   : Array of TMoonData;}
      NameEdit.Text:=CometDataTmpArray[CometUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(CometDataTmpArray[CometUpDown.Position-1].AxisTilt);
      nbS3dsEdit.Text:= Inttostr(CometDataTmpArray[CometUpDown.Position-1].NbS3ds);
      DocIndexEdit.Text:= Inttostr(CometDataTmpArray[CometUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(CometDataTmpArray[CometUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(CometDataTmpArray[CometUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= Floattostr(CometDataTmpArray[CometUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= Floattostr(CometDataTmpArray[CometUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= Floattostr(CometDataTmpArray[CometUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(CometDataTmpArray[CometUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].EMax);
      VelocityTypeEdit.Text:= Inttostr(CometDataTmpArray[CometUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(CometDataTmpArray[CometUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(CometDataTmpArray[CometUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(CometDataTmpArray[CometUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= CometDataTmpArray[CometUpDown.Position-1].Atmosphere;
    end;
    1:begin
      NameEdit.Text:=S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].AxisTilt);
      nbS3dsCB.Checked:=S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].S3dsTex;
      DocIndexEdit.Text:= Inttostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].EMax);
      nConstEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].nLongitude);
      nVarEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= Inttostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= S3dsDataTmpArray[3,CometUpDown.Position-1,CS3dsUpDown.Position-1].Atmosphere;
    end;
  end;
  4:
    case DebrisRG.ItemIndex of
    0:begin    {DebrisDataTmpArray   : Array of TMoonData;}
      NameEdit.Text:=DebrisDataTmpArray[DebrisUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].AxisTilt);
      nbS3dsEdit.Text:= Inttostr(DebrisDataTmpArray[DebrisUpDown.Position-1].NbS3ds);
      DocIndexEdit.Text:= Inttostr(DebrisDataTmpArray[DebrisUpDown.Position-1].DocIndex);

      RCDTypeEdit.Text:= Inttostr(DebrisDataTmpArray[DebrisUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(DebrisDataTmpArray[DebrisUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].EMax);
      nConstEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].nLongitude);
      nVarEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].nLongitudeVar);
      wConstEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].wPerihelion);
      wVarEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].wPerihelionVar);
      mConstEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].mAnomaly);
      mVarEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].mAnomalyVar);
      VelocityTypeEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(DebrisDataTmpArray[DebrisUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= DebrisDataTmpArray[DebrisUpDown.Position-1].Atmosphere;
    End;
    1:Begin
      NameEdit.Text:=S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Name;
      RadiusEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Radius);
      ObjectRotationEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].ObjectRotation) ;
      AxisTiltEdit.Text:=  floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].AxisTilt);
      nbS3dsCB.Checked:=S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].S3dsTex;
      DocIndexEdit.Text:= Inttostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].DocIndex);


      RCDTypeEdit.Text:= Inttostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDType);
      RCDCountEdit.Text:= Inttostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDCount);
      RCDXYSizeEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDXYSize);
      RCDZSizeEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDZSize);
      RCDPositionEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].RCDPosition);

      AlbedoEdit.Text:= Floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Albedo);
      OrbitRotationEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].OrbitRotation);
      aConstEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].aDistance);
      aVarEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].aDistanceVar);
      iConstEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Inclination);
      iVarEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].InclinationVar);
      eConstEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Eccentricity);
      EvarEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].EVar);
      EMaxEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].EMax);
      VelocityTypeEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].VelocityType);
      VelocityEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Velocity);
      VelocityDirEdit.Text:= floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].VelocityDir);
      MassEdit.Text:= Floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Mass);
      DensityEdit.Text:= Floattostr(S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Density);
      AtmosphereCB.ItemIndex:= S3dsDataTmpArray[4,DebrisUpDown.Position-1,DS3dsUpDown.Position-1].Atmosphere;
    end;
  end;
  end;
end;





{Save info as a Text file
 and Call System to Open THAT... to print or ?}
procedure TABCreatorFrm.PrintBtnClick(Sender: TObject);
var
  i,j:Integer;
  F: TextFile;
begin
  AssignFile(F,EarthModelPath+'Spud.txt');
  Rewrite(F);
  Writeln(F,'System.NbSun: '+ inttostr(SystemDataTmp.NbSun));
  Writeln(F,'System.NbPlanet: '+ inttostr(SystemDataTmp.NbPlanet));
  Writeln(F,'System.NbAsteroid: '+ inttostr(SystemDataTmp.NbAsteroid));
  Writeln(F,'System.NbComet: '+ inttostr(SystemDataTmp.NbComet));
  Writeln(F,'System.NbDebris: '+ inttostr(SystemDataTmp.NbDebris));

  Writeln(F,'Sun.SunName: '+ (SunDataTmp.SunName));
  Writeln(F,'Sun.Radius: '+ Floattostr(SunDataTmp.Radius));
  Writeln(F,'Sun.ObjectRotation: '+ Floattostr(SunDataTmp.ObjectRotation));
  Writeln(F,'Sun.AxisTilt: '+ Floattostr(SunDataTmp.AxisTilt));
  Writeln(F,'Sun.DocIndex: '+ inttostr(SunDataTmp.DocIndex));
  Writeln(F,'Sun.SystemObjectScale: '+ Floattostr(SunDataTmp.SystemObjectScale));
  Writeln(F,'Sun.SystemDistanceScale: '+ Floattostr(SunDataTmp.SystemDistanceScale));
  Writeln(F,'Sun.Number of S3ds: '+ inttostr(SunDataTmp.nbS3ds));
    for j:=0 to SunDataTmp.nbS3ds-1 do
    begin
     Writeln(F,'Sun S3ds'+inttostr(j)+'.Name: '+ (S3dsDataTmpArray[0,0,j].Name));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Radius: '+ Floattostr(S3dsDataTmpArray[0,0,j].Radius));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.ObjectRotation: '+ Floattostr(S3dsDataTmpArray[0,0,j].ObjectRotation));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.AxisTilt: '+ Floattostr(S3dsDataTmpArray[0,0,j].AxisTilt));
      If (S3dsDataTmpArray[0,0,j].S3dsTex) then
         Writeln(F,'Sun S3ds'+inttostr(j)+'.S3ds Textured: True')
         else Writeln(F,'Sun S3ds'+inttostr(j)+'.S3ds Textured: False');
      Writeln(F,'Sun S3ds'+inttostr(j)+'.DocIndex: '+ Floattostr(S3dsDataTmpArray[0,0,j].DocIndex));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Mass: '+ Floattostr(S3dsDataTmpArray[0,0,j].Mass));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Density: '+ Floattostr(S3dsDataTmpArray[0,0,j].Density));

      Writeln(F,'Sun. S3ds RCDType: '+ inttostr(S3dsDataTmpArray[0,0,j].RCDType));
      Writeln(F,'Sun. S3ds RCDCount: '+ inttostr(S3dsDataTmpArray[0,0,j].RCDCount));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.RCDXYSize: '+ Floattostr(S3dsDataTmpArray[0,0,j].RCDXYSize));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.RCDZSize: '+ Floattostr(S3dsDataTmpArray[0,0,j].RCDZSize));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.RCDPosition: '+ Floattostr(S3dsDataTmpArray[0,0,j].RCDPosition));

      Writeln(F,'Sun S3ds'+inttostr(j)+'.Albedo: '+ Floattostr(S3dsDataTmpArray[0,0,j].Albedo));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.OrbitRotation: '+ Floattostr(S3dsDataTmpArray[0,0,j].OrbitRotation));

      Writeln(F,'Sun S3ds'+inttostr(j)+'.Distance: '+ Floattostr(S3dsDataTmpArray[0,0,j].aDistance));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Distance Var: '+ Floattostr(S3dsDataTmpArray[0,0,j].aDistanceVar));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Inclination: '+ Floattostr(S3dsDataTmpArray[0,0,j].Inclination));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Inclination Var: '+ Floattostr(S3dsDataTmpArray[0,0,j].InclinationVar));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Eccentricity: '+ Floattostr(S3dsDataTmpArray[0,0,j].Eccentricity));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.EMin Per: '+ Floattostr(S3dsDataTmpArray[0,0,j].EVar));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.EMax Ape: '+ Floattostr(S3dsDataTmpArray[0,0,j].EMax));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.nLongitude: '+ Floattostr(S3dsDataTmpArray[0,0,j].nLongitude));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.nLongitude Var: '+ Floattostr(S3dsDataTmpArray[0,0,j].nLongitudeVar));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.wPerihelion: '+ Floattostr(S3dsDataTmpArray[0,0,j].wPerihelion));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(S3dsDataTmpArray[0,0,j].wPerihelionVar));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.mAnomaly: '+ Floattostr(S3dsDataTmpArray[0,0,j].mAnomaly));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(S3dsDataTmpArray[0,0,j].mAnomalyVar));

      Writeln(F,'Sun S3ds'+inttostr(j)+'.Atmosphere: '+ inttostr(S3dsDataTmpArray[0,0,j].Atmosphere));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Velocity Type: '+ Floattostr(S3dsDataTmpArray[0,0,j].VelocityType));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Velocity: '+ Floattostr(S3dsDataTmpArray[0,0,j].Velocity));
      Writeln(F,'Sun S3ds'+inttostr(j)+'.Velocity Dir: '+ Floattostr(S3dsDataTmpArray[0,0,j].VelocityDir));
    end;

  for i:=0 to SystemDataTmp.NbPlanet-1 do
  begin
    Writeln(F,'Planet'+inttostr(i)+'.Name: '+ (PlanetDataTmpArray[i].Name));
    Writeln(F,'Planet'+inttostr(i)+'.Radius: '+ Floattostr(PlanetDataTmpArray[i].Radius));
    Writeln(F,'Planet'+inttostr(i)+'.ObjectRotation: '+ Floattostr(PlanetDataTmpArray[i].ObjectRotation));
    Writeln(F,'Planet'+inttostr(i)+'.AxisTilt: '+ Floattostr(PlanetDataTmpArray[i].AxisTilt));
    Writeln(F,'Planet'+inttostr(i)+'.nbRings: '+ Floattostr(PlanetDataTmpArray[i].nbRings));
    Writeln(F,'Planet'+inttostr(i)+'.nbMoons: '+ Floattostr(PlanetDataTmpArray[i].nbMoons));
    Writeln(F,'Planet'+inttostr(i)+'.nbS3ds: '+ inttostr(PlanetDataTmpArray[i].nbS3ds));
    Writeln(F,'Planet'+inttostr(i)+'.DocIndex: '+ Floattostr(PlanetDataTmpArray[i].DocIndex));
    Writeln(F,'Planet'+inttostr(i)+'.Mass: '+ Floattostr(PlanetDataTmpArray[i].Mass));
    Writeln(F,'Planet'+inttostr(i)+'.Density: '+ Floattostr(PlanetDataTmpArray[i].Density));


    Writeln(F,'Planet'+inttostr(i)+'.Albedo: '+ Floattostr(PlanetDataTmpArray[i].Albedo));
    Writeln(F,'Planet'+inttostr(i)+'.OrbitRotation: '+ Floattostr(PlanetDataTmpArray[i].OrbitRotation));

    Writeln(F,'Planet'+inttostr(i)+'.Distance: '+ Floattostr(PlanetDataTmpArray[i].aDistance));
    Writeln(F,'Planet'+inttostr(i)+'.Distance Var: '+ Floattostr(PlanetDataTmpArray[i].aDistanceVar));
    Writeln(F,'Planet'+inttostr(i)+'.Inclination: '+ Floattostr(PlanetDataTmpArray[i].Inclination));
    Writeln(F,'Planet'+inttostr(i)+'.Inclination Var: '+ Floattostr(PlanetDataTmpArray[i].InclinationVar));
    Writeln(F,'Planet'+inttostr(i)+'.Eccentricity: '+ Floattostr(PlanetDataTmpArray[i].Eccentricity));
    Writeln(F,'Planet'+inttostr(i)+'.EMin Per: '+ Floattostr(PlanetDataTmpArray[i].EVar));
    Writeln(F,'Planet'+inttostr(i)+'.EMax Ape: '+ Floattostr(PlanetDataTmpArray[i].EMax));
    Writeln(F,'Planet'+inttostr(i)+'.nLongitude: '+ Floattostr(PlanetDataTmpArray[i].nLongitude));
    Writeln(F,'Planet'+inttostr(i)+'.nLongitude Var: '+ Floattostr(PlanetDataTmpArray[i].nLongitudeVar));
    Writeln(F,'Planet'+inttostr(i)+'.wPerihelion: '+ Floattostr(PlanetDataTmpArray[i].wPerihelion));
    Writeln(F,'Planet'+inttostr(i)+'.wPerihelion Var: '+ Floattostr(PlanetDataTmpArray[i].wPerihelionVar));
    Writeln(F,'Planet'+inttostr(i)+'.mAnomaly: '+ Floattostr(PlanetDataTmpArray[i].mAnomaly));
    Writeln(F,'Planet'+inttostr(i)+'.mAnomaly Var: '+ Floattostr(PlanetDataTmpArray[i].mAnomalyVar));

    Writeln(F,'Planet'+inttostr(i)+'.Atmosphere: '+ inttostr(PlanetDataTmpArray[i].Atmosphere));
    Writeln(F,'Planet'+inttostr(i)+'.Velocity Type: '+ inttostr(PlanetDataTmpArray[i].VelocityType));
    Writeln(F,'Planet'+inttostr(i)+'.Velocity: '+ Floattostr(PlanetDataTmpArray[i].Velocity));
    Writeln(F,'Planet'+inttostr(i)+'.Velocity Dir: '+ Floattostr(PlanetDataTmpArray[i].VelocityDir));

    for j:=0 to PlanetDataTmpArray[i].nbRings-1 do
    begin
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Name: '+ (RingDataTmpArray[i,j].Name));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Radius: '+ Floattostr(RingDataTmpArray[i,j].Radius));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.ObjectRotation: '+ Floattostr(RingDataTmpArray[i,j].ObjectRotation));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.AxisTilt: '+ Floattostr(RingDataTmpArray[i,j].AxisTilt));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.DocIndex: '+ Floattostr(RingDataTmpArray[i,j].DocIndex));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Mass: '+ Floattostr(RingDataTmpArray[i,j].Mass));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Density: '+ Floattostr(RingDataTmpArray[i,j].Density));

      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+' RCDType: '+ inttostr(RingDataTmpArray[i,j].RCDType));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+' RCDCount: '+ inttostr(RingDataTmpArray[i,j].RCDCount));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'RCDXYSize: '+ Floattostr(RingDataTmpArray[i,j].RCDXYSize));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'RCDZSize: '+ Floattostr(RingDataTmpArray[i,j].RCDZSize));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'RCDPosition: '+ Floattostr(RingDataTmpArray[i,j].RCDPosition));

      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Albedo: '+ Floattostr(RingDataTmpArray[i,j].Albedo));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.OrbitRotation: '+ Floattostr(RingDataTmpArray[i,j].OrbitRotation));

      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Distance: '+ Floattostr(RingDataTmpArray[i,j].aDistance));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Distance Var: '+ Floattostr(RingDataTmpArray[i,j].aDistanceVar));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Inclination: '+ Floattostr(RingDataTmpArray[i,j].Inclination));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Inclination Var: '+ Floattostr(RingDataTmpArray[i,j].InclinationVar));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Eccentricity: '+ Floattostr(RingDataTmpArray[i,j].Eccentricity));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.EMin Per: '+ Floattostr(RingDataTmpArray[i,j].EVar));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.EMax Ape: '+ Floattostr(RingDataTmpArray[i,j].EMax));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.nLongitude: '+ Floattostr(RingDataTmpArray[i,j].nLongitude));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.nLongitude Var: '+ Floattostr(RingDataTmpArray[i,j].nLongitudeVar));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.wPerihelion: '+ Floattostr(RingDataTmpArray[i,j].wPerihelion));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(RingDataTmpArray[i,j].wPerihelionVar));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.mAnomaly: '+ Floattostr(RingDataTmpArray[i,j].mAnomaly));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(RingDataTmpArray[i,j].mAnomalyVar));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Atmosphere: '+ inttostr(RingDataTmpArray[i,j].Atmosphere));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Velocity Type: '+ inttostr(RingDataTmpArray[i,j].VelocityType));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Velocity: '+ Floattostr(RingDataTmpArray[i,j].Velocity));
      Writeln(F,'Planet'+inttostr(i)+' Ring'+inttostr(j)+'.Velocity Dir: '+ Floattostr(RingDataTmpArray[i,j].VelocityDir));
    end;
    for j:=0 to PlanetDataTmpArray[i].nbmoons-1 do
    begin
     Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.PlanetName: '+ (MoonDataTmpArray[i,j].Name));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Radius: '+ Floattostr(MoonDataTmpArray[i,j].Radius));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.ObjectRotation: '+ Floattostr(MoonDataTmpArray[i,j].ObjectRotation));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.AxisTilt: '+ Floattostr(MoonDataTmpArray[i,j].AxisTilt));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.DocIndex: '+ inttostr(MoonDataTmpArray[i,j].DocIndex));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Mass: '+ Floattostr(MoonDataTmpArray[i,j].Mass));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Density: '+ Floattostr(MoonDataTmpArray[i,j].Density));

      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+' RCDType: '+ inttostr(MoonDataTmpArray[i,j].RCDType));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+' RCDCount: '+ inttostr(MoonDataTmpArray[i,j].RCDCount));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'RCDXYSize: '+ Floattostr(MoonDataTmpArray[i,j].RCDXYSize));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'RCDZSize: '+ Floattostr(MoonDataTmpArray[i,j].RCDZSize));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'RCDPosition: '+ Floattostr(MoonDataTmpArray[i,j].RCDPosition));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Albedo: '+ Floattostr(MoonDataTmpArray[i,j].Albedo));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.OrbitRotation: '+ Floattostr(MoonDataTmpArray[i,j].OrbitRotation));

      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Distance: '+ Floattostr(MoonDataTmpArray[i,j].aDistance));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Distance Var: '+ Floattostr(MoonDataTmpArray[i,j].aDistanceVar));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Inclination: '+ Floattostr(MoonDataTmpArray[i,j].Inclination));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Inclination Var: '+ Floattostr(MoonDataTmpArray[i,j].InclinationVar));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Eccentricity: '+ Floattostr(MoonDataTmpArray[i,j].Eccentricity));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.EMin Per: '+ Floattostr(MoonDataTmpArray[i,j].EVar));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.EMax Ape: '+ Floattostr(MoonDataTmpArray[i,j].EMax));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.nLongitude: '+ Floattostr(MoonDataTmpArray[i,j].nLongitude));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.nLongitude Var: '+ Floattostr(MoonDataTmpArray[i,j].nLongitudeVar));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.wPerihelion: '+ Floattostr(MoonDataTmpArray[i,j].wPerihelion));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(MoonDataTmpArray[i,j].wPerihelionVar));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.mAnomaly: '+ Floattostr(MoonDataTmpArray[i,j].mAnomaly));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(MoonDataTmpArray[i,j].mAnomalyVar));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Atmosphere: '+ inttostr(MoonDataTmpArray[i,j].Atmosphere));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Velocity Type: '+ inttostr(MoonDataTmpArray[i,j].VelocityType));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Velocity: '+ Floattostr(MoonDataTmpArray[i,j].Velocity));
      Writeln(F,'Planet'+inttostr(i)+' Moon'+inttostr(j)+'.Velocity Dir: '+ Floattostr(MoonDataTmpArray[i,j].VelocityDir));
    end;
    for j:=0 to PlanetDataTmpArray[i].nbS3ds-1 do
    begin
     Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Name: '+ (S3dsDataTmpArray[1,i,j].Name));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Radius: '+ Floattostr(S3dsDataTmpArray[1,i,j].Radius));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.ObjectRotation: '+ Floattostr(S3dsDataTmpArray[1,i,j].ObjectRotation));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.AxisTilt: '+ Floattostr(S3dsDataTmpArray[1,i,j].AxisTilt));
      If (S3dsDataTmpArray[1,i,j].S3dsTex) then
         Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: True')
         else Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: False');
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.DocIndex: '+ Floattostr(S3dsDataTmpArray[1,i,j].DocIndex));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Mass: '+ Floattostr(S3dsDataTmpArray[1,i,j].Mass));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Density: '+ Floattostr(S3dsDataTmpArray[1,i,j].Density));

      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+' RCDType: '+ inttostr(S3dsDataTmpArray[1,i,j].RCDType));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+' RCDCount: '+ inttostr(S3dsDataTmpArray[1,i,j].RCDCount));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'RCDXYSize: '+ Floattostr(S3dsDataTmpArray[1,i,j].RCDXYSize));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'RCDZSize: '+ Floattostr(S3dsDataTmpArray[1,i,j].RCDZSize));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'RCDPosition: '+ Floattostr(S3dsDataTmpArray[1,i,j].RCDPosition));

      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Albedo: '+ Floattostr(S3dsDataTmpArray[1,i,j].Albedo));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.OrbitRotation: '+ Floattostr(S3dsDataTmpArray[1,i,j].OrbitRotation));

      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance: '+ Floattostr(S3dsDataTmpArray[1,i,j].aDistance));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance Var: '+ Floattostr(S3dsDataTmpArray[1,i,j].aDistanceVar));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination: '+ Floattostr(S3dsDataTmpArray[1,i,j].Inclination));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination Var: '+ Floattostr(S3dsDataTmpArray[1,i,j].InclinationVar));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Eccentricity: '+ Floattostr(S3dsDataTmpArray[1,i,j].Eccentricity));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.EMin Per: '+ Floattostr(S3dsDataTmpArray[1,i,j].EVar));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.EMax Ape: '+ Floattostr(S3dsDataTmpArray[1,i,j].EMax));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude: '+ Floattostr(S3dsDataTmpArray[1,i,j].nLongitude));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude Var: '+ Floattostr(S3dsDataTmpArray[1,i,j].nLongitudeVar));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion: '+ Floattostr(S3dsDataTmpArray[1,i,j].wPerihelion));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(S3dsDataTmpArray[1,i,j].wPerihelionVar));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly: '+ Floattostr(S3dsDataTmpArray[1,i,j].mAnomaly));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(S3dsDataTmpArray[1,i,j].mAnomalyVar));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Atmosphere: '+ inttostr(S3dsDataTmpArray[1,i,j].Atmosphere));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Type: '+ Floattostr(S3dsDataTmpArray[1,i,j].VelocityType));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity: '+ Floattostr(S3dsDataTmpArray[1,i,j].Velocity));
      Writeln(F,'Planet'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Dir: '+ Floattostr(S3dsDataTmpArray[1,i,j].VelocityDir));
    end;
  end;

  for i:=0 to SystemDataTmp.NbAsteroid-1 do
  begin
    Writeln(F,'Asteroid'+inttostr(i)+'.Name: '+ (AsteroidDataTmpArray[i].Name));
    Writeln(F,'Asteroid'+inttostr(i)+'.Radius: '+ Floattostr(AsteroidDataTmpArray[i].Radius));
    Writeln(F,'Asteroid'+inttostr(i)+'.ObjectRotation: '+ Floattostr(AsteroidDataTmpArray[i].ObjectRotation));
    Writeln(F,'Asteroid'+inttostr(i)+'.AxisTilt: '+ Floattostr(AsteroidDataTmpArray[i].AxisTilt));
    Writeln(F,'Asteroid'+inttostr(i)+'.nbS3ds: '+ inttostr(AsteroidDataTmpArray[i].nbS3ds));
    Writeln(F,'Asteroid'+inttostr(i)+'.DocIndex: '+ Floattostr(AsteroidDataTmpArray[i].DocIndex));
    Writeln(F,'Asteroid'+inttostr(i)+'.Mass: '+ Floattostr(AsteroidDataTmpArray[i].Mass));
    Writeln(F,'Asteroid'+inttostr(i)+'.Density: '+ Floattostr(AsteroidDataTmpArray[i].Density));

      Writeln(F,'Asteroid'+inttostr(i)+' RCDType: '+ inttostr(AsteroidDataTmpArray[i].RCDType));
      Writeln(F,'Asteroid'+inttostr(i)+' RCDCount: '+ inttostr(AsteroidDataTmpArray[i].RCDCount));
      Writeln(F,'Asteroid'+inttostr(i)+'RCDXYSize: '+ Floattostr(AsteroidDataTmpArray[i].RCDXYSize));
      Writeln(F,'Asteroid'+inttostr(i)+'RCDZSize: '+ Floattostr(AsteroidDataTmpArray[i].RCDZSize));
      Writeln(F,'Asteroid'+inttostr(i)+'RCDPosition: '+ Floattostr(AsteroidDataTmpArray[i].RCDPosition));

    Writeln(F,'Asteroid'+inttostr(i)+'.Albedo: '+ Floattostr(AsteroidDataTmpArray[i].Albedo));
    Writeln(F,'Asteroid'+inttostr(i)+'.OrbitRotation: '+ Floattostr(AsteroidDataTmpArray[i].OrbitRotation));

    Writeln(F,'Asteroid'+inttostr(i)+'.Distance: '+ Floattostr(AsteroidDataTmpArray[i].aDistance));
    Writeln(F,'Asteroid'+inttostr(i)+'.Distance Var: '+ Floattostr(AsteroidDataTmpArray[i].aDistanceVar));
    Writeln(F,'Asteroid'+inttostr(i)+'.Inclination: '+ Floattostr(AsteroidDataTmpArray[i].Inclination));
    Writeln(F,'Asteroid'+inttostr(i)+'.Inclination Var: '+ Floattostr(AsteroidDataTmpArray[i].InclinationVar));
    Writeln(F,'Asteroid'+inttostr(i)+'.Eccentricity: '+ Floattostr(AsteroidDataTmpArray[i].Eccentricity));
    Writeln(F,'Asteroid'+inttostr(i)+'.EMin Per: '+ Floattostr(AsteroidDataTmpArray[i].EVar));
    Writeln(F,'Asteroid'+inttostr(i)+'.EMax Ape: '+ Floattostr(AsteroidDataTmpArray[i].EMax));
    Writeln(F,'Asteroid'+inttostr(i)+'.nLongitude: '+ Floattostr(AsteroidDataTmpArray[i].nLongitude));
    Writeln(F,'Asteroid'+inttostr(i)+'.nLongitude Var: '+ Floattostr(AsteroidDataTmpArray[i].nLongitudeVar));
    Writeln(F,'Asteroid'+inttostr(i)+'.wPerihelion: '+ Floattostr(AsteroidDataTmpArray[i].wPerihelion));
    Writeln(F,'Asteroid'+inttostr(i)+'.wPerihelion Var: '+ Floattostr(AsteroidDataTmpArray[i].wPerihelionVar));
    Writeln(F,'Asteroid'+inttostr(i)+'.mAnomaly: '+ Floattostr(AsteroidDataTmpArray[i].mAnomaly));
    Writeln(F,'Asteroid'+inttostr(i)+'.mAnomaly Var: '+ Floattostr(AsteroidDataTmpArray[i].mAnomalyVar));
    Writeln(F,'Asteroid'+inttostr(i)+'.Atmosphere: '+ inttostr(AsteroidDataTmpArray[i].Atmosphere));
    Writeln(F,'Asteroid'+inttostr(i)+'.Velocity Type: '+ inttostr(AsteroidDataTmpArray[i].VelocityType));
    Writeln(F,'Asteroid'+inttostr(i)+'.Velocity: '+ Floattostr(AsteroidDataTmpArray[i].Velocity));
    Writeln(F,'Asteroid'+inttostr(i)+'.Velocity Dir: '+ Floattostr(AsteroidDataTmpArray[i].VelocityDir));

    for j:=0 to AsteroidDataTmpArray[i].nbS3ds-1 do
    begin
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Name: '+ (S3dsDataTmpArray[2,i,j].Name));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Radius: '+ Floattostr(S3dsDataTmpArray[2,i,j].Radius));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.ObjectRotation: '+ Floattostr(S3dsDataTmpArray[2,i,j].ObjectRotation));
      If (S3dsDataTmpArray[2,i,j].S3dsTex) then
         Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: True')
         else Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: False');
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.AxisTilt: '+ Floattostr(S3dsDataTmpArray[2,i,j].AxisTilt));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.DocIndex: '+ Floattostr(S3dsDataTmpArray[2,i,j].DocIndex));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Mass: '+ Floattostr(S3dsDataTmpArray[2,i,j].Mass));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Density: '+ Floattostr(S3dsDataTmpArray[2,i,j].Density));

      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+' RCDType: '+ inttostr(S3dsDataTmpArray[2,i,j].RCDType));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+' RCDCount: '+ inttostr(S3dsDataTmpArray[2,i,j].RCDCount));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'RCDXYSize: '+ Floattostr(S3dsDataTmpArray[2,i,j].RCDXYSize));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'RCDZSize: '+ Floattostr(S3dsDataTmpArray[2,i,j].RCDZSize));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'RCDPosition: '+ Floattostr(S3dsDataTmpArray[2,i,j].RCDPosition));

      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Albedo: '+ Floattostr(S3dsDataTmpArray[2,i,j].Albedo));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.OrbitRotation: '+ Floattostr(S3dsDataTmpArray[2,i,j].OrbitRotation));

      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance: '+ Floattostr(S3dsDataTmpArray[2,i,j].aDistance));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance Var: '+ Floattostr(S3dsDataTmpArray[2,i,j].aDistanceVar));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination: '+ Floattostr(S3dsDataTmpArray[2,i,j].Inclination));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination Var: '+ Floattostr(S3dsDataTmpArray[2,i,j].InclinationVar));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Eccentricity: '+ Floattostr(S3dsDataTmpArray[2,i,j].Eccentricity));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.EMin Per: '+ Floattostr(S3dsDataTmpArray[2,i,j].EVar));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.EMax Ape: '+ Floattostr(S3dsDataTmpArray[2,i,j].EMax));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude: '+ Floattostr(S3dsDataTmpArray[2,i,j].nLongitude));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude Var: '+ Floattostr(S3dsDataTmpArray[2,i,j].nLongitudeVar));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion: '+ Floattostr(S3dsDataTmpArray[2,i,j].wPerihelion));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(S3dsDataTmpArray[2,i,j].wPerihelionVar));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly: '+ Floattostr(S3dsDataTmpArray[2,i,j].mAnomaly));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(S3dsDataTmpArray[2,i,j].mAnomalyVar));

      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Atmosphere: '+ inttostr(S3dsDataTmpArray[2,i,j].Atmosphere));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Type: '+ inttostr(S3dsDataTmpArray[2,i,j].VelocityType));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity: '+ Floattostr(S3dsDataTmpArray[2,i,j].Velocity));
      Writeln(F,'Asteroid'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Dir: '+ Floattostr(S3dsDataTmpArray[2,i,j].VelocityDir));
    end;
  end;
  for i:=0 to SystemDataTmp.NbComet-1 do
  begin
    Writeln(F,'Comet'+inttostr(i)+'.Name: '+ (CometDataTmpArray[i].Name));
    Writeln(F,'Comet'+inttostr(i)+'.Radius: '+ Floattostr(CometDataTmpArray[i].Radius));
    Writeln(F,'Comet'+inttostr(i)+'.ObjectRotation: '+ Floattostr(CometDataTmpArray[i].ObjectRotation));
    Writeln(F,'Comet'+inttostr(i)+'.AxisTilt: '+ Floattostr(CometDataTmpArray[i].AxisTilt));
    Writeln(F,'Comet'+inttostr(i)+'.nbS3ds: '+ inttostr(CometDataTmpArray[i].nbS3ds));
    Writeln(F,'Comet'+inttostr(i)+'.DocIndex: '+ Floattostr(CometDataTmpArray[i].DocIndex));
    Writeln(F,'Comet'+inttostr(i)+'.Mass: '+ Floattostr(CometDataTmpArray[i].Mass));
    Writeln(F,'Comet'+inttostr(i)+'.Density: '+ Floattostr(CometDataTmpArray[i].Density));

      Writeln(F,'Comet'+inttostr(i)+' RCDType: '+ inttostr(CometDataTmpArray[i].RCDType));
      Writeln(F,'Comet'+inttostr(i)+' RCDCount: '+ inttostr(CometDataTmpArray[i].RCDCount));
      Writeln(F,'Comet'+inttostr(i)+'RCDXYSize: '+ Floattostr(CometDataTmpArray[i].RCDXYSize));
      Writeln(F,'Comet'+inttostr(i)+'RCDZSize: '+ Floattostr(CometDataTmpArray[i].RCDZSize));
      Writeln(F,'Comet'+inttostr(i)+'RCDPosition: '+ Floattostr(CometDataTmpArray[i].RCDPosition));

    Writeln(F,'Comet'+inttostr(i)+'.Albedo: '+ Floattostr(CometDataTmpArray[i].Albedo));
    Writeln(F,'Comet'+inttostr(i)+'.OrbitRotation: '+ Floattostr(CometDataTmpArray[i].OrbitRotation));

    Writeln(F,'Comet'+inttostr(i)+'.Distance: '+ Floattostr(CometDataTmpArray[i].aDistance));
    Writeln(F,'Comet'+inttostr(i)+'.Distance Var: '+ Floattostr(CometDataTmpArray[i].aDistanceVar));
    Writeln(F,'Comet'+inttostr(i)+'.Inclination: '+ Floattostr(CometDataTmpArray[i].Inclination));
    Writeln(F,'Comet'+inttostr(i)+'.Inclination Var: '+ Floattostr(CometDataTmpArray[i].InclinationVar));
    Writeln(F,'Comet'+inttostr(i)+'.Eccentricity: '+ Floattostr(CometDataTmpArray[i].Eccentricity));
    Writeln(F,'Comet'+inttostr(i)+'.EMin Per: '+ Floattostr(CometDataTmpArray[i].EVar));
    Writeln(F,'Comet'+inttostr(i)+'.EMax Ape: '+ Floattostr(CometDataTmpArray[i].EMax));
    Writeln(F,'Comet'+inttostr(i)+'.nLongitude: '+ Floattostr(CometDataTmpArray[i].nLongitude));
    Writeln(F,'Comet'+inttostr(i)+'.nLongitude Var: '+ Floattostr(CometDataTmpArray[i].nLongitudeVar));
    Writeln(F,'Comet'+inttostr(i)+'.wPerihelion: '+ Floattostr(CometDataTmpArray[i].wPerihelion));
    Writeln(F,'Comet'+inttostr(i)+'.wPerihelion Var: '+ Floattostr(CometDataTmpArray[i].wPerihelionVar));
    Writeln(F,'Comet'+inttostr(i)+'.mAnomaly: '+ Floattostr(CometDataTmpArray[i].mAnomaly));
    Writeln(F,'Comet'+inttostr(i)+'.mAnomaly Var: '+ Floattostr(CometDataTmpArray[i].mAnomalyVar));
    Writeln(F,'Comet'+inttostr(i)+'.Atmosphere: '+ inttostr(CometDataTmpArray[i].Atmosphere));
    Writeln(F,'Comet'+inttostr(i)+'.Velocity Type: '+ Floattostr(CometDataTmpArray[i].VelocityType));
    Writeln(F,'Comet'+inttostr(i)+'.Velocity: '+ Floattostr(CometDataTmpArray[i].Velocity));
    Writeln(F,'Comet'+inttostr(i)+'.Velocity Dir: '+ Floattostr(CometDataTmpArray[i].VelocityDir));

    for j:=0 to CometDataTmpArray[i].nbS3ds-1 do
    begin
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Name: '+ (S3dsDataTmpArray[3,i,j].Name));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Radius: '+ Floattostr(S3dsDataTmpArray[3,i,j].Radius));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.ObjectRotation: '+ Floattostr(S3dsDataTmpArray[3,i,j].ObjectRotation));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.AxisTilt: '+ Floattostr(S3dsDataTmpArray[3,i,j].AxisTilt));
      If (S3dsDataTmpArray[3,i,j].S3dsTex) then
         Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: True')
         else Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: False');
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.DocIndex: '+ Floattostr(S3dsDataTmpArray[3,i,j].DocIndex));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Mass: '+ Floattostr(S3dsDataTmpArray[3,i,j].Mass));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Density: '+ Floattostr(S3dsDataTmpArray[3,i,j].Density));

      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+' RCDType: '+ inttostr(S3dsDataTmpArray[3,i,j].RCDType));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+' RCDCount: '+ inttostr(S3dsDataTmpArray[3,i,j].RCDCount));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'RCDXYSize: '+ Floattostr(S3dsDataTmpArray[3,i,j].RCDXYSize));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'RCDZSize: '+ Floattostr(S3dsDataTmpArray[3,i,j].RCDZSize));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'RCDPosition: '+ Floattostr(S3dsDataTmpArray[3,i,j].RCDPosition));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Albedo: '+ Floattostr(S3dsDataTmpArray[3,i,j].Albedo));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.OrbitRotation: '+ Floattostr(S3dsDataTmpArray[3,i,j].OrbitRotation));

      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance: '+ Floattostr(S3dsDataTmpArray[3,i,j].aDistance));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance Var: '+ Floattostr(S3dsDataTmpArray[3,i,j].aDistanceVar));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination: '+ Floattostr(S3dsDataTmpArray[3,i,j].Inclination));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination Var: '+ Floattostr(S3dsDataTmpArray[3,i,j].InclinationVar));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Eccentricity: '+ Floattostr(S3dsDataTmpArray[3,i,j].Eccentricity));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.EMin Per: '+ Floattostr(S3dsDataTmpArray[3,i,j].EVar));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.EMax Ape: '+ Floattostr(S3dsDataTmpArray[3,i,j].EMax));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude: '+ Floattostr(S3dsDataTmpArray[3,i,j].nLongitude));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude Var: '+ Floattostr(S3dsDataTmpArray[3,i,j].nLongitudeVar));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion: '+ Floattostr(S3dsDataTmpArray[3,i,j].wPerihelion));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(S3dsDataTmpArray[3,i,j].wPerihelionVar));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly: '+ Floattostr(S3dsDataTmpArray[3,i,j].mAnomaly));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(S3dsDataTmpArray[3,i,j].mAnomalyVar));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Atmosphere: '+ inttostr(S3dsDataTmpArray[3,i,j].Atmosphere));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Type: '+ inttostr(S3dsDataTmpArray[3,i,j].VelocityType));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity: '+ Floattostr(S3dsDataTmpArray[3,i,j].Velocity));
      Writeln(F,'Comet'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Dir: '+ Floattostr(S3dsDataTmpArray[3,i,j].VelocityDir));
    end;
  end;
  for i:=0 to SystemDataTmp.NbDebris-1 do
  begin
    Writeln(F,'Debris'+inttostr(i)+'.Name: '+ (DebrisDataTmpArray[i].Name));
    Writeln(F,'Debris'+inttostr(i)+'.Radius: '+ Floattostr(DebrisDataTmpArray[i].Radius));
    Writeln(F,'Debris'+inttostr(i)+'.ObjectRotation: '+ Floattostr(DebrisDataTmpArray[i].ObjectRotation));
    Writeln(F,'Debris'+inttostr(i)+'.AxisTilt: '+ Floattostr(DebrisDataTmpArray[i].AxisTilt));
    Writeln(F,'Debris'+inttostr(i)+'.nbS3ds: '+ inttostr(DebrisDataTmpArray[i].nbS3ds));
    Writeln(F,'Debris'+inttostr(i)+'.DocIndex: '+ Floattostr(DebrisDataTmpArray[i].DocIndex));
    Writeln(F,'Debris'+inttostr(i)+'.Mass: '+ Floattostr(DebrisDataTmpArray[i].Mass));
    Writeln(F,'Debris'+inttostr(i)+'.Density: '+ Floattostr(DebrisDataTmpArray[i].Density));

      Writeln(F,'Debris'+inttostr(i)+' RCDType: '+ inttostr(DebrisDataTmpArray[i].RCDType));
      Writeln(F,'Debris'+inttostr(i)+' RCDCount: '+ inttostr(DebrisDataTmpArray[i].RCDCount));
      Writeln(F,'Debris'+inttostr(i)+'RCDXYSize: '+ Floattostr(DebrisDataTmpArray[i].RCDXYSize));
      Writeln(F,'Debris'+inttostr(i)+'RCDZSize: '+ Floattostr(DebrisDataTmpArray[i].RCDZSize));
      Writeln(F,'Debris'+inttostr(i)+'RCDPosition: '+ Floattostr(DebrisDataTmpArray[i].RCDPosition));
    Writeln(F,'Debris'+inttostr(i)+'.Albedo: '+ Floattostr(DebrisDataTmpArray[i].Albedo));
    Writeln(F,'Debris'+inttostr(i)+'.OrbitRotation: '+ Floattostr(DebrisDataTmpArray[i].OrbitRotation));

    Writeln(F,'Debris'+inttostr(i)+'.Distance: '+ Floattostr(DebrisDataTmpArray[i].aDistance));
    Writeln(F,'Debris'+inttostr(i)+'.Distance Var: '+ Floattostr(DebrisDataTmpArray[i].aDistanceVar));
    Writeln(F,'Debris'+inttostr(i)+'.Inclination: '+ Floattostr(DebrisDataTmpArray[i].Inclination));
    Writeln(F,'Debris'+inttostr(i)+'.Inclination Var: '+ Floattostr(DebrisDataTmpArray[i].InclinationVar));
    Writeln(F,'Debris'+inttostr(i)+'.Eccentricity: '+ Floattostr(DebrisDataTmpArray[i].Eccentricity));
    Writeln(F,'Debris'+inttostr(i)+'.EMin Per: '+ Floattostr(DebrisDataTmpArray[i].EVar));
    Writeln(F,'Debris'+inttostr(i)+'.EMax Ape: '+ Floattostr(DebrisDataTmpArray[i].EMax));
    Writeln(F,'Debris'+inttostr(i)+'.nLongitude: '+ Floattostr(DebrisDataTmpArray[i].nLongitude));
    Writeln(F,'Debris'+inttostr(i)+'.nLongitude Var: '+ Floattostr(DebrisDataTmpArray[i].nLongitudeVar));
    Writeln(F,'Debris'+inttostr(i)+'.wPerihelion: '+ Floattostr(DebrisDataTmpArray[i].wPerihelion));
    Writeln(F,'Debris'+inttostr(i)+'.wPerihelion Var: '+ Floattostr(DebrisDataTmpArray[i].wPerihelionVar));
    Writeln(F,'Debris'+inttostr(i)+'.mAnomaly: '+ Floattostr(DebrisDataTmpArray[i].mAnomaly));
    Writeln(F,'Debris'+inttostr(i)+'.mAnomaly Var: '+ Floattostr(DebrisDataTmpArray[i].mAnomalyVar));
    Writeln(F,'Debris'+inttostr(i)+'.Atmosphere: '+ inttostr(DebrisDataTmpArray[i].Atmosphere));
    Writeln(F,'Debris'+inttostr(i)+'.Velocity Type: '+ Floattostr(DebrisDataTmpArray[i].VelocityType));
    Writeln(F,'Debris'+inttostr(i)+'.Velocity: '+ Floattostr(DebrisDataTmpArray[i].Velocity));
    Writeln(F,'Debris'+inttostr(i)+'.Velocity Dir: '+ Floattostr(DebrisDataTmpArray[i].VelocityDir));

    for j:=0 to DebrisDataTmpArray[i].nbS3ds-1 do
    begin
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Name: '+ (S3dsDataTmpArray[4,i,j].Name));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Radius: '+ Floattostr(S3dsDataTmpArray[4,i,j].Radius));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.ObjectRotation: '+ Floattostr(S3dsDataTmpArray[4,i,j].ObjectRotation));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.AxisTilt: '+ Floattostr(S3dsDataTmpArray[4,i,j].AxisTilt));
      If (S3dsDataTmpArray[4,i,j].S3dsTex) then
         Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: True')
         else Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.S3ds Textured: False');
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.DocIndex: '+ Floattostr(S3dsDataTmpArray[4,i,j].DocIndex));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Mass: '+ Floattostr(S3dsDataTmpArray[4,i,j].Mass));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Density: '+ Floattostr(S3dsDataTmpArray[4,i,j].Density));

      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+' RCDType: '+ inttostr(S3dsDataTmpArray[4,i,j].RCDType));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+' RCDCount: '+ inttostr(S3dsDataTmpArray[4,i,j].RCDCount));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'RCDXYSize: '+ Floattostr(S3dsDataTmpArray[4,i,j].RCDXYSize));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'RCDZSize: '+ Floattostr(S3dsDataTmpArray[4,i,j].RCDZSize));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'RCDPosition: '+ Floattostr(S3dsDataTmpArray[4,i,j].RCDPosition));

      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Albedo: '+ Floattostr(S3dsDataTmpArray[4,i,j].Albedo));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.OrbitRotation: '+ Floattostr(S3dsDataTmpArray[4,i,j].OrbitRotation));

      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance: '+ Floattostr(S3dsDataTmpArray[4,i,j].aDistance));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Distance Var: '+ Floattostr(S3dsDataTmpArray[4,i,j].aDistanceVar));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination: '+ Floattostr(S3dsDataTmpArray[4,i,j].Inclination));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Inclination Var: '+ Floattostr(S3dsDataTmpArray[4,i,j].InclinationVar));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Eccentricity: '+ Floattostr(S3dsDataTmpArray[4,i,j].Eccentricity));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.EMin Per: '+ Floattostr(S3dsDataTmpArray[4,i,j].EVar));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.EMax Ape: '+ Floattostr(S3dsDataTmpArray[4,i,j].EMax));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude: '+ Floattostr(S3dsDataTmpArray[4,i,j].nLongitude));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.nLongitude Var: '+ Floattostr(S3dsDataTmpArray[4,i,j].nLongitudeVar));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion: '+ Floattostr(S3dsDataTmpArray[4,i,j].wPerihelion));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.wPerihelion Var: '+ Floattostr(S3dsDataTmpArray[4,i,j].wPerihelionVar));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly: '+ Floattostr(S3dsDataTmpArray[4,i,j].mAnomaly));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.mAnomaly Var: '+ Floattostr(S3dsDataTmpArray[4,i,j].mAnomalyVar));

      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Atmosphere: '+ inttostr(S3dsDataTmpArray[4,i,j].Atmosphere));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Type: '+ Floattostr(S3dsDataTmpArray[4,i,j].VelocityType));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity: '+ Floattostr(S3dsDataTmpArray[4,i,j].Velocity));
      Writeln(F,'Debris'+inttostr(i)+' S3ds'+inttostr(j)+'.Velocity Dir: '+ Floattostr(S3dsDataTmpArray[4,i,j].VelocityDir));
    end;
  end;
  CloseFile(F);
  ShellExecute(0, 'open',
    PChar(EarthModelPath+'Spud.txt'), '', '', SW_SHOW);
end;

procedure TABCreatorFrm.PickActiveCBClick(Sender: TObject);
{var i,Proxyi:Integer;}
begin
 (* If (PickActiveCB.Checked) then
  begin
    SunShineCB.Checked:=false;
    SunShineFlare.Visible:=SunShineCB.Checked;
    {Turn them OFF .. they crash the PickObject}
    for i:=1 to SystemDataTmp.NbDebris do
    for Proxyi:=1 to trunc(DebrisDataTmpArray[i].Density) do
    DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet].children[0].
    Children[0].children[Proxyi].Visible:=False;
  end else
    for i:=1 to SystemDataTmp.NbDebris do
    for Proxyi:=1 to trunc(DebrisDataTmpArray[i].Density) do
    DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet].children[0].
    Children[0].children[Proxyi].Visible:=True;*)
end;

procedure TABCreatorFrm.SunShineCBClick(Sender: TObject);
begin
  {If (PickActiveCB.Checked) then
  begin
    SunShineCB.Checked:=false;
    SunShineFlare.Visible:=SunShineCB.Checked;
  end else }
  begin
    SunShineFlare.Visible:=SunShineCB.Checked;
  end;
end;
procedure TABCreatorFrm.GLSceneViewerABeforeRender(Sender: TObject);
begin
  If SunShineCB.Checked then SunShineFlare.PreRender(Sender as TGLSceneBuffer);
end;
procedure TABCreatorFrm.SunShineTBChange(Sender: TObject);
begin
  SunShineFlare.Size:=SunShineTB.Position;
  SunShineLabel.Caption:=inttostr(SunShineTB.Position);
end;

procedure TABCreatorFrm.LabelTBChange(Sender: TObject);
var Temp:Double;
begin
  Temp:= LabelTB.Position/1000;
  GLFlatTextLabel.Scale.X:=Temp;
  GLFlatTextLabel.Scale.Y:=Temp;
  GLFlatTextLabel.Scale.Z:=Temp;
  LabelLabel.Caption:=Floattostr(Temp);
end;
{Distance is Planets apart,Scale is SIZE of Planets
This could be done automatically with some code
that uses the Bounding box of the 3ds object
and scales that to fit the desired 'diameter'}
procedure TABCreatorFrm.S3dsScalerTBChange(Sender: TObject);
var
  Scale,i,j:Integer;
begin
  Scale:=S3dsScalerScalerTB.Position;
  S3dsScaler:=S3dsScalerTB.Position/Scale;
  S3dsScalerLabel.Caption:=
      FloatToStrF(S3dsScaler,ffFixed, 18,2);
  S3dsScalerScaleLabel.Caption:= inttostr(Scale);

  Case SSORG.ItemIndex  of //to control which 3ds objects get scaled
  //Sun
  0:
  begin
  for j:=0 to SunDataTmp.nbS3ds-1 do
  begin
    DCSolarSystem.children[0].Children[0].children[j].Children[0].Scale.x
    :=S3dsScaler;
    DCSolarSystem.children[0].Children[0].children[j].Children[0].Scale.y
    :=S3dsScaler;
    DCSolarSystem.children[0].Children[0].children[j].Children[0].Scale.z
    :=S3dsScaler;
    {To try to fix object edges fluttering}{ vcObjectBased}
    {If S3DsVisibilityCB.Checked then
    DCSolarSystem.children[0].Children[0].children[j].Children[0].VisibilityCulling:=
    vcHierarchicalelse
    DCSolarSystem.children[0].Children[0].children[j].Children[0].VisibilityCulling:=
    vcInherited;}
    DCSolarSystem.StructureChanged;
  end;
  end;
  //Planets
  1:
  begin
  i:=PlanetUpDown.Position-1;
  for j:=1 to PlanetDataTmpArray[i].nbS3ds do
  begin
    DCSolarSystem.children[i].Children[0].children[j].Children[0].Scale.x
    :=S3dsScaler;
    DCSolarSystem.children[i].Children[0].children[j].Children[0].Scale.y
    :=S3dsScaler;
    DCSolarSystem.children[i].Children[0].children[j].Children[0].Scale.z
    :=S3dsScaler;
    DCSolarSystem.StructureChanged;
  end;
  end;
  //Asteroids
  2:
  begin
  //AsteroidDataTmpArray CometDataTmpArray  DebrisDataTmpArray
  i:=AsteroidUpDown.Position-1;
  for j:=0 to AsteroidDataTmpArray[i].nbS3ds-1 do
  begin
    DCSolarSystem.children[SystemDataTmp.NbPlanet+i].Children[0].children[j].Children[0].Scale.x
    :=S3dsScaler;
    DCSolarSystem.children[SystemDataTmp.NbPlanet+i].Children[0].children[j].Children[0].Scale.y
    :=S3dsScaler;
    DCSolarSystem.children[SystemDataTmp.NbPlanet+i].Children[0].children[j].Children[0].Scale.z
    :=S3dsScaler;
    DCSolarSystem.StructureChanged;
  end;
  end;
  //Comets  CometDataTmpArray
  3:
  begin
  //AsteroidDataTmpArray CometDataTmpArray  DebrisDataTmpArray
  i:=AsteroidUpDown.Position-1;
  for j:=0 to CometDataTmpArray[i].nbS3ds-1 do
  begin
    DCSolarSystem.children[SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+i].Children[0].children[j].Children[0].Scale.x
    :=S3dsScaler;
    DCSolarSystem.children[SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+i].Children[0].children[j].Children[0].Scale.y
    :=S3dsScaler;
    DCSolarSystem.children[SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+i].Children[0].children[j].Children[0].Scale.z
    :=S3dsScaler;
    DCSolarSystem.StructureChanged;
  end;
  end;
  //Debris  DebrisDataTmpArray
  4:
  begin
  //AsteroidDataTmpArray CometDataTmpArray  DebrisDataTmpArray
  i:=AsteroidUpDown.Position-1;
  for j:=0 to DebrisDataTmpArray[i].nbS3ds-1 do
  begin
    DCSolarSystem.children[SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet+i].Children[0].children[j].Children[0].Scale.x
    :=S3dsScaler;
    DCSolarSystem.children[SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet+i].Children[0].children[j].Children[0].Scale.y
    :=S3dsScaler;
    DCSolarSystem.children[SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet+i].Children[0].children[j].Children[0].Scale.z
    :=S3dsScaler;
    DCSolarSystem.StructureChanged;
  end;
  end;
  end;{case}
end;

procedure TABCreatorFrm.TimeTrackBarChange(Sender: TObject);
begin
  SolarTimeMultiplier:= (HoursTimeTrackBar.Position/24)*
                         TimeTrackBar.Position;
  HourLabel.Caption:=inttostr(HoursTimeTrackBar.Position);                         
  TimeLabel.Caption:=floattostr(SolarTimeMultiplier);
end;
procedure TABCreatorFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27 : Close;
    '0'..'9' :
    begin
      SolarTimeMultiplier:=PowerInteger(Integer(Key)-Integer('0'), 3);
      TimeLabel.Caption:=floattostr(SolarTimeMultiplier);
      TimeTrackBar.Position:= Round(SolarTimeMultiplier);
    end;
  end;
end;

procedure TABCreatorFrm.PlanetPickerCBChange(Sender: TObject);
begin
  If PlanetPickerCB.ItemIndex > 0 then
  begin
    GLCamera.MoveTo(DCSolarSystem.children[PlanetPickerCB.ItemIndex].Children[0]);
    GLCamera.TargetObject:=DCSolarSystem.children[PlanetPickerCB.ItemIndex].Children[0];
  end else
  begin
    GLCamera.MoveTo(DCSolarSystem);
    GLCamera.TargetObject:=DCSolarSystem;
  end;
end;

procedure TABCreatorFrm.RunBtnClick(Sender: TObject);
begin      {Running selects action inside Cadencer}
  {Allow camera movement without moving planets}
  Running:=True; //Cadencer Always running, Timer Toggled as FPS
  {GLCadencer1.Enabled:=True;
  Timer1.Enabled:=True;}
end;
procedure TABCreatorFrm.TimerATimer(Sender: TObject);
begin
   {Caption:=Format('%d Comet particles, %.1f FPS',
                   [GLCometParticles.Count-1,
                   GLSceneViewerA.FramesPerSecond]);}
If PlanetsLoaded then                   
   {DisplayFPS1Click Toggles Timer and thus FPS display}
   Caption:=Format('%.1f FPS', [GLSceneViewerA.FramesPerSecond]);
   GLSceneViewerA.ResetPerformanceMonitor;
end;
procedure TABCreatorFrm.StopBtnClick(Sender: TObject);
begin
  {GLCadencer1.Enabled:=False;
  Timer1.Enabled:=False;}
  Running:=False;
  //Menu Timer Toggle controls Caption display now
  //Caption:= 'A.B. Creator D. E. Prime';
end;

procedure TABCreatorFrm.GLCadencerAProgress(Sender: TObject;
          const deltaTime, newTime: Double);
var
   i,j,kometcount:Integer;
   a, aBase : Double;
   (*d : Double;    p : TAffineVector;*)
   pPoint : TVector;
begin
  If Running then {Allow camera movement without moving planets}
  begin
    If PlanetsLoaded then {Gotta have something to turn}
    begin
      {Need Check that the data has been Computed}
(*    If UseOrbitalElementsCB.Checked then
      begin                 {OrbitalTime  Now-2 2 days back}
        d:=GMTDateTimeToJulianDay(OrbitalTime-2+newTime*SolarTimeMultiplier);
        p:=ComputePlanetPosition(cSunOrbitalElements, d);
        //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
        //                  SolarDistance    SolarScaleDivisor
        ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
        //LSSun.
        DCSolarSystem.children[0].children[0].
          Position.AsAffineVector:=p;
      end else
*)
      Begin
        {Sun Rotates.. in place  DummyCube.Sphere}
        DCSolarSystem.children[0].children[0].TurnAngle:=
        DCSolarSystem.children[0].children[0].TurnAngle
          +(24/SunDataTmp.ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
        {PitchAngle   TurnAngle RollAngle Direction xyz  Position xyz}
        {GetPitchAngle  FRotation.X;
         GetTurnAngle   FRotation.Y;
         GetRollAngle    FRotation.Z;}
        for j:=0 to SunDataTmp.nbS3ds-1 do
        begin
          DCSolarSystem.children[0].children[0].children[j].TurnAngle:=
           DCSolarSystem.children[0].children[0].children[j].TurnAngle
           +(365/S3dsDataTmpArray[0,0,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;

          DCSolarSystem.children[0].children[0].children[j].children[0].TurnAngle:=
           DCSolarSystem.children[0].children[0].children[j].children[0].TurnAngle
           +(24/S3dsDataTmpArray[0,0,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
        end;
        {Counts start at 1 due to Sun, kinda messes up other stuff
          the DC .. the Array of Data... may be why it should be using the
          Object 'Extradata' data rather than an array that is also filled...}
         {Sun is 0}
        for i:=1 to SystemDataTmp.NbPlanet do
        begin        {DummyCube.Sphere.ChildCube.ChildSphere}
          {Rotate around Sun}
          DCSolarSystem.children[i].TurnAngle:=
            DCSolarSystem.children[i].TurnAngle
            +(365/PlanetDataTmpArray[i-1].OrbitRotation)*deltaTime*SolarTimeMultiplier;
          {Rotate Sphere and thus the Moon,Rings, etc...}
          DCSolarSystem.children[i].children[0].TurnAngle:=
            DCSolarSystem.children[i].children[0].TurnAngle
            +(24/PlanetDataTmpArray[i-1].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
          If OrbitTrailsOnCB.Checked then
          begin
            {A Orbit Lines could be made and assigned to the Object when loaded
              This Would Toggle Visibility.. and MOVE them.. Delete old ones}
            //for i:=0 to stage[7].elements-1 do
            If i= PlanetToOrbitTrail then {Always reset to 0.. so SOMETHING GOTTA be Picked.. Sun is 0}
            begin
              SetVector(pPoint, (DCSolarSystem.children[i].children[0] as TGLSphere).AbsolutePosition);
              AddToTrail(pPoint);
              OrbitLines.Nodes.Last.AsVector:=
                (DCSolarSystem.children[i].children[0] as TGLSphere).AbsolutePosition;
            end;
          end;

          If AtmosphereOnCB.Checked then
          begin
            {Actually probably toggle something from the menu click...
             Activate the Rendering like in Eric's Earth Demo}
          end;
          for j:=0 to PlanetDataTmpArray[i-1].nbRings-1 do
          begin
            //Spin the Rings connected to the Planet Sphere
            DCSolarSystem.children[i].children[0].children[j].TurnAngle:=
              DCSolarSystem.children[i].children[0].children[j].TurnAngle
              +(365/RingDataTmpArray[i-1,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;
            {Rotate Ring}
            DCSolarSystem.children[i].children[0].children[j].children[0].TurnAngle:=
              DCSolarSystem.children[i].children[0].children[j].children[0].TurnAngle
              +(24/RingDataTmpArray[i-1,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
            If  RingDataTmpArray[i-1,j].RCDType = 3 then
            begin
              for kometcount:=1 to DCSolarSystem.children[i].children[0].children[j].Count-1 do
              begin
                DCSolarSystem.children[i].children[0].children[j].children[kometcount].Position.Y:=
                  1.25*Sin(DCSolarSystem.children[i].children[0].children[j].children[kometcount].Position.Z/2+newTime);
              end;
            end;
          end;

          for j:=0 to PlanetDataTmpArray[i-1].nbmoons-1 do
          begin
            //Spin the Moons Cube connected to the Planet Sphere       RollAngle
            DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+j].TurnAngle:=
              DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+j].TurnAngle
              +(365/MoonDataTmpArray[i-1,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;
            {Rotate Sphere }
            {ObjectRotation   OrbitRotation }
            DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+j].children[0].TurnAngle:=
              DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+j].children[0].TurnAngle
              +(24/MoonDataTmpArray[i-1,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
          end;
          for j:=0 to PlanetDataTmpArray[i-1].nbS3ds-1 do
          begin
            //Spin the Moons connected to the Planet Sphere
            DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+PlanetDataTmpArray[i-1].nbmoons+j].RollAngle:=
              DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+PlanetDataTmpArray[i-1].nbmoons+j].RollAngle
              +(365/S3dsDataTmpArray[1,i,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;
            {Rotate Sphere}
            DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+PlanetDataTmpArray[i-1].nbmoons+j].children[0].TurnAngle:=
              DCSolarSystem.children[i].children[0].children[PlanetDataTmpArray[i-1].nbRings+PlanetDataTmpArray[i-1].nbmoons+j].children[0].TurnAngle
              +(24/S3dsDataTmpArray[1,i,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
          end;
        end;  {Planet}

        for i:=1 to SystemDataTmp.NbAsteroid do
        begin
          {Rotate Sphere}
          DCSolarSystem.children[i+SystemDataTmp.NbPlanet]{.children[0]}.TurnAngle:=
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet]{.children[0]}.TurnAngle
            +(365/AsteroidDataTmpArray[i-1].OrbitRotation)*deltaTime*SolarTimeMultiplier;

          DCSolarSystem.children[i+SystemDataTmp.NbPlanet].children[0].TurnAngle:=
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet].children[0].TurnAngle
            +(24/AsteroidDataTmpArray[i-1].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;

          for j:=0 to AsteroidDataTmpArray[i-1].nbS3ds-1 do
          begin
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet].children[0].children[j]{.children[0]}.TurnAngle:=
              DCSolarSystem.children[i+SystemDataTmp.NbPlanet].children[0].children[j]{.children[0]}.TurnAngle
              +(365/S3dsDataTmpArray[2,i,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;
            {Rotate Sphere}
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet].children[0].children[j].children[0].TurnAngle:=
              DCSolarSystem.children[i+SystemDataTmp.NbPlanet].children[0].children[j].children[0].TurnAngle
              +(24/S3dsDataTmpArray[2,i,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
          end;
        end;
        {Counts start at 1 due to Sun, kinda messes up other Counts}
        {Comet Trail Needs to Point AWAY from Sun}
        kometcount:= 1;

        for i:=1 to SystemDataTmp.NbComet do
        begin
          DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].TurnAngle:=
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].TurnAngle
            +(365/CometDataTmpArray[i-1].OrbitRotation)*deltaTime*SolarTimeMultiplier;
          DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].children[0].TurnAngle:=
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].children[0].TurnAngle
            +(24/CometDataTmpArray[i-1].ObjectRotation)*365
            *deltaTime*SolarTimeMultiplier;
            //DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].Turn(-1*deltaTime*SolarTimeMultiplier{100});

          for j:=0 to CometDataTmpArray[i-1].nbS3ds-1 do
          begin
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].children[0].children[j]{.children[0]}.TurnAngle:=
              DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].children[0].children[j]{.children[0]}.TurnAngle
              +(365/S3dsDataTmpArray[3,i,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].children[0].children[j].children[0].TurnAngle:=
              DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid].children[0].children[j].children[0].TurnAngle
              +(24/S3dsDataTmpArray[3,i,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
          end;
          If  CometDataTmpArray[i-1].RCDType = 3 then
          begin
            //Freeform and debris
          end;
          //Need an Array of these FX... there might be more than 1 comet...
          {
          If CometFiring then   Fx.FxAdvance;
          }
          //other type of comet.
          If CometTrailing then
          begin
            // angular reference : 90° per second <=> 4 second per revolution
            aBase:={90}// CometDataTmpArray[i-1].Mass
                CometDataTmpArray[i-1].RCDPosition
                *newTime;
	    // rotate the sprites around the yellow "star"
            for j:=0 to trunc(CometDataTmpArray[i-1].RCDCount)-1 do
            begin
	      a:=DegToRadian(aBase+j*CometDataTmpArray[i-1].RCDCount);
              with (DCComet.Children[j+kometcount] as TGLSprite) do
              begin
                // rotation movement
         	Position.X:=
                        {40}(CometDataTmpArray[i-1].aDistance/(SolarDistance))
                        *cos(a);
  	        Position.Z:=
                        {40}(CometDataTmpArray[i-1].aDistance/(SolarDistance))
                        *sin(a);
                // ondulation
                Position.Y:=
                      {20}(CometDataTmpArray[i-1].aDistance/(SolarDistance))/2
                   *cos(2.1*a);
                // sprite size change
                SetSquareSize(
                  {20}(CometDataTmpArray[i-1].aDistance/(SolarDistance))/2
                  +cos(3*a));
 	      end;
   	    end;
            inc(kometcount,trunc(CometDataTmpArray[i-1].RCDCount));
          end;
        end;

        for i:=1 to SystemDataTmp.NbDebris do
        begin
          DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet]{.children[0]}.TurnAngle:=
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet]{.children[0]}.TurnAngle
            +(365/DebrisDataTmpArray[i-1].OrbitRotation)*deltaTime*SolarTimeMultiplier;
          DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet].children[0].TurnAngle:=
            DCSolarSystem.children[i+SystemDataTmp.NbPlanet+SystemDataTmp.NbAsteroid+SystemDataTmp.NbComet].children[0].TurnAngle
            +(24/DebrisDataTmpArray[i-1].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;

          for j:=0 to DebrisDataTmpArray[i-1].nbS3ds-1 do
          begin
            DCSolarSystem.children[i].children[0].children[j]{.children[0]}.TurnAngle:=
              DCSolarSystem.children[i].children[0].children[j]{.children[0]}.TurnAngle
              +(365/S3dsDataTmpArray[4,i,j].OrbitRotation)*deltaTime*SolarTimeMultiplier;
            DCSolarSystem.children[i].children[0].children[j].children[0].TurnAngle:=
              DCSolarSystem.children[i].children[0].children[j].children[0].TurnAngle
              +(24/S3dsDataTmpArray[4,i,j].ObjectRotation)*365*deltaTime*SolarTimeMultiplier;
          end;
        end;//Debris
      End;
    end; {Loaded}
  end;{Running}
   // honour camera movements
  if (dmy<>0) or (dmx<>0) then
  begin
    GLCamera.MoveAroundTarget(dmy,dmx);
            {MoveAroundTarget(ClampValue(dmy*0.3, -5, 5),
                              ClampValue(dmx*0.3, -5, 5));}
    dmx:=0;
    dmy:=0;
  end;
end;


procedure TABCreatorFrm.AddToTrail(const p : TVector);
var
   i, k : Integer;
begin
   OrbitLines.Nodes.Last.AsVector:=p;
   OrbitLines.AddNode(0, 0, 0); ///keep changing the LAST one
   if OrbitLines.Nodes.Count>MaxLines then // limit trail to ?? points
      OrbitLines.Nodes[0].Free;

   for i:=0 to {MaxLines-1}OrbitLines.Nodes.Count-1 do
   begin
      k:=OrbitLines.Nodes.Count-i-1;
      if k>=0 then
         TGLLinesNode(OrbitLines.Nodes[k]).Color.Alpha:=0.95-i*0.05;
   end;
end;



procedure TABCreatorFrm.GLSceneViewerAMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var s,ss:String;
  Spec,{Tag: 1 Sun,2 Planet,3 Ast,4 Com,5 Deb,6 Ring,7 Moon, 8 3ds
    19 CometSprite
    20 SunFlare  21 FFDebris}
  Spec3ds,
  Species,{Hint Parent#   ,sub#}
  SubSpecies{Object#}
  :Integer;
begin
   mx:=x;
   my:=y;
   If PickActiveCB.Checked then
   begin
     if ((ssLeft in Shift)and(ssAlt in Shift)) then
     begin
       {Perform Selection of Marker.. then
        Select the NameCB.ItemIndex := 0;
        to display the Selected Data}
//TGLBaseSceneObject = class (TGLCoordinatesUpdateAbleComponent)
//TGLProxyObject = class (TGLBaseSceneObject)
//Custom has Hint...
//   TGLCustomSceneObject = class(TGLBaseSceneObject)            //TGLCustomSceneObject
       PickedObjA := GLSceneViewerA.Buffer.GetPickedObject(X, Y) as TGLBaseSceneObject;
       if PickedObjA<>nil then
       begin
       if ((PickedObjA.Tag >0) and (PickedObjA.Tag <20)) then
       begin
       PickedObj := GLSceneViewerA.Buffer.GetPickedObject(X, Y) as TGLCustomSceneObject;
  If LabelsOnCB.Checked then
  begin
     LabelSelected:=True;
     GLFlatTextLabel.Text:=PickedObj.Name;      //Rotation
    // GLFlatTextLabel.Position.X:=PickedObj.Position.X;  //Scale.X
    // GLFlatTextLabel.Position.Y:=PickedObj.Position.Y;  //Scale.Y }
       //Move DCLabels DummyCube TO the Object
      GLFlatTextLabel.MoveTo(PickedObj);
   end;
    If (PickedObj.Tag=2) then
      PlanetToOrbitTrail:=strtoint(PickedObj.Hint)+1;//+1 is another flip flop of where to count, and what the count is used for
         Spec:=PickedObj.Tag;
         Species:=0;
         SubSpecies:=0;
         Spec3ds:=0;
         Case PickedObj.Tag of {Base Type}
           1..5: Species:=strtoint(PickedObj.Hint);
           6..7:
           begin
             s:=copy(PickedObj.Hint,0,pos(',',PickedObj.Hint)-1);
             Species:=strtoint(s);
             s:=copy(PickedObj.Hint,pos(',',PickedObj.Hint)+1,length(PickedObj.Hint));
             SubSpecies:=strtoint(s);
           end;{6..7}
           8://3ds
           begin
             s:=copy(PickedObj.Hint,0,pos(',',PickedObj.Hint)-1);
             Spec3ds:=strtoint(s);
             s:=copy(PickedObj.Hint,pos(',',PickedObj.Hint)+1,length(PickedObj.Hint));
             ss:=copy(s,0,pos(',',s)-1);
             Species:=strtoint(ss);
             ss:=copy(s,pos(',',s)+1,length(s));
             s:=copy(ss,pos(',',ss)+1,length(ss));
             SubSpecies:=strtoint(s);
           end;{8}
           19:Species:=strtoint(PickedObj.Hint);{19: CometSprite 1..}
         end;{Case}

       end else
       begin
  If LabelsOnCB.Checked then
  begin
     LabelSelected:=True;
     GLFlatTextLabel.Text:=PickedObjA.Name;      //Rotation
    // GLFlatTextLabel.Position.X:=PickedObj.Position.X;  //Scale.X
    // GLFlatTextLabel.Position.Y:=PickedObj.Position.Y;  //Scale.Y }
       //Move DCLabels DummyCube TO the Object
      GLFlatTextLabel.MoveTo(PickedObjA);
   end;
//SunShineFlare=20
//Proxy  Tag:=21; Hint:=inttostr(Proxyi);
         Spec:=PickedObjA.Tag;
         Species:=0;//PickedObjA.Tag;
        { If PickedObjA.Tag=21 then SubSpecies:=strtoint(PickedObj.Hint)
           else }
           SubSpecies:=0;
         Spec3ds:=0;
       end;
         If DocIndexLinkCB.Checked then
         DataDisplayer(0,Spec,Species,SubSpecies,Spec3ds)
         else
         DataDisplayer(1,Spec,Species,SubSpecies,Spec3ds);
     end;
     end;
   end;
end;

{Dont know what this is to do... but it does get the data}
{Case of Species ..1..5 with
   sub-case of SubSpecies to determine if 3ds #8 or not
   Planet case for 6 Ring,7 Moon, 8 3ds
   19,20,21,22 Do NOT have 'data' to display ?
  19 CometSprite
  20 Sun Flare, 21 Ring Proxy, 22 FFDebris Proxy
  Could be done like below  Display what you can.

  The 'Case' statments could set the RadioGroups and Call 'Show' button
  to Display the data...
  still dont know what DocIndex will do...}
procedure TABCreatorFrm.DataDisplayer(Switch,Spec,Species,SubSpecies,Spec3ds:Integer);
var s1,s:String;
Begin
  Case Switch of
    0:showmessage('DocIndex one'
               +#13#10+
           Inttostr(Spec)+','+
           Inttostr(Species)+','+
           Inttostr(SubSpecies)+','+
           Inttostr(Spec3ds));
    1:
    Begin
      Case Spec of {Base Type}
        0:begin s1:=PickedObjA.Name; s:='UNK.. maybe Debris Field'; end;
        1:
        begin
          s1:=PickedObj.Name;
          s:=floattostr(SunDataTmp.Radius)
        end;
        2:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(PlanetDataTmpArray[Species].Radius)
        end;
        3:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(AsteroidDataTmpArray[Species].Radius)
        end;
        4:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(CometDataTmpArray[Species].Radius)
        end;
        5:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(DebrisDataTmpArray[Species].Radius)
        end;
        6:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(RingDataTmpArray[Species,SubSpecies].Radius)
        end;
        7:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(MoonDataTmpArray[Species,SubSpecies].Radius)
        end;
        8:
        begin
         s1:=PickedObj.Name;
          s:=
           floattostr(S3dsDataTmpArray[Spec3ds,Species,SubSpecies].Radius)
        end;
        19:
        begin
         s1:=PickedObj.Name;
         s:='Comet Sprite';
        end;
{ Switch,Spec,Species,SubSpecies,Spec3ds
   SunDataTmp     PlanetDataTmpArray
     RingDataTmpArray  MoonDataTmpArray      S3dsDataTmpArray
    AsteroidDataTmpArray     CometDataTmpArray    DebrisDataTmpArray}
        20:begin s1:=PickedObjA.Name; s:='Sun Shine'; end;
        21:begin s1:=PickedObjA.Name; s:='Ring Proxy'; end;
        22:begin s1:=PickedObjA.Name; s:='Debris Field'; end;
        25:begin s1:=PickedObjA.Name; s:='Comet Sprite'; end;
        else begin s1:=PickedObj.Name; s:='Totally Bogus'; end;
      end;
      showmessage(s1
           +#13#10+
           Inttostr(Spec)+','+
           Inttostr(Species)+','+
           Inttostr(SubSpecies)+','+
           Inttostr(Spec3ds)
           +#13#10+
           s);
    end;
  end;
end;

procedure TABCreatorFrm.GLSceneViewerAMouseEnter(Sender: TObject);
begin
  GLSceneViewerA.SetFocus;//  GLSceneViewer.Focused;
end;

procedure TABCreatorFrm.GLSceneViewerAMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ((ssLeft in Shift)and(ssCtrl in Shift)) then
  begin     //showmessage('ctrl');
    GLCamera.FocalLength:=GLCamera.FocalLength*PowerSingle(1.05, (my-y)*0.1);
    CameraFocalLength:=GLCamera.FocalLength;
       {This can get BEYOND the defined range(s) of the trackbar}
       {ScaleTrackBar.Position:=Round(CameraFocalLength); }
    CFLLabel.Caption:=inttostr(round(GLCamera.FocalLength));
   end else
    {To keep from changing view when trying to Select an object}
 { if ((ssLeft in Shift)and(ssAlt in Shift)) then
  begin
  end else }
   if (ssLeft in Shift) then
   begin
      //showmessage('ssLeft');
     dmx:=dmx+(mx-x);
     dmy:=dmy+(my-y);
   end;
   mx:=x; my:=y;
end;

procedure TABCreatorFrm.CFLTrackBarChange(Sender: TObject);
begin
  CameraFocalLength:=CFLTrackBar.Position;
  GLCamera.FocalLength:=CameraFocalLength;
  CFLLabel.Caption:=inttostr(round(GLCamera.FocalLength));
end;

procedure TABCreatorFrm.GLSceneViewerAMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   PickedObj := nil;
end;

procedure TABCreatorFrm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
   f : Single;
begin       {Going away or Not too close: WheelDelta Value is 120 or -120}
   if (WheelDelta>0) or (GLCamera.Position.VectorLength>0.90) then
   begin
      f:=PowerSingle(1.05, WheelDelta*(1/120));
      GLCamera.AdjustDistanceToTarget(f);
      CameraDistanceLabel.Caption:=
      //FloatToStrF(Value: Extended;
                   //Format: TFloatFormat;Precision, Digits: Integer): string;
      FloatToStrF(GLCamera.Position.VectorLength,
                  ffFixed, 18,2);
   end;
   Handled:=True;
end;

procedure TABCreatorFrm.CameraDistanceUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  WheelDeltas: Integer;
  f : Single;
begin
  If (Button = btNext) then WheelDeltas:=120
     else WheelDeltas:=-120;
  if (WheelDeltas>0) or (GLCamera.Position.VectorLength>0.90) then
  begin
    f:=PowerSingle(1.05, WheelDeltas*(1/120));
    GLCamera.AdjustDistanceToTarget(f);
    CameraDistanceLabel.Caption:=
      FloatToStrF(GLCamera.Position.VectorLength,
                  ffFixed, 18,2);
  end;
end;


procedure TABCreatorFrm.DisplayToolbar1Click(Sender: TObject);
begin
  DisplayToolbar1.Checked := (not DisplayToolbar1.Checked);
  ToggleToolbarDisplay;
end;
procedure TABCreatorFrm.ToggleToolbarDisplay;
Begin
  If DisplayToolbar1.Checked then
  begin        //SolarOrbPanel
    GLSceneViewerA.align:=alNone;
    SolarDataPanel.Visible:=True;
    SolarDataPanel.align:=alLeft;
 { If DisplayOrbitalElements1.Checked then
  begin
    SolarOrbPanel.Visible:=True;
    SolarOrbPanel.align:=alLeft;
  end else
  begin
    SolarOrbPanel.Visible:=False;
    SolarOrbPanel.align:=alNone;
  end;}
    GLSceneViewerA.align:=alClient;
  end else
  begin
    GLSceneViewerA.align:=alNone;
    SolarDataPanel.Visible:=False;
    SolarDataPanel.align:=alNone;
  {If DisplayOrbitalElements1.Checked then
  begin
    SolarOrbPanel.Visible:=True;
    SolarOrbPanel.align:=alLeft;
  end else
  begin
    SolarOrbPanel.Visible:=False;
    SolarOrbPanel.align:=alNone;
  end; }
    GLSceneViewerA.align:=alClient;
  end;
End;

procedure TABCreatorFrm.DisplayFPS1Click(Sender: TObject);
begin
  DisplayFPS1.Checked := (not DisplayFPS1.Checked);
  If DisplayFPS1.Checked then
  begin
    TimerA.Enabled:=True;
  end else
  begin
    TimerA.Enabled:=False;;
    Caption:= 'A.B. Creator D. E. Prime';
  end;
end;

procedure TABCreatorFrm.FullScreen1Click(Sender: TObject);
begin   {fig FullScreen ?}
   GLSceneViewerA.OnMouseMove:=nil;
   if WindowState=wsMaximized then
   begin
      WindowState:=wsNormal;
      BorderStyle:=bsSizeable;//bsSizeToolWin;
   end else begin
      BorderStyle:=bsNone;
      WindowState:=wsMaximized;
   end;
   FullScreen1.Checked := (WindowState=wsMaximized);
   GLSceneViewerA.OnMouseMove:=GLSceneViewerAMouseMove;
end;

procedure TABCreatorFrm.GLSceneViewerADblClick(Sender: TObject);
begin
   FullScreen1Click(Sender);
end;


procedure TABCreatorFrm.PlanetsLoadFakeTextureClick(Sender: TObject);
begin
  PlanetsLoadFakeTexture.Checked := (not PlanetsLoadFakeTexture.Checked);
end;
procedure TABCreatorFrm.RingsLoadFakeTextureClick(Sender: TObject);
begin
  RingsLoadFakeTexture.Checked := (not RingsLoadFakeTexture.Checked);
end;
procedure TABCreatorFrm.MoonsLoadFakeTextureClick(Sender: TObject);
begin
  MoonsLoadFakeTexture.Checked := (not MoonsLoadFakeTexture.Checked);
end;
procedure TABCreatorFrm.S3dsLoadFakeTextureClick(Sender: TObject);
begin
  S3dsLoadFakeTexture.Checked := (not S3dsLoadFakeTexture.Checked);
end;
procedure TABCreatorFrm.AsteroidsLoadFakeTextureClick(Sender: TObject);
begin
  AsteroidsLoadFakeTexture.Checked := (not AsteroidsLoadFakeTexture.Checked);
end;
procedure TABCreatorFrm.CometsLoadFakeTextureClick(Sender: TObject);
begin
  CometsLoadFakeTexture.Checked := (not CometsLoadFakeTexture.Checked);
end;
procedure TABCreatorFrm.DebrisLoadFakeTextureClick(Sender: TObject);
begin
  DebrisLoadFakeTexture.Checked := (not DebrisLoadFakeTexture.Checked);
end;




procedure TABCreatorFrm.DocIndexLinkCBClick(Sender: TObject);
begin
{  DocIndexLinkCB.Checked := (not DocIndexLinkCB.Checked); }
end;

procedure TABCreatorFrm.AtmosphereOnCBClick(Sender: TObject);
begin
{Cant really 'Focus' on a Planet so Atmosphere is kinda a waste}
 {AtmosphereOnCB.Checked := (not AtmosphereOnCB.Checked); }
end;

procedure TABCreatorFrm.UseOrbitalElementsCBClick(Sender: TObject);
begin
  {UseOrbitalElementsCB.Checked := (not UseOrbitalElementsCB.Checked);}
  
end;

procedure TABCreatorFrm.LabelsOnCBClick(Sender: TObject);
begin  {HUDLabel}GLFlatTextLabel.Visible:= LabelsOnCB.Checked;
  {LabelsOnCB.Checked := (not LabelsOnCB.Checked);}
    {A HudText could be made and assigned to the Object when loaded
     This Would Toggle Visibility.. AND Selectability in PICKER}
   // TGLFlatText
   //	TGLFlatText = class (TGLImmaterialSceneObject)
   { A 2D text displayed and positionned in 3D coordinates.   
      The FlatText uses a character font defined and stored by a TGLBitmapFont
      component. Default character scale is 1 font pixel = 1 space unit. }
end;

procedure TABCreatorFrm.SelectFontMenuClick(Sender: TObject);
begin
   FontDialogA.Font:=WindowsBitmapFontA.Font;
   FontDialogA.Font.Color:= GLFlatTextLabel.ModulateColor.AsWinColor;
   if FontDialogA.Execute then
   begin
      WindowsBitmapFontA.Font:=FontDialogA.Font;
      GLFlatTextLabel.ModulateColor.AsWinColor:=FontDialogA.Font.Color;
   end;
end;

procedure TABCreatorFrm.OrbitTrailsOnCBClick(Sender: TObject);
var i:integer;
begin  {Clear at start AND End}
  for i:= OrbitLines.Nodes.Count-1 downto 0 do
    OrbitLines.Nodes[i].Free;
  OrbitLines.AddNode(0, 0, 0);
{  OrbitTrailsOnCB.Checked := (not OrbitTrailsOnCB.Checked); }
end;

procedure TABCreatorFrm.DatePickerCBClick(Sender: TObject);
begin
  DateTimePicker1.Visible := (DatePickerCB.Checked);
end;
procedure TABCreatorFrm.DateTimePicker1Change(Sender: TObject);
begin
  showmessage(Datetostr(DateTimePicker1.Date));
  OrbitalTime:= DateTimePicker1.Date;
end;

procedure TABCreatorFrm.MoonScalex0Click(Sender: TObject);
begin
  MoonScale:= 0;
  Case MoonScale of
  0:  MoonScalex0.Checked:=True;
  10: MoonScalex10.Checked:=True;
  50: MoonScalex50.Checked:=True;
  end;
end;

procedure TABCreatorFrm.MoonScalex10Click(Sender: TObject);
begin
  MoonScale:= 10;
  Case MoonScale of
  0:  MoonScalex0.Checked:=True;
  10: MoonScalex10.Checked:=True;
  50: MoonScalex50.Checked:=True;
  end;
end;

procedure TABCreatorFrm.MoonScalex50Click(Sender: TObject);
begin
  MoonScale:= 50;
  Case MoonScale of
  0:  MoonScalex0.Checked:=True;
  10: MoonScalex10.Checked:=True;
  50: MoonScalex50.Checked:=True;
  end;
end;

procedure TABCreatorFrm.SunScale20Click(Sender: TObject);
begin
  SunScale:= 20;
  Case SunScale of
  20:  SunScale20.Checked:=True;
  200: SunScale200.Checked:=True;
  2000: SunScale2000.Checked:=True;
  end;
end;

procedure TABCreatorFrm.SunScale200Click(Sender: TObject);
begin
  SunScale:= 200;
  Case SunScale of
  20:  SunScale20.Checked:=True;
  200: SunScale200.Checked:=True;
  2000: SunScale2000.Checked:=True;
  end;
end;

procedure TABCreatorFrm.SunScale2000Click(Sender: TObject);
begin
  SunScale:= 2000;
  Case SunScale of
  20:  SunScale20.Checked:=True;
  200: SunScale200.Checked:=True;
  2000: SunScale2000.Checked:=True;
  end;
end;

procedure TABCreatorFrm.OrbitTrails36Click(Sender: TObject);
begin
  MaxLines:= 36;
  Case MaxLines of
  36:  OrbitTrails36.Checked:=True;
  360: OrbitTrails360.Checked:=True;
  1000: OrbitTrails1000.Checked:=True;
  3600: OrbitTrails3600.Checked:=True;
  end;
end;

procedure TABCreatorFrm.OrbitTrails360Click(Sender: TObject);
begin
  MaxLines:= 360;
  Case MaxLines of
  36:  OrbitTrails36.Checked:=True;
  360: OrbitTrails360.Checked:=True;
  1000: OrbitTrails1000.Checked:=True;
  3600: OrbitTrails3600.Checked:=True;
  end;
end;

procedure TABCreatorFrm.OrbitTrails1000Click(Sender: TObject);
begin
  MaxLines:= 1000;
  Case MaxLines of
  36:  OrbitTrails36.Checked:=True;
  360: OrbitTrails360.Checked:=True;
  1000: OrbitTrails1000.Checked:=True;
  3600: OrbitTrails3600.Checked:=True;
  end;
end;

procedure TABCreatorFrm.OrbitTrails3600Click(Sender: TObject);
begin
  MaxLines:= 3600;
  Case MaxLines of
  36:  OrbitTrails36.Checked:=True;
  360: OrbitTrails360.Checked:=True;
  1000: OrbitTrails1000.Checked:=True;
  3600: OrbitTrails3600.Checked:=True;
  end;
end;


procedure TABCreatorFrm.SpudVersionConvertor1Click(Sender: TObject);
begin
  {
   HoloSpudVCForm.Show;
   }
end;





end.
