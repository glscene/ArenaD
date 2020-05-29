//This Form demonstrates basic "hierarchical" movements

unit FSkyPilot;
interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
   
  GLScene, GLObjects, GLVectorGeometry,
  GLWin32Viewer, GLCadencer,
  GLTexture, GLMaterial, GLCoordinates, GLCrossPlatform, GLBaseClasses;

type
  TSkyPilotFrm = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLLightSource1: TGLLightSource;
    SunSphere: TGLSphere;
    SunCube: TGLDummyCube;
    SceneCamera: TGLCamera;
    CameraCube: TGLDummyCube;
    SkyCamera: TGLCamera;
    MarsCube: TGLDummyCube;
    VenusCube: TGLDummyCube;
    EarthCube: TGLDummyCube;
    MercuryCube: TGLDummyCube;
    JupiterCube: TGLDummyCube;
    SaturnCube: TGLDummyCube;
    UranusCube: TGLDummyCube;
    NeptuneCube: TGLDummyCube;
    PlutoCube: TGLDummyCube;
    PlutoSphere: TGLSphere;
    NeptuneSphere: TGLSphere;
    UranusSphere: TGLSphere;
    SaturnSphere: TGLSphere;
    JupiterSphere: TGLSphere;
    MarsSphere: TGLSphere;
    EarthSphere: TGLSphere;
    MoonCube: TGLDummyCube;
    MoonSphere: TGLSphere;
    VenusSphere: TGLSphere;
    MercurySphere: TGLSphere;
    MarsPhobosCube: TGLDummyCube;
    MarsDeimosCube: TGLDummyCube;
    MarsDeimosSphere: TGLSphere;
    MarsPhobosSphere: TGLSphere;
    JupiterIoCube: TGLDummyCube;
    JupiterEuropaCube: TGLDummyCube;
    JupiterEuropaSphere: TGLSphere;
    JupiterIoSphere: TGLSphere;
    JupiterGanymedeCube: TGLDummyCube;
    JupiterGanymedeSphere: TGLSphere;
    JupiterCallistoCube: TGLDummyCube;
    JupiterCallistoSphere: TGLSphere;
    SaturnMimasCube: TGLDummyCube;
    SaturnMimasSphere: TGLSphere;
    UranusArielCube: TGLDummyCube;
    UranusArielSphere: TGLSphere;
    UranusUmbrielCube: TGLDummyCube;
    UranusUmbrielSphere: TGLSphere;
    NeptuneNereidCube: TGLDummyCube;
    NeptuneNereidSphere: TGLSphere;
    CharonCube: TGLDummyCube;
    CharonSphere: TGLSphere;
    CometHalleyCube: TGLDummyCube;
    CometHalleySphere: TGLSphere;
    KuiperBeltCube: TGLDummyCube;
    KuiperBeltSphere: TGLSphere;
    OortCloudCube: TGLDummyCube;
    OortCloudSphere: TGLSphere;
    GLCadencer1: TGLCadencer;
    Timer1: TTimer;
    Panel1: TPanel;
    TrackBar: TTrackBar;
    CBPlay: TCheckBox;
    LoadBtn: TSpeedButton;
    SaturnEnceladusCube: TGLDummyCube;
    SaturnEnceladusSphere: TGLSphere;
    SaturnTethysCube: TGLDummyCube;
    SaturnTethysSphere: TGLSphere;
    SaturnDioneCube: TGLDummyCube;
    SaturnDioneSphere: TGLSphere;
    SaturnRheaCube: TGLDummyCube;
    SaturnRheaSphere: TGLSphere;
    SaturnTitanCube: TGLDummyCube;
    SaturnTitanSphere: TGLSphere;
    SaturnHyperionCube: TGLDummyCube;
    SaturnHyperionSphere: TGLSphere;
    SaturnIapetusCube: TGLDummyCube;
    SaturnIapetusSphere: TGLSphere;
    SaturnPhoebeCube: TGLDummyCube;
    SaturnPhoebeSphere: TGLSphere;
    UranusTitaniaCube: TGLDummyCube;
    UranusTitaniaSphere: TGLSphere;
    UranusOberonCube: TGLDummyCube;
    UranusOberonSphere: TGLSphere;
    UranusMirandaCube: TGLDummyCube;
    UranusMirandaSphere: TGLSphere;
    NeptuneTritonCube: TGLDummyCube;
    NeptuneTritonSphere: TGLSphere;
    NeptuneLarissaCube: TGLDummyCube;
    NeptuneLarissaSphere: TGLSphere;
    NeptuneProteusCube: TGLDummyCube;
    NeptuneProteusSphere: TGLSphere;
    GLMaterialLibrary: TGLMaterialLibrary;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseEnter(Sender: TObject);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
procedure MishMash;
    procedure CBPlayClick(Sender: TObject);
  private
     
    PlanetsLoaded:Boolean;
    EarthProjectPath:String;
  public
     
    deltaTimeGlobal:Double;
    timeMultiplier : Single;
    mx, my, dmx, dmy : Integer;
  end;

var
  SkyPilotFrm: TSkyPilotFrm;

implementation
{uses  HoloGlobals;}

{$R *.DFM}

procedure TSkyPilotFrm.FormCreate(Sender: TObject);
begin
  CBPlay.Checked:=False;
  Timer1.Enabled:=False;
 { top := HoloSkypilotFormY;
  left := HoloSkypilotFormX; }
  EarthProjectPath:= ExtractFilePath(ParamStr(0))+'EarthData\';
  PlanetsLoaded:=False;
  timeMultiplier:=1;
  deltaTimeGlobal:=0;
  if FileExists(ExtractFilePath(ParamStr(0))+'Holographic.hlp') THEN
  Application.HelpFile := ExtractFilePath(ParamStr(0))+ 'Holographic.hlp';
end;
procedure TSkyPilotFrm.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=True;
  GLCadencer1.Enabled:=True;
end;

procedure TSkyPilotFrm.FormHide(Sender: TObject);
begin
  CBPlay.Checked:=False;
  Timer1.Enabled:=False;
  GLCadencer1.Enabled:=False;
end;
procedure TSkyPilotFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
	// We need to stop playing here :
	// 	since the timer is asynchronous, if we don't stop play,
	// 	it may get triggered during the form's destruction
  CBPlay.Checked:=False;
end;

procedure TSkyPilotFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 { HoloSkyPilotFormY := HoloSkyPilotForm.top;
  HoloSkyPilotFormX := HoloSkyPilotForm.left;}
end;

procedure TSkyPilotFrm.FormResize(Sender: TObject);
begin
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TSkyPilotFrm.LoadBtnClick(Sender: TObject);
   procedure LoadHighResTexture(libMat : TGLLibMaterial; const fileName : String);
   begin
      if FileExists(fileName) then begin
//         libMat.Material.Texture.Compression := tcStandard;
         libMat.Material.Texture.Image.LoadFromFile(fileName);
      end;
   end;
begin
  if not PlanetsLoaded then
  begin
    GLSceneViewer1.Cursor:=crHourGlass;

    try
      with GLMaterialLibrary do
      begin
        If FileExists(EarthProjectPath+'Sun.jpg') then
        begin
        with AddTextureMaterial('Sun',EarthProjectPath+'Sun.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SunSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SunSphere.Material.LibMaterialName:='Sun';
          SunSphere.Material.Texture.Disabled:=False;
        end;
        end else showmessage(EarthProjectPath+'Sun.jpg is missing');

        If FileExists(EarthProjectPath+'Mercury.jpg') then
        with AddTextureMaterial('Mercury',EarthProjectPath+'Mercury.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          MercurySphere.Material.MaterialLibrary:= GLMaterialLibrary;
          MercurySphere.Material.LibMaterialName:='Mercury';
          MercurySphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Venus.jpg') then
        with AddTextureMaterial('Venus',EarthProjectPath+'Venus.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          VenusSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          VenusSphere.Material.LibMaterialName:='Venus';
          VenusSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Earth.jpg') then
        with AddTextureMaterial('Earth',EarthProjectPath+'Earth.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          EarthSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          EarthSphere.Material.LibMaterialName:='Earth';
          EarthSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Moon.jpg') then
        with AddTextureMaterial('Moon',EarthProjectPath+'Moon.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          MoonSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          MoonSphere.Material.LibMaterialName:='Moon';
          MoonSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Mars.jpg') then
        with AddTextureMaterial('Mars',EarthProjectPath+'Mars.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          MarsSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          MarsSphere.Material.LibMaterialName:='Mars';
          MarsSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Phobos.jpg') then
        with AddTextureMaterial('Phobos',EarthProjectPath+'Phobos.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          MarsPhobosSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          MarsPhobosSphere.Material.LibMaterialName:='Phobos';
          MarsPhobosSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Deimos.jpg') then
        with AddTextureMaterial('Deimos',EarthProjectPath+'Deimos.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          MarsDeimosSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          MarsDeimosSphere.Material.LibMaterialName:='Deimos';
          MarsDeimosSphere.Material.Texture.Disabled:=False;
        end;

        If FileExists(EarthProjectPath+'Jupiter.jpg') then
        with AddTextureMaterial('Jupiter',EarthProjectPath+'Jupiter.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          JupiterSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          JupiterSphere.Material.LibMaterialName:='Jupiter';
          JupiterSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Io.jpg') then
        with AddTextureMaterial('Io',EarthProjectPath+'Io.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          JupiterIoSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          JupiterIoSphere.Material.LibMaterialName:='Io';
          JupiterIoSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Europa.jpg') then
        with AddTextureMaterial('Europa',EarthProjectPath+'Europa.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          JupiterEuropaSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          JupiterEuropaSphere.Material.LibMaterialName:='Europa';
          JupiterEuropaSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Ganymede.jpg') then
        with AddTextureMaterial('Ganymede',EarthProjectPath+'Ganymede.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          JupiterGanymedeSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          JupiterGanymedeSphere.Material.LibMaterialName:='Ganymede';
          JupiterGanymedeSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Callisto.jpg') then
        with AddTextureMaterial('Callisto',EarthProjectPath+'Callisto.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          JupiterCallistoSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          JupiterCallistoSphere.Material.LibMaterialName:='Callisto';
          JupiterCallistoSphere.Material.Texture.Disabled:=False;
        end;

        If FileExists(EarthProjectPath+'Saturn.jpg') then
        with AddTextureMaterial('Saturn',EarthProjectPath+'Saturn.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnSphere.Material.LibMaterialName:='Saturn';
          SaturnSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Mimas.jpg') then
        with AddTextureMaterial('Mimas',EarthProjectPath+'Mimas.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnMimasSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnMimasSphere.Material.LibMaterialName:='Mimas';
          SaturnMimasSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Enceladus.jpg') then
        with AddTextureMaterial('Enceladus',EarthProjectPath+'Enceladus.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnEnceladusSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnEnceladusSphere.Material.LibMaterialName:='Enceladus';
          SaturnEnceladusSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Tethys.jpg') then
        with AddTextureMaterial('Tethys',EarthProjectPath+'Tethys.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnTethysSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnTethysSphere.Material.LibMaterialName:='Tethys';
          SaturnTethysSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Dione.jpg') then
        with AddTextureMaterial('Dione',EarthProjectPath+'Dione.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnDioneSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnDioneSphere.Material.LibMaterialName:='Dione';
          SaturnDioneSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Rhea.jpg') then
        with AddTextureMaterial('Rhea',EarthProjectPath+'Rhea.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnRheaSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnRheaSphere.Material.LibMaterialName:='Rhea';
          SaturnRheaSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Titan.jpg') then
        with AddTextureMaterial('Titan',EarthProjectPath+'Titan.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnTitanSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnTitanSphere.Material.LibMaterialName:='Titan';
          SaturnTitanSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Hyperion.jpg') then
        with AddTextureMaterial('Hyperion',EarthProjectPath+'Hyperion.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnHyperionSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnHyperionSphere.Material.LibMaterialName:='Hyperion';
          SaturnHyperionSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Iapetus.jpg') then
        with AddTextureMaterial('Iapetus',EarthProjectPath+'Iapetus.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnIapetusSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnIapetusSphere.Material.LibMaterialName:='Iapetus';
          SaturnIapetusSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Phoebe.jpg') then
        with AddTextureMaterial('Phoebe',EarthProjectPath+'Phoebe.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          SaturnPhoebeSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          SaturnPhoebeSphere.Material.LibMaterialName:='Phoebe';
          SaturnPhoebeSphere.Material.Texture.Disabled:=False;
        end;

        If FileExists(EarthProjectPath+'Uranus.jpg') then
        with AddTextureMaterial('Uranus',EarthProjectPath+'Uranus.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          UranusSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          UranusSphere.Material.LibMaterialName:='Uranus';
          UranusSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Ariel.jpg') then
        with AddTextureMaterial('Ariel',EarthProjectPath+'Ariel.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          UranusArielSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          UranusArielSphere.Material.LibMaterialName:='Ariel';
          UranusArielSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Umbriel.jpg') then
        with AddTextureMaterial('Umbriel',EarthProjectPath+'Umbriel.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          UranusUmbrielSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          UranusUmbrielSphere.Material.LibMaterialName:='Umbriel';
          UranusUmbrielSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Titania.jpg') then
        with AddTextureMaterial('Titania',EarthProjectPath+'Titania.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          UranusTitaniaSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          UranusTitaniaSphere.Material.LibMaterialName:='Titania';
          UranusTitaniaSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Oberon.jpg') then
        with AddTextureMaterial('Oberon',EarthProjectPath+'Oberon.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          UranusOberonSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          UranusOberonSphere.Material.LibMaterialName:='Oberon';
          UranusOberonSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Miranda.jpg') then
        with AddTextureMaterial('Miranda',EarthProjectPath+'Miranda.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          UranusMirandaSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          UranusMirandaSphere.Material.LibMaterialName:='Miranda';
          UranusMirandaSphere.Material.Texture.Disabled:=False;
        end;


        If FileExists(EarthProjectPath+'Neptune.jpg') then
        with AddTextureMaterial('Neptune',EarthProjectPath+'Neptune.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          NeptuneSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          NeptuneSphere.Material.LibMaterialName:='Neptune';
          NeptuneSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Triton.jpg') then
        with AddTextureMaterial('Triton',EarthProjectPath+'Triton.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          NeptuneTritonSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          NeptuneTritonSphere.Material.LibMaterialName:='Triton';
          NeptuneTritonSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Nereid.jpg') then
        with AddTextureMaterial('Nereid',EarthProjectPath+'Nereid.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          NeptuneNereidSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          NeptuneNereidSphere.Material.LibMaterialName:='Nereid';
          NeptuneNereidSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Larissa.jpg') then
        with AddTextureMaterial('Larissa',EarthProjectPath+'Larissa.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          NeptuneLarissaSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          NeptuneLarissaSphere.Material.LibMaterialName:='Larissa';
          NeptuneLarissaSphere.Material.Texture.Disabled:=False;
        end;
        If FileExists(EarthProjectPath+'Proteus.jpg') then
        with AddTextureMaterial('Proteus',EarthProjectPath+'Proteus.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          NeptuneProteusSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          NeptuneProteusSphere.Material.LibMaterialName:='Proteus';
          NeptuneProteusSphere.Material.Texture.Disabled:=False;
        end;

        If FileExists(EarthProjectPath+'Pluto.jpg') then
        with AddTextureMaterial('Pluto',EarthProjectPath+'Pluto.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          PlutoSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          PlutoSphere.Material.LibMaterialName:='Pluto';
          PlutoSphere.Material.Texture.Disabled:=False;
        end;

        If FileExists(EarthProjectPath+'Charon.jpg') then
        with AddTextureMaterial('Charon',EarthProjectPath+'Charon.jpg') do
        begin {Create the matlib}
          Material.Texture.TextureMode:=tmDecal;
          CharonSphere.Material.MaterialLibrary:= GLMaterialLibrary;
          CharonSphere.Material.LibMaterialName:='Charon';
          CharonSphere.Material.Texture.Disabled:=False;
        end;

{  sunmap.jpg
Mercury NOT: mer0muu2.jpg
Venus  ven0ajj2.jpg  OR ven0aaa2.jpg or
       ven0auu1.jpg or ven0mss2.jpg
Earth Earth5.jpg  or ear0xuu2.jpg
  Moon
Mars mar0kuu2.jpg
  Phobos mar1kuu2.jpg
  Deimos mar2kuu2.jpg
Jupiter   jup0vss1.jpg
  Io jup1vuu2.jpg or jup1vss2.jpg
  Europa jup2vuu2.jpg  or jup2vss2.jpg
  Ganymede jup3vss2.jpg or jup3vuu2.jpg
  Callisto  jup4vuu2.jpg or jup4vss2.jpg
Saturn  sat0fds1.jpg
  Mimas   sat1vuu2.jpg or sat1vss2.jpg
  Enceladus  sat2vuu2.jpg or sat2vss2.jpg
  Tethys   sat3vuu2.jpg or sat3vss2.jpg
  Dione    sat4vuu2.jpg or sat4vss2.jpg
  Rhea     sat5vuu2.jpg or sat5vss2.jpg
  Titan    sat6vuu2.jpg or sat6vss2.jpg
  Hyperion [] sat7vuu2.jpg or sat7vss2.jpg
  Iapetus  sat8vuu2.jpg or sat8vss2.jpg
  Phoebe[] sat9vuu2.jpg or sat9vss2.jpg

Uranus  ura0fss1.jpg  uranusmap.jpg
  1/Ariel    ura1vuu2.jpg
  2/Umbriel  ura2vuu2.jpg
  3/Titania  ura3vuu2.jpg
  4/Oberon   ura4vuu2.jpg
  5/Miranda  ura5vuu2.jpg

Neptune  nep0fds1.jpg or nep0vtt1.jpg
 Triton   nep1vuu2.jpg
 Nereid []
 Larissa []
 Proteus  nep8vpp2.jpg

Pluto  plu0rss1.jpg or    plu0hbb1.jpg
Charon plu1rss1.jpg

CometHalleyCube
KuiperBeltCube
OortCloudCube
}
      end;
    finally
      GLSceneViewer1.Cursor:=crDefault;
    end;
    PlanetsLoaded:=True;
  end;
end;
procedure TSkyPilotFrm.SpeedButton1Click(Sender: TObject);
begin
  Application.HelpContext(5000);
end;


procedure TSkyPilotFrm.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  if CBPlay.Checked and Visible then
  begin
    // simulate a user action on the trackbar...
    TrackBar.Position:=((TrackBar.Position+1) mod 360);
  end;
  deltaTimeGlobal:=deltaTime;
  if (dmy<>0) or (dmx<>0) then
  begin
     SceneCamera.MoveAroundTarget(dmy,dmx);
     dmx:=0;
     dmy:=0;
  end;
end;



procedure TSkyPilotFrm.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
end;

procedure TSkyPilotFrm.GLSceneViewer1MouseEnter(Sender: TObject);
begin
  GLSceneViewer1.SetFocus;//  GLSceneViewer.Focused;
end;

procedure TSkyPilotFrm.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   if Shift=[ssLeft] then
   begin
      dmx:=dmx+(mx-x);
      dmy:=dmy+(my-y);
   end else if Shift=[ssRight] then
      SceneCamera.FocalLength:=SceneCamera.FocalLength*PowerSingle(1.05, (my-y)*0.1);
   mx:=x; my:=y;
end;

procedure TSkyPilotFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
   case Key of
      #27 : Close;
{They all orbit in the same direction
(counter-clockwise looking down
 from above the Sun's north pole);
 all but Venus, Uranus and Pluto
 also rotate in that same sense.
      'e', 'E' : begin
         GLCamera.MoveTo(DCEarthSystem);
         GLCameraControler.MoveTo(DCEarthSystem);
         GLCamera.TargetObject:=DCEarthSystem;
         GLCameraControler.TargetObject:=DCEarthSystem;
      end;
Spacebar Sun      
M  Mercury,
V  Venus,
E  Earth,M  Moon,
A  Mars,
J  Jupiter,
S  Saturn,
U  Uranus,
N  Neptune,
P  Pluto,
T  Asteroids}
      'm', 'M' :
        begin
          SceneCamera.MoveTo(MercurySphere);
          SceneCamera.TargetObject:=MercurySphere;
        end;
      'v', 'V' :
        begin
          SceneCamera.MoveTo(VenusSphere);
          SceneCamera.TargetObject:=VenusSphere;
        end;
      'e', 'E' :
        begin
          SceneCamera.MoveTo(EarthSphere);
          SceneCamera.TargetObject:=EarthSphere;
        end;
      'a', 'A' :
        begin
          SceneCamera.MoveTo(MarsSphere);
          SceneCamera.TargetObject:=MarsSphere;
        end;
      'j', 'J' :
        begin
          SceneCamera.MoveTo(JupiterSphere);
          SceneCamera.TargetObject:=JupiterSphere;
        end;
      's', 'S' :
        begin
          SceneCamera.MoveTo(SaturnSphere);
          SceneCamera.TargetObject:=SaturnSphere;
        end;
      'u', 'U' :
        begin
          SceneCamera.MoveTo(UranusSphere);
          SceneCamera.TargetObject:=UranusSphere;
        end;
      'n', 'N' :
        begin
          SceneCamera.MoveTo(NeptuneSphere);
          SceneCamera.TargetObject:=NeptuneSphere;
        end;
      'p', 'P' :
        begin
          SceneCamera.MoveTo(PlutoSphere);
          SceneCamera.TargetObject:=PlutoSphere;
        end;
        ' ':
        begin
          SceneCamera.MoveTo(SunCube);
          SceneCamera.TargetObject:=SunCube;
        end;
      '0'..'9' : timeMultiplier:=PowerInteger(Integer(Key)-Integer('0'), 3);
   end;
end;

procedure TSkyPilotFrm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
   f : Single;
begin
   if (WheelDelta>0) or ({GLCameraControler}SceneCamera.Position.VectorLength>0.90) then begin
      f:=PowerSingle(1.05, WheelDelta*(1/120));
      {GLCameraControler}SceneCamera.AdjustDistanceToTarget(f);
   end;
   Handled:=True;
end;

procedure TSkyPilotFrm.Timer1Timer(Sender: TObject);
begin
  Caption:='Sky Pilot: '+Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TSkyPilotFrm.TrackBarChange(Sender: TObject);
begin
  MishMash;
end;
{
Mercury -3715  -3693  39     Scale XYZ 0.382  Position X -39
Venus -8392  -451  478       Scale XYZ 0.949  Position X -478
Earth
 Moon: 277604 687816 29574    Scale Moon/Earth radii = 3475/12756
Mars -5882  17881  518       Scale XYZ 0.533  Position X 518
Jupiter -61941  13502  1329  Scale XYZ 11.209  Position X 1329
Saturn -25401  102463  -779  Scale XYZ 9.45  Position X -779
Uranus 209552 -104695 -3108  Scale XYZ 4.007  Position X -3108
Neptune 241251  -255428 -291 Scale XYZ 3.883  Position X -291
Pluto...
Charon
Ooort
Kuiper Belt Asteroids
Comet Halley}
procedure TSkyPilotFrm.MishMash;
var   t : Double;
Begin
  {if CBPlay.Checked and Visible then
  t:=TrackBar.Position else t:=deltaTimeGlobal*timeMultiplier;}
  t:=TrackBar.Position;
  {The Hierarchy is NOT exactly like demo..
   All Planets Spin themselves}
{    DummyCubeRed3.PitchAngle:=stage[3].rot_x*(Rotator);
	  DummyCubeRed3.RollAngle:=stage[3].rot_y*(Rotator);
    DummyCubeRed3.TurnAngle:=stage[3].rot_z*(Rotator);}
  // the "sun" spins slowly
  SunCube.TurnAngle:=-t;
  SunSphere.TurnAngle:=t/4;
  MercuryCube.TurnAngle:=t*3;
  VenusCube.TurnAngle:=t*1.3;
  // "earth" rotates around the sun and spins
  EarthCube.TurnAngle:=t*2;
  // "moon" rotates around earth and spins
  EarthSphere.RollAngle:=3*t;
  MoonSphere.TurnAngle:=4*t;
   MoonSphere.TurnAngle:=MoonSphere.TurnAngle+t/29.5;

  MarsCube.TurnAngle:=t*4;
    MarsDeimosCube.RollAngle:=t*2;
    MarsPhobosCube.RollAngle:=t*4;
  JupiterCube.TurnAngle:=t*5;
     JupiterCallistoCube.RollAngle:=t*1;
     JupiterGanymedeCube.RollAngle:=t*2;
     JupiterEuropaCube.RollAngle:=t*3;
     JupiterIoCube.RollAngle:=t*4;

  SaturnCube.TurnAngle:=t*2;
     SaturnMimasCube.RollAngle:=t*1;
     SaturnEnceladusCube.RollAngle:=t*2;
     SaturnTethysCube.RollAngle:=t*3;
     SaturnDioneCube.RollAngle:=t*4;
     SaturnRheaCube.RollAngle:=t*5;
     SaturnTitanCube.RollAngle:=t*6;
     SaturnHyperionCube.RollAngle:=t*7;
     SaturnIapetusCube.RollAngle:=t*8;
     SaturnPhoebeCube.RollAngle:=t*9;

  UranusCube.TurnAngle:=t*7;
     UranusArielCube.RollAngle:=t*1;
     UranusUmbrielCube.RollAngle:=t*2;
     UranusTitaniaCube.RollAngle:=t*3;
     UranusOberonCube.RollAngle:=t*4;
     UranusMirandaCube.RollAngle:=t*5;

  NeptuneCube.TurnAngle:=t*2;
     NeptuneTritonCube.RollAngle:=t*1;
     NeptuneNereidCube.RollAngle:=t*2;
     NeptuneLarissaCube.RollAngle:=t*3;
     NeptuneProteusCube.RollAngle:=t*4;

  PlutoCube.TurnAngle:=t*12;
  CharonCube.TurnAngle:=t*5;

  CometHalleyCube.TurnAngle:=t*3;
  KuiperBeltCube.TurnAngle:=t*8;
  OortCloudCube.TurnAngle:=t*5;
  GLSceneViewer1.Invalidate;
End;


procedure TSkyPilotFrm.CBPlayClick(Sender: TObject);
begin
  Timer1.Enabled:=True;
  GLCadencer1.Enabled:=True;
end;

end.
